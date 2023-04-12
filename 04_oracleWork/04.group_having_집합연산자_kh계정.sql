/*
    <GROUP BY절>
    그룹기준을 제시할 수 있는 구문(해당 구문기준별로 여러 그룹으로 묶을 수 있음)
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/
SELECT SUM(SALARY)
FROM EMPLOYEE;    -- 전체 사원을 하나의 그룹으로 묶어서 총합을 구한 결과

-- 각 부서별 총 급여합 조회(부서코드, 급여합)
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 사원의 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 직급별(JOB_CODE) 사원수, 급여합
SELECT JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 각 직급별 총사원수, 보너스를 받는 사원수, 급여합, 평균급여, 최저급여, 최고급여
SELECT JOB_CODE
     , COUNT(*) 사원수
     , COUNT(BONUS) "보너스를 받는 사원수"
     , SUM(SALARY) 급여합
     , ROUND(AVG(SALARY),2) 평균급여
     , MIN(SALARY) 최소급여
     , MAX(SALARY) 최대급여
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

-- GROUP BY절에 함수식 기술 가능
-- 성별 사원수
SELECT DECODE(SUBSTR(EMP_NO, 8, 1),'1','남','2','여') 성별, COUNT(*) || '명' AS 인원수
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- GROUP BY절에 여러 컬럼 기술 가능
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY 1;

--------------------------------------------------------------------------------
/*
    <HAVING 절>
    그룹에 대한 조건을 제시할 때 사용되는 구문(주로 그룹함수를 가지고 조건 제시할 때 사용)
*/

-- 각 부서별 평균 급여 조회
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 평균급여가 300만원 이상인 부서들만 조회
/*  오류
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
WHERE AVG(SALARY) >= 3000000;  -- GROUP BY 에서는 WHERE을 사용하지 못함
*/
SELECT DEPT_CODE, CEIL(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

------------------------------- 실습문제 -------------------------------------
-- 1. 직급별 총 급여합(단, 직급별 급여합이 1000만원 이상인 직급만 조회)(직급코드, 급여합조회)

-- 2. 부서별 보너스를 받는 사원이 없는 부서만 조회(부서코드, 사원수)
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

--------------------------------------------------------------------------------
/*
    <집계함수>
    그룹별 산출된 결과 값에 중간집계를 계산해 주는 함수
    
    ROLLUP(), CUBE() => GROUP BY절에 기술하는 함수
    - ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
    - CUBE(컬럼1, 컬러2) : 컬럼1을 가지고 중간집계를 내고, 컬럼2를 가지고도 중간집계를 냄 
*/
-- 각 직급별 급여합
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

-- 컬럼이 1개 일때는 중간집계가 곧 SUM
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;

-- 컬럼이 2개 일때
-- ROLLUP
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- CUBE
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-------------------------------------------------------------------------------
/*
    <집합 연산자 == SET OPERATION>
    여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
    
    - UNION : OR | 합집합(두 쿼리문을 수행한 결과값을 더한 후 중복되는 값은 한번만 더해지도록)
    - INTERSECT : AND | 교집합(두 쿼리문을 수행한 결과값 중 중복된 결과값)
    - UNION ALL : 합집합 + 교집합(중복되는 부분은 두번 표현될 수 있음)
    - MINUS : 차집합(선행결과값에서 후행 결과값을 뺀 나머지)
*/
----------------------------------- 1. UNION ---------------------------------
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회

-- 부서코드가 D5인 사원
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';   -- 6개

-- 급여가 300만원 초과
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY 1;

-- UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- OR절로도 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;

----------------------------------- 2. INTERSECT -------------------------------
-- 부서코드가 D5이면서 급여가 300만원 초과인 사원들 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- AND절로도 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

----------------------------------- 3. UNION ALL -------------------------------
-- 부서코드가 D5이거나 급여가 300만원 초과인 사원들을 모두 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

----------------------------------- 4. MINUS -------------------------------
-- 부서코드가 D5이면서 급여가 300만원 초과인 사원들을 제외한 사원 조회
-- 급여가 300만원초과 이면서 부서코드가 D5인 사원들을 제외한 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 다음처럼도 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000 AND DEPT_CODE != 'D5';