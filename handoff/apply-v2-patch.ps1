# ===========================================================
# medimap-geo (버전 B) — 모든 메뉴 인터랙티브화 패치 적용
# 한번에 실행: powershell -ExecutionPolicy Bypass -File handoff\apply-v2-patch.ps1
# ===========================================================

$ErrorActionPreference = 'Stop'
$root = "C:\Users\user\Documents\Claude\Projects\GEO\AEO 프로그램"

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " medimap-geo v2 패치 적용 시작" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $root
Write-Host "[1/7] 작업 폴더 진입: $root" -ForegroundColor Green

# 1) 잔존 git lock 파일 제거
if (Test-Path ".git\index.lock") {
    Remove-Item -Force ".git\index.lock"
    Write-Host "[2/7] .git\index.lock 제거됨" -ForegroundColor Green
} else {
    Write-Host "[2/7] .git\index.lock 없음 (정상)" -ForegroundColor Green
}

# 2) 패치된 파일 11개 강제 덮어쓰기
$srcDir = Join-Path $root "handoff\v2-patches\src"
if (-not (Test-Path $srcDir)) {
    Write-Host "ERROR: handoff\v2-patches\src 폴더가 없음. handoff/ 폴더 확인 필요" -ForegroundColor Red
    exit 1
}
Write-Host "[3/7] 패치 파일 강제 복사 중..." -ForegroundColor Green
$result = & xcopy /Y /S /Q $srcDir "src\" 2>&1
Write-Host $result -ForegroundColor Gray

# 3) 변경 사항 확인
Write-Host "[4/7] git status 확인" -ForegroundColor Green
$status = git status --short
if (-not $status) {
    Write-Host "WARN: 변경 없음 — 이미 동일한 내용이거나 xcopy 실패" -ForegroundColor Yellow
    Write-Host "      diff 강제 확인:" -ForegroundColor Yellow
    git diff --stat
} else {
    Write-Host $status -ForegroundColor Gray
}

# 4) commit
Write-Host "[5/7] commit 시도" -ForegroundColor Green
git add -A
$diffCheck = git diff --cached --stat
if (-not $diffCheck) {
    Write-Host "WARN: 스테이징 변경 없음. 커밋 스킵." -ForegroundColor Yellow
} else {
    git commit -m "feat(v2): 모든 메뉴 페이지 인터랙티브화 — dead button 0건

- 신규 API: /api/simulator/compare, /api/blog/generate, /api/video/generate
- src/lib/clientActions.ts: clipboard/blob/toast 공통 유틸
- / : PDF 다운로드 동작
- /data-feeding: form state + localStorage + 필수필드 검증
- /simulator: 4 엔진 동시 비교 + 스레드 전환
- /ai-code: .html 다운로드 + 토스트
- /faq: 본문 복사 + 검수/발행 상태 토글 + AI 추가 모달
- /blog: 5글 생성 + .md 묶음 다운로드 + 네이버 발행 토글
- /video: 스크립트 생성 + 복사 + 채널 업로드 토글"
    Write-Host "[5/7] commit 완료" -ForegroundColor Green
}

# 5) push
Write-Host "[6/7] git push origin main" -ForegroundColor Green
git push origin main

Write-Host ""
Write-Host "[7/7] 완료!" -ForegroundColor Cyan
Write-Host ""
Write-Host "다음 단계:" -ForegroundColor Yellow
Write-Host "  1. Vercel 빌드 1-3분 대기"
Write-Host "  2. https://medimap-geo.vercel.app/data-feeding 새로고침"
Write-Host "  3. 각 페이지 버튼 클릭 검증"
Write-Host ""
Write-Host "참고:"
Write-Host "  - 만약 'Everything up-to-date' 가 나오면 패치는 이미 적용된 상태"
Write-Host "  - 만약 push 실패 (403) 가 나오면 Vercel 자체가 다른 repo 연결일 수 있음"
Write-Host "    → Vercel Dashboard → medimap-geo project → Settings → Git 에서 연결 repo 확인"
Write-Host ""
