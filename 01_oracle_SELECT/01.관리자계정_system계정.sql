-- 한줄 주석 : 단축키 ctrl + /
/*
    여러줄 주석 : 단축키 alt + shift + c
*/

-- 사용자 생성 : 실행시 단축키 ctrl + enter
create user c##test2 identified by 1234;

-- 이를 회피하는 방법
alter session set "_oracle_script" = true;

-- 앞으로 테이블을 생성하고 사용하려면 아래 3가지를 해야함
-- 1. kh 사용자 생성

-- "User"란, 데이터베이스에 접근할 수 있는 계정을 말합니다.

-- "identified"는 사용자의 암호를 설정하는 키워드입니다.
-- 이 키워드 다음에는 해당 사용자의 암호를 입력합니다.
create user kh identified by 1234;

-- 2. 권한부여
-- "GRANT CONNECT" 문은 사용자가 데이터베이스에 연결할 수 있는 권한을 부여하는 데 사용됩니다. 
-- "GRANT RESOURCE" 문은 사용자가 테이블, 시퀀스, 
-- 프로시저 등과 같은 데이터베이스 객체를 생성하고 관리할 수 있는 권한을 부여하는 데 사용됩니다.

grant connect, resource to kh;

-- 3. 테이블스페이스 할당
-- alter user kh quota 30M on users;  -- 명시

/*
 사용자 "kh"의 기본 테이블스페이스를 "users"로 설정하고,
 "users" 테이블스페이스에서 사용 가능한 용량을 무제한으로 설정하는 것을 의미합니다.

 "QUOTA" 절을 사용하여 사용자가 해당 테이블스페이스에서 사용할 수 있는 최대 용량을 제한할 수 있습니다.
  위의 SQL 문장에서는 "UNLIMITED" 키워드를 사용하여 
  사용자가 "users" 테이블스페이스에서 사용할 수 있는 용량을 무제한으로 설정했습니다.
  즉, 사용자 "kh"는 "users" 테이블스페이스에서 무제한으로 데이터를 저장할 수 있게 됩니다.
*/
alter user kh default tablespace users quota unlimited on users; 

-- 사용자 삭제
drop user c##test2;

-- 테이블이 존재할 경우 사용자 삭제
drop user c##test2 cascade;
