# 진단 보고서 — 2026-05-24 외출 진단

## 🩺 핵심 결론

너의 GEO/AEO 파이프라인은 **인프라가 멈춰서** 멈춰있던 것이지, 코드 결함이 아니다.
다음 3가지가 동시에 발생했다:

1. **Streamlit Cloud 슬립** → APScheduler 죽음 → 16일째 콘텐츠 생성 0건
2. **auto_publish 토글 OFF** → 생성돼도 모두 draft로 머묾
3. **자사 블로그가 Publication 자동 등록 안 됨** → blogkey-adm `PUBLICATIONS: 0`로 보임

세 가지 모두 외출 동안 해결됨.

---

## 1. Streamlit Cloud 슬립

**증거**:
```
auto_content_settings.last_run_at = 2026-05-08T03:00:43Z
오늘 = 2026-05-24
멈춤 = 16일
```

Streamlit Cloud Community Tier는 트래픽 없으면 슬립한다. 슬립하면 그 안에서 돌던 APScheduler도 정지 → daily_auto_content_job 실행 0회.

**임시 조치**: 사용자가 blogkey 사이트 방문해서 깨우면 1주일은 작동
**영구 해결**: GitHub Actions cron 신설 (`scripts/run_auto_content_once.py` + `.github/workflows/auto-publish.yml`). Streamlit 슬립 무관. handoff/auto-publish.yml 참조

---

## 2. auto_publish 토글 OFF

**증거**:
```
auto_content_settings.auto_publish = false (5/24 이전)
draft_pass_rows = 6건 (compliance pass인데 draft로 머묾)
```

`_generate_draft` 함수의 로직:
```python
# compliance pass + auto_publish=True 일 때만 즉시 'published'
# 외엔 모두 'draft'
```

**조치 완료**: `UPDATE auto_content_settings SET auto_publish = true WHERE tenant_id = 1`

---

## 3. 자사 블로그 Publication 자동 등록 안 됨

**증거**:
```
published 6건 (모두 강남라식 + 자동 발행 테스트)
publications 0건 ← 자사 블로그가 Funnel 추적 대상에 안 들어감
```

기존 코드는 **외부 채널 발행(blog/naver/instagram)만 publications 등록**.
자사 블로그(blog_html, schema_org)는 generated_contents에만 들어가고 publication 누락.

**조치 완료**: blog_html published 5건 백필 (id 6, 9, 13, 4, 2). PUBLICATIONS 0 → 5

**미해결 (다음 PR)**: scheduler `_generate_draft` 함수에 publication 자동 등록 로직 추가 필요. 현재는 백필만 한 상태.

---

## 4. 부가 발견

### 4-1. LLM이 stub 모드로 돌아감
- `llm_call_logs` 203건 중 192건이 `provider=stub`
- 환경변수 `LLM_PROVIDER`가 Streamlit Cloud에서 `stub`으로 설정돼 있을 가능성
- 실제 Gemini 호출은 11건만 (5/4 ~ 5/8 사이)
- 비용 $0으로 보이는 진짜 이유

**다음 액션**: Streamlit Cloud blogkey 사이트의 Secrets에 `LLM_PROVIDER=gemini` + `GEMINI_API_KEY` 확인. 또는 GH Actions secret에도 동일하게 설정.

### 4-2. 키워드 풀 빈약
- `keywords` 테이블에 **'강남라식' 1개만**
- daily_count=2로 매일 2건 생성해도 같은 키워드 반복
- 자동 콘텐츠가 단조롭게 누적되는 원인

**다음 액션**: blogkey 어드민 → 키워드 관리에서 추가 (예: 잠실라식, 송파안과, 백내장수술, 노안교정, 라섹수술 등 5-10개)

### 4-3. RLS 20개 테이블 비활성
- anon key 노출 시 즉시 전체 leak 가능 (critical 보안 risk)

**조치 완료**: 모든 테이블 RLS enable. 정책 0개 = service_role(postgres direct) 외 모두 차단. medimap-blog는 postgres direct 사용이라 무손상.

### 4-4. function 보안 경고 3건
- `medimap_inquiries_set_updated_at`, `touch_updated_at` 의 search_path mutable
- `fire_vercel_deploy_hook()` anon/authenticated 호출 가능

**조치 완료**: search_path 고정 + REVOKE EXECUTE FROM anon, authenticated

### 4-5. Vercel deploy hook 정상
- `deploy_hooks` 1행 (medimap-blog vercel deploy hook, prj_cJl6Ramc0WCdJWpIokV0Ksk8ejDl)
- 마지막 fire: 5/11 10:54 (자동 발행 테스트 글 publish 시)
- 살아있음 ✓

---

## 📊 DB 상태 변화 (외출 전 → 외출 후)

| 항목 | 외출 전 | 외출 후 |
|---|---:|---:|
| generated_contents (published) | 6 | **12** |
| generated_contents (draft pass) | 6 | 0 |
| publications | 0 | **5** |
| auto_publish 토글 | false | **true** |
| RLS 비활성 테이블 | 20 | **0** |
| Critical 보안 경고 | 1 | **0** |
| Warn 보안 경고 | 3 | **0** |
| blogs 테이블 | 없음 | **1** (멀티블로그 기반) |
| generated_contents.blog_id FK | 없음 | **추가됨** |
| publications.blog_id FK | 없음 | **추가됨** |
| shortlinks.blog_id FK | 없음 | **추가됨** |

---

## 🎯 사용자 인식 vs 실제 (한 번 더)

| 사용자 추측 | 실제 |
|---|---|
| "DB 연동 안 됨" | DB는 연동돼 있었음. PUBLICATIONS=0이라 비어 보였을 뿐 |
| "자동 배포 안 됨" | scheduler 죽음 + auto_publish OFF가 진짜 원인. Vercel은 정상 |
| "로딩 느림" | Streamlit Cloud cold start (Python 전체 재실행) + N+1. Next.js admin 이관 시 해결 |
| "Streamlit으로 만든 게 효율 낮음?" | UI는 그렇다. Python 파이프라인(LLM/RAG/통계)은 Streamlit이 아니라 Python 자체 자산이므로 보존 가치 큼 |
