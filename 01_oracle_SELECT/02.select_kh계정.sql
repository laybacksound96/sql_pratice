/*
    (')홑따옴표 : 문자열을 감싸주는 기호
    (")쌍따옴표 : 컬럼명 등을 감싸주는 기호
*/
/*
    <select>
    데이터 조회할 때 사용하는 구문
    
    >> result set : select문을 통해 조회된 결과물(즉, 조회된 행(튜플)들의 집합을 의미)
    
    [표현법]
    SELECT 조회하고자하는 컬럼, 컬럼, ...
    FROM 테이블명;
*/

-- EMPLOYEE테이블의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE;

-- EMPLOYEE테이블에 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- JOB테이블의 모든 컬럼 조회
SELECT *
FROM JOB;

-- 연습문제
-- 1. JOB테이블에 직급명만 조회

-- 2. DEPARTMENT 테이블의 모든 컬럼 조회

-- 3. DEPARTMENT 테이블의 부서코드, 부서명만 조회

-- 4. EMPLOYEE테이블에서 사원명, 이메일, 전화번호, 입사일, 급여 조회

---------------------- < 컬럼값을 통한 산술연산 > -------------------------
/*
    SELECT절 컬럼명 작성부분에 산술연산기술 가능(이때 산술연산된 결과 조회)
*/

-- EMPLOYEE테이블에 사원명, 사원의 연봉(급여*12) 조회
SELECT EMP_NAME, SALARY*12
FROM EMPLOYEE;

-- EMPLOYEE테이블에 사원명, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE;

-- EMPLOYEE테이블에 사원명, 급여, 보너스, 연봉, 보너스가포함된연봉(급여 + 보너스*급여)*12 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY*12, (SALARY+BONUS*SALARY)*12
FROM EMPLOYEE;
-- 산술과정 중 NULL값이 존재할 경우 산술연산한 결과값도 NULL값으로 나옴

-- 오늘날짜 : SYSDATE
-- DATE형식끼리도 연산 가능 : 결과값은 일 단위
-- EMPLOYEE테이블에서 사원명, 입사일, 근무일수(오늘날짜-입사일)
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
FROM EMPLOYEE;
-- 값이 소수점이하로 나오는 이유는 시분초 단위의 시간정보까지 관리하기 때문
-- 함수 관련 수업시 그때 진행

---------------------------<컬럼명에 별칭 지정하기>-----------------------------
/*
    산술연산시 컬럼명이 산술에 들어간 수식 그대로 됨 이때 별칭을 부여하면 깔끔하게 정리
    
    [표현법]
    컬럼명 별칭 | 컬럼명 AS 별칭 | 컬럼명 "별칭" | 컬럼명 AS "별칭"
    
    별칭에 띄어쓰기가 들어있거나 특수문자가 포함되어 있으면 반드시("")쌍따옴표로 기술
*/
SELECT EMP_NAME 사원명, SALARY AS 급여, BONUS, SALARY*12 "연봉(원)", (SALARY+BONUS*SALARY)*12 AS "총 소득"
FROM EMPLOYEE;

----------------------------------< 리터럴 >-----------------------------
/*
    임의로 지정한 문자열(' ')
    
    SELECT절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터 처럼 조회 가능
    조회된 RESULT SET의 모든 행에 반복적으로 같이 출력
*/
-- EMPLOYEE테이블에서 사번, 사원명, 급여 조회(급여 옆에 컬럼을 하나 추가하여 원을 출력)
SELECT EMP_ID, EMP_NAME,'귀하' AS 존칭, SALARY, '원' AS 단위
FROM EMPLOYEE;

----------------------------------< 연결연산자 || >-----------------------------
/*
    여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/
-- 사번, 이름, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

-- 컬럼값과 리터럴과 연결
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다'
FROM EMPLOYEE;

-- 연습문제
-- 1. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함 연봉), 실수령액(총수령액 - (연봉*세금3%)) 조회
--    단, 산술연사이 들어간것은 별칭부여

-- 2. LOCATION테이블에서 NATIONAL_CODE 옆에 '국가' 컬럼추가(별칭부여)

-- 3. DEPARTMENT테이블에서 1컬럼에 '인사관리부의 위치는 L1 입니다'

----------------------------------< DISTINCT >-----------------------------
/*
    컬럼에 중복된 값을 한번씩만 표기하고자 할때
*/
-- EMPLOYEE에서 직급코드 조회
SELECT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE에서 직급코드를 중복제거하여 조회
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE에서 부서코드를 중복제거하여 조회
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

-- 유의사항 : DISTINCT는 SELECT절에 딱 한번만 기술 가능
-- SELECT DISTINCT DEPT_CODE, DISTINCT JOB_CODE FROM EMPLOYEE;
SELECT DISTINCT JOB_CODE, DEPT_CODE
FROM EMPLOYEE;

------------------------------------------------------------------
/*
    <WHERE 절>
    조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 때
    이때 WHERE절에 조건식을 제시하게 됨
    조거식에는 다양한 연산자들을 사용
    
    [표현법]
    SELECT 컬럼, 컬럼, ...
    FROM 테이블명
    WHERE 조건식;
    
    -- 비교연산자
    <, >, >=, <=  : 대소 비교
    =             : 같은지 비교
    !=, ^=, <>    : 같지 않은지 비교
*/

-- EMPLOYEE에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE에서 부서코드가 'D1'인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE에서 부서코드가 'D1'이 아닌 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D1';
-- WHERE DEPT_CODE ^= 'D1';
WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE에서 급여가 400만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- EMPLOYEE에서 재직중인(ENT_YN컬럼값이 'N'인) 사원들의 사번, 이름, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE ENT_YN = 'N';
----------------------------- 실습문제----------------------------------
--1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회

--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회

--3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회

------------------------------------------------------------------------
/*
    <논리 연산자>
    여러개의 조건을 제시하고자 할 때 사용
    
    AND(~이면서, 그리고)
    OR(~이거나, 또는)
*/

-- 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9' AND SALARY >= 5000000;

-- 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >= 3000000;

-- 급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
-- WHERE 3500000 <= SALARY <= 6000000;  -- 오류
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

------------------------------------------------------------------------
/*
    <BETWEEN AND>
    조건식에서 사용되는 구문
    ~이상 ~이하 범위에 대한 조건을 제시할 때 사용되는 연산자
    
    [표현법]
    비교대상컬럼 BETWEEN 하한값 AND 상한값
    -> 해당컬럼값이 하한값 이상이고 상한값 이하인 경우
*/

-- 급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 급여가 350만원 미만 600만원 초과인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
-- WHERE SALARY < 3500000 OR SALARY > 6000000;
WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
-- NOT : 논리부정연산자