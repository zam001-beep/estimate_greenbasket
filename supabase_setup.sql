-- 녹색바구니 팀 공유용 테이블 (Supabase > SQL Editor 에 붙여넣고 Run)
-- 실행 전에 아래 'team@example.com' 을 팀 공용 계정 이메일로 바꾸세요 (한 군데).

create table if not exists public.parties (
  kind       text        not null check (kind in ('sup', 'rcv')),  -- sup: 공급자, rcv: 거래처
  name       text        not null,                                  -- 상호
  data       jsonb       not null,                                  -- 사업자번호·주소·도장 이미지 등
  deleted    boolean     not null default false,                    -- 삭제 표시
  updated_at timestamptz not null default now(),
  primary key (kind, name)
);

-- 행 단위 보안: 로그인한 팀 공용 계정만 읽고 쓸 수 있다.
-- 로그인하지 않은 사람, 다른 이메일로 가입한 사람은 한 줄도 볼 수 없다.
alter table public.parties enable row level security;

drop policy if exists "team only" on public.parties;
create policy "team only" on public.parties
  for all to authenticated
  using      ((auth.jwt() ->> 'email') = 'team@example.com')
  with check ((auth.jwt() ->> 'email') = 'team@example.com');

revoke all on public.parties from anon;
grant select, insert, update on public.parties to authenticated;
