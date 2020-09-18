DML : Date Manipulate Language
DDL : Date Defination Language
      데이터와 관련된 객체를 생성, 수정, 삭제하는 명령

오라클 객체 생성, 삭제 명령
CREATE 객체타입 객체이름-개발자가 부여{}....
DROP 객체타입 객체이름;

****알아는 두자(못외워도 찾아서 사용할 수 있으면 됨)
    모델링 툴을 사용하여 설계를 하게되면 툴에서 설계된 테이블을 생성하는 구문을 자동으로 만들어준다.

테이블을 생성하는 문법
CREATE TABLE [오라클사용자].테이블명 (
    컬럼명 컬럼의 데이터타입,
    컬럼명2 컬럼의 데이터타입2.....
);

테이블 생성
테이블명 - ranger
컬럼은 ranger_no NUMBER
      ranger_nm VARCHAR2(50)
      reg_dt DATE

CREATE TABLE RANGER ( RANGER_NO NUMBER, RANGER_NM VARCHAR2(50), REG_DT DATE);

테이블에 신규데이터 입력
INSERT INTO RANGER VALUES (55, 'BROWN', SYSDATE);

SELECT *
FROM ranger;

테이블 삭제
DROP TABLE ranger;

주로 사용하는 데이터 타입
1. 숫자 : NUMBER(p, s) p : 전체자리수, s : 소수점 자리수 라고 생각하면 편함
          NUMBER ==> 숫자가 표현할 수 있는 최대 범위로 표현
2. 문자 : VARCHAR2(사이즈=byte), CHAR(사실상 안씀)
          VARCHAR2의 쵀대 사이즈 4000byte
          VARCHAR2(2000) : 최대 2000BYTE를 담을 수 있는 문자 타입
          java - 2byte , oracle xw 11g - 3byte
          
          CHAR(1~2000byte), 고정길이 문자열
          만약 CHAR(5) 'test' 면 test는 4byte고 char(5) 5byte이기 때문에 남은 데이터 공간에 공백 문자를 삽입함
3. 날짜 : DATE - 7byte로 고정
                일자, 시간(시,분,초) 정보 저장
        varchar2 날짜관리 :
                시스템에서 문자 형식으로 많이 사용한다면 문자 타입으로 사용도 고려
                
4. Large OBJECT
    4.1 CLOB : 문자열을 저장할 수 있는 타입, 사이즈 : 4GB
    4.2 BLOB : 바이너리 데이터, 사이즈 : 4GB
     
제약조건 : 데이터에 이상한 값이 들어가지 않도록 강제하는 설정
          EX) emp테이블에 empno컬럼에 값이 없는 상태로 들어가는 것을 방지
              emp테이블에 deptno컬럼의 값이 dept 테이블에 존재하지 않는 데이터를 입력하는 것을 방지
              emp테이블에 empno컬럼의 값이 중복되지 않도록 방지
제약조건은 4가지가 존재, 그 중에 한가지의 일부를 별도의 키워드로 제공
ORACLE에서 만들 수 있는 제약조건이 5가지

1. NOT NULL : 컬럼에 반드시 값이 들어가게 하는 제약조건
2. UNIQUE : 해당 컬럼에 중복된 값이 들어오는 것을 방지하는 제약조건
3. PRIMARY KEY : UNIQUE + NOT NULL
4. FOREIGN KEY : 해당 컬럼이 참조하는 다른 테이블의 컬럼에 값이 존재해야하는 제약조건
                 emp.deptno ==> dept.deptno
5. CHECK : 컬럼에 들어갈 수 있는 값을 제한하는 제약조건
           ex) 성별이라는 컬럼있다고 가정
               들어갈 수 있는 값 : 남 M, 여 F, ==> T ??
               
제약조건을 생성하는 방법 3가지
1. 테이블을 생성하면서 컬럼 레벨에 제약조건을 생성
        ==> 제약조건을 결함 컬럼(여러개의 컬럼을 합쳐서)에는 적용 불가
2. 테이블을 생성하면서 테이블 레벨에 저약조건을 생성
3. 이미 생성된 테이블에 제약조건을 추가하여 생성

1.테이블 생성시 컬럼 레벨로 제약조건 생성
CREATE TABLE 테이블명 (
    컬럼1이름 컬럼1타입 [컬럼제약조건]
);

DESC dept;
dept_test 테이블을 생성
컬럼 : dept 테이블과 동일하게
제약조건 : deptno 컬럼을 PRIMARY KEY 제약조건으로 생성

CREATE TABLE dept_test (deptno NUMBER(2) PRIMARY KEY, dname VARCHAR2(14), loc VARCHAR2(13));

INSERT INTO dept_test VALUES (NULL, 'ddit', 'daejeon'); --PRIMARY KEY의 NOT NULL땜에 에러남
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon'); --90번 부서는 중복되므로 PRIMARY KEY 규칙에 어긋나서 에러

비교
dept 테이블에는 deptno컬럼에 PRIMARY KEY 제약이 없는 상태, 그렇기 때문에 deptno 컬럼의 값이 중복이 가능
INSERT INTO dept VALUES (90, 'ddit', 'daejeon');
INSERT INTO dept VALUES (90, 'ddit', 'daejeon');

제약조건 생성시 이름을 부여
키 명명 규칙 : PK_테이블명
CREATE TABLE dept_test (deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY, dname VARCHAR2(14), loc VARCHAR2(13));
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');


2.테이블 생성시 테이블 레벨로 제약조건 생성
CREATE TABLE 테이블명 (
    컬럼1 컬럼1의 데이터타입,
    컬럼2 컬럼2의 데이터타입,
    (TABLE LEVEL 제약조건)
);
CREATE TABLE dept_test (deptno NUMBER(2), dname VARCHAR2(14), loc VARCHAR2(13),
                        CONSTRAINT PK_dept_test PRIMARY KEY (deptno, dname)
);
deptno 컬럼의 값은 90으로 같지만 dname 컬럼의 값이 다르므로 PRIMARY KEY (deptno, dname) 설정에 따라 데이터가 입력될 수 있다.

복합 컬럼에 대한 제약조건은 컬럼 레벨에서는 설정이 불가하고 
테이블 레벨, 혹은 테이블 생성후 제약조건을 추가하는 형태에서만 가능

INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (90, 'ddit2', 'daejeon');
INSERT INTO dept_test VALUES (90, 'ddit2', 'daejeon'); -- 오류

NOT NULL 제약조건 생성
DROP TABLE dept_test;

CREATE TABLE dept_test (deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY, 
dname VARCHAR2(14) NOT NULL, loc VARCHAR2(13));

INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (91, NULL, '대전'); --오류 NULL값도 중복이 안댐

UNIQUE 제약조건 : 값의 중복이 없도록 방지하는 제약조건, 단 NULL은 허용
CREATE TABLE dept_test (deptno NUMBER(2), 
dname VARCHAR2(14), loc VARCHAR2(13), CONSTRAINT U_dept_test_dname UNIQUE (dname)); 

INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (90, NULL, 'daejeon');
INSERT INTO dept_test VALUES (90, NULL, 'daejeon'); --NULL값은 중복이 됨
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon'); --오류

FOREIGN KEY 제약조건 : 참조하는 테이블에 데이터만 입력가능하도록 제어
다른 제약조건과 다르게 두개의 테이블 간의 제약조건 설정
1. dept_test (부모) 테이블 생성
2. emp_test (자식) 테이블 생성
    2.1 참조 제약 조건을 같이 생성

1번 작업
DROP TABLE dept_test;

CREATE TABLE dept_test (deptno NUMBER(2) PRIMARY KEY, 
dname VARCHAR2(14), loc VARCHAR2(13));

INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');

2번 작업 emp_test (empno, ename, deptno)
CREATE TABLE emp_test ( empno NUMBER(4),
ename VARCHAR2(10), deptno NUMBER(2) REFERENCES dept_test (deptno));
참조 무결성 제약조건에 의해 emp_test 테이블의 deptno 컬럼의 값은 dept_test 테이블의
deptno 컬럼에 존재하는 값만 입력이 가능하다.

현재는 dept_test 테이블에는 90번 부서만 존재, 그렇기 때문에
emp_test 에는 90번 이외의 값이 들어갈 수가 없다.
INSERT INTO emp_test VALUES (9000, 'brown', 90);
INSERT INTO emp_test VALUES (9001, 'sally', 10); --오류

테이블 레벨 참조 무결성 제약조건 생성
DROP TABLE dept_test;
DROP TABLE emp_test;
명명규칙 : FK_소스테이블_참조테이블
CREATE TABLE emp_test ( empno NUMBER(4),
ename VARCHAR2(10), 
deptno NUMBER(2), CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
REFERENCES dept_test (deptno));

INSERT INTO emp_test VALUES (9000, 'brown', 90);
INSERT INTO emp_test VALUES (9001, 'sally', 10);

dept_test : 90번 부서가 존재
emp_test : 90번 부서를 참조하는 9000번 brown이 존재

만약 dept_test테이블에서 90번 부서를 삭제하게 된다면 ??
DELETE dept_test
WHERE deptno = 90;

참조 무결성 조건 옵션
1. default : 자식이 있는 부모 데이터를 삭제할 수 없다
2. 참조 무결성 생성시 OPTION - ON DELETE SET NULL
            삭제시 참조하고 있는 자식테이블의 컬럼을 NULL로 만든다.
3. 참조 무결성 생성시 OPTION - ON DELETE CASCADE
            삭제시 참조하고 있는 자식테이블의 데이터도 같이 삭제

2.
DROP TABLE emp_test;

CREATE TABLE emp_test ( empno NUMBER(4),
ename VARCHAR2(10), 
deptno NUMBER(2), 
CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
REFERENCES dept_test (deptno) ON DELETE SET NULL);

INSERT INTO emp_test VALUES (9000, 'brown', 90);

DELETE dept_test
WHERE deptno = 90;

90번 부서에 속한 9000번 사원의 deptno 컬럼의 값이 NULL로 지정

3.
DROP TABLE emp_test;

CREATE TABLE emp_test ( empno NUMBER(4),
ename VARCHAR2(10), 
deptno NUMBER(2), 
CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
REFERENCES dept_test (deptno) ON DELETE CASCADE);

INSERT INTO emp_test VALUES (9000, 'brown', 90);

DELETE dept_test
WHERE deptno = 90;
90번 부서에 속한 9000번 사원의 deptno 컬럼의 값이 같이 없어짐

입력시 : 부모(dept) => 자식(emp)
삭제시 : 자식 => 부모

SELECT *
FROM emp_test;
(젤안쓰는 조건)체크 제약 조건 : 컬럼의 값을 확인하여 입력을 허용

DROP TABLE emp_test;
CREATE TABLE emp_test (
empno NUMBER(4),
ename VARCHAR2(14),
sal NUMBER(7),
gender VARCHAR2(1), 
CONSTRAINT c_sal CHECK (sal > 0),
CONSTRAINT c_gender CHECK (gender IN ('M','F')));

INSERT INTO emp_test VALUES (9000, 'brown', -5, 'M'); sal 체크
INSERT INTO emp_test VALUES (9000, 'brown', 100, 'T'); 성별 체크
INSERT INTO emp_test VALUES (9000, 'brown', 100, 'M'); 체크 통과
-----------------------------------------------------------------
CREATE TABLE emp_test (empno NUMBER(4),
ename VARCHAR2(14) );

INSERT INTO emp_test VALUES (9000, 'brown');

CREATE TABLE dept_test (deptno NUMBER(2), 
dname VARCHAR2(14));
여기서 부터는 새로운 트랜잭션