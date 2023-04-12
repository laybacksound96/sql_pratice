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

--===========================================================================
--                                <숫자 처리 함수>
--===========================================================================
/*
    * ABS : 숫자의 절대값을 구해주는 함수
    
    [표현법]
    ABS(NUMBER)
*/
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL;

-------------------------------------------------------------------------------
/*
    * MOD : 두 수를 나눈 나머지값을 반환하는 함수
    
    [표현법]
    MOD(NUMBER, NUMBER)
*/
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 2) FROM DUAL;  -- 잘 쓰지 않음

-------------------------------------------------------------------------------
/*
    * ROUND : 반올림한 결과를 반환하는 함수
    
    [표현법]
    ROUND(NUMBER, [위치])
*/
SELECT ROUND(1234.567) FROM DUAL;   -- 위치 생략시 0
SELECT ROUND(12.34) FROM DUAL;
SELECT ROUND(1234.5678, 2) FROM DUAL;
SELECT ROUND(1234.5678, -2) FROM DUAL;

-------------------------------------------------------------------------------
/*
    * CEIL : 정수로 올림한 결과를 반환하는 함수
    
    [표현법]
     CEIL(NUMBER)
*/
SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(-123.456) FROM DUAL;

-------------------------------------------------------------------------------
/*
    * FLOOR : 정수로 내림한 결과를 반환하는 함수
    
    [표현법]
    FLOOR(NUMBER)
*/
SELECT FLOOR(123.956) FROM DUAL;
SELECT FLOOR(-123.456) FROM DUAL;

-------------------------------------------------------------------------------
/*
    * TRUNC : 위치 지정 가능한 버림처리 함수
    
    [표현법]
    TRUNC(NUMBER, [위치])
*/
SELECT TRUNC(123.789) FROM DUAL;  -- 위치생략시 0
SELECT TRUNC(123.789, 1) FROM DUAL;
SELECT TRUNC(123.789, -1) FROM DUAL;

SELECT TRUNC(-123.857) FROM DUAL;
SELECT TRUNC(-123.857, -2) FROM DUAL;

--===========================================================================
--                                <날짜 처리 함수>
--===========================================================================
/*
    * SYSDATE : 시스템 날짜 및 시간 반환
*/
SELECT SYSDATE FROM DUAL;

-------------------------------------------------------------------------------
/*
    * MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수
*/
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE-HIRE_DATE) 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' AS 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') 근무개월수
FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*
    * ADD_MONTHS(DATE, NUMBER) : 특정 날짜에 해당 숫자만큼의 개월수를 더해 날짜를 반환
*/
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;

-- EMPLOYEE테이블에서 사원명, 입사일, 정직원된 날짜(입사일에서 6개월 후) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원된 날짜"
FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*
    * NEXT_DAY(DATE, 요일(문자, 숫자)) : 특정 날짜 이후에 가까운 해당 요일의 날짜 반환해주는 함수
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '화') FROM DUAL;

-- 1: 일요일, 2: 월요일 ...
SELECT SYSDATE, NEXT_DAY(SYSDATE, 3) FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;  -- 에러 : 현재 언어가 KOREA이기 때문

-- 언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;  -- 에러

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-------------------------------------------------------------------------------
/*
    * LAST_DAY(DATE) : 해당 월의 마지막 날짜를 반환해주는 함수
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- EMPLOYEE에서 사원명, 입사일, 입사한 달의 마지막 날짜
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 입사일, 입사한 달의 마지막 날짜, 입사한 달에 근무한 일수 
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE), LAST_DAY(HIRE_DATE)-HIRE_DATE+1 
FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*
    * EXTRACT : 특정 날짜로부터 년도 | 월 | 일 값을 추출하여 반환해주는 함수(반환형 : NUMBER)
    - EXTRACT(YEAR FROM DATE) : 년도만 추출
    - EXTRACT(MONTH FROM DATE) : 월만 추출
    - EXTRACT(DAY FROM DATE) : 일만 추출
*/

-- EMPLOYEE에서 사원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME
     , EXTRACT(YEAR FROM HIRE_DATE) 입사년도
     , EXTRACT(MONTH FROM HIRE_DATE) 입사월
     , EXTRACT(DAY FROM HIRE_DATE) 입사일
  FROM EMPLOYEE
 ORDER BY 입사년도, 입사월, 입사일;

--===========================================================================
--                                <형변환 함수>
--===========================================================================
/*
    * TO_CHAR : 숫자 또는 날짜 타입의 값을 문자타입으로 변환시켜주는 함수.
                반환결과를 특정 형식에 맞게 출력할 수 도있음
    
    [표현법]
    TO_CHAR(숫자|날짜, [포맷])
*/
---------------------- 숫자타입 => 문자 타입
/*
    9 : 해당 자리의 숫자를 의미한다.
       - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표기
    0 : 해당 자리의 숫자를 의미한다.
       - 값이 없을 경우 0으로 표시하며 숫자의 길이를 고정적으로 표시할 때 주로 사용
    L : 현재 설정된 나라(LOCAL)의 화폐단위
    FM : 좌우 9로 치환된 소수점 이상의 공백 및 소수점 이하의 0을 제거
         해당자리에 값이 없을 경우 자리차지하지 않음
*/
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234), TO_CHAR(1234, '999999') FROM DUAL;
SELECT TO_CHAR(1234, '000000') FROM DUAL;

SELECT TO_CHAR(1234, 'L999999') FROM DUAL;
SELECT TO_CHAR(1234, '$999999') FROM DUAL;  -- $만 가능
-- SELECT TO_CHAR(1234, '\999999') FROM DUAL; -- 오류

SELECT TO_CHAR(1234, 'L99,999') FROM DUAL;

SELECT EMP_NAME, TO_CHAR(SALARY, 'L99,999,999') 급여, TO_CHAR(SALARY*12, 'L999,999,999') 연봉
FROM EMPLOYEE;

SELECT TO_CHAR(123.456, 'FM999990.999') 
     , TO_CHAR(1234.56, 'FM9990.9')
     , TO_CHAR(0.1000, 'FM9990.999')
     , TO_CHAR(0.1000, 'FM9999.999')
     , TO_CHAR(123, 'FM9999.009')
  FROM DUAL;
  
SELECT TO_CHAR(123.456, '999990.999') 
     , TO_CHAR(1234.56, '9990.9')
     , TO_CHAR(0.1000, '9990.999')
     , TO_CHAR(0.1000, '9999.999')
     , TO_CHAR(123, '9999.009')
  FROM DUAL;

---------------------- 날짜타입 => 문자 타입
-- 시간
SELECT TO_CHAR(SYSDATE, 'AM') KOREA
     , TO_CHAR(SYSDATE, 'PM', 'NLS_DATE_LANGUAGE=AMERICAN') AMERICA
  FROM DUAL;
  -- AM, PM 무엇을 쓰든 상관없음

SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;  -- 12시간 형식
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL;   -- 24시간 형식

-- 날짜
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;

-- EMPLOYEE에서 사원명, 입사일(형식 '22-04-07')

-- EMPLOYEE에서 사원명, 입사일(형식 '2023년 4월 7일 금요일')

-- EMPLOYEE에서 사원명, 입사일(형식 '2023년 04월 07일')

-- 년도
SELECT TO_CHAR(SYSDATE, 'YYYY')
     , TO_CHAR(SYSDATE, 'YY')
     , TO_CHAR(SYSDATE, 'RRRR')
     , TO_CHAR(SYSDATE, 'RR')
     , TO_CHAR(SYSDATE, 'YEAR')
  FROM DUAL;
  
-- 월
SELECT TO_CHAR(SYSDATE, 'MM')
     , TO_CHAR(SYSDATE, 'MON')
     , TO_CHAR(SYSDATE, 'MONTH')
     , TO_CHAR(SYSDATE, 'RM')
  FROM DUAL;

-- 일
SELECT TO_CHAR(SYSDATE, 'DDD')  -- 년 기준 몇일째
     , TO_CHAR(SYSDATE, 'DD')   -- 월 기준 몇일째
     , TO_CHAR(SYSDATE, 'D')    -- 주 기준(일요일) 몇일째
  FROM DUAL;

-- 요일
SELECT TO_CHAR(SYSDATE, 'DAY')
     , TO_CHAR(SYSDATE, 'DY')
  FROM DUAL;

---------------------- 숫자,문자 타입 => 날짜타입
/*
    * TO_DATE : 숫자 또는 문자 타입을 날짜타입으로 변환
    TO_DATE(숫자|문자, [포맷])
*/
SELECT TO_DATE(20230407) FROM DUAL;
SELECT TO_DATE(230407) FROM DUAL;
SELECT TO_DATE(010223) FROM DUAL;  -- 첫글자가 0일 때 에러
SELECT TO_DATE('010223') FROM DUAL; -- 첫글자가 0일 때에는 문자타입으로 넣어준다

SELECT TO_DATE('040630', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('040630', 'RRMMDD') FROM DUAL;

SELECT TO_DATE('980630', 'YYMMDD') FROM DUAL; -- YY : 무조건 현재세기로 반영
SELECT TO_DATE('980630', 'RRMMDD') FROM DUAL; -- RR : 해당 두자리가 50미만이면 현재세기, 50 이상이면 이전세기

---------------------- 문자 타입 => 숫자타입
/*
    * TO_NUMBER : 문자 타입을 숫자타입으로 변환
    TO_NUMBER(문자, [포맷])
*/
SELECT TO_NUMBER('01234567') FROM DUAL;
SELECT '1000' + '5000' FROM DUAL;  -- 연산결과 출력
SELECT '1,000' + '5,000' FROM DUAL; -- ,때문에 자동형변환 안됨 오류
SELECT TO_NUMBER('1,000,000', '9,999,999') + TO_NUMBER('550,000', '999,999') FROM DUAL;

--===========================================================================
--                                <NULL처리 함수>
--===========================================================================
/*
    * NVL(컬럼, 해당컬럼값이 NULL일 때 반환할 값)
*/
SELECT EMP_NAME, NVL(BONUS, 0)
FROM EMPLOYEE;

-- 전사원의 이름, 보너스포함 연봉
SELECT EMP_NAME, (SALARY*NVL(BONUS,0) + SALARY) * 12
FROM EMPLOYEE;

-- 전사원의 이름, MANAGER_ID(NULL이면 '사수없음')
SELECT EMP_NAME, NVL(MANAGER_ID, '사수없음')
FROM EMPLOYEE;

-- 전사원의 이름, 부서CODE(NULL이면 '부서없음')
SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음')
FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*
    NVL2(컬럼, 반환값1, 반환값2)
    - 컬럼값이 존재하면 반환값1
    - 컬럼값이 NULL이면 반환값2
*/
SELECT EMP_NAME, BONUS, NVL2(BONUS, BONUS+0.3, 0.2)
FROM EMPLOYEE;

SELECT EMP_NAME, NVL2(DEPT_CODE, '부서있음', '부서없음')
FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*
    NULLIF(비교대상1, 비교대상2)
    - 두개의 값이 일치하면 NULL반환
    - 두개의 값이 일치하지 않으면 비교대상1 값을 반환
*/
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL;

--===========================================================================
--                                <선택 함수>
--===========================================================================
/*
    DECODE(비교하고자하는 대상(컬럼|산술연산|함수식), 비교값1, 결과값1, 비교값2, 결과값2, ...)
    
    - 자바에서는
    SWITCH(비교대상) {
        CASE 비교값1 :
            실행구문(결과값1);
        CASE 비교값2 :
            실행구문(결과값2);
        ...
        DEFAULT :
            실행구문;
    }
*/
-- EMPLOYEE에서 사번, 사원명, 주민번호(123456-1******), 성별
SELECT EMP_ID
     , EMP_NAME
     , SUBSTR(EMP_NO, 1, 8) || '******' 주민번호
     , DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여','3','남','4','여') 성별
FROM EMPLOYEE;

-- 직원의 급여 조회시 각 직급별로 인상하여 조회
-- J7인 사원은 급여를 10%인상 (SALARY * 1.1)
-- J6인 사원은 급여를 15%인상 (SALARY * 1.15)
-- J5인 사원은 급여를 20%인상 (SALARY * 1.2)
-- 그외 사원은 급여를 5%인상 (SALARY * 1.05)

SELECT EMP_NAME, JOB_CODE, SALARY
     , DECODE(JOB_CODE, 'J7', SALARY * 1.1
                      , 'J6', SALARY * 1.15
                      , 'J5', SALARY * 1.2
                            , SALARY * 1.05) "인상된 급여"
 FROM EMPLOYEE;    

-----------------------------------------------------------------------------
/*
    CASE WHEN THEN
    END
    
    CASE WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값N
    END
*/

-- 급여가 500만원 이상이면 고급, 350만원 ~ 500만원 미만은 중급, 그외는 초급
SELECT EMP_NAME, SALARY
     , CASE WHEN SALARY >= 5000000 THEN '고급'
            WHEN SALARY >= 3500000 THEN '중급'
            ELSE '초급'
        END AS 급수
  FROM EMPLOYEE;

--===========================================================================
--                                <그룹 함수>
--===========================================================================
/*
    SUM(숫자타입컬럼) : 해당 컬럼 값들의 총 합계를 구해서 반환해주는 함수
*/
-- 전사원의 총 급여의 합
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 남자사원들의 총 급여의 합
SELECT SUM(SALARY)
FROM EMPLOYEE
-- WHERE SUBSTR(EMP_NO, 8, 1) = '1' OR SUBSTR(EMP_NO, 8, 1) = '3';
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1','3');

-- 부서코드가 D5인 사원들의 총 연봉의 합(보너스 포함 X)
SELECT SUM(SALARY*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 부서코드가 D5인 사원들의 총 연봉의 합(보너스 포함)
SELECT SUM((SALARY*NVL(BONUS,0) + SALARY)*12) "연봉(보너스포함)"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-----------------------------------------------------------------------------
/*
    AVG(숫자타입컬럼) : 해당 컬럼 값의 평균을 반환해주는 함수
*/
-- 전사원급여의 평균
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2','4');

-----------------------------------------------------------------------------
/*
    MIN(모든컬럼) : 해당 컬럼 값들중 가장 작은값 반환
    MAX(모든컬럼) : 해당 컬럼 값들중 가장 큰값 반환
*/
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;

SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    COUNT(*|컬럼|DISTINCT컬럼) : 행의 갯수 반환
    
    COUNT(*) : 조회된 결과의 모든 행의 갯수
    COUNT(컬럼) : 제시한 컬럼값의 NULL값을 제외한 행의 갯수
    COUNT(DISTINCT 컬럼) : 해당 컬럼값 중복을 제거한 후의 행의 갯수
*/
-- 전체 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE;

-- 여자 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN ('2','4');

-- 보너스를 받는 사원의 수
SELECT COUNT(BONUS)
FROM EMPLOYEE;

-- 현재 사원들이 총 몇개의 부서에 분포되어있는지
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;