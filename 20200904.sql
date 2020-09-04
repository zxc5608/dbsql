SELECT empno, ename ==> 컬럼으로인식
FROM emp;
별칭기술 : 텍스트, "텍스트"/'텍스트;'
SELECT empno "ename" 
FROM emp;

WHERE 절 :스프레드시트  - filter : 전체 데이터중에 내가원하는 행만 나오도록 제한

비교연산: <,>,=,!=,<> ,<=, >=
BETWEEN AND
IN
연산자를 배울떄 (복습할때 ) 기억할 부분
해당 연산자 x항 연산자 인지하자 

SELECT *
FROM emp
WHERE 10 BETWEEN 20 AND 50;

==============================복습==============================

==============================시작==============================
NULL비교 
NULL값은 =, !=등의 비교연산으로 비교가 불가능
EX: emp테이블에서는comm컬럼의 값이 NULL인 데이터가 존재 
comm 이 null인 데이터를 조회하기 위해 다음과 같이 실행할경우
정상적으로 동작하지 않음

SELECT *
FROM emp
WHERE comm IS NOT NULL;

comm  컬럼의 값이 NULL이 아닐때
=, !=, <>

IN <==> NOT IN 

사원중 소속 부서가 10번이 아닌_ 사원을 조회
SELECT *
FROM emp
WHERE deptno NOT IN(10)
=========
사원중에 자신의 상급자가 존재하지 않는 사원들만 조회 (모든컬럼)
SELECT *
FROM emp
WHERE mgr IS NULL; 널 값만 출력
            NOT   :널값 빼고 출력 
            
논리연산 : AND ,OR, NOT
AND OR 조건을 결합
AND : 조건1 AND 조건 2 : 조건 1과 조건 2를 동시에 만족하는 행만 조회가되도록 제한
OR :  조건1 OR 조건2: 조건1 혹은 조건2 를 만족하는 행만 조회 되도록 제한

조건 1 조건2  조건1 AND 조건2  조건1  OR 조건2 
t       t       t               t
t       f       f               t
f       t       f               t
f       f       f               f

WHERE 절에AND조건을 사용하게 되면 보통은 행이 줄어든다.
WHERE 절에 OR조건을 사용하게 되면 보통은 행이 늘어난다,
---
NOT 부정연산
다른연간자와 함께사용되며 부정형 표현으로 사용됨
NOT IN (값1.값2..
IS NOT NULL


mgr가 7698 사번을 갖으면서 급여기 1000보다 큰 사원들을 조회

SELECT *
FROM emp
WHERE mgr=7698
AND sal>1000;   결과다름 

SELECT *
FROM emp
WHERE mgr=7698
OR sal>1000;


emp 테이블의 사원중에 mgr가 7698이 아니고 7939가 아닌 직원

    SELECT *
    FROM emp
    WHERE mgr!=7698
    AND mgr!=7839;
    
    ||
    
    SELECT *
    FROM emp
    WHERE mgr NOT IN(7698,7839)

    IN연산자는 OR연산자로 대체가 가능
    
    SELECT *
    FROM emp
   
    WHERE mgr IN (7698,7839); >> mgr= 7698 OR mgr=7839   (시험문제)
    WHERE mgr NOT IN (7698,7839); >>  mgr != 7698 AND mgr != 7839 부정형을 쓰게되면 
    
    IN 연산자 사용시 NULL 데이터 유의점 
    요구사항: mgr 가7698,7839, NULL인 사원만 조회
    
    SELECT *
    FROM emp
    WHERE mgr IN (7698,7839)
    OR mgr IS NULL; 
    
    
    mgr = 7698 OR mgr = 7839 OR mgr = NULL;
      WHERE mgr IN (7698,7839,NULL); 
      
    SELECT *
    FROM emp
    WHERE mgr NOT IN (7698,7839,NULL); 
    mgr != 7698 AND mgr!=7839 AND mgr != NULL
    
    연습문제
    
    job이 SALSEMAN 입사일자가 19810601 이후 
    data 는대소문자를가린다
    data type표현
    두가지 조건을 논리연산자로 묶는방법(AND)
7
    SELECT *
    FROM emp
    WHERE job= 'SALESMAN' 
            AND hiredate >= TO_DATE('19810601','YYYYMMDD'); 
         8번    
    SELECT *
    FROM emp
    WHERE deptno != 10 
    AND hiredate >= TO_DATE ('19810601','YYYYMMDD');
    9
    SELECT *
    FROM emp
    WHERE deptno NOT IN (10)
    AND hiredate >= TO_DATE ('19810601','YYYYMMDD');
    10
    SELECT *
    FROM emp
    WHERE deptno IN(20,30)
    AND hiredate>= TO_DATE ('19810601','YYYYMMDD');
    
    11.12.13 ,14과제  
    
   
  
  정렬
    =================매우 매우 중요==========================
    RDBMS는 집합에서 많은부분을 차용
    집합의 특징 : 순서가없다 중복을 사용하지않는다
    {1, 5, 10} =={5, 1, 10}({순서가없다.
    {1,5,5,10}==>{1,5,10} 집합은 중복을 허용하지않는다.
    
   
   
    아래 sql 의 실행결과, 데이터의 조회 순서는 보장되지않는다.
    지금은 7369,7499.... 조회가되지만
    내일 동일한 sql을 실행을 하더라도 오늘 순서가 보장되지않는다.(바뀔수있음)
     *데이터는 보편적으로 데이터를 입력한 순서대로 나온다 (보장은아님)
     ** table에는 순서가없다. 
    SELECT *
    FROM emp
    
    시스템을 만들다보면 데이터의정렬이 중요한 경우가 많다. 
    게시판 글 리스트:가장 최신글이 가장 위로 와야한다.
    
    ** 즉 SELECT 결과 행의 순서를 조정 할수 있어야한다
    ==> ORDER BY 구문
    
    문법
    SELECT *
    FROM 테이블명
    [WHERE]
    [ORDER BY 컬럼 1,컬럼2 ]
    오름차순,ASC :값이 작은 데이터부터 큰 데이터 순으로 나열
    내림차순 ,DESC:값이 큰 데이터부터 작은 데이터 순으로 나열
    
    ORACLE에서는 기본적으로 오름차순이 기본 값으로 적용됨
    내림차순으로 정렬을 원할경우 정렬 기준 컬럼뒤에 DESC를 붙여 준다.
    
    job컬럼으로 오름차순 정렬하고 , 같은 job을 갖는 행끼리는 empno로 내림차순 정렬한다.
    SELECT *
    FROM emp
    ORDER BY job,empno DESC; 
    
    참고로만 ..중요하지않은 
    1. ORDER BY 절에 별칭 사용가능 
    
    SELECT empno eno, ename enm
    FROM emp
    ORDER BY enm; 
    
    2. ORDER BY절에 SELECT 절의 컬럼 순서번호를 기술하여 정렬가능
    SELECT empno, ename 
    FROM emp
    ORDER BY 2; ===> ORDER BY ename
    
    3. expreesion도 가능
    SELECT empno, ename, sal+ 500
    FROM emp
    ORDER BY sal+500;
    
    
    SELECT *              오름차순
    FROM dept
    ORDER BY dname ASC;
    
    SELECT *
    FROM dept           내림차순
    ORDER BY loc DESC;
    
    comm 이 존재하는 사원만 조회, 단 상여가0인사람은 상여가 없는것으로간주.
    
    SELECT *
    FROM emp 
    WHERE comm Is NOT NULL
    AND comm != 0
     ORDER BY comm DESC, deptno DESC;
     
     
     SELECT *
     FROM emp
     WHERE mgr IS NOT NULL
     ORDER BY job, empno DESC;
     
     ㅇㅅ
    1 SELECT *
     2FROM emp
     3WHERE deptno IN (10, 30)
            AND sal > 1500
     4ORDER BY ename DESC; 
     2 -3-1-4
     
     **********************실무에서 매우 많이사용
      ROWNUM :행의번호를 부여하는 가상 컬럼
             ** 조회된 순서대로 번호를 부여 
   
      ROWNUM 은 1번부터 순차적으로 데이터를 읽어올때만 사용가능 
     1. WHERE절에서 사용하는것이 가능
     
     *WHERE ROWNUM =1 (=동등 비교 연산의 경우 1만 가능)
     WHERE ROWNUM<=15  가능
     WHERE ROWNUM BETWEEN 1 AND 15; 가능
     
     SELECT ROUNUM empno,ename
     FROM emp
     WHERE ROWNUM BETWEEN 6 AND ;
     
     SELECT ROWNUM, empno ,ename
      FROM emp
      WHERE 글번호 BETWEEN 46 AND 60;
      
     2. ORDER BY절은 SELECT 이후에 실행된다
     ** SELECT 절에 ROWNUM 을 사용하고 ORDERBY절을 적용하게되면 원하는 결과를 얻지못한다
     
     SELECT ROWNUM, empno,ename
     FROM emp
     ORDER BY ename;
     
     정렬을 먼저하고 정렬된 결과에 ROWNUM을 적용
     ==> INLINE -VIEW
         SELECT 결과를 하나의 테이블처럼 만들어준다.
 
 
 사원정보를 페이징 처리 
 1페이지에 5명씩 조회
 1페이지 1-5     (page-1)*pagesize+1 ~ page *pagesize
 2페이지 :6-10 
 3페이지 11-15

page = 1, pagesize =5

SELECT *
FROM 
 (SELECT ROWNUM rn,a.*
 FROM        
    (SELECT empno,ename
     FROM emp
     ORDER BY ename)a)
     WHERE rn BETWEEN (:page - 1) * :pagesize + 1 AND :page*:pagesize;
     
           정렬이된상태에서 번호를 부여
    SELECT절에 *사용했는데, 를 통해 다른 특수 컬럼이나 expression을 사용할 경우는
    *앞에 해당 데이터가 어떤 테이블에서 왔는지 명시를 해줘야 한다(한정자)
    
   SELECT ROWNUM, emp. *
   FROM emp;
   
   별칭은 테이블에도 적용가능 ,단 컬럼이랑 다르게 AS옵션은 없다

SELECT ROWNUM,e,*
FROM emp e;
           