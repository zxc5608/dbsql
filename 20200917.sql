SELECT sido, sigungu, ROUND(sal/people)p_sal
FROM tax
ORDER BY p_sal DESC;

도시발전지수 1 =세금1위
도시발전지수 2= 세금2위
도시발전지수 3= 세금3위



DML:Date Manipulate LANGUAGE
1.SELECT
2.INSERT: 테이블에 새로운 데이터를 입력하는 명령
3.UPDATE : 테이블에 존재하는 데이터의 컬럼을 변경하는명령
4.DELETE: 테이블에 존재하는 데이터(행)을 삭제하는명령

INSERT 3가지
1.
테이블의 특정 컬럼에만 데이터를 입력할 때 (입력되지 않은 컬럼은 nULL값을 설정된다.
INSERT INTO 테이블명(컬럼1 컬럼2... ) VALUES(컬럼1의 값 , 컬럼 2의 값2....);

DESC emp;

INSERT INTO emp(empno,ename) VALUES(9999,'brown');
SELECT*
FROM emp 
WHERE empno =9999;
↓empno  설정이 NOTNULL이기떄문에 empno컬럼에 null값이 들어 갈수없어서 에러가발생
INSERT INTO emp(ename) VALUES('sally');

2.테이블에 모든 컬럼에 모든 데이터를 입력할때
        **단 값을 나열하는 순서는 테이블의 정의된 컬럼의 순서대로 기술해야한다.
             테이블 컬럼순서 확인하는 방법: DESC 테이블명
 
INSERT INTO 테이블명 VALUES(컬럼1의 값 , 컬럼 2의 값2....);

DESC dept;

INSERT INTO dept VALUES(98,'대덕','대전');
SELECT *
FROM dept;
2개의 값도 넣으면? 오류발생
컬럼을 기술하지 않았기댸문에 테이블에 정의된 모든 컬럼에 대해 값을 기술해야하나
3개중 2개만 기술하여 에러발생
INSERT INTO dept VALUES(97,'ddit');


3. SELECT 결과를 (여러행일 수도 있다) 테이블에 입력
INSERT INTO 테이블명[(col,...)]
SELECT 구문;

INSERT INTO emp (empno, ename)
SELECT 9997,'cony'FROM dual
UNION ALL
SELECT 9996,'moon'FROM dual;

SELECT *
FROM emp;

날짜컬럼값 입력하기 

INSERT INTO emp VALUES (9996,'james','CLERK', NULL, SYSDATE,3000,NULL,NULL); 

'2020/09/01'
INSERT INTO emp VALUES(9996,'james','CLERK', NULL,TO_DATE('2020/09/01'.'YYYYMMDD'),3000,NULL,NULL);


UPDATE :테이블에 존재하는 데이터를 수정
        1.어떤 데이터를 수정할지 데이터 한정(WHERE)
        2.어떤 컬럼에 어떤 값을 넣을지 기술
        
UPDATE 테이블명 SET변경할 컬럼명= 수정할값 [, 변경할 컬럼명= 수정할 값....]
[WHERE]
99 ddit daejeon
dept 테이블의 deptno컬럼의 값이 99번인 데이터의
    dname컬럼을 대문자 DDIT로 , LOC컬럼을 한글'영민'으로 변경
SELECT *
FROM emp;
WHERE deptno=99

UPDATE dept SET dname='DDIT' , LOC ='영민' 
--얘는 다바뀐다 조심
UPDATE dept SET dname='DDIT' , LOC ='영민' 
얘는 ㅇWHERE이 붙어서 조금은 ㄱㅊ
WHERE deptno=99

ROLLBACK;

2. 서브쿼리를 활용한 데이터변경 (**추후 MERGE구문을 배우면 더 효율적으로 작성할수있다.)

테스트데이터 입력
INSERT INTO emp (empno,ename,job)VALUES (9000,;'brown',NULL);
9000번 사번의 DEPTNO ,JOB 컬럼의 값을 SMITH사원의 DEPTNOm,JOB컬럼으로 동일하게 변경

UPDATE emp SET deptno =값1. job=값2
WHERE empno =9000;

SELECT deptno,job
FROM emp
WHERE ename='SMITH'

UPDATE emp SET deptno =20, job='CLECK'
                        WHERE empno =9000;
                        
UPDATE emp SET deptno =(SELECT deptno
                        FROM emp
                        WHERE ename='SMITH')
                ,job=  (SELECT job
                        FROM emp
                        WHERE ename='SMITH')
WHERE empno=9000;

SELECT *
FROM emp
WHERE ename IN('brown','SMITH')


3.DELETE :테이블에 존재하는 데이터를 삭제 (행 전체를 삭제)
***** emp 테이블에서 9000번 사번의 deptno컬럼을 지우고 싶을 때 (null)??
  ==> deptno컬럼을 null로 업데이트한다.
  
  DELETE [FROM] 테이블명  
 [WHERE...]
 
 emp테이블에서9000번의 사번의 데이터를 완전히 삭제
 DELETE emp
 WHERE empno =9000;
 
 UPDATE , DELETE절을 실행하기 전에
 WHERE절에 기술한 조건으로 SELECT를 먼저 실행하여, 변경, 삭제 되는 행을 눈으로 확인해보자
 
 DELETE emp
 WHERE empno = 7369;

SELECT *
FROM emp
 WHERE empno = 7369;
 
 DML 구문 실행시
 DBMS는 복구를 위해 로그를 남긴다
 즉 데이터 변경 작업 +alpah의 작업량이 필요
 
 하지만 개발환경에서는 데이터를 복구할 필요가 없기때 문에
 삭제 속도를 빠르게 하는것이 개발 효율성에서 좋음;
 
 로그없이 테이블의 모든 데이터를 삭제하는 방법: TRUNCATE TABLE 테이블명;
 
 DELETE emp;
 TRUNCATE TABLE emp;
 복구불가
 
