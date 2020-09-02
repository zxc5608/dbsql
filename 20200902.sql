
== SELECT쿼리문법==              별명
SELECT * | {column |expression[ alias]}
FROM 테이블이름 ;


1. 실행하려고 하는 SQL을 선택후 ctrl+ enter;
2. 실행하려는 SQL 구문에 커서를 위치시키고 ctrl+ enter;
SELECT *
FROM emp;  -- emp 테이블은 8개열 14개 행 (해달 컬럼을 전부 조회해라.

select empno,ename  -- 두개 컬럼만 보이게
from emp;

SELECT *
FROM dept;

SQL 의 경우 KEY워드의 대소문자를 구분하지 않는다.

그래서 아래 SQL은 정상적으로 실행 대소문자 상관없음

SELECT *
FROM dept;
coding rule
키워드 대문자
그외에는  소문자 

lprod테이블에서 모든 데이터를 조회하는 쿼리를 작성하시오
SELECT *
FROM lprod;
buyer테이블에서 buyer_id buyer_name컬럼만 조회하는 쿼리를 작성하시오
SELECT buyer_id,buyer_name
FROM buyer;
cart테이블에서 모든 데이터를 조회하는 쿼리를 작성하시오
SELECT *
FROM cart;
member테이블에서mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하시오
SELECT mem_id, mem_pass, mem_name
FROM member;

SELECT쿼리는 테이블의 데이터에 영향을 주지않는다
SELECT쿼리를 잘못작성 했다고 해서 데이터가 망가지지않음

연산 --sal 컬럼에 100을 더해서 보고싶다.
SELECT ename,sal, sal+100  
FROM emp;

데이터 타입
DESC 테이블명 (테이블 구조를 확인)
DESC emp;
숫자+숫자= 숫자값
5+6=11
문자+문자+ 문자==> 자바에서는 문자열에 이은 문자열 결합으로 처리
수학적으로 정의된개념이 아님
오라클레서 정의한개념
날짜에다가 숫자를 일수로 생각하여 더하고 뺀 일자 결과로 된다.
날짜 +숫자= 날짜

hiredata 에서 365일 미래의 일자

==중요하진 않음=\=\=

별칭 : 컬럼, expression에 새로운 이름을 부여
        컬럼| expression [AS][컬럼명]
        SELECT ename, hiredate, hiredate+365after_1year,  hiredate-365 before_1year
FROM emp;
또는 
SELECT ename AS emp_namer, hiredate, hiredate+365after_1year,  hiredate-365 before_1year
FROM emp;

별칭 부여할때주의 할점
1.공백이나 ,특수문자가 있는경우 더블 쿼데이션으로 감싸줘야한다
2.별칭명은 기본적으로 대문자로 취급되지만 소문자로 지정하고싶으면 더블쿼테이션을 적용한다.
SELECT ename "emp name"(1.== 이띄어쓰기 처럼),empno emp_no"emp_no2"(2번)
FROM emp;

자바에서 문자열 : "Hello world"
SQL에서 문자열 : 'Hello world'


==매우중요==
NULL : 아직 모르는 값
숫자타입 : 0이랑 NULL은 다르다
문자타입: ' ' 공백문자와 NULL은 다르다
******NULL을 포함한 연산의 결과는 항상 NULL
5* NULL= NULL
800+NULL=NULL
800+0=0
emp 테이블 컬럼 정리 
1. empno : 사원번호
2. ename : 사원이름
3. jop: (담당)업무
4. mgr: 매니저 사번번호
5. hiredate:입사일자
6. sal : 급여
7. comm: 상과급
8. deptno: 부서번호

emp 테이블에서NULL 값을 확인

SELECT ename,sal,comm, sal+comm AS total_sal
FROM emp;

SELECT *
FROM dept;

SELECT userid, usernm, reg_dt,reg_dt+5
FROM users;

연습문제 2
SELECT prod_id AS id, prod_name "name"
FROM prod;

SELECT lprod_gu AS gu, lprod_nm "nm"
FROM lprod;

SELECT buyer_id AS 바이어아이디, buyer_name"이름"
FROM buyer;





literal 값 자체
literal 표기법: 값을 표현하는 방법

숫자 10이라는 값을 
java= int a= 10;
SQL: SELECT empno,10
FROM emp

문자 Hello world라는 문자값을
java: String str = " Hello world";
            컬럼 별칭 , expression별칭, 별칭
sql: SELECT empno,'hello world',"Hello world"
  * | {column | expression[alias]}
  
날짜 2020년 9월 2일이라는 날짜 값을..
java: primitive type (원시타입) 8개 int long short byte char float double boolean
문자열 >> String class
날짜 >> date class

sql: ?? 나중에 


문자열 연산
java => 결합연산
"hello,"+"world" >> hello, world
"hello,"-"world" :연산자가 정의되어있지 않다
"hello,"*"world" : 연산자가 정의되어있지않다.

sql || ,CONCAT 함수==> 결합 연산

  emp 테이블의 ename,jop 컬럼의 문자열
java:ename +" "+job
 sql: ename || '' || job
  
  CONCAT( 문자열1,문자열2) : 문자열1과 문자열 2 를 합쳐서 만들어진 새로운 문자열을 반환해준다. 
  
  컨켓을 3개로 하는 방법
  SELECT ename || '' ||job,
  CONCAT(CONCAT(ename, ' '),job)
  FROM emp;
  
  
  USER_TABLES: 오라클레서 관리하는 테이블 (뷰)
                접속한 사용자가 보유하고있는 테이블 정보 관리]
                
SELECT table_name                    --테이블 이름만 보여라
FROM user_tables;

SELECT CONCAT('SELECT * FROM  ',table_name)||';' "QUERY"  --컨켓 사용
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' as QUERY     --|| 만 사용했을때 
FROM user_tables;

SELECT table name
FROM user_tables;
  