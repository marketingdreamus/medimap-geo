# 메디맵 GEO/AEO — 배포 URL 인벤토리 (2026-05-25)

## 라이브 사이트

| 항목 | URL | 비고 |
|---|---|---|
| **버전 A — 메디맵 블로그** (자사 운영용) | https://medimap-blog-phi.vercel.app | 메디맵 블루 #1B68FF · /admin · /client 포털 |
| **버전 B — 메디맵 GEO** (광고대행사 시안) | https://medimap-geo.vercel.app | 딥 티얼 #0E5A6B · /data-feeding · /simulator · /ai-code · /faq · /blog · /video |
| **메디맵 본 사이트** (의료뷰티 플랫폼) | https://medi-map.co.kr | 회원 가입 + 톡톡 상담 본체 |

## GitHub 리포지토리

| 리포 | URL |
|---|---|
| 버전 A 소스 | https://github.com/passion4050-byte/Marketing |
| 버전 B 소스 | https://github.com/marketingdreamus/medimap-geo |
| 버전 A GH Actions | https://github.com/passion4050-byte/Marketing/actions |

## Supabase (양 버전 공유)

| 항목 | URL |
|---|---|
| API 엔드포인트 | https://gifopyowyankfsfghhdi.supabase.co |
| 대시보드 | https://supabase.com/dashboard/project/gifopyowyankfsfghhdi |
| DB Connection | `postgresql://postgres.gifopyowyankfsfghhdi:[pw]@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres?sslmode=require` |
| Storage bucket | `post-images` (public read) |

## Vercel 프로젝트

| 프로젝트 | 대시보드 |
|---|---|
| 버전 A | https://vercel.com/medimaps-projects/medimap-blog |
| 버전 B | https://vercel.com/medimaps-projects (medimap-blog-v2 또는 medimap-geo) |

## Streamlit (legacy, 폐기 예정)

| 사이트 | URL | 비고 |
|---|---|---|
| 테넌트 대시보드 | https://blogkey.streamlit.app | Phase 4 에서 폐기 |
| 어드민 | https://blogkey-adm.streamlit.app | Phase 4 에서 폐기 |

## 어드민 / 포털 (버전 A)

| 경로 | URL |
|---|---|
| 메디맵 직원 어드민 | https://medimap-blog-phi.vercel.app/admin |
| 클라이언트 포털 (TETE) | https://medimap-blog-phi.vercel.app/client |
| 클라이언트 로그인 | https://medimap-blog-phi.vercel.app/client/login |

## GEO/AEO 메타 (양 버전)

| 경로 | 용도 |
|---|---|
| /llms.txt | llmstxt.org 표준 |
| /llms-full.txt | 전체 콘텐츠 매니페스트 |
| /robots.txt | AI 크롤러 13종 허용 (GPTBot/ChatGPT-User/OAI-SearchBot/ClaudeBot/Claude-Web/anthropic-ai/Google-Extended/Googlebot/PerplexityBot/Perplexity-User/Bingbot/CCBot 등) |
| /sitemap.xml | XML 사이트맵 |
| /api/health | 헬스체크 |

## 핸드오프 문서 (이 폴더 안)

| 파일 | 내용 |
|---|---|
| 01-diagnosis.md | 초기 진단 |
| 02-actions-taken.md | 그동안 한 작업 |
| 03-next-steps.md | 다음 작업 큐 |
| 04-aws-migration-plan.md | AWS 이관 계획 |
| 06-streamlit-secrets-fix.md | Streamlit Secrets 핫픽스 |
| 07-overnight-progress.md | 자는 동안 진행 |
| 08-overnight-final.md | 자는 동안 최종 보고 |
| **09-v2-functional-patch.md** | **이번 패치 적용 안내** |
| **10-deployed-urls.md** | **(이 문서) URL 인벤토리** |
