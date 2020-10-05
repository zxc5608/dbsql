분석함수 -집계함수
SUM(col), MIN(col),MAX(col),COUNT(col|*),AVG(col)
사원번호, 사원이름, 소속부서번호, 소속된 부서의 사원수
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno)cnt
FROM emp;

SELECT empno, ename,sal, deptno,ROUND(AVG(sal)OVER(PARTITION BY deptno),2)avg_sal
FROM emp;

분석함수 쓰지 않고 구하기
SELECT empno,ename ,sal,emp.deptno,a.avg_sal
FROM emp,
    (SELECT deptno, ROUND(AVG(sal),2)avg_sal
    FROM emp
    GROUP BY deptno)a
WHERE emp.deptno=a.deptno;

실습 ana3
SELECT empno,ename,sal,deptno,MAX(sal)OVER(PARTITION BY deptno)max_sal
FROM emp;

분석함수 쓰지 않고 구하기
SELECT empno,ename,sal,emp.deptno,a.max_sal
FROM  emp,
(SELECT deptno,MAX(sal)max_sal
FROM emp
GROUP BY deptno)a
WHERE emp.deptno=a.deptno
ORDER BY deptno;

분석함수 정리
1.순위 :RANK, DENSE_RANK, ROW_NUMBER
2.집계: SUM,AVG,MAX,MIN,COUNT
3.그룹내 행순서: LAG,LEAD
    현재행을 기준으로 이전/이후 N번째 행의 컬럼값 가져오기
    
사원번호 ,사원이름 ,입사일자, 급여,급여순위가 자신보다 한단계 낮은사람의 급여
(단. 급여가 같은경우 입사일이 빠른 사람이 높은 우선순위
--피티 엑셀 사진첨부
4번
SELECT  empno,ename,hiredate,sal,
    LEAD(sal) OVER(ORDER BY sal DESC,hiredate ASC)
FROM emp

5번 
SELECT  empno,ename,hiredate,sal,
    LAG(sal) OVER(ORDER BY sal DESC,hiredate ASC)
FROM emp

6
SELECT empno,ename,hiredate,job,sal, 
        LAG(sal) OVER(PARTITION BY job ORDER BY sal DESC,hiredate ASC)LAG_SAL
        --job별로 급여순위가 한단계 높은사람의급여
FROM emp;

이전/이후 n행 값 가져오기
LAG(col,건너뛸 행수-default 1,값이 없을 경우 적용할 기본값)=nvl이랑 비슷
SELECT empno,ename,hiredate,job,sal, 
        LAG(sal,2,0) OVER(ORDER BY sal DESC,hiredate ASC)LAG_SAL
FROM emp;

현재행까지의 누적합 구하기
범위지정: windowing 
windowing 에서 사용할수있는 특수키워드
1. UNBOUNDED PRECEDING:현재행을 기준으로 선행하는 모든 행(이전행)
2. CURRENT ROW :현재행
3. UNBOUNDED FOLLOWING :현재행을 기준으로 후행하는 모든행 (이후행)
4. n PRECEDING (n은 정수): N행 이전부터
5. n FOLLOWING (n은 정수): n행 이후까지

현재행 이전의 모든행부터~현재까지==>행들을 정렬할수 있는 기준이 있어야 한다
SELECT empno,ename,sal,
    SUM(sal)OVER(ORDER BY sal,hiredate ASC
                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)C_sum,
    SUM(sal)OVER(ORDER BY sal,hiredate ASC 
                 ROWS UNBOUNDED PRECEDING)C_sum2                            
FROM emp ;

선행하는 이전 첫번째 행부터 후행하는 이후 첫번쨰 행까지
선행 - 현재행 - 후행 중 총 3개의 행에 대해 급여합을 구하기

SELECT empno,ename,sal,
        SUM(sal) OVER (ORDER BY sal,hiredate 
                        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)c_sum
FROM emp

실습7 급여정보를 부서별로 사원번호 오름차순으로 정렬했을때
SELECT empno,ename,deptno,sal,
        SUM(sal)OVER (PARTITION BY deptno ORDER BY sal,empno
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum

FROM emp



SELECT empno,ename,deptno,sal,
        SUM(sal)OVER ( ORDER BY sal ROWS UNBOUNDED PRECEDING )rows_sum,
        SUM(sal)OVER ( ORDER BY sal RANGE UNBOUNDED PRECEDING )range_sum,
        SUM(sal)OVER (ORDER BY sal)c_sum--디폴트는 레인지
FROM emp


==============실행계획===
DBMS 입장에서 SQL 처리순서
1.요청된 SQL과 동일한SQL이 이미 실행된 적이 있는지 확인하여 실행된 적이 있다면
SHARED POOL에  저장된 실행계획은 재활용한다
1-2 만약 SHARD POOL에 저장된 실행계획이 없다면 (동일한 SQL이 실행된적이 없음)
    실행계획을 세운다
    
**동일한 SQL이란?
-결과만 갖다고 동일한 sql이 아님
-DBMS입장에서는 완벽하게 문자열이 동일해야 동일한 SQL임
 다음 SQL은 서로 다른 SQL로 인식한다
 1.
 SELECT /* SQL_TEST */ * FROM emp;
 2.
 select /* SQL_TEST */ * FROM emp;
 3.
 Select /* SQL_TEST */ * FROM emp;
 4. 10번부서에 속하는 사원정보조회
    ==>특정 부서에 속하는 사원정보조회
    Select /* SQL_TEST */ * FROM emp WHERE deptno = 10;
    Select /* SQL_TEST */ * FROM emp WHERE deptno = 20;
    바인드 변수를 왜 사용해야 하는가에 대한 설명
    Select /* SQL_TEST */ * FROM emp WHERE deptno = :deptno;
    
    -------------------------
    
 ISOLATION LEVEL (고립화 레벨)후행 트랜잭션이 선행트랜젝션에 어떻게  영향을 미치는지 정의한 단계
 
 LEVEL 0~3
 LEVEL 0:READ UNCOMMITED
        선행 트랜젝션이 커밋하지 않는 데이터도 후행트랜잭션에서 조회된다
        오라클에서는 공식적으로 지원하지 않는단계
LEVEL 1: READ COMMITED
        후행트랜잭션에서 커밋한 테이터가 선행 트랜젝션에서도 조회된다
        오라클의 기본 고립화 레벨
        대부분의 DBMS가 채택하는 레벨
LEVEL 2: REPEATABLE READ (반복적읽기)
        트랜젝션안에서 동일한 SELECT쿼리를 실행해도 트랜잭션의 어떤 위치에서 던지
        후행트랜잭션의 변경 (update)삭제(DELETE)의 영향을 받지 않고 항상 
        동일한 실행결과를 조회하는 레벨
        
        오라클에서는 공식적으로 지원하지는 않지만 SELECT FOR UPDATE 구문을 통해 
        효과를 낼수있다
        
        후행 트랜잭션의 변경, 삭제에 대해서는 막을수 있지만
        테이블의 기존에 존재했던 데이터에대해)
        신규(INSERT)로 입력하는 데이터에 대해서는 선행 트랜잭션에 영향이간다
        ==>Phantom Read (귀신읽기)
        존재하지 않았던 데이터가 갑자기 조회되는 현상
        
LEVEL 3: SERIALIZABLE READ(직렬화읽기)
        후행 트랜잭션의 작업이 선행 트랜잭션에 아무런 영향을 주지 않는 단계
        ** DBMS마다 LOCKING 메커니즘이 다르기떄문에 ISOLATION LEVEL을 함부로
        수정하는것은 위험하다
  
  

