DELETE emp_test;
DELETE emp_test2;
commit;

unconditional insert
conditional insert
    
    ALL: 조건에 만족하는 모든 구문의 INSERT실행
    FIRST: 조건에 만족하는 첫번째 구문의INSERT만실행

INSERT FIRST  --만족하는 첫번쨰구문에 하나만찾으면 끝남
    WHEN eno >=9500 THEN
    INTO emp_test VALUES (eno,enm)
    WHEN eno>=9000 THEN
        INTO emp_test2 VALUES (eno,enm)
SELECT 9000 eno, 'brown' enm FROM dual UNION ALL
SELECT 9500,'sally' FROM dual;

SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

동일한 구조(컬럼)의 테이블을 여러개 생성 했을 확률이높음
행을 잘라서 서로 다른 테이블에 분산: 
 ==>테이블의 건수가 줄어듬으로 table full access 속도가빨라진다.
실적 테이블: 20190101~20191231 실적데이터==> SALES_2019테이블에 저장
            20200101~20201231 실적데이터==>SALES _2020테이블에 저장
개별년도 계산은 상관없으나 19,20년도 데이터를 동시에 보기 위해서는UNIONALL 혹은
쿼리를 두번 사용 해야한다.

오라클 파티션 기능(오라클 공식 버전에서만 지원 ,xe에서는 지원하지않음)
테이블을 생성하고, 입력되는 값에 따라서 오라클 내부적으로 별도의 영역에다 저장


일실적: 한달에 생성 데이터가 4~5000만건==>월단위 파티션
=======================================================

MERGE 특정테이블에 입력하려고하는 데이터가 없으면 입력하고 있으면 업데이트를 한다.
9000,'brown'데이터를 emp_test넣으려고 하는데 
emp_test테이블에9000번 사번을 갖고잇는 사원 있으면 이름을 업데이트하고
사원이 없으면 신규로입력

merge구문을 사용하지 않고 위 시나리오 대로 개발을 하려면 적어도 2개의 sql을 실행 해야함
1.
SELECT 'X'
FROM emp_test
WHERE empno=9000;

2-1 1q번에서 조회된 데이터가 없을경우
INSERT INTO emp_test VALUES(9000,'brown');

2-2 2번에서 조회된 데이터가 있을경우
UPDATE emp_test SET ename='brown'
WHERE empno=9000;
                                 
    merge 구문을 이용하게 되면 한번의 sql로 실행가능
    
MERGE INTO 변경/신규 입력할 테이블
    USING 테이블|뷰 |인라인뷰
    ON(INTO 절과 USING절에 기술한 테이블의 연결조건
WHEN MATCHED THEN
    UPDATE SET 컬럼 =값,....
WHEN NOT MATCHED THEN
    INSERT [(컬럼1,컬럼2...)] VALUES(값1, 값2...);


SELECT 'X'
FROM emp_test
WHERE empno=9000;

2-1 1q번에서 조회된 데이터가 없을경우
INSERT INTO emp_test VALUES(9000,'brown');

2-2 2번에서 조회된 데이터가 있을경우
UPDATE emp_test SET ename='brown'
WHERE empno=9000;
                        
    ||
    rollback;
    
MERGE INTO emp_test
    USING(SELECT 9000 eno,'sally'enm
         FROM dual)a
        ON(emp_test.empno = a.eno)
WHEN MATCHED THEN 
    UPDATE SET ename = a.enm
WHEN NOT MATCHED THEN
    INSERT VALUES (a.eno,a.enm);
    
    SELECT *
    FROM emp_test;
    
COMMIT;

emp==> emp_test 데이터 두건 복사

INSERT INTO emp_test
SELECT empno,ename
FROM emp
WHERE empno IN (7369,7499);

SELECT *
FROM emp_test;

emp테이블을 이용하여emp 테이블에 존재하고 emp_test에는 없는 사원에대해서는
emp_test테이블에 신규로 입력하고
emp,emp_test양쪽에 존재하는 사원은  이름을 이름||'_M'

MERGE INTO emp_test
    USING emp
    ON(emp.empno=emp_test.empno)
WHEN MATCHED THEN 
    UPDATE SET ename =  emp_test.ename ||'_M'
WHEN NOT MATCHED THEN
    INSERT VALUES(emp.empno,emp.ename);
    
DESC emp;

SELECT *
FROM emp_test

DELETE emp
WHERE empno = 6;  --행지워
commit;
매칭 2건에 매칭 안되는게 12건
==> merge를 하면 UPDATE 2건에 INSERT 12건
SELECT *
FROM emp_test,emp
WHERE emp.empno=emp_test.empno;


========GROUP FUNCTION==========
SELECT *
FROM emp;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
UNION ALL
SELECT Null,SUM(sal)
FROM emp

ORDER BY deptno;
위의 쿼리를 레포트 그룹함수를 적용하면
SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP(deptno);



ROLLUP: GROUP BY를 확장한 구문
        서브 그룹을 자동적으로 생성
        GROUP BY ROLLUP(컬럼1,컬럼2...)
        ***ROLLUP 절에 기술한 컬럼을 오른쪽에서 부터 하나씩 제거해가며
        서브그룹을 생성한다 생성된 서브그룹을 하나의 결과로 합쳐준다.

GROUP BY ROLLUP(deptno)

GROUP BY deptno
UNION ALL
GROUP BY ==> 전체

GROUP BY ROLLUP(deptno,job)
GROUP BY deptno,job
UNION ALL
GROUP BY deptno
UNION ALL
GROUP BY ==>전체

SELECT job, deptno, SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY ROLLUP(job,deptno);

SELECT null, null , SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY job,deptno 

UNION ALL

SELECT null, null , SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY job

UNION ALL

SELECT null, null , SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY 
-----------------------------GROUPING
GROUPING함수: rollup,cube절을 사용한 sql에서만 사용이 가능한함수
            인자 col은 gruop by절에 기술된 컬럼만 사용가능
            1. 0을반환
            1: 해당 컬럼이 소계 계산에 사용된경우
            0: 해당 컬럼이 소계 계산에 사용되지 않은경우
            
SELECT job, deptno,
    GROUPING(job),GROUPING(deptno),
    SUM(sal+NVL(comm,0))sal 
FROM emp
GROUP BY ROLLUP(job,deptno);


SELECT 
CASE
        WHEN GROUPING(job)= 1 THEN '총계'
        ELSE job
        END job,deptno,
      GROUPING(job),GROUPING(deptno),
    SUM(sal+NVL(comm,0))sal 
FROM emp
GROUP BY ROLLUP(job,deptno);


NVL로하면 왜안되는지

null이 아닌 GROUPING 함수를 통해 레이블을ㄷ 달아준이유
null값이 실제 데이터의 null인지 group by에 의해 null이 표현 된것인지는
GROUPING 을 통해서만 알수있다.

SELECT job,mgr ,GROUPING(job),GROUPING(mgr),SUM(sal)
FROM emp
GROUP BY ROLLUP(job,mgr);

실습2
SELECT 
CASE 
    WHEN GROUPING(job)=1 THEN '총'
    ELSE job
    END job,
CASE
     WHEN GROUPING(job)=1 AND GROUPING(deptno)= 1 THEN '계'
     WHEN GROUPING(deptno)=1 THEN '소계'
    ELSE TO_CHAR(deptno)
    END deptno,

    GROUPING(job),GROUPING(deptno),
    SUM(sal+NVL(comm,0))sal 
FROM emp
GROUP BY ROLLUP(job,deptno);


SELECT 
DECODE(GROUPING(job),1 , '총' ,job) job,
DECODE(GROUPING(job)+ GROUPING(deptno), 2, '계',1, '소계',TO_CHAR(deptno)) deptno,
        SUM(sal+NVL(comm,0))sal_sum
FROM emp
GROUP BY ROLLUP(job,deptno);

SELECT 
  DECODE(GROUPING(job),1 , '총' ,job ) job,                           
  DECODE (GROUPING(job)|| GROUPING(deptno), 11, '계',1, '소계', TO_CHAR(deptno))deptno,
       SUM(sal+NVL(comm,0))sal                                   
FROM emp
GROUP BY ROLLUP(job,deptno);

실습 3.
SELECT deptno,job,
     SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY ROLLUP(deptno,job);
실습4

SELECT dname, job , SUM(sal+NVL(comm,0))sal
FROM emp ,dept 
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname,job)
ORDER BY dname,job DESC;


그룹바이 실습5

사진




============================
GROUPING SETS
ROLLUP단점: 서브그룹을 기술된 오른쪽에서부터 삭제해가며 결과를 만들기 때문에 
            개발자가 중간에 필요없는서브그룹을 제거할수가 없다
            ROLLUP절에 컬럼을N 개 기술하면 서브그룹은 총 N+1개가나온다
            
GROUPING SETS는 개발자가 필요로 하는 서브그룹을 직접나열하는 형태로 사용할수있다

GROUP BY ROLLUP (col1,col2)
==> GROUP BY col1,col2
        GROUP BY col1
        GROUP by전체
GROUP BY GROUPING SET (col1,col2)
==> GROUP BY col1
    GROUP BY col2
    
GROUP BY GROUPING SET ((col1,col2),col1)

SELECT job,deptno,SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY GROUPING SETS(deptno,job);

ROLLUP과 다르게 컬럼의 순서가 데이터 집합 셋에 영향을 주지 않는다.
(행의 정렬 순서는 다를수 있지만,..)
    
            
    
    