1.정답 조회하는 쿼리작성
2. SQL에불필요한 부분이 없는지 점검


sub 2
전체직원의 급여가 평균보다 높은 급여를 받는 사원들 조회      
SELECT *
FROM emp
WHERE sal >(SELECT AVG(SAL)
                FROM emp); 
                



SELECT empno, ename, deptno ,  
(SELECT dname FROM dept WHERE deptno=emp.deptno) 
FROM emp;   

본인 속한 부서의 급여 평균보다 높은급여를 받는 사람들을 조회

SELECT *
FROM emp e
WHERE sal>(SELECT AVG(SAL)
                FROM emp 
                WHERE deptno=e.deptno);

Sub4
테스트용 데이터추가
DESC dept;
INSERT INTO dept VALUES(99,'ddit','daejeon');

SELECT *
FROM dept;

SELECT *
FROM dept 
WHERE deptno NOT IN(SELECT deptno
                    FROM emp);
1. emp 테이블에 등록된 사원들이 속한 부서번호확인
SELECT deptno
FROM emp;



SELECT *
FROM cycle;
pid
SELECT pid
FROM product;
pid pnm

SELECT pid, pnm
FROM product 
WHERE pid NOT IN(SELECT pid
                 FROM cycle
                 WHERE cid = 1);
SELECT *
FROM cycle
WHERE cid = 1 AND
pid IN (SELECT pid 
              FROM cycle
              WHERE cid=2);
****
SELECT *
FROM customer



SELECT c.cid,t.cnm, p.pid , p.pnm , c.day, c.cnt
FROM product p , cycle c , customer t
WHERE p.pid= c.pid
AND c.cid = t.cid
AND c.cid=1
AND c.pid IN (SELECT c.pid
                FROM cycle c
             WHERE c.cid=2);

****
EXISTS 연산자
2항연산자 1+2
3항연산자int a=b==c? 1:2;

EXISTS 연산자:조건을 만족하는 서브쿼리의 행이 존재하면 TRUE

조건을 만족하는 데이터를 찾으면 서브쿼리에서 값을 찾지 않는다

서브쿼리의 결과가 있나 없나에 따라 달라진다.


매니저가 존재하는 사원정보 조회
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
                FROM emp m
                WHERE e.mgr= m.empno);

sub8
SELECT a.*
FROM emp a, emp b
WHERE a.empno= b.mgr;

sub9 1번고객이 먹는 100번 제품에 
4개의 제품중 1번고객이 먹는 제품만 조회
SELECT pid, pnm
FROM product p 
WHERE EXISTS (SELECT 'X'
              FROM cycle c
              WHERE c.pid= p.pid
              AND c.cid = 1);
먹지 않는제품 
SELECT pid, pnm
FROM product p 
WHERE NOT EXISTS (SELECT 'X'
              FROM cycle c
              WHERE c.pid= p.pid
              AND c.cid = 1);             

SELECT pid, pnm
FROM product p
WHERE EXISTS (SELECT 'X'
                FROM cycle c
                WHERE c. pid= p.pid
                AND p.pid NOT IN(100,400));
  
  SELECT *
  FROM cycle
  
  문제 처음부터 풀어보기
  
집합연산자: 알아두자
수학의 집합연산
A={1,3,5}
B={1,4,5}

합집합: A U B = {1,3,4,5} (교환법칙성립) A U B == B U A
교집합: A^B = {1,5} 교환법칙성립 A ^ B == B ^ A
차집합: A-B = {3}  교환법칙 성립하지않음 A - B != B - A
      B-A ={4}
  SQL에서의 집합연산자
  합집합:UNION   :수학접 합집합과 개념이 동일 (중복을 허용하지 않음)
                    중복을 체크==> 두 집합에서 중복된 값을 확인==> 연산이느림
        UNION ALL: 수학적집합 개념을 떠나 두개의 집합을 단순히 합친다
                    (중복 데이터 존재가능)
                    중복 체크 없음==> 두 집합에서 중복된 값 확인 없음 ==> 연산이 빠름
                    ** 개발자가 두개의 집합에 중복되는 데이터가 없다는 것을 알수있는 상황이라면 
                    UNION연산자를 사용하는 것보다 UNION ALL을 사용하여 (오라클리 하는) 연산을 절약 할수있다.
        INTERSECT : 수학적 교집합 개념과동일
        MINUS : 수학적 차집합 개념과 동일
        
위 아래 집합이 동일하기 떄문에 합집합을 하더라도 행이 추가되지 않는다.
SELECT empno , ename
FROM emp
WHERE deptno=10;
UNION   ---합집합
SELECT empno , ename
FROM emp
WHERE deptno=10;

위 아래 집합에서 7369번 사번은 중복되므로 한번만 나오게 한다.
SELECT empno , ename
FROM emp
WHERE empno IN(7369,7566)
UNION
SELECT empno , ename
FROM emp
WHERE empno IN(7369,7782);

UNION ALL 중복제거 단계가 없다 총 데이터 4개의행
SELECT empno , ename
FROM emp
WHERE empno IN(7369,7566)
UNION ALL
SELECT empno , ename
FROM emp
WHERE empno IN(7369,7782);

두 집합의 공통된 부분은 7369행 밖에 없음 :총 데이터 1행
SELECT empno , ename
FROM emp
WHERE empno IN(7369,7566)
INTERSECT
SELECT empno , ename
FROM emp
WHERE empno IN(7369,7782);

윗쪽 집합에서 아래쪽 집합의 행을 제거하고 남은행 : 1개의행 (7566)
SELECT empno , ename
FROM emp
WHERE empno IN(7369,7566)
MINUS  --차집합
SELECT empno , ename
FROM emp
WHERE empno IN(7369,7782);

집합 연산자 특징
1. 컬럼명은 첫번째 집합의 컬럼명을 따라간다. 위쪽에있는 알리아스를 따라간다
2. ORDER BY절은 마지막 집합에 적용한다.
    마지막 sql이 아닌 sql에서 정렬을 사용하고싶은경우 INLINE -VIEW 를 활용
    union all의 경우 위 아라 집합을 이어주기때문에 집합의 순서를 그대로 유지
    하기 때문에 요구사항에 다라 정렬된 데이터 집합이 필요하다면 해당 방법을 고려
SELECT empno e, ename
FROM emp
WHERE empno IN(7369,7566)
UNION ALL
SELECT empno , ename
FROM emp
WHERE empno IN(7369,7782)
ORDER BY ename;