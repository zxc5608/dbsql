테이블생성하는 스크립트
외래키 작업문제 
시험문제
3. emp_test 테이블의 deptno 컬럼이 dept_test 컬럼의 deptno컬럼을
    참조하는 FOREIGN KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_dept_test
    FOREIGN KEY(deptno) REFERENCES dept_test(deptno);
    
    PRIMARY KEY: PK_테이블명
    FOREIGN KEY : FK_소스테이블명_참조테이블명
    제약조건 삭제
    ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명
    
1. 부서 테이블에 PRIMARY KEY 제약조건추가
2. 부서테이블에 PRIMARY KEY 제약조건추가
3. 사원테이블 부서테이블간 FOREIGN KEY 제약조건추가

제약조건 삭제시는 데이터 입력과 반대로 자식부터 먼저삭제
3-(1,2)
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명


ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test;
ALTER TABLE dept_test DROP CONSTRAINT PK_dept_test;
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;

SELECT *
FROM user_constraints
WHERE table_name IN('EMP_TEST','DEPT_TEST');

SELECT *
FROM emp_test

drop table emp_test
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);
제약조건생성
1. dept_test 테이블의 deptno 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE dept_test ADD CONSTRAINT PK_dept_test PRIMARY KEY(deptno);

2. emp_test 테이블의 empno 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY(empno);

3. emp_test 테이블의 deptno 컬럼이 dept_test 컬럼의 deptno컬럼을
    참조하는 FOREIGN KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno)
REFERENCES dept_test(deptno);

제약조건 활성화 -비활성화 테스트
테스트 데이터준비 : 부모-자식 관계가 있는 테이블에서는 부모 테이블에 데이터를 먼저입력
dept_test ==> emp_test
INSERT INTO dept_test VALUES (10,'ddit','daejeon');
dept_test 와 emp_test 테이블간 FK가 설정되어 잇지만 10번 부서는 dept_test에 존재하기떄문에 정상입력
INSERT INTO emp_test VALUES (9999,'brown',10);
20번 부서는dept_test 테이블에 존재하지 않는데이터이기떄문에
FK에의해 입력불가
INSERT INTO emp_test VALUES (9999,'sally',20);

FK를 비활성화 한후 다시 입력

SELECT *
FROM user_constraints
WHERE table_name IN('EMP_TEST','DEPT_TEST');

--비활성화 명령어
ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test_dept_test;
INSERT INTO emp_test VALUES (9999,'sally',20);
COMMIT;

dept_test :10
emp_test:9999(99)brown 10,9998(98)sally 20 ==>10, NULL, 삭제
FK제약조건 재 활성화
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test_dept_test;


테이블 , 컬럼 주석 (comments)생성가능
테이블 주석 정보확인
user_tables, user_constrints, user_tab_comments

SELECT *
FROM user_tab_comments;

테이블 주석 작성방법
COMMENT ON TABLE 테이블명 IS '주석';

EMP 테이블에 주석(사원) 생성하기
COMMENT ON TABLE emp IS '사원';

컬럼 주석 확인
SELECT *
FROM user_col_comments
WHERE TABLE_NAME='EMP';

컬럼 주석 다는 문법
COMMENT ON COLUMN 테이블명 .컬럼명 IS 주석       
COMMENT ON COLUMN emp.EMPNO IS'사번';
COMMENT ON COLUMN emp.ENAME IS'사원이름';
COMMENT ON COLUMN emp.JOB   IS '담당역할';
COMMENT ON COLUMN emp.MGR   IS '매니저사번';
COMMENT ON COLUMN emp.HIREDATE IS'입사일자';
COMMENT ON COLUMN emp.SAL   IS '급여';
COMMENT ON COLUMN emp.COMM  IS'성과급';
COMMENT ON COLUMN emp.DEPTNO IS'소속부서번호';


SELECT t.*,c.column_name, c.comments
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name= c.table_name
  AND c.table_name IN('CUSTOMER','PRODUCT','CYCLE','DAILY');


SELECT *
FROM user_constraints
WHERE table_name IN('EMP','DEPT');

ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY(empno);
ALTER TABLE emp ADD CONSTRAINT PK_dept PRIMARY KEY(deptno);
ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY(deptno) REFERENCES dept(deptno);
ALTER TABLE emp ADD CONSTRAINT FK_emp_emp FOREIGN KEY(empno) REFERENCES emp(empno);

view:VIEW는 쿼리이다
물리적인 데이터를 갖고있지 않고 ,논리적인 데이터 정의 집합이다(SELECT쿼리)
vIEW 가 사용하고있는 테이블의 데이터가 바뀌면  VIEW 조회 결과도 같이 바뀐다.

문법
CREATE OR REPLACE VIEW 뷰이름 AS
SELECT 쿼리;

emp테이블에서 sal ,comm 컬럼 2개를 제외한 나머지6개컬럼으로 v_emp 이름으로view 생성
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate ,deptno
FROM emp;

GRANT CONNECT, RESOURCE TO 계정명;
VIEW 에 대한 생성권한은 RESOURCE에 포함되지 않는다


SELECT *
FROM v_emp;
 emp 테이블에서 10번 부서에 속하는 3명을 지웠기 때문에 아래 
 view 의 조회 결과도 3명이 지워진 11명만 나온다.

DELETE emp
WHERE deptno='10';

SELECT *
FROM
(SELECT empno, ename, job, mgr, hiredate ,deptno
 FROM emp);
 

yongyong계정에있는 v_EMP 뷰를 HR계정에게 조회할수 있도록 권한부여
GRANT SELECT ON v_emp TO hr;