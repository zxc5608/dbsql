

view를 사용하는사례
1.데이터노출을 방지 

    (emp 테이블의sal,comm 을 제외하고 view를 생성 
    hr계정에게 view를 조회할수 있는 권한을 부여
    hr계정에서는emp테이블을 직접 조회하지 못하지만 v_emp는 가능
    ==> v_emp 에는 sal,comm 컬럼이 없기 때문에 급여관련 정보를 감출수있다.)
    
2. 자주 사용되는 쿼리를 view 만들어서 재사용
    ex:emp테이블은 dept테이블이랑 조인되서 사용되는 경우가많음
    view를 만들지 않을경우 매번 조인 쿼리를 작성해야하나, view로만 들면 재사용이가능
    
emp 테이블과 dept 테이블을 dpetno가 같은 조건으로 조인한 결과를 v_emp_dept이름으로 
view생성


 쿼리가 간단해진다.

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.*, dept.dname, dept.loc
FROM emp, dept                     --뷰생성
WHERE emp.deptno= dept.deptno;

SELECT *                    --확인
FROM v_emp_dept;

view 삭제

DROP VIEW 뷰이름;
DROP VIEW v_emp_dept;            --삭제


CREATE VIEW v_emp_cnt AS
SELECT deptno, COUNT(*)cnt   --그룹바이 
FROM emp
GROUP BY deptno;


SELECT *                    --확인
FROM v_emp_cnt;

SELECT *
FROM v_emp_cnt
WHERE deptno =10;


ROLLBACK;

squence :중복되지 않는 정수값을 만들어내는 오라클 객체
    java: UUID클래스를 통해 중복되지 않는 문자열을 생성할수있다.

문법 : CREATE SEQUENCE 시퀀스이름;
SEQ_ 사용할 테이블 이름;
CREATE SEQUENCE SEQ_emp;

사용방법: 함수를 생각하자
함수테스트 :dual
 시퀀스 객체명.nextval :시퀀스 객체에서 마지막으로 사용한 다음값을 반환
 시퀀스 객체명.currval: nestval 함수를 실행하고나서 사용할수 있다.
                     nextval 함수를 통해 얻어진 값을 반환
                     
SELECT seq_emp.nextval
FROM dual;

SELECT seq_emp.currval  --넥스트밸류에서 마지막으로 사용했던값
FROM dual;

사용 예
INSERT INTO emp(empno,ename,hiredate)
            VALUES(seq_emp.nextval,'brown',sysdate);
            
SELECT *    
FROM emp;


의미가 있는 값에 대해서는 시퀀스만 갖고는 만들 수 없다
시퀀스를 통해서는 중복되지 않는 값을 생성 할수 있다.

시퀀스는 롤백을 하더라도 읽은값이 복원되지 않는다.



INDEX : TABLE의 일부 컬럼을 기준으로 미리 정렬해둔 객체
ROWID : 테이블에 저장된행의 위치를 나타내는 값

SELECT ROWID ,empno ,ename
FROM emp;      --여기서 ROWID조회

만약 ROWID를 알수만 있으면 해당 테이블의 모든 데이터를 뒤지지 않아도
해당 행에 바로 접근을 할수가 있다.
 SELECT *
 FROM emp
 WHERE ROWID='AAAE5kAAFAAAACLAAA';
 
 SELECT *
 FROM TABLE(dbms_xplan.display);
 
 
 BLOCK: 오라클의 기본 입출력 단위
 block의 크기는 데이터 베이스 생성시 결정 기본값 8k byte
 DESC emp;
 emp테이블 한행은 최대 54byte
 block하나에는 emp테이블을 8000/54=160행이 들어갈수있음
 
 사용자가 한행을 읽어도 해당행이 담겨져있는 block을 전체로 읽는다.
 
 
 SELECT *
 FROM user_constraints
 WHERE table_name='EMP';
 
 EMP테이블의 EMPNO컬럼에 PRIMARY KEY 추가
 ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY(empno);

PRIMARY KEY(UNIQUE +NOT NULL ), UNIQUE 제약을 생성하면 해당 컬럼으로 인덱스를 생성한다.
==>인덱스가 있으면 값을 빠르게 찾을수있다
    해당 컬럼에 중복된 값을 빠르게 찾기위한 제한사항
ALTER TABLE emp ADD CONSTRAINT PK_dept PRIMARY KEY(deptno);
ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY(deptno) REFERENCES dept(deptno);
ALTER TABLE emp ADD CONSTRAINT FK_emp_emp FOREIGN KEY(mgr) REFERENCES emp(empno);
 
 -----------------------------------------------------------------------------------------
 0.시나리오
 테이블만 있는 경우(제약조건 ,인덱스가 없는경우)
 SELECT *
 FROM emp
 WHERE empno=7782;
 ==> 테이블에는 순서가 없기떄문에 emp테이블의 14건의 데이터를 모두뒤져보고
 empno값이 7782 인 한건에 대해서만 사용자에게 반환은한다.
 Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
 시나리오1
 emp테이블의 empno컬럼에 PK_EMP유니크 인덱스가 생성된경우
 (우리는 인덱스를 직접 생성하지 않았고 PRIMARY KEY제약조건에 의해 자동적으로생성됨)
 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno =7782;
 
 SELECT*
 FROM TABLE (dbms_xplan.display);
  
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
시나리오2
emp테이블의 empno컬럼에 PRIMARY KEY 제약조건이 걸려있는 경우

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE (dbms_xplan.display);

UNIQUE 인덱스: 인덱스 구성의 컬럼의 중복값을 허용하지 않는 인덱스(emp.empno)
NON UNIQUE 인덱스 : 인덱스 구성컬럼의 중복 값을 허용하는 인덱스(emp.deptno.emp.job)
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
시나리오3
emp테이블의 empno컬럼에 non-unique 인덱스가 있는경우
ALTER TABLE emp DROP CONSTRAINT FK_emp_emp; --외래키를 없애줌
ALTER TABLE emp DROP CONSTRAINT PK_emp;     -- 프라이머리키를 없애줌

IDX_테이블명_U_01 --테이블명 짓는 규칙
IDX_테이블명_N_02

CREATE INDEX IDX_emp_N_01 ON emp(empno);   --idx_emp_N_01이라는 인덱스생성

EXPLAIN PLAN FOR
SELECT*
FROM emp
WHERE empno= 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_01 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 Predicate Information (identified by operation id):
---------------------------------------------------
2 - access("EMPNO"=7782)
시나리오4
emp테이블의 job컬럼으로 non-unique인덱스를 생성한 경우
CREATE INDEX idx_emp_n_02 ON emp (job);

emp테이블에는 현재 인덱스가 2개존재
idx_emp_n_01: empno
idx_emp_n_02: job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job= 'MANAGER';

SELECT*
FROM TABLE(dbms_xplan.display);

Plan hash value: 431958961
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     3 |   114 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     3 |   114 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 ---------------------------------------------------
 
   2 - access("JOB"='MANAGER')


시나리오5
emp테이블에는 현재 인덱스가 2개존재
idx_emp_n_01: empno
idx_emp_n_02: job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'-- 매니저까지3건
AND ename LIKE 'C%'; --인덱스와 테이블에 접근하는것은 동일하지만 LIKE로 인해 달라짐

SELECT*
FROM TABLE(dbms_xplan.display);
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')

시나리오 6
CREATE INDEX idx_emp_n_03 ON emp(job,ename);
emp테이블에는 현재 인덱스가 3개존재
idx_emp_n_01: empno
idx_emp_n_02: job
idx_emp_n_03: job,ename  --복합인덱스를만든다.

SELECT job,ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR --실행계획
SELECT*
FROM emp 
WHERE job ='MANAGER'
AND ename LIKE 'C%'; 

SELECT*
FROM TABLE(dbms_xplan.display);

Plan hash value: 2102545684
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_03 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')


시나리오 7
DROP INDEX idx_emp_n_03;            --인덱스3 삭제                          --ename job순서가다름 위에거랑
CREATE INDEX idx_emp_n_04 ON emp(ename,job);  --인덱스4 생성
emp테이블에는 현재 인덱스가 3개존재
idx_emp_n_01: empno
idx_emp_n_02: job
idx_emp_n_04: ename, job


SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE'C%';

SELECT*
FROM TABLE(dbms_xplan.display);
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_04 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       
       
       
시나리오 8
emp 테이블에 empno컬럼에 UNIQUE 인 인덱스생성
dept 테이블에 deptno컬럼에 UNIQUE인덱스생성

DROP INDEX idx_emp_n_01;                              --2

ALTER TABLE emp DROP CONSTRAINT pk_emp;                --프라이머리키 제약조건삭제1
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
commit;
DELETE dept           --90이상인 행을 삭제
WHERE deptno>=90;

emp테이블에는 현재 인덱스가 3개존재
pk_emp: empno
idx_emp_n_02: job
idx_emp_n_03: empno, job

dept 테이블에는 현재위치 인덱스가 1개존재
pk_dept:deptno
4       2   8
emp==>dept
2       4   8
dept=>emp

EXPLAIN PLAN FOR
SELECT ename, dname,loc
FROM emp,dept
WHERE emp.deptno= dept.deptno
AND emp.empno=7788;

SELECT*
FROM TABLE(dbms_xplan.display);
----------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |     1 |    31 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |         |     1 |    31 |     2   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMP     |     1 |    13 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_EMP  |     1 |       |     0   (0)| 00:00:01 |
|   4 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     9 |   162 |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN         | PK_DEPT |     1 |       |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
3-2-5-4-1-0 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   

