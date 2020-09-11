5
SELECT TO_CHAR(hiredate,'yyyy')HIREDATE_YYYY,
COUNT(*)CNT
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyy');

6
SELECT COUNT(*)
FROM dept; 
or
SELECT COUNT(COUNT(deptno))CNT
FROM dept
GROUP BY deptno;
7 부서가 몇개 존재하는지==>3행
SELECT COUNT(*)
FROM
(SELECT deptno
FROM emp
GROUP BY deptno)a;

SELECT COUNT(COUNT(deptno))
FROM emp
GROUP BY deptno;

======================================
실습 JOIN 0
SELECT emp.empno,emp.ename,dept.deptno,dept.dname
FROM emp,dept
WHERE emp.deptno=dept.deptno
ORDER BY deptno;

JOIN
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp JOIN dept 
ON emp.deptno=dept.deptno
ORDER BY deptno;


실습 JOIN 1
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno= dept.deptno
AND emp.deptno IN(10,30);

join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept
on emp.deptno= dept.deptno
AND emp.deptno IN(10,30);


실습 JOIN2
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno  
AND sal>2500
ORDER BY deptno;

SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp JOIN dept
ON emp.deptno = dept.deptno  
AND sal>2500
ORDER BY deptno;

실습 JOIN 3
SELECT emp.empno, emp.ename ,emp.sal ,dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno=dept.deptno
AND sal>2500
AND empno>7600;

JOIN
SELECT emp.empno, emp.ename ,emp.sal ,dept.deptno, dept.dname
FROM emp JOIN dept
ON emp.deptno=dept.deptno
AND sal>2500
AND empno>7600;


실습 JOIN4
SELECT emp.empno, emp.ename, emp.sal ,dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal>2500
AND empno>7600
AND dname='RESEARCH';

JOIN
SELECT emp.empno, emp.ename, emp.sal ,dept.deptno, dept.dname
FROM emp JOIN dept
ON emp.deptno = dept.deptno
AND sal>2500
AND empno>7600
AND dname='RESEARCH';

=======================
데이터 결합 실습 
1번
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

prod 테이블건수?

SELECT COUNT(*)
FROM prod;
2번
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE prod.prod_buyer = buyer.buyer_id;

3번
JOIn시 생각할 부분
1.테이블기술
2.연결조건


ANSI -SQL
테이블 join 테이블 on()
      join 테이블 on()
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart , prod
WHERE  member.mem_id = cart.cart_member 
AND cart.cart_prod= prod.prod_id;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON(member.mem_id = cart.cart_member) 
     JOIN prod ON(cart.cart_prod= prod.prod_id);
 
