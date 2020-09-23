SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM  buyer;

SELECT *
FROM cart

SELECT mem_id, mem_pass,mem_name
FROM member

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101','yyyymmdd')AND
 TO_DATE('19830101','yyyymmdd');
 
 SELECT *
 FROM emp
 
SELECT userid , usernm, alias
FROM users
WHERE userid IN ('sally','brown','cony')

SELECT *
FROM emp
WHERE comm IS NOT NULL


SELECT *
FROM emp
WHERE deptno != 10
AND hiredate >TO_DATE('19810601','yyyymmdd')

SELECT *
FROM emp
WHERE deptno NOT IN 10
AND hiredate >TO_DATE('19810601','yyyymmdd')


SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm ASC;

SELECT ROWNUM rn,empno,ename
FROM emp
WHERE ROWNUM<=10


가상컬럼 로우넘실습
SELECT *
FROM(SELECT ROWNUM rn,a.*
    FROM(SELECT empno,ename
        FROM emp
        ORDER BY ename)a)
         WHERE rn BETWEEN (:page - 1) * :pagesize + 1 AND :page*:pagesize;


SELECT *
FROM(SELECT ROWNUM rn, empno,ename
    FROM emp)
    WHERE rn BETWEEN 11 AND 14;

SELECT SYSDATE
FROM dual;

SELECT SYSDATE DT_DASH ,TO_DATE(SYSDATE,'yyyy-mm-ddhh24:mi:ss'),
FROM dual;


SELECT TO_CHAR(LAST_DAY(TO_DATE(202001,'yyyymm')),'DD')
FROM dual;

SELECT userid,usernm,reg_dt,NVL(reg_dt,0)m
FROM users;

SELECT empno, ename,
    CASE 
        WHEN deptno = 10 THEN 'ACCOUNT'
        WHEN deptno = 20 THEN 'RESERCh'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATION'
        ELSE 'DDIT'
    END dname
FROM emp;
        
SELECT 
    CASE 
        MOD(TO_CHAR(reg_dy'yyyy'),2)


SELECT TO_CHAR(hiredate,'yyyymm'), COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyymm')

SELECT TO_CHAR(hiredate,'yyyy'), COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyy')

SELECT COUNT(COUNT(deptno))cnt
FROM dept
GROUP BY deptno


SELECT COUNT(COUNT(deptno))cnt
FROM emp
GROUP BY deptno

SELECT e.empno, e.ename,d.deptno,d.dname
FROM  emp e,  dept d
WHERE e.deptno = d.deptno
ORDER BY deptno; 

SELECT *
FROM dept

SELECT e.empno, e.ename,d.deptno,d.dname
FROM  emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno IN(10,30)
ORDER BY deptno; 


SELECT e.empno, e.ename,e.sal ,d.deptno,d.dname
FROM  emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal >=2500;


SELECT e.empno, e.ename,e.sal ,d.deptno,d.dname
FROM  emp e, dept d
WHERE e.deptno=d.deptno
AND sal>2500
AND empno>7600;

SELECT e.empno, e.ename,e.sal ,d.deptno,d.dname
FROM  emp e, dept d
WHERE e.deptno=d.deptno
AND e.sal> 2500
AND e.empno>7600
AND d.dname = 'RESEARCH';

SELECT l.lprod_gu,l.lprod_nm,p.prod_id,p.prod_name
FROM  prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

SELECT b.buyer_id,b.buyer_name,p.prod_id,p.prod_name
FROM buyer b, prod p
WHERE b.buyer_id = p.prod_buyer


SELECT *
FROM customer

SELECT r.cid, r.cnm ,c.pid,c.day, c.cnt
FROM customer r, cycle c
WHERE r.cid=c.cid
AND r.cnm IN('brown','sally');


SELECT r.cid, r.cnm ,c.pid, p.pnm, sum(c.cnt)cnt
FROM customer r, cycle c ,product p
WHERE r.cid=c.cid
AND p.pid = c.pid
GROUP BY r.cid , r.cnm, c.pid , p.pnm ;

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM customer, cycle, product
WHERE cycle.cid= customer.cid
AND product.pid= cycle.pid
GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm


SELECT c.pid, p.pnm,SUM(c.cnt)cnt
FROM cycle c, product p
WHERE c.pid=p.pid
GROUP BY c.pid, p.pnm;


SELECT *
FROM buyprod;


SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
                FROM emp)
                
                

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename='SMITH'
                OR ename = 'WARD');
                
                
SELECT c.pid,p.pnm
FROM cycle c , product p
WHERE 