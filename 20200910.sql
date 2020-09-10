많이 쓰이는 함수 ,잘 알아두자
(개념적으로 혼돈하지 말고 잘 정리하자 -SELECT절에 올수있는 컬럼에 대해 잘 정리

그룹 함수 :여러개의 행을 입력으로 받아 하나의 행으로 결과를 반환하는 함수
오라클제공 그룹함수

MIN(컬럼|익스프레션): 그룹중에 최소값을 반환
MAX(컬럼|익스프레션): 그룹중에 최대값을 반환
AVG:(컬럼|익스프레션): 그룹의 평균값
SUM :(컬럼|익스프레션): 그룹의 합계
COUNT(컬럼|익스프레션| * ): 그룹핑된 행의 갯수 

SELECT  행을 묶을 컬럼, 그룹함수 
FROM 테이블명
[WHERE]
GROUP BY 행을 묶을 컬럼;
[HAVING 그룹함수 체크조건];

SELECT *
FROM emp
ORDER BY deptno;
그룹함수에서 많이 어려워하는 부분
SELECT 절에 기술할수 있는 컬럼의 구분:
                    GROUP BY절에 나오지 않은 컬럼이 SELECT절에 나오면 에러
-- 부서번호가 같은것 끼리 묶는다
SELECT deptno, COUNT(*), MIN(sal), MAX(sal),AVG(sal),SUM(sal)
FROM emp
GROUP BY deptno;

전체 직원 (모든 행을대상으로) 중에 가장 많은 급여를 받는사람의 값
--전체행을 대상으로 그루핑할경우 GROUPBY절을 기술하지 않는다.
SELECT MAX(sal)
FROM emp;           
전체직원중에 가장 큰급여를 알수는 있지만 해당 급여를 받는 사람이 누군지는 
그룹합수만 이용해서는 구분할수없다
emp 테이블 가장 큰 급여를 받는 사람의 값이 5000인 것은 알지만 해당사원이 누구인지는
그룹함수만 사용해서는 누군지 식별할수 없다.
==>추후 진행

SELECT MAX(sal)
FROM emp;           

COUNT 함수 * 인자
*: 행의 개수를 반환
컬럼|익스프레션 : null값이 아닌 행의 개수

SELECT COUNT(*), COUNT(mgr), COUNT(comm)
FROM emp;

그룹함수의 특징 : null값을 무시
NULL연산의 특징 : 결과가 항상 NULL이다

SELECT SUM(comm)  -- 널값을 무시
FROM emp

SELECT SUM(sal+comm),SUM(sal)+SUM(comm)
FROM emp;

그룹함수의 특징2 :그룹화와 관련없는 상수들은 SELECT절에 기술할수ㅇ 있다
SELECT deptno, SYSDATE,'TEST',1 , COUNT(*)
FROM emp
GROUP BY deptno;

그룹함수 특징3:
SINGLE ROW: 함수의 경우 WHERE 에 기술하는 것이 가능하다
ex: SELECT *
    FROM emp
    WHERE ename= UPPER('smith');
    
    그룹함수의 경우 WHERE절에서 사용하는것이 불가능하다
    ==> HAVING 절에서 그룹함수에 대한 조건을 기술하여 행을 제한 할수있다.
    그룹함수는 WHERE절에 사용불가
    SELECT deptno, COUNT(*)
    FROM emp
    WHERE COUNT(*)>=5
    GROUP BY deptno;
    
    그룹함수에 대한 행 제한은 HAVING절에 기술
    SELECT deptno, COUNT(*)
    FROM emp
     GROUP BY deptno
     HAVING COUNT(*)>=5;
    
    GROUP by 를 사용하면 WHERE 절을 사용못하냐
    그룹바이에 대상이 되는 행들을 제한할떄 WHERE절을 사용
    SELECT dept count(*)
    FROM emp
    WHERE sal>1000
    GROUP BY deptno;

SELECT *
FROM emp;
    
SELECT MAX(sal)MAX_SAL,
       MIN(sal)MIN_SAL,
       ROUND(AVG(sal),2)AVG_SAL,
       SUM(sal)SUM_SAL,
       COUNT(sal)COUNT_SAL,
       COUNT(mgr)COUNT_MGR,
       COUNT(*)COUNT_ALL
FROM emp;

SELECT deptno
       MAX(sal)MAX_SAL,
       MIN(sal)MIN_SAL,
       ROUND(AVG(sal),2)AVG_SAL,
       SUM(sal)SUM_SAL,
       COUNT(sal)COUNT_SAL,
       COUNT(mgr)COUNT_MGR,
       COUNT(*)COUNT_ALL
FROM emp
GROUP BY deptno;

**GROUP BY절에 기술한 컬럼이 SELECT절에 오지 않아도 실행에는 문제없다.
1
SELECT DECODE(deptno,
                10, 'ACCOUNTING',
                20, 'RESEARCH',
                30, 'SALES',
                40, 'OPERATIONS','DDIT')dname,
                MAX(sal)MAX_SAL,
                MIN(sal)MIN_SAL,
                ROUND(AVG(sal),2)AVG_SAL,
                SUM(sal)SUM_SAL,
                COUNT(sal)COUNT_SAL,
                COUNT(mgr)COUNT_MGR,
                COUNT(*)COUNT_ALL
FROM emp 
GROUP BY DECODE(deptno,
                10, 'ACCOUNTING',
                20, 'RESEARCH',
                30, 'SALES',
                40, 'OPERATIONS','DDIT') ;

4
SELECT TO_CHAR(hiredate,'yyyymm')HIREDATE_YYYYMM,
        COUNT(*)CNT
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyymm');
5
SELECT TO_CHAR(hiredate,'yyyy')HIREDATE_YYYY,
        COUNT(*)CNT
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyy');

6
SELECT COUNT(COUNT(deptno))CNT
FROM dept
GROUP BY deptno;
7
SELECT COUNT(COUNT(deptno))
FROM emp
GROUP BY deptno;
===============================================

***************WHERE+JOIN SELECT SQL의 모든 것**********
JOIN : 다른 테이블과 연결하여 데이터를 확장하는 문법
        -컬럼을 확장
** 행을확장 =집합연산자(UNION,INTERSECT,MINUS)

JOIN문법구분
1. ANSI - SQL
    :RDBMS 에서 사용하는 sql표준
    (표준을 잘 지킨 모든 RDBMS-MYSQL,MSSQL ,POSTGRESQL..에서 실행가능)
2. ORCLE -SQL
        :ORAVLE 사만의 고유문법

회사에서 요구하는형태로 따라가자
7(oracle):3(ansi)

NATURAL JOIN:조인하고자하는 테이블의 컬럼명이 같은컬럼끼리 연결
            컬럼의 값이같은행들끼리 연결
            
    ANSI SQL
    SELECT 컬럼
    FROM테이블명 NATURAL JOIN 테이블명;
    조인컬럼에 테이블 한정자를 붙이면 NATURAL JOIN 에서는 에러로 취급
    emp, deptno(X)===> deptno(O)
    컬럼명의 한쪽테이블에서만 존재할경우 테이블 한정자를 붙이지 않아도 상관없다.
    
    emp.empno(O), empno(O)
    
    SELECT empno,deptno,dname
    FROM emp NATURAL JOIN dept;
    
    SELECT *
    FROM dept;

NATURAL JOINf을 ORACLE 문법으로
1 FROm절에 조인할 테이블을 나열한다
2.WHERE절에 테이블 조인 조건을 기술한다.

SELECT *
FROM emp, dept
WHERE emp.deptno= dept.deptno;

컬럼이 여러개 테이블에 동시에존재하는 상황에서 테이블 한정자를 붙이지 않아서
오라클 입장에서는 해당 컬럼이 어떤 테이블의 컬럼인지 알수가 없을떄 발생.
deptno컬럼은,emp,dept테이블 양쪽 모두에 존재한다
SELECT *
FROM emp, dept
WHERE deptno= deptno;

인라인뷰 별칭처럼 테이블 별칭을부여하는게 가능
컬럼과 다르게 AS키워드는 붙이지 않는다.
SELECT *
FROM emp, dept
WHERE emp.deptno= dept.deptno;

SELECT *
FROM emp e, dept d
WHERE e.deptno= d.deptno;  --별칭

ANSI-SQL JOIN WIth USING
    조인하려는 테이블간 같으 이름의 컬럼이 2개이상일때
   하나의 컬럼으로만 조인을 하고싶을떄 사용
   
   SELECT *
   FROM emp JOIN dept USING(deptno);                ------------ㄱ
   
   
   ORACLE 문법
   SELECT *
   FROM emp,dept
   WHERE emp.deptno=dept.deptno;
   
   ANSI SQL:JOIN WITH ON- 조인조건을 개발자가 직접기술
        NATURAL JOIN ,JOIN WITH USING 절을  jOIN WITH ON절을 통해 표현가능
    
    SELECT *
    FROM emp JOIN dept ON(emp.deptno=dept.deptno) -------------------
    WHERE emp.deptno IN(20,30)
    ORACLE
    
    SELECT *
    FROM emp,dept
    WHERE emp.deptno=dept.deptno
    AND emp.deptno IN (20, 30);
    
    논리적인형태에 따른 조인구분
1. SELF JOIN :조인하는 테이블이 서로같은경우
    
    
    SELECT e.empno,e.ename, e.mgr, m.ename
    FROM emp e JOIN emp m ON (e.mgr = m.empno);
    
ORACLE 문법으로
SELECT e.empno, e.ename, e.mgr , m.ename
FROM emp e, emp m
WHERE e.mgr=m.empno;

KING의 경우mgr 컬럼의 값이 null이기때문에WHERE e.mgr=m.empno; 조건을 충족시키지 못함
그래서 조인 실패해서 14건중 13건의 데이터만 조회

2.NONEQUI JOIN :조인 조건이 =이 아닌 조인
SELECT *
FROM emp, dept
WHERE emp.empno=7369
AND emp.deptno != dept.deptno;

sal를 이용하여 등급을 구하기
SELECT *
FROM salgrade;
empno, ename, sal, 등급(grade)

SELECT empno, ename, sal, grade
FROM emp,salgrade
WHERE sal BETWEEN salgrade.losal AND salgrade.hisal;

salgrade.losal<= emp.sal
AND salgrade. hisal >= emp.sal;

위를 ANSI로 변경
SELECT empno, ename, sal, grade
FROM emp JOIN salgrade  
ON(salgrade.losal<= emp.sal AND salgrade. hisal >= emp.sal;)

