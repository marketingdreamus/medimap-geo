# 변경 내역 — 시간순 (사용자 외출 2026-05-24 07:00 ~ 08:00 KST)

## 🗄️ Supabase 직접 변경 (4건)

| 시각 | Migration / SQL | 내용 |
|---|---|---|
| 07:27 | INLINE UPDATE | `generated_contents` draft 6건 → published (id 1, 3, 5, 6, 8, 9) |
| 07:30 | INLINE UPDATE | `auto_content_settings.auto_publish` false → **true** |
| 07:35 | INLINE INSERT | `publications` 5건 백필 (blog_html only, 한글 slug) |
| 07:40 | `enable_rls_20_tables_anon_leak_guard` | 20개 테이블 RLS enable. 정책 0개 = service_role 외 차단 |
| 07:42 | `fix_function_security_warnings` | search_path 고정 (2개) + fire_vercel_deploy_hook anon REVOKE |
| 07:50 | `multi_blog_schema` | `blogs` 테이블 + medimap-blog row 1 시드 + 3개 FK 추가 |

---

## 🎨 GitHub commit + push (2건)

### Commit `42a752c` — 메디맵 블루 디자인 토큰 전면 교체 (17 files)

```
medimap-blog/tailwind.config.ts       brand DEFAULT/scale, accent scale, shadow, mesh
medimap-blog/src/app/globals.css      --color-brand, --color-accent, UX-fix outline
medimap-blog/src/app/layout.tsx       themeColor
medimap-blog/src/app/icon.tsx         gradient
medimap-blog/src/app/apple-icon.tsx   gradient
medimap-blog/src/app/opengraph-image.tsx        gradient
medimap-blog/src/app/blog/[slug]/opengraph-image.tsx  gradient
medimap-blog/src/app/admin/(panel)/page.tsx     차트 색
medimap-blog/src/app/about/page.tsx   drop-shadow rgba
medimap-blog/src/components/Header.tsx  rgba gradient + drop-shadow
src/dashboard/theme.py                Streamlit 테넌트 — PRIMARY, PRIMARY_LIGHT, ACCENT
src/dashboard/dashboard_tab.py        _BRAND 차트 토큰
src/dashboard/measurement_tab.py      _BRAND_PINK 차트 토큰
src/admin/theme.py                    Streamlit 어드민 — BRAND, BRAND_LIGHT, gradient
src/admin/app.py                      Streamlit 어드민 — 인라인 gradient
src/marketing/cta_templates.py        4채널 발행 CTA 블록 색 (외부 노출)
CLAUDE.md                             cross-site sync 노트 갱신
```

**색 변경**:
- `#FF4D5E` (강남언니 핫핑크) → `#1B68FF` (메디맵 Primary)
- `#FF6B35` (오렌지) → `#1AD2A4` (메디맵 Sub Mint)
- `#FF6E7C` → `#5290FF`
- rgba(255,77,94,*) → rgba(27,104,255,*)
- rgba(255,107,53,*) → rgba(26,210,164,*)
- rgba(16,24,40,*) → rgba(11,18,36,*) (ink 베이스도 메디맵 #0B1224 톤)
- `#d83547` → `#0E44AD` (다크 모드 brand-700)
- `#FFEFF1` → `#EEF4FF`, `#FFF1EA` → `#E8FBF6`, `#FFE9EC` → `#DCE9FF`, `#FFF6F7` → `#EEF4FF`

**검증**:
- 잔존 핑크 hex 0건 (광역 grep)
- TS typecheck pass
- 백업: `/tmp/backup-strawberry/` (10 파일, 세션 종료 시 휘발)

### Commit `e936d33` — GH Actions cron entry (1 file)

```
scripts/run_auto_content_once.py  daily_auto_content_job 단발 실행 진입점
```

- `.github/workflows/auto-publish.yml`은 **PAT scope 부족으로 push 거부됨** → `handoff/auto-publish.yml`에 별도 보관. 사용자가 GH UI로 직접 추가 필요

---

## ❌ 시도했으나 실패한 작업

| 시도 | 실패 원인 | 우회 |
|---|---|---|
| Vercel API 직접 호출 (curl) | Sandbox 외부 네트워크 차단 | Vercel MCP 재인증 필요 (사용자 복귀 후) |
| `fire_vercel_deploy_hook()` RPC 호출 | trigger function이라 직접 호출 불가 | git push가 이미 Vercel 자동 빌드 트리거 |
| 한글 URL 직접 fetch | Anthropic cowork 정책 차단 | 메인 페이지 메타로 검증 |
| `.github/workflows/*.yml` push | PAT에 `workflow` scope 없음 | handoff 폴더에 yml 동봉 |
| `npm run build` 검증 | 45초 타임아웃 초과 | TS typecheck + ESLint만 빠르게 통과 확인 |

---

## 📁 Handoff 파일 목록

```
handoff/
├── 00-progress.md           (이 문서 — 실시간 진척)
├── 01-diagnosis.md          (진단 보고서 — 16일 멈춤 원인 3가지)
├── 02-actions-taken.md      (이 문서 — 시간순 변경 내역)
├── 03-next-steps.md         (복귀 후 즉시 처리할 5단계)
├── 04-aws-migration-plan.md (AWS 이관 청사진)
└── auto-publish.yml         (GH Actions cron 워크플로 — 수동 추가용)
```
