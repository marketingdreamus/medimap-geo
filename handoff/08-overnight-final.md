# 자는 동안 작업 최종 보고 — 2026-05-25 새벽

> 사용자가 자는 동안 풀스택 자율 진행 결과. 일어나서 이 한 문서로 모든 상황 1분 파악.

## ✅ 한 줄 요약

D (GH Actions cron) 풀가동 + 11개 키워드 + Gemini 자동 발행 + **버전 B (광고대행사 시안) medimap-blog-v2 모노레포 통합** + 스킬 저장.
아침에 너가 할 일은 Vercel에서 **new project import (Root: medimap-blog-v2)** + `CLIENT_PASSWORD` 1줄 추가.

---

## 🎯 자는 동안 이뤄진 것

### 1. GH Actions cron 풀가동 ✅
- 매시간 자동 실행 (UTC 정각)
- 22:18 KST cron 검증: schema_org + blog_html 모두 published, Gemini 사용
- ID 14-18 새 글 5건 누적 (강남라식)
- 다음 cron부터 11개 키워드 × 2 = 매시간 새 콘텐츠 다양성

### 2. 버그 fix 3건 (코드 push) ✅

| Commit | 내용 |
|---|---|
| `103a116` | DB `SessionLocal` lazy alias (PEP 562 `__getattr__`) — cron ImportError fix |
| `e54463a` | `GOOGLE_API_KEY` OR `GEMINI_API_KEY` fallback — env 이름 mismatch fix |
| `c5e5ff4` | Gemini `response_mime_type=application/json` + lenient JSON parser — blog_html JSON 깨짐 fix |

### 3. /client 인증 ✅ (`ec8ccf3`)
- `/lib/client-auth.ts` + `/api/client/login` + `/api/client/logout` + `/client/login`
- Server-side cookie 가드 (`/client/(portal)/layout.tsx`)
- 아침에 Vercel env `CLIENT_PASSWORD` 1줄만 추가하면 활성화

### 4. ⭐ 버전 B (medimap-blog-v2) 모노레포 통합 ✅ (`099b527`)
**광고대행사 Figma 시안** (`0aTpygHZIzbzv5lHr0iRnc?node-id=804-353`) 풀반영.

- 같은 GitHub 레포 (`passion4050-byte/Marketing`)
- 같은 Supabase DB (`gifopyowyankfsfghhdi`) — 데이터 공유
- 같은 GH Actions cron — 두 사이트 모두 자동 발행
- Vercel deploy 만 분리

**버전 B 고유 페이지** (버전 A 에 없는 4 종):
- `/data-feeding` — 의료진/장비/시술/오퍼 입력 → Schema.org JSON-LD
- `/simulator` — AI 검색 시뮬레이터 (4 엔진 동시 호출)
- `/ai-code` — JSON-LD 코드 뷰
- `/video` — 영상 스크립트

디자인 토큰 (시안 100% 정합):
- Brand `#0E5A6B` 딥 티얼
- Accent `#15B8A6` 민트
- engine.chatgpt `#10A37F` / claude `#D97706` / gemini `#4285F4` / perplexity `#20B2AA`
- KPI font 2.5rem -0.02em
- livePulse + shimmer keyframes

### 5. Supabase 인프라 강화 ✅

| 작업 | 결과 |
|---|---|
| Storage bucket `post-images` 신설 | public read + 5MB 제한 + PNG/JPEG/WebP 허용 |
| `autofill_title_slug` trigger | INSERT/UPDATE 시 body 의 `<h1>` 자동 추출 → title, slug = `keyword-id` 자동 채움 |
| 기존 ID 14-18 백필 | title/slug 모두 정상 채워짐 |
| 키워드 풀 1 → **11개** | 잠실/송파/강남라식·라섹/스마일/백내장/노안교정/강남안과/시력교정/라식부작용/안과검사 |

### 6. 스킬 저장 ✅
`handoff/skills/geo-aeo-version-b/SKILL.md`. 아침에 다음 위치로 옮기면 활성화:
```
C:\Users\user\AppData\Roaming\Claude\local-agent-mode-sessions\skills-plugin\..\skills\geo-aeo-version-b\SKILL.md
```

---

## 🌅 아침에 너가 할 일 (10분)

### STEP 1 — 버전 B Vercel 새 project import (5분)

1. https://vercel.com/medimaps-projects → **Add New** → **Project**
2. **Import Git Repository** → `passion4050-byte/Marketing` 선택
3. Configure Project:
   - Project Name: `medimap-blog-v2` (또는 `medimap-geo`)
   - **Root Directory**: `medimap-blog-v2`  ← **중요!**
   - Framework Preset: Next.js (자동)
4. Environment Variables — 다음 복사 (버전 A 와 동일):
   ```
   DATABASE_URL=postgresql://postgres.gifopyowyankfsfghhdi:[pw]@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres?sslmode=require
   NEXT_PUBLIC_SUPABASE_URL=https://gifopyowyankfsfghhdi.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=(버전 A 와 동일)
   SUPABASE_SERVICE_ROLE_KEY=(버전 A 와 동일)
   LLM_PROVIDER=gemini
   GEMINI_API_KEY=(버전 A 와 동일)
   IMAGE_GEN_ENABLED=true
   ADMIN_PASSWORD=(원하는 값)
   ADMIN_SESSION_SECRET=(원하는 random 32+ chars)
   ```
5. **Deploy** → 1-3분 대기 → 라이브 URL 확보

### STEP 2 — 버전 A 의 `CLIENT_PASSWORD` 추가 (3분)

기존 medimap-blog 의 Vercel 프로젝트에서:
1. Settings → Environment Variables
2. **`CLIENT_PASSWORD`** = `tete-medimap-2026` (또는 원하는 값) 추가
3. Save → 자동 redeploy

→ `/client/login` 작동 시작

### STEP 3 — 스킬 활성화 (2분)

`C:\Users\user\Documents\Claude\Projects\GEO\AEO 프로그램\handoff\skills\geo-aeo-version-b\SKILL.md` 를
`C:\Users\user\AppData\Roaming\Claude\local-agent-mode-sessions\skills-plugin\d03f71fe-7db7-40d2-b082-1012ba682524\2f2bcd1c-5861-489c-9270-f5a429ac0af9\skills\geo-aeo-version-b\SKILL.md` 로 복사.

다음 클로드 세션에서 "메디맵 GEO 버전 B" 같은 표현 쓰면 자동 활성화.

---

## 📊 라이브 상태

### 버전 A — https://medimap-blog-phi.vercel.app
- 메인 / 블로그 / 어드민 / 클라이언트 포털 모두 작동
- meta-theme-color `#1B68FF` (메디맵 블루)
- /client 포털 데이터 정상 (12 발행글, 마지막 5시간 전)
- 로고 새 SVG 적용

### 버전 B — (아침에 Vercel import 후 발생)
- Root: `medimap-blog-v2`
- 광고대행사 시안 (딥 티얼)
- 같은 DB 공유 → 같은 글 보이지만 다른 UI

### GH Actions cron
- 매시간 자동 실행 검증됨
- 다음 정각부터 11개 키워드 + 이미지 자동 첨부 시도

### Supabase DB 상태
- generated_contents: **18 row** (5건 신규 추가 — Gemini 생성)
- 키워드: 1 → **11**
- post-images Storage bucket: ✅
- title/slug autofill trigger: ✅

---

## 🔜 다음 결정 (사용자 복귀 후)

| 결정 사항 | 옵션 |
|---|---|
| **B. Streamlit 폐기 시점** | 즉시 / 2주 dual-run / 안내만 |
| 버전 B URL 도메인 | `medimap-geo.vercel.app` / `medimap-v2.medi-map.co.kr` / 기타 |
| /client tenant별 인증 강화 | 단일 password (현재) / tenant.password_hash bcrypt |
| AWS 이관 (Phase 5) | 4-6주 후 인용 입증 시점 |

---

## ✅ 최종 commit 목록 (시간순)

```
099b527 feat(v2): medimap-blog-v2 신설 — 광고대행사 시안 (딥 티얼) 버전 B
ec8ccf3 feat(client-auth): tenant별 /client 포털 password 게이트 (STEP A)
c5e5ff4 fix(gemini-json): response_mime_type=application/json + lenient parser
e54463a fix(llm): GOOGLE_API_KEY OR GEMINI_API_KEY fallback (Gemini)
103a116 fix(db): SessionLocal lazy alias — GH Actions cron ImportError fix
cd9a22e feat(geo-aeo + perf): llms.txt + AI 크롤러 풀세트 + /client layout 핵심 버그 fix
e66f5be chore(email): 잔존 cs@medimap.co.kr → sales@medimap.team
480639a chore(site): 네이버 플레이스 URL timestamp 갱신
a625f11 fix(contact + header + hooks + /client layout): 종합 fix
feca951 feat(logo) + chore(blog header) + verify(/admin /client)
```

## 🎁 보너스 작업 (자동 진행됨)

- Supabase Storage bucket `post-images` (이미지 자동 첨부 인프라)
- title/slug 자동 채움 DB trigger (수동 백필 불필요)
- 11개 키워드 INSERT (블로그 콘텐츠 다양성)

자세한 사항은 `01-diagnosis.md`, `02-actions-taken.md`, `03-next-steps.md`, `04-aws-migration-plan.md`, `06-streamlit-secrets-fix.md`, `07-overnight-progress.md` 참조.

밤사이 작업 끝. 잘 잤어? ☕
