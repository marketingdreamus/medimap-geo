# 🚨 Streamlit Cloud Secrets — silent SQLite fallback 사고 fix

> 2026-05-24 사용자 보고: blogkey-adm 에서 테넌트 추가/키워드 추가 등이 **DB 에 반영 안 됨**.

## 진단 결과 (확정)

`src/storage/db.py` 의 fallback 코드가 원인:
```python
url = os.getenv("DATABASE_URL", "sqlite:///./data/geo.db")  # ← 이 부분
```

→ Streamlit Cloud secrets 에 `DATABASE_URL` 누락 시 **SQLite 임시 저장 모드** 로 fallback.

- 사용자 폼 제출 → 컨테이너 내부 SQLite 에 INSERT (success 메시지 정상 표시)
- Streamlit Cloud 컨테이너 슬립/재시작 → SQLite 휘발
- Supabase 에서 조회하면 row 없음

## 코드 차원 영구 차단 (이미 적용됨, 다음 push 에 포함)

`src/storage/db.py` 강화:
- `DATABASE_URL` 미설정 시 명시적 `RuntimeError` 발생 (silent fallback 차단)
- `STREAMLIT_ALLOW_SQLITE=true` 명시 토글한 경우에만 sqlite 허용 (로컬 개발용)
- `get_db_kind()` 헬퍼 신설 → admin/dashboard 상단 배너로 현재 DB 표시

배너 동작:
- `postgres` → 배너 없음 (정상)
- `sqlite-fallback` → 🚨 빨간 에러 배너 ("DATABASE_URL 미설정 — 컨테이너 휘발")
- `sqlite` → ⚠️ 노랑 경고 ("로컬 DB. Production 비추")

## 너가 즉시 처리할 것 (10분)

### 1. blogkey-adm Streamlit Secrets 추가

https://share.streamlit.io/ → **blogkey-adm** app → ⚙️ Settings → Secrets

```toml
# 필수
DATABASE_URL = "postgresql://postgres.gifopyowyankfsfghhdi:[YOUR-PASSWORD]@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres"
SUPABASE_URL = "https://gifopyowyankfsfghhdi.supabase.co"
SUPABASE_SERVICE_ROLE_KEY = "(외출 동안 너가 준 service_role JWT — 또는 reset 후 신규)"
ADMIN_APP_PASSWORD = "(현재 어드민 패스워드)"

# 선택
LLM_PROVIDER = "gemini"
GEMINI_API_KEY = "(있으면)"
MAX_DAILY_USD = "10"
IMAGE_GEN_ENABLED = "true"   # Pollinations.AI 자동 이미지 첨부 활성화
```

### 2. blogkey (테넌트 대시보드) Streamlit Secrets 추가

같은 형식. 추가로:
```toml
APP_PASSWORD = "(테넌트 게이트 패스워드)"
TENANT_AUTH_REQUIRED = "true"
```

### 3. `[YOUR-PASSWORD]` 어디서 얻나

Supabase Dashboard → Settings → Database → **Connection string** → "Transaction" 모드 (포트 6543) 복사:
```
postgresql://postgres.gifopyowyankfsfghhdi:<진짜 패스워드>@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres
```
위 `<진짜 패스워드>` 부분이 그대로 들어갈 값. 또는 Database password reset 으로 새로 발급.

### 4. Save 후 Reboot

- Secrets 저장 → 자동 reboot (수십 초)
- blogkey-adm 접속 → 상단 배너가 사라졌는지 확인 (배너 = 아직 미적용)
- 테넌트 추가 → Supabase 에서 직접 SQL 조회 (`SELECT * FROM tenants`) 로 반영 확인

## 같은 patch 가 적용된 곳 (push 이후)

- `src/admin/app.py` — render_admin_header 직후 _db_safety_banner() 호출
- `src/dashboard/app.py` — set_page_config 직후 _db_safety_banner() 호출

## 향후 작업

- GH Actions secrets 에도 동일 패턴 (이미 handoff/03-next-steps.md 2번 참조)
- AWS 이관 시 IAM role 기반 인증으로 전환 가능 (handoff/04-aws-migration-plan.md)
