실습 1

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON(b.buy_prod=p.prod_id)
AND b.buy_date = TO_DATE('05/01/25','YY/MM/dd');


TO_DATE('yyyymmdd','YY/MM/dd')바인드 변수로 써줘도된다 밑에도바꿔주고
SELECT TO_DATE('05/01/25','YY/MM/dd')buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b ,prod p  
WHERE b.buy_prod(+)=p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25','YY/MM/dd');


=====================================================
outer join2

TO_DATE('yyyymmdd','YY/MM/dd')바인드 변수로 써줘도된다 밑에도바꿔주고
SELECT TO_DATE('05/01/25','YY/MM/dd')buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b ,prod p  
WHERE b.buy_prod(+)=p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25','YY/MM/dd');


outer join 3
TO_DATE('yyyymmdd','YY/MM/dd')--바인드 변수로 써줘도된다 밑에도바꿔주고
SELECT TO_DATE('05/01/25','YY/MM/dd')buy_date, b.buy_prod, p.prod_id, p.prod_name, 
NVL(b.buy_qty,0)
FROM buyprod b ,prod p  
WHERE b.buy_prod(+)=p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25','YY/MM/dd');


바인드 변수를 써주고(+) 조인 표시를 해준다
SELECT P.pid , p.pnm, :cid cid, NVL(c.day,0)day, NVL(c.cnt,0)cnt
FROM  cycle c ,product p 
WHERE c.pid(+) = p.pid
AND c.cid(+)=:cid;

ANSI
변환 위


5번문제변환


INNER JOIN :조인이 성공하는 데이터만 조회가 되는 조인방식(JOIN이랑 같다)
OUTER JOIN 조인에 실패해도 기준으로 정한 테이블의 컬럼은 조회가 되는 조인방식

cross join 
EMP테이블의 행 건수14)* DEPT테이블 행 건수(4) =56건
SELECT *
FROM emp,dept;


cross join 실습
5번 과제 

SELECT *
FROM customer,product;

SELECT *
FROM customer CROSS JOIN product;

============================
SQL활용에 있어서 매우 중요
서브쿼리: 쿼리안에서 실행되는 쿼리를 의미

1. 서브쿼리 분류 - 서브쿼리가 사용되는위치에따른 분류
 1.1 SELECT : 스칼라 서브쿼리(SCALAR SUBQUERY)
 1.2 FROM : 인라인뷰(INLINE VIEW)
 1.3 WHERE: 서브쿼리 (SUB QUERY)
                            (행1, 행 여러개)(컬럼1,컬럼여러개)
2. 서브쿼리 분류 - 서브쿼리가 반환하는 행이 컬럼의 개수에 따른 분류
(행1, 행 여러개)(컬럼1,컬럼여러개):
(행 ,컬럼):4가지
2.1 단일행 , 단일컬럼
2.2 단일행 , 복수컬럼 ==> x
2.3 복수행 , 단일컬럼
2.4 복수행 , 복수컬럼

3. 서브쿼리분류-메인쿼리의 컬럼을 서브쿼리에서 사용하는 사용여부
    3.1 상호 연관 서브쿼리 (CO-RELATED SUB QUERY)
    -메인 쿼리의 컬럼을 서브 쿼리에서 사용하는 경우
    3.2 비상호 연관 서브 쿼리 (NON-CORELATED SUB QUERY)
    - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하지 않는경우
    
SMITH가 속한 부서에 속한 사원들은 누가 있을까?
1. SMITH 가 속한 부서번호 구하기
2. 1번에서구한 부서에 속해있는 사원들 구하기

1. 
SELECT dept
FROM emp
WHERE ename =' SMITH';

2.
SELECT *
FROM emp
WHERE deptno=20; 
 ==>서브쿼리를 이용하여 하나로 합칠수있다.
 
 SELECT *
 FROM emp      --=20
 WHERE deptno=(SELECT deptno
                FROM emp
                WHERE ename='SMITH');
서브쿼리를 사용할때 주의점
 1. 연산자
 2. 서브쿼리의 리턴형태
 
 서브쿼리가 한개의행 복수컬럼을 조회하고, 단일 컬럼과= 비교하는경우==>x
 SELECT *
 FROM emp   
 WHERE deptno=(SELECT deptno, empno
                FROM emp
                WHERE ename='SMITH');

서브쿼리가 여러개의행 단일 컬럼을 조회하는 경우
1. 사용되는 위치: WHERE -서브쿼리
2. 조회되는 행, 컬럼의 개수: 복수행의 단일컬럼
3. 메인쿼리의 컬럼을 서브쿼리에서 사용 유무: 비상호연관 서브쿼리
SELECT *
 FROM emp     --여러개의 행일경우 IN 연산자 사용
 WHERE deptno IN(SELECT deptno
                FROM emp
                WHERE ename='SMITH' 
                OR ename ='ALLEN');
deptno =20,30  

평균급여보다 높은급여를 받는 직원의 수를 조회하세요
1. 평균급여구하기
2. 1에서구한값 보다 sal값이 큰 사원들의 수 카운트 하기

SELECT COUNT(*)--널값을 갖든말든 행의수를 갖는다.
FROM emp
WHERE sal >(SELECT AVG(SAL)
                FROM emp);
                
sub 2
              
SELECT *
FROM emp
WHERE sal >(SELECT AVG(SAL)
                FROM emp);  
 실습 sub3
  SMITH와 WARD사원이 속한 부서의 모든사원정보를 조회하는 쿼리를 작성하세요
  SELECT *
  FROM emp
  WHERE deptno IN(SELECT deptno
                  FROM emp
                  WHERE ename='SMITH' OR ename='WARD');
                == WHERE ename IN ('SMITH','WARD')
 복수행 연산자: IN (중요) ANY, ALL (빈도 떨어진다)               
 SELECT *
  FROM emp          --800,1250
  WHERE sal <ANY(SELECT sal
                  FROM emp
                  WHERE ename='SMITH' OR ename='WARD');
sal컬럼의 값이 800이나 1250보다 작은 사원
==> sal 컬럼이 값이 1250보다 작은 사원

 SELECT *
  FROM emp          --800,1250
  WHERE sal >ALL(SELECT sal
                  FROM emp
                  WHERE ename='SMITH' OR ename='WARD');
sal 컬럼의 값이 800보다 크면서 1250보다 큰 사원
==> sal 컬럼의 값이 1250보다 큰 사원

복습
==
NOT IN 연산자와 NULL
관리자가 아닌 사원의 정보를 조회
SELECT *
FROM emp
WHERE empno NOT IN(SELECT mgr
                    FROM emp);
                    
pair wise 개념: 순서쌍 , 두가지 조건을 동시에 만족시키는 데이터를 조회할떄 사용
                    AND 논리 연산자와 결과 값이 다를 수있다. (아래예시참조)
서브쿼리 : 복수행 , 복수컬럼

SELECT *
FROM emp
WHERE (mgr,deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499,7782));
                        
                        사진
                        
                        
SCALAR SUBQUERY: SELECT 절에 기술된 서브쿼리
                        하나의컬럼
                            중요*
    **스칼라 서브쿼리는 하나의 행, 하나의 컬럼을 조회하는 쿼리 이어야 한다.
SELECT dummy,(SELECT SYSDATE,
                FROM dual)
FROM dual;

스칼라 서브쿼리가 복수개의 행 (4개), 단일 컬럼을 조회==>에러
SELECT empno, ename,deptno,(SELECT dname FROM dept)
FROM emp;

emp테이블과 스칼라 서브쿼리를 이용하여 부서명 가져오기
기존:emp테이블과dept테이블을 조인하여 컬럼을 확장

SELECT empno, ename, dname
FROM emp e ,dept d
WHERE e.deptno= d.deptno;  --이것을 스칼라 서브쿼리로
                          
                                                                
SELECT empno, ename, deptno ,  --한정자를 붙여서 
(SELECT dname FROM dept WHERE deptno=emp.deptno) --emp부서번호를 사용을해서 일반부서번호랑 비교해
FROM emp;       --단독실행이 안됨 emp테이블이 없잖아

상호 연관 서브쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용한 서브쿼리
                - 서브쿼리만 단독으로 실행 하는것이 불가능 하다.
                - 메인쿼리와 서브쿼리의 실행순서가 정해져있다.
                    메인쿼리가 항상 먼저 실행된다

비상호연관 서브쿼리 : 메인쿼리의 컬럼을 서브쿼리에서 사용하지 않는 서브쿼리 
                    -서브쿼리만 단독으로 실행하는 것이 가능하다
                    - 메인 쿼리와 서브 쿼리의 실행순서가 정해져있지 않다
                     메인=> 서브 , 서브=> 메인 둘다 가능 
                     
                     
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                FROM emp);

SELECT dname
FROM dept 
WHERE deptno=deptno