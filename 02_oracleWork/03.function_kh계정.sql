/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
    
    - 단일행 함수 : N개의 값을 읽어들여 N개의 결과값 반환(매 행마다 함수 실행)
    - 그룹 함수 : N개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
    
    >> SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
    
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
*/

------------------------------------단일행 함수-------------------------------
--===========================================================================
--                                <문자 처리 함수>
--===========================================================================
/*
    * LENGTH / LENGTHB
    LENGTH(컬럼|'문자열') : 해당 문자열의 글자수 반환(반환형 : NUMBER)
    LENGTHB(컬럼|'문자열') : 해당 문자열의 BYTE수 반환(반환형 : NUMBER)
      - 한글 : XE버전일 때 => 1글자당 3BYTE(ㄱ, ㅏ, 정 등 1글자로 인식)
              EE버전일 때 => 1글자당 2BYTE
      - 그외 : 1글자당 1BYTE
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;  -- 오라클에서 제공하는 가상테이블

SELECT LENGTH('ㅋㅋ'), LENGTHB('ㅋㅋ')
FROM DUAL;

SELECT LENGTH('oracle'), LENGTHB('oracle')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME)
     , EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
  FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정 문자의 시작위치(INDEX)를 찾아서 반환(반환형 : NUMBER)
      -*** ORACLE에서는 INDEX는 1부터 시작. 찾을 문자가 없을 때 0반환
      
    INSTR(컬럼|'문자열', '찾고자하는 문자', [찾을위치의 시작값, [순번]])
      - 찾을위치의 시작값
        1 : 앞에서부터 찾기(기본값)
        -1 : 뒤에서부터 찾기
*/

SELECT INSTR('JAVASCRIPTJAVAORACLE','A') FROM DUAL;         -- 결과 : 2
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1) FROM DUAL;       -- 결과 : 2
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1) FROM DUAL;      -- 결과 : 17
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1,3) FROM DUAL;     -- 결과 : 12
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1,2) FROM DUAL;    -- 결과 : 14

-- EMPLOYEE테이블에서 EMAIL, EMAIL '_'의 인덱스값, '@'의 인덱스값
SELECT EMAIL, INSTR(EMAIL, '_') "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(반환형 : CHARACTER)
    
    SUBSTR(컬럼|'문자열', POSITION, [LENGTH])
    - POSITION : 문자열을 추출할 시작위치 INDEX
    - LENGTH : 추출할 문자 갯수(생략시 마지막까지 추출)
*/

SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;        -- 결과 : HTMLCSS
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;     -- 결과 : HTML
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;     -- 결과 : ORACLE
SELECT SUBSTR('ORACLEHTMLCSSRE', -9, 4) FROM DUAL;  -- 결과 : HTML

-- EMPLOYEE테이블에서 주민번호에서 성별만 추출하여 주민번호, 사원명, 성별을 조회
SELECT EMP_NO, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 여자사원들만 사원번호, 사원명, 성별을 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

-- EMPLOYEE테이블에서 남자사원들만 사원번호, 사원명, 성별을 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN (1, 3)
ORDER BY EMP_NAME;

-- EMPLOYEE테이블에서 아이디(EMAIL에서 @앞의 문자)만 추출하여 사원명, 이메일, 아이디 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) 아이디
FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*
    * LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때 사용(반환형 : CHARACTER)
    
    LPAD / RPAD('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
    문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열 반환
*/

-- 20만큼의 길이 중 EMAIL컬럼값을 오른쪽으로 정렬하고 나머지 부분은 공백으로 채워(왼쪽)
SELECT EMP_NAME, LPAD(EMAIL, 20)   -- 덧붙이고자하는 문자 생략시 기본값 공백
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

-- 주민번호 971125-1******  조회   
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO,1,8), 14, '*')
FROM EMPLOYEE;

SELECT EMP_NAME, SUBSTR(EMP_NO,1,8) || '******'
FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*
    * LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 나머지 반환(반환형 : CHARACTER)
    * TRIM : 문자열의 앞/뒤 양쪽에 있는 지정한 문자들을 제거한 나머지 문자열 반환
    
    [표현법]
    LTRIM / RTRIM('문자열', [제거하고자하는 문자열])
    TRIM([LEADING|TRAILING|BOTH]제거하고자 하는 문자열 FROM '문자열')
      - BOTH : 양쪽제거(기본값) 생략가능
      - LEADING : 왼쪽 제거 = LTRIM
      - TRAILING : 오른쪽 제거 = RTRIM
    
    문자열의 왼쪽 혹은 오른쪽을 제거하고자는 문자들을 찾아서 제거한 나머지 문자열을 반환
*/

SELECT LTRIM ('     K H     ') || '정보교육원' FROM DUAL;  -- 제거하고자하는 문자열 생략시 기본값 공백
SELECT RTRIM ('     K H     ') || '정보교육원' FROM DUAL;

SELECT LTRIM ('JAVAJAVASCRIPTJSP','JAVA') FROM DUAL;
SELECT LTRIM ('BACAABCFDSCA','ABC') FROM DUAL;
SELECT LTRIM ('3829DKDIS213', '0123456789') FROM DUAL;

SELECT RTRIM ('JAVAJAVASCRIPTAVJJAV','JAVA') FROM DUAL;
SELECT RTRIM ('BACAABCFDSCA','ABC') FROM DUAL;
SELECT RTRIM ('3829DKDIS213', '0123456789') FROM DUAL;

SELECT TRIM ('     K H     ') || '정보교육원' FROM DUAL;         -- 기본값이 (BOTH)양쪽 제거
SELECT TRIM (BOTH 'A' FROM 'AAAJAVASCRIPTAAA') FROM DUAL;       -- BOTH는 생략가능
SELECT TRIM (LEADING 'A' FROM 'AAAJAVASCRIPTAAA') FROM DUAL;    -- 왼쪽만 제거
SELECT TRIM (TRAILING 'A' FROM 'AAAJAVASCRIPTAAA') FROM DUAL;   -- 오른쪽만 제거

-------------------------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP : 영문자를 모두 소/대문자로 변환 및 단어의 앞글자만 대문자로 변환
    
    [표현법]
    LOWER / UPPER / INITCAP('문자열')
*/

SELECT LOWER('Java JavaScript Oracle') FROM DUAL;
SELECT UPPER('Java JavaScript Oracle') FROM DUAL;
SELECT INITCAP('java javascript oracle') FROM DUAL;

-------------------------------------------------------------------------------
/*
    * CONCAT : 문자열 두개를 전달받아 하나로 합친 결과 반환
    
    [표현법]
    CONCAT('문자열', '문자열')
*/

SELECT CONCAT('Oracle', '오라클') FROM DUAL;
SELECT 'Oracle' || '오라클' FROM DUAL;

-- SELECT CONCAT('Oracle', '오라클', '02-1234-5678') FROM DUAL;   -- 2개만 가능
SELECT 'Oracle' || '오라클' || '02-1234-5678' FROM DUAL;       -- 갯수 상관없음

-------------------------------------------------------------------------------
/*
    * REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
    [표현법]
    REPLACE('문자열', '기존문자열', '바꿀문자열')
*/
SELECT REPLACE(EMAIL, 'kh.or.kr', 'google.com')
from employee;