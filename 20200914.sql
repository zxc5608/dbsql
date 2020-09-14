트랜젝션

동시성

emp테이블의 모든컬럼

cid customer id:고객아이디
cnm customer nm:고객이름
SELECT *
FROM customer;

pid  product id  제품번호
pnm product name 제품이름

SELECT *
FROM product;

cycle고객 애음주기
cid customer id:고객 id
pid product id: 제품 id
day:1~7(일~토) 애음 요일 (매주지정된요일)
cnt:COUNT 약자 (수량)

SELECT *
FROM cycle;

실습 join4
SELECT customer.*,cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE cycle.cid = customer.cid
AND customer.cnm IN('brown','sally');

ANSI 작성
SELECT cid, cnm,cycle.pid, cycle.day, cycle.cnt
FROM customer NATURAL JOIN cycle
WHERE customer.cnm IN('brown','sally');


SELECT cid, cnm,cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle USING(cid)
WHERE customer.cnm IN('brown','sally');



SELECT cid, cnm ,cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle ON(cycle.cid = customer.cid)
WHERE customer.cnm IN('brown','sally');???

join5
sql: 시행에 대한 순서가 없다 조인할 테이블에대해서 FROM절에
기술한 순으로 테이블을 읽지않음
FROM customer ,cycle ,product >>오라클에서는 product테이블부터 읽을수있따.


EXPLAIN PLAN FOR
SELECT customer.*, product.pnm,cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE cycle.cid = customer.cid
AND PRODUCT.pid=cycle.pid
AND customer.cnm IN('brown','sally');

  SELECT *
    FROM TABLE(dbms_xplan.display);


SELECT *
FROM product;
실습 6

SELECT customer.cid, customer.cnm, product.pid, product.pnm,SUM(cycle.cnt)cnt
FROM customer, cycle, product
WHERE cycle.cid= customer.cid
AND product.pid= cycle.pid
GROUP BY product.pnm,SUM(cycle.cnt)cnt,customer.cnm;


OUTER JOIN:자주쓰이지 않지만 중요
join구분 
    1. 문법에 따른구분" ANSI-SQL ,ORACLE
    2. JOIN의 형태에 따른구분: SELF JOIN , NONEQUL-JOIN , CROSS JOIN
    3. JOIN 성공여부에 따라 데이터 표시여부:
    : INNER JOIN 조인이 성공했을떄 데이터를 표시
    : OUTER JOIN-조인이 실패해도 기준으로 정한테이블의 컬럼정보를 표시
    
사번 ,사원의이름  , 관리자 사번, 관리자이름
king (PRESIDENT 의 경우 mgr컬럼값이 null이기때문

SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp e, emp m
WHERE e.mgr= m.empno;



SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp.e JOIN emp.m
ON(e.mgr= m.empno);
 
 --13건이 아니라 14건
SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr= m.empno);


SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr= m.empno);
행에대한 제한 조건 기술시 WHERE절에 기술했을때와 ON절에 기술했을때 결과가다르다


사원의 부서가 10번이 사람들만 조회 되도록 부서번호 조건을 추가

SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr= m.empno AND e.deptno=10);



조건을 WHERE절에 기술한경우==> OUTER JOIN 이 아닌 INTER조인 결과가 나온다.


SELECT e.empno,e.ename,e.deptno,e.mgr,m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr= m.empno) 
WHERE e.deptno=10; 
 
    ||  킹이 빠졌다. 
SELECT e.empno,e.ename,e.deptno,e.mgr,m.ename, m.deptno
FROM emp e JOIN emp m ON(e.mgr= m.empno) 
WHERE e.deptno=10;



ANSI-SQL
SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr= m.empno);

UNION
SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr= m.empno);

--ORACLE -SQL: 데이터가 없는쪽의 컬럼에 (+)기호를 붙인자
            ANSI -SQL기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다.
            WHERE절  연결 조건에 적용

--얘는 사원기준 
SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp e, emp m 
WHERE e.mgr= m.empno(+);



SELECT e.empno,e.ename,e.mgr,m.empno,m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr=m.empno);
--얘는 관리자기준

full outer
레프트아우터와 라이트아우터 의 중복데이터를 제거

SELECT e.ename,m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr= m.empno);

UNION  --합집합
SELECT e.ename,m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr= m.empno);
MINUS
SELECT e.ename,m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr= m.empno);

SELECT e.ename,m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr= m.empno);
UNION  --합집합

SELECT e.ename,m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr= m.empno);
INTERSECT -- 교집합

SELECT e.ename,m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr= m.empno);

실습
SELECT *
FROM prod;

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod
WHERE BUY_DATE =  TO_DATE('2005/01/25','YYYY/MM/dd');


실습 1
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON(b.buy_prod=p.prod_id)
AND b.buy_date = TO_DATE('05/01/25','YY/MM/dd');


SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b ,prod p 
WHERE b.buy_prod(+)=p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25','YY/MM/dd');
