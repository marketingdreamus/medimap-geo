# GEO 버전 B (medimap-geo) — 모든 메뉴 인터랙티브화 패치

> 2026-05-25. v2 사이트 전수 검수 결과: 모든 페이지가 UI shell 만 있고 **버튼 100% dead** 상태.
> 본 패치로 7개 페이지 × 모든 CTA 가 실제 동작하도록 수정.

## 무엇이 바뀌었나

| 페이지 | 이전 | 이후 |
|---|---|---|
| `/` (대시보드) | PDF 다운로드 버튼 무반응 | `window.print()` 트리거 + 토스트 |
| `/data-feeding` | 모든 필드 빈 칸, 저장 무반응 | form state + localStorage 저장 + 필수필드 검증 + 패널 X close/restore |
| `/simulator` | 전송 버튼 무반응, 스레드 전환 X | `/api/simulator/compare` 호출 + 4 엔진 BEFORE/AFTER 동시 응답 누적 + 스레드 전환 + 추천 질문 클릭 |
| `/ai-code` | .html 다운로드 무반응 | blob 다운로드 + 토스트 |
| `/faq` | 본문복사/검수/발행/AI추가 무반응 | clipboard 복사 + 검수/발행 상태 토글 + AI 추가 모달 (`/api/faq/generate`) |
| `/blog` | 5글 생성/복사/다운로드/발행 무반응 | `/api/blog/generate` 호출 + 본문 markdown 복사 + 5글 .md 묶음 다운로드 + 네이버 발행 상태 토글 |
| `/video` | 스크립트 생성/복사/업로드 무반응 | `/api/video/generate` 호출 + 스크립트 markdown 복사 + 채널 업로드 상태 토글 |

## 신규 파일 (4개)

- `src/lib/clientActions.ts` — clipboard / blob 다운로드 / 토스트 공통 유틸 (외부 의존성 0)
- `src/app/api/simulator/compare/route.ts` — 4 엔진 BEFORE/AFTER 비교 stub (env 키 있으면 실 호출로 교체 예정)
- `src/app/api/blog/generate/route.ts` — 소재 → 5변형 글 생성 stub
- `src/app/api/video/generate/route.ts` — 영상 스크립트 3종(Shorts/Reels/YouTube) stub

## 수정 파일 (7개)

- `src/app/page.tsx`
- `src/app/data-feeding/page.tsx`
- `src/app/simulator/page.tsx`
- `src/app/ai-code/page.tsx`
- `src/app/faq/page.tsx`
- `src/app/blog/page.tsx`
- `src/app/video/page.tsx`

## 패치 적용 방법 (선택 1, 더 안전한 옵션)

내 PowerShell / cmd 에서 (medimap-geo 작업 폴더 = `C:\Users\user\Documents\Claude\Projects\GEO\AEO 프로그램`):

```powershell
cd "C:\Users\user\Documents\Claude\Projects\GEO\AEO 프로그램"

# 패치 적용
git apply handoff\v2-functional.patch

# 검증
npm run typecheck

# 커밋 + 푸시
git add -A
git commit -m "feat(v2): 모든 메뉴 페이지 인터랙티브화 — dead button 0건"
git push origin main
```

→ Vercel 자동 빌드 (1-3분) → 라이브 검증.

## 패치 적용 방법 (선택 2, 패치 실패 시 fallback)

`handoff/v2-patches/` 에 패치된 파일 11개가 그대로 들어 있음. 그대로 덮어쓰기:

```powershell
cd "C:\Users\user\Documents\Claude\Projects\GEO\AEO 프로그램"
xcopy /Y /S handoff\v2-patches\src src\
git add -A
git commit -m "feat(v2): 모든 메뉴 페이지 인터랙티브화"
git push origin main
```

## 검증 체크리스트 (배포 후 라이브에서)

- [ ] `/` 우상단 "PDF 다운로드" 클릭 → 브라우저 인쇄 다이얼로그
- [ ] `/data-feeding` 의료진 카테고리 → 빈 필드 채우고 "추가" → 토스트 + 다음 방문 시 값 복원
- [ ] `/simulator` 입력창 "잠실 라식 비용" 입력 → 전송 → 4 엔진 BEFORE/AFTER 카드 4 컬럼 표시
- [ ] `/ai-code` ".html 다운로드" → 즉시 .html 파일 다운로드
- [ ] `/faq` "AI로 FAQ 추가" → 모달 → "잠실 라섹" 입력 → 3건 FAQ 추가
- [ ] `/blog` "안구건조증" 입력 → "소재 + 5글 생성" → 좌측 리스트에 새 소재 + 우측 5글 카드
- [ ] `/video` "라섹 회복기" 입력 → "스크립트 생성" → 3 카드 (Shorts/Reels/YouTube)

## 알려진 제약

- API 라우트 3종은 모두 **stub** (mock 응답). 실제 LLM 호출은 다음 단계.
  - `LLM_PROVIDER=gemini` + `GEMINI_API_KEY` env 추가하면 simulator/blog/video API 모두 실 호출로 교체 가능 (route.ts 의 stub 부분만 교체).
- `/data-feeding` 저장은 localStorage 만 (브라우저별 보존). 운영 DB 연동은 다음 단계.
- "네이버 발행", "채널 업로드" 는 클라이언트 상태만 토글. 실제 외부 API 연동은 별도.

## 가드

- `tsc --noEmit` — 패치 적용 후 typecheck 통과 확인됨 (factory.ts 의 기존 ⚠️ 2건은 패치 무관)
- 모든 새 코드는 디자인 토큰만 사용 (hex 하드코딩 0)
- 4 엔진 시그니처 컬러 일관 적용 (`bg-engine-chatgpt/claude/gemini/perplexity`)
