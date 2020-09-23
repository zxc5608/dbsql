
인덱스 생성 방법
1.자동생성
 UNIQUE ,PRIMARY KEY 생성시
 해당컬럼으로 이루어진 인덱스가 없을  경우 해당 제약조건 명으로 인덱스를 자동생성
 
 ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno)
 예)
 empno컬럼을 선두컬럼으로 하는 인덱스가 없을 경우 
 pk_emp 이름으로 UNIQUE 인덱스를 자동생성  --왜 유니크가 생성될까? 
                                     -- 속도때문

 UNIQUE: 컬럼의 중복된 값이 없음을 보장하는 제약조건
 PRIMARY KEY UNIQUE +NOT NULL
 
 DBMS입장에서는 신규 데이터가 입력되거나 기존데이터가 수정된 떄
 UNIQUE 제약에 문제가 없는지 확인==> 무결성을 지키기 위해
 
 빠른 속도로 중복데이터 검증을 위해 오라클에서는 UNIQUE PRIMARY KEY생성시 해당
 컬럼으로 인덱스를 생성을 강제한다.
 
 PRIMARY KEY: 제약조건 생성후 해당 인덱스 삭제 시도시 삭제가 불가 
 
 FOREIGN KEY: 입력한려는 데이터가 참조하는 테이블의 컬럼에 존재하는 데이터만 
              입력되도록 제한
              
emp 테이블에서 brown사원을 50번 부서에 입력을 하게 되면 50번 부서가 dept테이블의
deptno컬럼에 존재여부를 확인하여 존재할 시에만 emp테이블에 데이터를 입력

명명규칙
idx_테이블명_n_01


DDL실습 1

idx1)
CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1=1

CREATE UNIQUE INDEX idx_dept_test2_u_01 ON dept_test2(deptno);
CREATE INDEX idx_dept_test2_n_02 ON dept_test2(dname);
CREATE INDEX idx_dept_test2_n_03 ON dept_test2(deptno,dname);

idx2)
DROP INDEX idx_dept_test2_u_01
DROP INDEX idx_dept_test2_n_02 
DROP INDEX idx_dept_test2_n_03  --인덱스삭제


 ALTER TABLE dept DROP CONSTRAINT pk_emp  --테이블삭제
 
 idx3)
 조건1. empno(=)조건 (1
 조건2. ename(=)조건 (2
 조건3. deptno(=) , empno(LIKE: empno ||'%') (1
 empno,deptno 가되면 1번조건은 만들필요는 없다.
 조건4.deptno(=), sal(BEWTEEN)
 조건5.deptno(=),mgr 컬럼이 있을 경우 테이블 엑세스 불필요
        empno(=) (1
 조건6.deptno,hiredate 컬럼으로 구성된 인덱스가 있을경우 테이블 엑세스 불필요
 
  
1.        
CREATE UNIQUE INDEX idx_emp_u_01 ON emp(empno,deptno);
2.
CREATE INDEX idx_emp_02 ON emp(ename);
3
CREATE INDEX idx_emp_u_03 ON emp(deptno,mgr, sal, hiredate);

인덱스 사용에 있어서 중요한점
인덱스 구성컬럼이 모두 null이면 인덱스에 저장을 하지 않느다
즉 테이블 접근을 해봐야 해당 행에 대한 정보를 알수있다
가급적이면 컬럼에 값이 null이 들어오지 않는 경우는 not null 제약을
적극적으로 활용==> 오라클 입장에서 실행계획을 세우는데 도움이된다

실습4번 과제

조건1 empno(=)   (emp)
조건2. deptno(=)  (emp,dept)
조건3. deptno(=),empno ,LIKE :empno||'%'; (dept emp)
조건4 deptno (=),sal(bewteen) (emp)
조건5. deptno(=) (emp dept)
        loc(=)
 ==========================과제=====================       
DROP INDEX idx_dept_03;

CREATE UNIQUE INDEX idx_emp_u_01 ON emp(empno,deptno);
CREATE INDEX idx_emp_02 ON emp(deptno, sal );
CREATE INDEX idx_dept_03 ON dept(deptno,loc);

EXPLAIN PLAN FOR
SELECT *
FROM emp,dept
WHERE emp.deptno=dept.deptno
AND emp.deptno=:deptno
AND dept.loc=:loc;


SELECT *
FROM TABLE(dbms_xplan.display);

=====================================


===========================================
synonym: 동의어 
오라클 객체에 별칭을 생성한 객체
오라클 객체를 짧은 이름으로 지어줄 수 있다.

생성방법
CREATE [PUBLIC] SYNONYM 동의어_이름 FOR 오라클 객체;
PUBLIC :공용 동의어 생성시 사용하는 옵션
        시스템 관리자 권한이 있어야 사용


emp 테이블에 e라는 이름으로 synonym을 생성

CREATE SYNONYM e FOR emp;

SELECT *
FROM emp
||

SELECT *
FROM e;


dictionary 오라클의 객체 정보를 볼수있는view
dictionary의 종류는 dictionary view를 통해 조회가능
SELECT *
FROM dictionary;

dictionary 는 크게 4가지로 구분가능
USER_ :해당 사용자가 소유한 객체만조회
ALL_ 해당 사용자가 소유한 객체 +다른 사용자로부터 권한을 부여받은 객체
DBA_ 시스템 관리자만 볼수있으며 모든 사용자의 객체 조회
V$ : 시스템 성능과 관련된 특수VIEW

SELECT *
FROM user_table;

SELECT *
FROM all_table;

DBA 권한이 있는 계정에서만 조회가능(SYSTEM,sys)
SELECT *
FROM dba_table;



3장 sql응용---------------------------------------

multiple insert 조건에 따라 여러 테이블에 데이터를 입력하는 INSERT

기존에 배운 쿼리는 하나의 테이블에 여러건의 데이터를 입력하는 쿼리
INSERT INTO emp (empno ,ename)
SELECT empno,ename
FROM emp;

mutiple insert 구분
1. unconditional insert: 여러 테이블에 insert
2. conditional insert: 조건을 만족하는 모든테이블에 insert
3. conditional first insert :조건을 만족하는 첫번쨰 테이블에 insert

1. unconditional insert :조건과 관계없이 여러테이블에 insert
DROP TABLE emp_test;
DROP TABLE emp_test2;--삭제해주고

CREATE TABLE emp_test AS
SELECT empno,ename
FROM emp
WHERE 1=2;

CREATE TABLE emp_test2 AS
SELECT empno,ename
FROM emp
WHERE 1=2;
테이블구조만 복사해오려고  1=1 는 다가져옴  1=2 거짓이기때문

INSERT ALL INTO emp_test
            INTO emp_test2
SELECT 9999, 'brown'FROM dual UNION ALL
SELECT 9998, 'sally'FROM dual ;

SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;



uncondition insert 실행시 테이블마다 데이터를 입력할 컬럼을 조작하는 것이 가능
위에서:INSERT INTO emp_test VALUE s(...) 테이블의 모든 컬럼에 대해 입력
        INSERT INTO emp_test (empno) VALUE (9999) 특정 컬럼을 지정하여 입력가능
INSERT ALL   
    INTO emp_test (empno) VALUES(eno)
    INTO emp_test2(empno,ename) VALUES(eno,enm)
    
    SELECT 9999 eno, 'brown'enm FROM dual UNION ALL
    SELECT 9998, 'sally'FROM dual ;
    
    SELECT *
    FROM emp_test;
    
    
    SELECT *
    FROM emp_test2;
    
    
conditional insert : 조건에 따라 데이터를 입력
CASE
    WHEN job='manager' THEN sal*1.05;
    WHEN job='PRESIDENT' THEN sal*1.2;

END
ROLLBACK;


INSERT ALL 
    WHEN eno>=9500 THEN 
        INTO emp_test VALUES(eno,enm)
        INTO emp_test2 VALUES(eno,enm)
    WHEN eno >=9900 THEN
        INTO emp_test2 VALUES(eno,enm)
    
    
    SELECT 9500 eno, 'brown'enm FROM dual UNION ALL
    SELECT 9998, 'sally'FROM dual ;
    
    
    SELECT *
    FROM emp_test2;
    