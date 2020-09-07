==emp 테이블에서 jo이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 
직원의 정보를 다음과 같이 조회하세요

SELECT *
FROM emp
WHERE job= 'SALESMAN' 
OR hiredate>= TO_DATE('19810601','YYYYMMDD');
12 emp 테이블에서job이 SELESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과
같이 조회 하세요
SELECT *
FROM emp
WHERE job='SALESMAN'
OR empno LIKE '78%';

13 emp 테이블에서job이 SELESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과
같이 조회 하세요(LIKE쓰지말고)

SELECT *
FROM emp
WHERE job='SALESMAN'
OR(empno BETWEEN 78 AND 78
OR empno BETWEEN 780 AND 789
OR empno BETWEEN 7800 AND 7899);

14 emp테이블에서
job이 SALESMAN이거나 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 
직원의 정보를 다음과 같이 입력하세요

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE'78%'
AND hiredate TO_DATE('19810901','YYYYMMDD');
=============================================================
DESC emp;


ROWNUM :1부터 읽어야 된다
    SELECT절이 ORDER BY절보다 먼저실행된다
        ==>  ROWNUM을 이용하여 순서를 부여하려면 정렬부터 해야된다
            ==> 인라인뷰 (ORDER BY ROWNUM을 분리)
            
row_1

SELECT ROWNUM rn,empno,ename
FROM emp
WHERE ROWNUM <=10;

row_2
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
row_3 emp테이블에서 사원이름으로 오름차순으로 정렬하고
11~14번에 해당하는 순번, 사원번호를 입력
1.
SELECT *
    FROM(SELECT ROWNUM rn,a.*
        FROM(SELECT empno,ename
            FROM emp
            ORDER BY ename ASC)a)
            WHERE rn BETWEEN 11 AND 14;
2.
 SELECT *
    FROM
    (SELECT ROWNUM rn, empno,ename            
      FROM         
        (SELECT empno,ename
        FROM emp
        ORDER BY ename ASC))
        WHERE rn>10 AND rn<=20;
        

SELECT *
FROM dual;   ppt첨부 사진132

ORACLE 함수분류
1. SINGLE ROW FUNCTION : 단일 행을 작업의 기준 결과도 한건 변환
2. MULTI ROWROW FUNCTON: 여러 행을 작업의 기준, 하나의 행을 결과로 변호나

dual테이블
1. sys 계정에 존재하는 누구나 사용할수있는 테이블
2. 테이블에는 하나의 컬럼, dummy존재, 값은x
3. 하나의 행만 존재 
 **************SINGLE
 SELECT empno, ename, LENGTH(ename),LENGTH('Heoll')
 FROM emp;
//ename의 길이가 숫자로나온다. //Hello 길이의 숫자 

SELECT LENGTH('Hello')
FROM dual;
sql 칠거지약
1. 좌변을 가공하지 말아라(테이블 컬럼에 함수를 사용하지 말것)
함수실행 횟수
인덱스 사용관련 (추후에)
SELECT ename, LOWER(ename)
FROM emp
WHERE LOWER(ename)='smith';

SELECT ename, LOWER(ename)
FROM emp
WHERE ename= UPPER('smith');    ==?
WHERE ename = 'SMITH';

문자열 관련함수:
SELECT CONCAT('Hello',',World')concat,    --별칭 
        SUBSTR('Hello, world',1, 11)substr,
        SUBSTR('Hello, world',5)substr2, --뒤에서 5글자
        LENGTH('Hello, World')length,   --글자수가 얼마나있는지
        INSTR('Hello, world','o')instr,  --몇번째 위치하는지
        INSTR('Hello, world','o',5+1)instr2,
        INSTR('Hello, world','o', INSTR('Hello, World','o') + 1) instr3,
        LPAD('Hello, World', 15, '*')lpad,
        LPAD('Hello, World', 15)lpad2,       
        RPAD('Hello, World',15, '*')rpad,
        REPLACE('Hello, World','Hello','Hell')replace,
        TRIM('Hello, World') trim,
        TRIM(' Hello, World  ') trim2,
        TRIM('H' FROM 'Hello, World')trim3
FROM dual;


숫자 관련함수

SELECT *
FROM emp
WHERE empno> 7800 AND sal <1500;

ROUND: 반올림 함수
TRUNK: 버림함수
===> 몇번째 자리에서 반올림 ,버림을 할지?
   두번째 인자가 양수: ROUND (숫자 , 반올림결과 자리수)
   두번째 인자가 음수 ROUND (숫자 , 반올림결과 자리수)
MOD :나머지를 구하는 함수 


SELECT ROUND(105.54, 1)round,
       ROUND(105.55, 1)round2,
       ROUND(105.55, 0)round3,
       ROUND(105.55, -1)round4
FROM dual;


SELECT TRUNC(105.54, 1)trunc,
       TRUNC(105.55, 1)trunc2,
       TRUNC(105.55, 0)trunc3,
       TRUNC(105.55, -1)trunc4
FROM dual;

mod 나머지를 구하는함수
피제수 --나눔을 당하는수,제수-나누는수

a/ b = c
a:피제수
b:제수

10을 3으로 나눴을때의 몫을 구하기
SELECT mod(10, 3), TRUNC(10/3, 0)
FROM dual;

날짜 관련 함수 
문자열==> 날짜 타입 TO_DATA

SYSDATE : 오라클 서버의 현재날짜, 시간을 돌려주는특수함수
        함수의 인자가 없다.
        (java
        pulic void test(){
        {
        test
        
    SQl 
    length('Hello , world')
    SYSDATE;
    
    SELECT SYSDATE      
    FROM dual;                    --환경설정 데이터베이스 NLS에서 시간 보이게 HH24:MI:SS 
    
    날짜타입 +- 정수: 날짜에서 정수만큼 더한(뺀) 날짜
    하루 24
    1일 24h
    1/24일 =1h
    1/24일/60 =1m
    1/24일/60/60 =1s
    emp hiredate +5, -5
    
    SELECT SYSDATE, SYSDATE +5, SYSDATE -5,
            SYSDATE + 1/24, SYSDATE + 1/24/60  1. 시간을 더해줌 2. 1분을 더해줌
    FROM dual;
    
    sql: NSL포맷에 설정된 문자열 형식을따르거나 
    ==> 툴 떄문일수도 있음 예측하기 힘듬
    TO_DATE 함수를 이용하여 명확하게 명시
    TO_DATE('날
    짜문자열','날짜 문자열 형식')
    
    
    SELECT TO_DATE('20191231','YYYYMMDD')LASTDAY, 
    TO_DATE('20191231','YYYYMMDD')-5 "LASTDAY_BE",
    SYSDATE NOW, SYSDATE-3 NOW_BE
    FROM dual;
    