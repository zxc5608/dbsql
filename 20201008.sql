
Exception (예외) :pl/sql블럭이 실행되는 동안 발생하는 에러
                 예외가 발생 했을때 pl/sql의 Exception절을 기술하여
                 다른 로직을 실행하여 예외문제를 해결할수있다.
                 
예외종류 
1.사전정의예외(Oracle Predefined Exception)
    오라클에서 미리정의한 예외로  ORA-XXXXX로 정의
    에러코드만 있고 에러이름이 없는 경우가 대다수
2.사용자정의 예외 (User Defined Exception)

예외발생시 해당sql문은 중단
    .EXCEPTION 절이 있으면 :예외 처리부에 기술된 문장을 실행
    .EXCEPTION 절이 없으면 pl/sql블록 종료
    
예외처리방법
DECLARE
BRGIN
EXCEPTION   
    WHEN 예외명 [OR 예외명2] THEN
        실행할 문장
    WHEN 예외명3 [OR예외명 4]THEN
    WHEN OTHER THEN
        실행할 문장(여기서 SQLCODE, SQLERRM 속성을 통해예외 코드를 확인할수있다)
END;
/

하나의 행이 조회 되어야 하는 상황에서 여러개의 행이 반환된 경우(예외처리가 없을때)

SET serveroutput ON;

DECLARE
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
END;
/

사용자 예외 정의 사용
1.PL/SQL 블럭안에서 또다른 PL/SQL블럭을 정의 하는 것이 가능

NO_EMP: 사번을 통해서 사원을 검색하는데 해당 사번을 갖는 사원이 없을 때
    SELECT *
    FROM emp
    WHERE empno=-1;
    ==>NO_DATA_FOUND ==> NO_EMP
    

DECLARE
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno=-1;
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RAISE NO_EMP;
    END;
EXCEPTION 
    WHEN NO_EMP THEN
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
    
END;
/


FUNCTION :반환값이 존재하는 PL/SQL블럭

사번을 입력받아서,해당 사원의 이름을 반환하는 FUNCTION

CREATE OR REPLACE FUNCTION getEmpName (p_empno emp.empno%TYPE) RETURN VARCHAR2 IS
    v_ename emp.ename%TYPE;
    
BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno= p_empno;
    
    RETURN v_ename;
END;
/

SELECT getEmpName(7369)
FROM dual;

SELECT getEmpName(empno),ename
FROM emp;

CREATE OR REPLACE FUNCTION getdeptname (p_deptno dept.deptno%TYPE)RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
/

SELECT empno,ename, deptno ,getdeptname(deptno)
FROM emp


사원이속한 부서이름을 가져오는 방법(다른 테이블의 컬럼으 확장하는 방법)
1.join
SELECT empno,ename, emp.deptno,dept.dname
FROM emp ,dept
WHERE emp.deptno= dept.deptno;


2. 스칼라서브쿼리
SELECT empno, ename ,deptno ,
    (SELECT dname FROM dept WHERE deptno=emp.deptno)dname
FROM emp;

3. FUNCTION
SELECT empno,ename, deptno
    getdeptname(deptno)dname
FROM emp;

분포도: 흩어진 정도
데이터 분포도: 특정데이터가 발생하는 빈도
예:  emp 테이블에 empno: 값이 - 14개존재 -데이터 분포도가 좋다. 
     emp 테이블에deptno: 값이-3개존재  - 데이터 분포도가 나쁘다.
     
함수의 경우 오라클에서 기본적으로 캐쉬 기능을 사용
기본 캐쉬 사이즈가 20개
getDeptName (10) -> ACCOUNTING 

오라클은 10번인자로 getDeptName 실행 했을 떄 ACCOUNTING이라는 결과값을 기억(캐싱)
이후에 동일한 인자로 함수를 실행하면 함수를 실행하지 않고 캐싱된 값을 반환


FUNCTION 2
SELECT LPAD(' ',(LEVEL-1)*4,' ')||deptnm,
    indent(LEVEL)||deptnm
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd=p_deptcd;

CREATE OR REPLACE FUNCTION indent(p_level NUMBER)RETURN VARCHAR2 IS
    v_ret VARCHAR(200);
BEGIN
   /* SELECT LPAD(' ', (LEVEL-1)*4,' ')INTO v_ret
    FROM dual;*/
    v_ret :=LPAD(' ',(p_level-1)*4,' ');
    RETURN v_ret;
END;
/

패키지 :관련된PL/SQL 블럭을 묶어 놓은 객체 
java의 패키지유사
==> 유사한 타입들의 모임

DBMS_XPLAN.
DBMS_OUTPUT.;
 패키지 생성 방법 :java의 interface,class 사용 방법과 유사
 Interface 객체명 = new class();
 List<String> names= new ArrayList<String>();
 
 PL/SQL 패키지생성 방법
 1. 선언부 
 2. BODY
 
 CREATE OR REPLACE PACKAGE names AS
    FUNCTION getEmpName (p_empno emp.empno%TYPE)RETURN VARCHAR2;
    FUNCTION getDeptName (p_deptno dept.deptno%TYPE)RETURN VARCHAR2;
     
end names;
/

body부 생성------------------------
CREATE OR REPLACE PACKAGE BODY names IS
 FUNCTION getEmpName (p_empno emp.empno%TYPE) RETURN VARCHAR2 IS
    v_ename emp.ename%TYPE;
    
BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno= p_empno;
    
    RETURN v_ename;
END;


FUNCTION getdeptname (p_deptno dept.deptno%TYPE)RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
end;
/
-----------
SELECT NAMES.GETEMPNAME(empno),NAMES.GETDEPTNAME(deptno)
FROM emp;

----------------------------------------
triger (방아쇠):설정한 이벤트에 따라 실행한 로직을 담은 객체
    웹: 로그인 버튼 클릭
        ==>사용자  아이디 input 값과 비밀번호 input값을
             파라미터로 서버로 전송
    db:테이블의 데이터가 추가되거나 변경되었을 때 pl/sql블럭을
        실행
    
    users 테이블에 사용자 비밀번호가 변경되었을때
    users_history테이블에 기존에 사용하던 비밀번호를 이력으로 생성
    
SELECT *
FROM users;

CREATE TABLE users_history AS
SELECT userid,pass,sysdate mod_dt
FROM users
WHERE 1=2;
--비어있는테이블을 만들어준다

SELECT *
FROM users_history

users테이블의 pass컬럼이 변경되었을때 실행할 트리거 생성

CREATE OR REPLACE TRIGGER trg_users_pass
    --변경되기전
    BEFORE UPDATE ON users
    FOR EACH ROW
BEGIN 
    --기존비밀번호와 사용자가 테이블 업데이트가 일어났을때
    --기존(:OLD.pass) 비밀번호와 업데이트 하려고하는 비밀번호(:NEW.PASS)가 다를때
    IF :OLD.pass !=:NEW.pass THEN
        INSERT INTO USERS_HISTORY VALUES(:OLD.userid,:OLD.pass, SYSDATE);
    END IF;
END;
/
users_history에는 데이터가 없는상황

SELECT *
FROM users_history;

SELECT *
FROM users;

UPDATE users SET pass ='brownPass'
WHERE userid = 'brown';

trg_users_pass트리거에 의해 테이블에 비밀번호 이력이 생긴걸 볼수가 있다.

트리거가 실행되지 않을 조건으로 update
UPDATE users SET alias ='곰탱이'
WHERE userid = 'brown';
안되는 이유 패스워드컬럼을 업데이트 하지 않았기 때문에

트리거 
    장점(시스템을 신규로 만드는 사람) 
         users테이블에 비밀번호를 바꾸는 로직은 작성 해야한다
        users_history에 이력을 남기는 로직(java)은 작성하지 않아도됨
    단점(시스템을 유지보수 하는 사람)
        :users_hitory테이블에 데이터를 넣는 로직이 없는데 생성됨    
        
pt modeling 12p 까지
    