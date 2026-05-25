---
name: geo-aeo-version-b
description: 메디맵 GEO/AEO SaaS 버전 B — 광고대행사 Figma 시안(node 804:353) 기반 별도 사이트. 딥 티얼 #0E5A6B + 민트 #15B8A6 + 4 LLM 엔진 시그니처 컬러. 같은 Supabase + 같은 GH Actions cron 공유. Data Feeding/AI 코드/Simulator/영상 라우트 풀반영. medimap-blog/(버전 A 메디맵 블루)와 별도 운영. medimap-blog-v2 폴더 또는 사용자가 'GEO 버전 B', 'medimap-blog-v2', 'medimap-geo', '딥 티얼', '광고대행사 시안 사이트', 'Figma 804:353', '4엔진 시그니처 컬러', 'Data Feeding 페이지', 'AI 코드 페이지', 'Simulator 페이지' 같은 표현 쓰면 반드시 이 스킬을 사용한다.
---

# 메디맵 GEO/AEO SaaS — 버전 B (광고대행사 시안)

## 무엇

메디맵의 GEO/AEO SaaS 의 **버전 B**. Figma `0aTpygHZIzbzv5lHr0iRnc?node-id=804-353` 시안 기반.
같은 `passion4050-byte/Marketing` 모노레포의 `medimap-blog-v2/` 폴더.

**버전 A (medimap-blog/)** = 메디맵 블루 #1B68FF — 자사 운영용 + 클라이언트 포털
**버전 B (medimap-blog-v2/)** = 딥 티얼 #0E5A6B — 광고대행사 시안 풀반영

같은 Supabase DB (`gifopyowyankfsfghhdi`) + 같은 GH Actions cron 공유. Vercel deploy 만 분리.

## 디자인 토큰 (절대 어기지 말 것)

| 토큰 | 값 | 용도 |
|---|---|---|
| `brand.DEFAULT` | `#0E5A6B` | 딥 티얼 — 의료 신뢰감 / AI 데이터 톤 |
| `brand.dark` | `#0B4C5A` | hover/pressed |
| `brand.50~900` | `#F0F7F8 ~ #031F25` | scale |
| `accent.DEFAULT` | `#15B8A6` | 민트 (데이터 강조) |
| `accent.soft` | `#CCFBF1` | 배경 옅은 강조 |
| `accent.deep` | `#0F766E` | text 강조 |
| `surface.base` | `#FFFFFF` | 카드/패널 |
| `surface.subtle` | `#F7F9FA` | 페이지 배경 |
| `ink.DEFAULT` | `#0F172A` | 본문 |
| `ink.soft/muted/faint` | `#334155 / #64748B / #94A3B8` | 계층 |
| `border.DEFAULT` | `#E5EBED` | 가는 선 |

**LLM 엔진 시그니처 컬러** (4-엔진 비교 차트 — 고정):
- `engine.chatgpt #10A37F`
- `engine.claude #D97706`
- `engine.gemini #4285F4`
- `engine.perplexity #20B2AA`

폰트: Pretendard + Noto Sans KR fallback. 모노: JetBrains Mono.

**KPI 타이포** (시그니처):
- `kpi`: 2.5rem / lineHeight 1.1 / weight 700 / letterSpacing -0.02em

**Keyframes**:
- `livePulse`: KPI 카드 우상단 실시간 dot
- `shimmer`: skeleton

## 라우트 (버전 B 풀세트)

| 라우트 | 역할 |
|---|---|
| `/` | 통합 대시보드 + AI 모니터링 — 4 엔진 비교 차트 |
| `/data-feeding` | 의료진/장비/시술/오퍼 입력 → Schema.org JSON-LD 자동 생성 |
| `/simulator` | AI 검색 시뮬레이터 — 4 엔진 동시 호출 |
| `/ai-code` | JSON-LD 코드 뷰 (복사 가능) |
| `/faq` | FAQ Q&A 텍스트 |
| `/blog` + `/blog/[slug]` | 블로그 콘텐츠 (버전 A 와 같은 DB) |
| `/video` | 영상 스크립트 |
| `/admin/funnel` | Publication ROI |
| `/r/[slug]` | ShortLink |
| `/llms.txt`, `/llms-full.txt`, `/robots.txt`, `/sitemap.xml` | GEO/AEO 메타 |

## 같은 Supabase 공유

```
DATABASE_URL=postgresql://postgres.gifopyowyankfsfghhdi:[pw]@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres?sslmode=require
NEXT_PUBLIC_SUPABASE_URL=https://gifopyowyankfsfghhdi.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
LLM_PROVIDER=gemini
GEMINI_API_KEY=...   (GOOGLE_API_KEY fallback 지원)
IMAGE_GEN_ENABLED=true
```

같은 GH Actions cron 워크플로 매시간 콘텐츠 생성 → 버전 A 와 B 모두 같은 DB 읽음.

## 디자인 컨벤션

1. 모든 컬러는 토큰 변수만. hex 직접 사용 금지
2. 카드 = `rounded-2xl border border-border bg-surface-base shadow-card`
3. KPI 카드 = 우상단 `animate-live-pulse` dot + `font-kpi` 숫자 + 변화율 chip
4. 차트 = recharts. 4 엔진 비교 시 `engine.*` 컬러 고정. 라인 2px, dot 4px
5. 버튼: primary `bg-brand text-white` / secondary `border border-border` / ghost `text-ink-muted`
6. chip = `inline-flex rounded-full px-2 py-0.5 text-xs font-semibold`
7. focus ring `focus:ring-3 focus:ring-brand/18`
8. 의료법 9 룰 린트 통과 콘텐츠만 발행

## KPI 카드 표준 코드

```tsx
<div className="rounded-2xl border border-border bg-surface-base p-5 shadow-card">
  <div className="flex items-start justify-between">
    <div className="text-xs font-semibold uppercase tracking-wider text-ink-muted">{label}</div>
    <span className="block h-2 w-2 rounded-full bg-status-success animate-live-pulse" />
  </div>
  <div className="mt-3 text-kpi text-ink">{value.toLocaleString("ko-KR")}</div>
  {delta && (
    <div className="mt-1 inline-flex items-center gap-1 rounded-full bg-status-successSoft px-2 py-0.5 text-xs font-semibold text-status-success">
      {delta.positive ? "▲" : "▼"} {delta.value}
    </div>
  )}
</div>
```

## 배포

- 같은 GitHub 레포: `passion4050-byte/Marketing`
- Vercel 별도 project — Root Directory `medimap-blog-v2`
- 환경변수 — 버전 A 와 동일

## 분리 / 충돌 가드

- 포트: dev `3002`, 버전 A 는 `3001`
- DB: 같은 인스턴스 공유. 같은 tenant_id 데이터 표시
- 시각적: 딥 티얼 vs 메디맵 블루 — 사용자가 한눈에 구분
- GH Actions cron: 워크플로 1 개. 두 사이트 모두 같은 DB 읽음

## 검수 체크리스트

- [ ] hex 하드코딩 0 건 (토큰만 사용)
- [ ] livePulse dot 이 모든 실시간 KPI 카드에 있나
- [ ] 4 엔진 시그니처 컬러가 차트에 일관 적용됐나
- [ ] 의료법 린터 통과한 콘텐츠만 publish 되나
- [ ] robots.txt 의 AI 크롤러 13 종 적용됐나
- [ ] /simulator 가 4 엔진 동시 호출 + cited URL 매칭하나

## 알려진 함정 (버전 A 에서 학습)

- SSG 빌드 timeout: `staticPageGenerationTimeout: 180` + DB 쿼리 8 초 Promise.race
- 한글 slug: `encodeURIComponent` + `decodeURIComponent`
- PgBouncer transaction mode: `prepare: false`
- Gemini JSON 깨짐: `response_mime_type: "application/json"` + lenient parser
