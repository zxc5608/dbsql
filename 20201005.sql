달력만들기
1. 행을 인위적으로 만들기
    CONNECT BY LEVEL
2. 그룹함수
    여러행을 하나의 행으로 만드는 방법
3.expression
    테이블에 존재하지 않지만, 수식 함수를 이용해서 새로운컬럼을 만드는방법
4.부수적인것들
    data 관련함수
        -월의 마지막일자구하기
        
        
1.인위적으로 여러개의행을 만들기
    계층쿼리: 행과 행을 연결
            CONNECT BY LEVEL ==> CROSS JOIN
    조인: 테이블과 행과 다른테이블의 행을 연결 - 컬럼이 확장
    SELECT level, dummy,LTRIM(SYS_CONNECT_BY_PATH(dummy,'-'),'-')
    FROM dual
    CONNECT BY LEVEL<=31;
    
    년월 문자열이 주어졌을때 해당 월의 일수 구하기
    EX: '202010'=>31
        날짜가 있으면 원하는 항목(년,월,일,시,분,초)만 추출할수 있다
        TO_CHAR(날짜,'원하는 항목')
        TO_CHAR(해당 날짜의 마지막날짜 구하는 함수TO_DATE('202010','포맷'),'원하는 항목');
        TO_CHAR(해당 날짜의 마지막날짜 구하는 함수TO_DATE('202010','포맷'),'원하는 항목');
        
        TO_DATE('202010','yyyymm'): 일자를 설정하지 않았기 떄문에 1일자 0시0분0초
        => 마지막날짜로변경
        
        SELECT TO_CHAR(LAST_DAY(TO_DATE('202010','yyyymm')),'dd')
        FROM dual;
        
        SELECT LEVEL ,dummy
        FROM dual
        CONNECT BY LEVEL <=TO_CHAR(LAST_DAY(TO_DATE('202010','yyyymm')),'dd');
        
        실제 필요한값 ==> 날짜(20201001~20201031)
        DATE +정수 =>date에서 정수를 일자로 취급해서 더한날짜
        2020.10.05 + 5 = 2020.10.10
        
        2020년 10월 1일자를 만들려면
        주어진값:'202010'
        
        '202010' || '01' ==> '20201001'
        TO_DATE('202010'||'01','yyyymmdd')
        
        == //동일
        TO_DATE('202010','yyyymm')
        
        2020년 10월1일의 날짜타입을 구함.
        날짜+ 숫자 (LEVEL)연산을 통해 2020 년 10월의 모든 일자를 구할 수 있다
        ==> LEVEL은 1부터 시작하므로 2020년 10월1일의 값을 유지하기 위해서는
        날짜+ LEVEL-1
        
        SELECT TO_DATE('202010','yyyymm')+LEVEL-1 day,
               TO_CHAR(TO_DATE('202010','yyyymm')+LEVEL -1,'d')d,
               TO_CHAR(TO_DATE('202010','yyyymm')+LEVEL -1,'iw')iw
        FROM dual
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202010','yyyymm')),'dd');
        
        해당 날짜의 요일에 따라서 새롭게 만든 7개의 컬럼 (일~월)에 위치 시킨다
        SELECT /*day,d,*/
        --DECODE(d,1,iw+1,iw),
        MIN(DECODE(d,1,day))d1,MIN(DECODE(d,2,day))d2,
        MIN(DECODE(d,3,day))d3,MIN(DECODE(d,4,day))d4,
        MIN(DECODE(d,5,day))d5,MIN(DECODE(d,6,day))d6,
        MIN(DECODE(d,7,day))d7                                             
        FROM            --해당일자가 일요일이면 day로 표현
        (SELECT TO_DATE('202010','yyyymm')+LEVEL-1 day,
               TO_CHAR(TO_DATE('202010','yyyymm')+LEVEL -1,'d')d,
               TO_CHAR(TO_DATE('202010','yyyymm')+LEVEL -1,'iw')iw
        FROM dual
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202010','yyyymm')),'dd'))
        GROUP BY DECODE(d,1,iw+1,iw)
        ORDER BY DECODE(d,1,iw+1,iw);
        
        

칠거지악: en-core-> b2en -> dibian
PL/SQL:procedual Language/sql
SQL은 집합적인 언어인데 여기다 절차적요소를 더함
절차적요소 (반복문,조건 제어 -분기처리)

결론: 절차적으로 잘못짜면 속도가느리다
    ==>sql로 한번에 처리할수 없는지 고민

절차적처리가 필요한 부분은 존재한다:인사시스템 급여, 연말정산
PL/sql사용방법: PL/SQL block을 통해서 실행

PL/SQL block구조 : java try catch 와 유사 -중첩가능

DECLARE
    선언부 - PL/SQL 블럭에서 사용할변수 , TYPE(CLASS),CURSOR(SQL-정보)등을 선언하는 절
        java랑은 다르게 변수선언을 블록 어디서나 할수 없음

BEGIN
    실행부(생략불가 )
    로직- (데이터를 조회해서 변수에 담기 ,루프, 조건제어)
EXCEPTION
    예외부(생략가능)
        BEGIN절에서 발생한예외를 처리하는부분
END;
/

PL/sql식별자 규칙: 오라클 객체 (table,index...) 생성시와 동일
    30글자가 넘어가면 안됨 (FK시 길어지게 되는 경우가 간혹있음 
    오라클객체명은 내부적으로 대문자로관리 
PL/SQL 연산자 :SQL과 동일
            프로그래밍 언어의 특성(변수, 반복문,조건문)
            대입연산자주의(SQL에 존재하지 않음 )
            JAVA = 
            PL/SQL :=
            
10번부서의 부서의 번호, 부서이름을 각 변수에 담아서 console에 출력
부서번호 : v_deptno, 부서이름 :v_deptnm
변수선언: java와 순서가다름
    java : 타입 변수명
    pl/sql :변수명 타입
    
    DESC dept;
console 출력
java: system.out.println(...);
pl/sql : DBMS_OUTPUT.PUT_LINE(...);

ORCLE :결과 출력을 위해 출력 기능을 활성화햐야함
매번 실행할 필요는 없고 ,오라클 접속후 한번만 실행하면됨
(내일 수업시 다시실행_
SET serveroutput ON;--얘
DECLARE
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
    
BEGIN
    SELECT deptno,dname INTO v_deptno,v_dname
    FROM dept
    WHERE deptno =10;
    
    DBMS_OUTPUT.PUT_LINE('v_deptno:'|| v_deptno|| ',v_dname :'|| v_dname);
    
END;
/
참조타입 : 변수 타입을 테이블의 컬럼 정보를 통해 선언
        변수명 테이블명 .컬럼명 % type;
        ==>특정테이블 컬럼의 타입을 참조하여 선언
            해당컬럼의 타입이 변경이 되더라도 pl/sql코드는 수정을 하지않아도 됨

DECLARE
    v_deptno dept.deptno%TYPE; /*v_deptno NUMBER(2);*/
    v_dname dept.dname%TYPE;
    
BEGIN
    SELECT deptno,dname INTO v_deptno,v_dname
    FROM dept
    WHERE deptno =10;
    
    DBMS_OUTPUT.PUT_LINE('v_deptno:'|| v_deptno|| ',v_dname :'|| v_dname);
    
END;
/

PL/SQL PROCEDURE:오라클 DBMS에 저장한 PL/SQL블럭
                함수와 다르게 리턴값이 없다
생성방법
CREATE OR REPLACE PROCEDURE 프로시저명 [(입력값...)]IS 
    선언부
BEGIN
END;
/

CREATE OR REPLACE PROCEDURE printdept IS 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno,dname INTO v_deptno,v_dname
    FROM dept
    WHERE deptno =10;
    DBMS_OUTPUT.PUT_LINE('v_deptno:'||v_deptno||',v_dname:'||v_dname);
END;
/

실행방법
EXEC 프로시저명;

EXEC printdept;
printdept 프로시져는  begin 절에 10번 부서의 정보를 조회하도록
hard coding 되어있음
프로시져가 인자를 받도록 수정
EXEC printdept(20);
EXEC printdept(30);

CREATE OR REPLACE PROCEDURE printdept(p_deptno IN dept.deptno%TYPE) IS 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno,dname INTO v_deptno,v_dname
    FROM dept
    WHERE deptno =p_deptno;
    DBMS_OUTPUT.PUT_LINE('v_deptno:'||v_deptno||',v_dname:'||v_dname);
END;
/

EXEC printemp(7369);

실습 pro_1
CREATE OR REPLACE PROCEDURE printemp(p_empno IN emp.empno%TYPE)IS
    v_ename emp.ename%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT ename,dname INTO v_ename,v_dname
    FROM emp, dept
    WHERE emp.deptno=dept.deptno
    AND empno=p_empno;
    DBMS_OUTPUT.PUT_LINE('v_ename:'||v_ename||',v_dname'||v_dname);
END;
/
EXEC printemp(7839)
실습 pro_2
CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept_test.deptno%TYPE,
                                            p_dname IN dept_test.dname%TYPE,
                                            p_loc IN dept_test.loc%TYPE)IS
BEGIN
INSERT INTO dept_test VALUES(p_deptno, p_dname, p_loc);

END;
/
EXEC registdept_test(99,'ddit','daejeon')

    

SELECT *
FROM dept_test

과제 pro3번

CREATE OR REPLACE PROCEDURE updatedept_test(p_deptno IN dept_test.deptno%TYPE,
                                            p_dname IN dept_test.dname%TYPE,
                                            p_loc IN dept_test.loc%TYPE)IS
BEGIN
UPDATE dept_test SET dname = p_dname, loc = p_loc
WHERE deptno=p_deptno;

END;
/

                                        