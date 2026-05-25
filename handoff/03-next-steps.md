# 복귀 후 즉시 처리 5단계

> 우선순위 순. 1-2-3은 보안/운영 가드, 4-5는 기능 강화.

---

## 1. 🚨 토큰 revoke (5분, 보안 critical)

외출 동안 노출된 토큰 3개 즉시 폐기:

| 토큰 | 위치 | URL |
|---|---|---|
| GitHub PAT `medimap-marketing-clone-26may` | github.com | https://github.com/settings/tokens |
| Vercel Access Token `medimap-26may-claude` | vercel.com | https://vercel.com/account/tokens |
| Supabase service_role key | dashboard | https://supabase.com/dashboard/project/gifopyowyankfsfghhdi/settings/api-keys → Reset |

**Supabase service_role 재발급 후 영향**:
- medimap-blog 의 Vercel 환경변수 `DATABASE_URL`은 `postgres:[server_password]@...:6543/postgres` 형식이라 service_role key와 분리됨 → **무영향**
- Streamlit Cloud blogkey/blogkey-adm secrets에 `SUPABASE_SERVICE_ROLE_KEY`가 있으면 갱신 필요

---

## 2. ⚙️ GitHub Actions cron 워크플로 추가 (10분, 운영 영구 해결)

GH PAT가 `workflow` scope 없어서 push 못 했음. **사용자가 직접 추가**:

### 방법 A — GitHub UI 직접 추가 (권장)

1. https://github.com/passion4050-byte/Marketing/new/main 접속
2. 파일명: `.github/workflows/auto-publish.yml`
3. `handoff/auto-publish.yml` 내용 복사 → 붙여넣기
4. Commit message: `feat(cron): GH Actions auto-publish workflow`
5. Commit directly to main

### 방법 B — 새 PAT 발급 후 push

1. https://github.com/settings/tokens/new 에서 새 PAT
   - Scope: `repo` + **`workflow`** 둘 다 체크
2. 로컬 clone에 워크플로 파일 두고 push

### 워크플로 필요 secrets

https://github.com/passion4050-byte/Marketing/settings/secrets/actions

| Secret | 값 | 필수? |
|---|---|---|
| `DATABASE_URL` | `postgresql://postgres:[pw]@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres` | **필수** |
| `LLM_PROVIDER` | `gemini` (또는 `stub`, `openai`, `anthropic`) | 선택 |
| `GEMINI_API_KEY` | Google AI Studio 발급 | LLM_PROVIDER=gemini 시 |
| `OPENAI_API_KEY` | 선택 | |
| `ANTHROPIC_API_KEY` | 선택 | |
| `MAX_DAILY_USD` | `10` (기본) | 선택 |
| `VERCEL_DEPLOY_HOOK` | 기존 deploy_hook URL (DB의 deploy_hooks 1행) | 선택 |

### 동작 검증

워크플로 추가 후:
1. Actions 탭 → "Auto-publish content (cron)" → "Run workflow" 수동 실행
2. 로그에서 `{"tenants": 1, "drafts": 2, "published": 2, "errors": 0}` 같은 결과 확인
3. Supabase `auto_content_settings.last_run_at` 갱신 확인
4. medimap-blog `/blog` 페이지에 새 글 노출 (60초 ISR)

---

## 3. 🩺 Vercel 배포 검증 (5분)

복귀 시 https://medimap-blog-phi.vercel.app 메타 태그 확인:

```
meta-theme-color: #1B68FF   ← 메디맵 블루로 갱신됐는지
```

만약 여전히 `#FF4D5E`면:
1. https://vercel.com/medimaps-projects/medimap-blog/deployments 에서 빌드 상태 확인
2. 실패면 빌드 로그 봐서 에러 디버깅 (사용자에게 알려줘)
3. 성공인데 캐시면: Settings → Functions → Purge Edge Cache

`/blog` 페이지에 강남라식 #6, #9, #1, #3, #5, #8도 노출되는지 확인 (총 10편 보여야 함 — 기존 4 + 신규 6).

**lib/posts.ts 필터**: `status='published' AND channel='blog_html' AND compliance_status='pass' AND slug IS NOT NULL`. id 6, 9는 blog_html이므로 보여야 하고, id 1/3/5/8은 schema_org라 lib/posts.ts에서 제외 (정상).

---

## 4. 📝 키워드 풀 확장 (15분, 콘텐츠 다양성)

`keywords` 테이블에 강남라식 1개만 있어서 매일 같은 글 반복 생성.

### 옵션 A — blogkey 어드민 UI

blogkey.streamlit.app → 로그인 → 키워드 관리 → 추가:
- 라식 계열: 잠실라식, 송파라식, 강남라섹, 잠실라섹
- 안과 계열: 강남안과, 송파안과, 백내장수술, 노안교정, 시력교정
- (TETE 브랜드 특화) TETE안과, TETE라식

### 옵션 B — SQL 직접

```sql
INSERT INTO keywords (tenant_id, text, target_brand, is_active, category)
VALUES
  (1, '잠실라식', 'tete', true, ''),
  (1, '송파라식', 'tete', true, ''),
  (1, '강남라섹', 'tete', true, ''),
  (1, '백내장수술', 'tete', true, ''),
  (1, '노안교정', 'tete', true, '');
```

> ⚠️ **스파링 코멘트**: 키워드만 늘리면 동일 키워드 N번째 글이 첫 글의 N% 정도 가치만 가짐 (캐니벌라이제이션). 키워드 추가는 OK지만 **각 키워드의 글 변형 알고리즘**(다른 각도/타겟 독자/길이/포맷)도 같이 발전시켜야 의미 있음. 현재 generator는 단조로움.

---

## 5. 🎯 LLM provider Gemini로 전환 (5분, 콘텐츠 품질)

현재 192/203건이 stub 모드 — Lorem ipsum 수준 콘텐츠.

### blogkey Streamlit Cloud Secrets

https://share.streamlit.io/ → blogkey app → Settings → Secrets

```toml
LLM_PROVIDER = "gemini"
GEMINI_API_KEY = "AI..."
```

### medimap-blog (Next.js) Vercel 환경변수

medimap-blog는 자체 LLM 호출 안 함 (콘텐츠 표시만). 환경변수 추가 불필요.

### GH Actions Secrets

위 2번에서 같이 설정.

> ⚠️ **스파링 코멘트**: Gemini Free Tier는 분당 15 req / 일당 1500 req. 일 2건 생성은 무료로 충분. 단 RAG에 OpenAI text-embedding-3-small도 쓰는 코드가 있다면 OPENAI_API_KEY도 필요 (스냅샷 11.6 RAG 관련 — 현재는 RAG 비활성화 가능성).

---

## 📅 단기 로드맵 (1-2주)

| 우선순위 | 작업 | 영향 |
|---:|---|---|
| H | Next.js `/admin` 풀스코프 이관 | Streamlit 폐기 → 도메인 통합 + UX |
| H | 광고대행사 시안 Gap 4종 이식 (Data Feeding/AI 코드/Simulator/영상) | UI 완성도 |
| M | `_generate_draft`에 publication 자동 등록 patch | Funnel KPI 정확도 |
| M | doctors/equipment/event_offers 입력 폼 (Data Feeding) | JSON-LD 구조화 강화 → AEO 인용 가능성 ↑ |
| M | 키워드별 글 변형 알고리즘 (각도/포맷 다양화) | 콘텐츠 캐니벌라이제이션 회피 |
| L | medimap_inquiries CRM 익스포트 | 운영 효율 |
| L | AWS 이관 (4-6주 후, 인용 입증 후) | 자체 서버 |
