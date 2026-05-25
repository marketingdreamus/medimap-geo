# AWS 이관 청사진 (4-6주 후, 인용 입증 후)

> **언제 이관할까?** AI 인용이 실증된 후. 1주일 안에 이관하면 인용 누적 무효화될 위험.
> POC = Supabase Free + Vercel Hobby + Streamlit Cloud 무료. 입증 시점에 이관.

---

## 0. 이관 결정 트리거 (Sparring 관점)

### 이관해야 할 시점 신호
- LLM이 우리 콘텐츠 인용한 응답을 **주당 5건 이상 측정** (mentions 테이블 누적)
- 자사 블로그 + 외부 채널 합쳐 **publication 50건 이상**
- **medimap_inquiries 폼 제출 10건+** (Funnel 실작동)
- 위 3개 중 2개 이상 충족 시 이관 추진. 1개 이하면 POC 보강에 집중

### 이관 절대 금지 시점
- 인용 측정 0건 (= AI에 노출 안 됨 = AWS 옮겨도 동일)
- publication < 20건 (= 인덱싱 표본 부족)
- medimap_inquiries < 3건 (= Funnel 작동 검증 안 됨)

---

## 1. 이관 대상 자산 매트릭스

| 현재 | AWS 이관 후 | 비용/주의 |
|---|---|---|
| **medimap-blog (Vercel)** | EC2/ECS + CloudFront, 또는 AWS Amplify Hosting | Amplify가 가장 가까움. Next.js ISR 지원 |
| **Supabase (gifopyowyankfsfghhdi)** | RDS PostgreSQL + IAM auth | service_role 개념 폐기, PgBouncer 직접 운영 |
| **Streamlit Cloud (blogkey, blogkey-adm)** | **Next.js /admin으로 이관 후 폐기** (별도 PR) | 이관 후 Streamlit 운영 종료 |
| **GitHub Actions cron** | EventBridge + Lambda, 또는 ECS Scheduled Task | 무료 한도 넘어가면 Lambda 비용 |
| **Vercel Cron / deploy_hook** | CloudFront Invalidation API | next/cache 처리 직접 구현 |
| **GA4** | 그대로 유지 (Google) | 변경 없음 |

---

## 2. 멀티블로그 인프라 (POC 단계 이미 준비됨)

`blogs` 테이블이 있으니 AWS 이관 시 N개 인스턴스 운영 패턴:

### 도메인 전략 (3가지 옵션)

| 옵션 | 예시 | 장단 |
|---|---|---|
| **A. 같은 도메인 하위 경로** | medimap.co.kr/site1, /site2 | AEO 권위 누적 최대. Next.js middleware로 blog_id 라우팅 |
| **B. 서브도메인** | site1.medimap.co.kr | 도메인 권위 일부 공유. SSL/DNS 관리 부담 |
| **C. 완전 별 도메인** | each-clinic.com | AEO 권위 0부터. 단 '병원별 GEO SaaS 패키지' 모델에 적합 |

**스파링 권장**: 메디맵 자체 콘텐츠 자산은 **A**, 클라이언트 병원 SaaS 패키지는 **C**. 하이브리드.

### AWS 인프라 (옵션 A 기준)

```
Route53 (medimap.co.kr)
  └─ CloudFront
       └─ Amplify (Next.js)
            ├─ middleware.ts (path → blog_id 매핑)
            └─ /blog/[blog_slug]/[post_slug] 동적 라우트

RDS PostgreSQL (Multi-AZ)
  └─ blogs, generated_contents, publications, ...

EventBridge (cron: hourly)
  └─ Lambda (Python — daily_auto_content_job)
       └─ RDS write + CloudFront Invalidation
```

---

## 3. 비용 추정 (1년)

| 서비스 | POC (지금) | AWS 이관 후 |
|---|---:|---:|
| Hosting | $0 (Vercel Hobby) | $30/mo (Amplify, 트래픽 따라) |
| DB | $0 (Supabase Free 500MB) | $25/mo (RDS db.t4g.micro 20GB) |
| Cron | $0 (GH Actions free) | $5/mo (Lambda + EventBridge) |
| LLM | $0~10 (Free tier + 가드레일) | 그대로 |
| **합계** | **$0~10/mo** | **$60~80/mo** |

**스파링**: POC 비용 거의 0. AWS 이관 정당화 = 보안 컴플라이언스 또는 멀티 클라이언트 운영 시. 단순 안정성 위해서는 비효율 (Vercel Pro $20/mo면 슬립 문제 해결).

---

## 4. 이관 단계 (단계별 1-2주)

### 주 1: DB 이관 dry-run
- AWS RDS 생성 (Multi-AZ 없이 시작)
- `pg_dump gifopyowyankfsfghhdi → pg_restore RDS`
- 데이터 정합성 검증 (row count + checksum)
- alembic head 매칭 확인

### 주 2: medimap-blog 이관
- Amplify Hosting에 GitHub 연결
- DATABASE_URL → RDS endpoint
- 환경변수 마이그레이션
- ISR 동작 검증
- DNS 전환 (Vercel → CloudFront)

### 주 3: cron 이관
- Lambda 함수 (Python 3.11) 패키징
- EventBridge 스케줄 (rate(1 hour))
- 첫 실행 로그 검증
- GH Actions 폐기

### 주 4: 모니터링 + 알람
- CloudWatch 알람 (RDS CPU, Lambda 에러)
- AI 인용 측정 자동화 검증
- Vercel/Supabase 자원 정리 (백업 후 폐기)

---

## 5. 의사결정 권장 (4-6주 후 재평가)

**시나리오 A** (인용 < 주 5건): AWS 이관 보류. Supabase Pro($25/mo)만 업그레이드 (RLS 정책 풀고 DB pool 늘림). 

**시나리오 B** (인용 ≥ 주 5건 + publication ≥ 50): AWS 이관 진행. 위 4단계 1개월.

**시나리오 C** (외부 병원 클라이언트 5개 이상 영입): 멀티 도메인 운영 필수 → AWS + 멀티블로그 풀활용. 옵션 C 도메인 전략.

---

## 6. 이관 위험 체크리스트

- [ ] DATABASE_URL 변경 시점에 medimap-blog 다운타임 0초 보장 (blue-green deploy)
- [ ] Streamlit Cloud secrets 마이그레이션 (또는 폐기 결정)
- [ ] AI 크롤러 robots.txt 신규 도메인에 적용
- [ ] llms.txt / llms-full.txt 신규 도메인에 적용
- [ ] 모든 publication URL 갱신 (도메인 변경 시 SEO/AEO 권위 일시 손실)
- [ ] 301 redirect 1년 유지 (옛 vercel.app → 신 도메인)
- [ ] medimap_inquiries 폼 backend URL 갱신

---

> 이 문서는 **인용 입증 후 작성될 정식 RFC의 초안**. 지금 4-6주는 POC 완성도에 집중하는 게 옳다.
