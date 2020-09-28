
START WITH :계층쿼리의 시작 점(행) 여러개의행을 조회하는 조건이 들어갈 수도있다
            START WITH절에 의해 선택된 행이 여러개이면 순차적으로 진행한다
            
CONNECT BY : 행과 행을 연결할 조건을 기술

PRIOR :현재읽은 행을 지칭

***PRIOR키워드는 CONNECT BY 바로 다음에 나오지 않아도된다.
CONNECT BY PRIOR deptcd=p_deptcd;
CONNECT BY deptcd= PRIOR p_deptcd;

**연결조건이 두개 이상일때 
CONNECT BY PRIOR p = q AND PRIOR a = b;

SELECT deptcd,LPAD(' ',(LEVEL-1)*2)||deptnm,LEVEL
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd=p_deptcd;


SELECT LEVEL lv, deptcd, LPAD(' ',(LEVEL-1)*2)||deptnm deptnm,p_deptcd
FROM dept_h
START WITH deptcd ='dept0_02'
CONNECT BY PRIOR deptcd=p_deptcd;

--밑에서 위로 

계층쿼리 상향식
디자인팀 (dept0_00_0)부터 시작하여 자시의 상위부서로 연결하는쿼리
SELECT LEVEL,deptcd,LPAD(' ',(LEVEL-1)*3)||deptnm deptnm,p_deptcd
FROM dept_h
START WITH deptcd='dept0_00_0'
CONNECT BY PRIOR p_deptcd=deptcd;

SELECT *
FROM h_sum;

SELECT LPAD(' ',(LEVEL-1)*3)||s_id s_id,value
FROM h_sum
START WITH s_id= '0'
CONNECT BY PRIOR s_id = ps_id;

Pruning branch :가지치기
SELECT 쿼리 처음 배울때, 설명해준 SQL구문 실행순서
FROM -> WHERE -> GROUP BY ->SELECT -> ORDER BY

SELECT 쿼리에 START WITH ,CONNECT BY절이 있을경우
FROM  -> START WITH,CONNECT BY ->WHERE ...

하향식 쿼리로 데이터 조회
SELECT deptcd, LPAD(' ',(LEVEL-1)*3)||deptnm deptnm
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd=p_deptcd AND deptcd != 'dept0_01';

현재 읽은행의 deptcd값이 앞으로 읽을 행의 P_deptcd컬럼과 같고
앞으로 읽을 행의 dept_cd컬럼 값이 'dept0_01'이 아닐때 연결하겠다

==> xx회사 밑에는 디자인부 ,정보기획부, 정보시스템부 3개의 부가 있는데 그중에서 
    정보기획부를 제외한 2개부서에 대해서만 연결하겠다
행 제한 조건을 WHERE절에 기술햇을 경우

FROM -> START WITH -> WHERE 절 순으로 실행되기 때문에
1. 계층탐색을 전부 완료한후
2.WHERE절에 해당하는 행만 데이터를 제외한다

SELECT deptcd, LPAD(' ',(LEVEL-1)*3)||deptnm deptnm
FROM dept_h
WHERE deptcd != 'dept0_01'
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd=p_deptcd ;

계층 쿼리 특수함수(오라클 사용자헤게는 중요한 함수)
* CONNECT_BY_ROOT(col):최상위 행의 컬럼 값 조회
* SYS_CONNECT_BY_PATH(col,구분자): 계층 순회 경로를 표현
* CONNECT_BY_ISLEAF :해당 행의 leaf node(자식이 없는 노드) 인지 여부를 반환
                    (1: leaf node, 0:no leaf node)
                    
SELECT deptcd,LPAD(' ',(LEVEL-1)*3)||deptnm,
    CONNECT_BY_ROOT(deptnm) cbr,
    LTRIM(SYS_CONNECT_BY_PATH(deptnm,'-'),'-')scbp,
    CONNECT_BY_ISLEAF CBI
FROM dept_h
START WITH deptcd=  'dept0'
CONNECT BY PRIOR deptcd=p_deptcd;

--------------------------------
CONNECT BY LEVEL 계층 쿼리: CROSSJOIN과 유사  ---달력이랑 같이보기
연결가능한 모든 행에 대해 계층으로연결

SELECT dummy,LEVEL, LTRIM(SYS_CONNECT_BY_PATH(dummy,'-'),'-')schp
FROM dual
CONNECT BY LEVEL <=10;
---------------------------------------


SELECT *
FROM board_test;
실습6
SELECT seq,LPAD(' ',(LEVEL-1)*3)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq=parent_seq;

SELECT seq,LPAD(' ',(LEVEL-1)*3)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC;





실습 6-8
SELECT seq,LPAD(' ',(LEVEL-1)*3)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

실습9
1.CONNECT_BY_ROOT를 사용한 그룹번호생성
SELECT *
FROM
(SELECT seq,LPAD(' ',(LEVEL-1)*3)||title title, CONNECT_BY_ROOT(seq) gn
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
ORDER BY gn DESC,seq ASC; 

2.gn(NUMBER)컬럼을 테이블에추가
ALTER TABLE board_test ADD (gn NUMBER);

UPDATE board_test SET gn =1
WHERE seq IN (1,9);

UPDATE board_test SET gn =2
WHERE seq IN (2,3);

UPDATE board_test SET gn =4
WHERE seq IN (1,2,3,9);
commit;

SELECT *
FROM board_test

SELECT seq,LPAD(' ',(LEVEL-1)*3)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;


-------------window함수 
분석함수 윈도우함수
사원중에 가장많은 급여를 받는 사람의 정보조회 (empno ,ename,sal)
SELECT empno, ename, sal
FROM emp
WHERE sal IN(SELECT MAX(sal)
             FROM emp);

SQL단점: 행간 연산이 부족 ==> 해당부분을 보완해 주는것이 분석함수(윈도우함수)

실습 ANA0 부서별 급여랭크 
SELECT ename, sal, deptno,
       RANK()OVER(PARTITION BY deptno ORDER BY sal DESC)sal_rank
FROM emp;

분석함수를 사용하지 않고도 위와 같은 동일한 결과를 만들어내는 것이가능
(***분석함수가 모든 DBMS에서 제공을 하지는 않음)

공유폴더

SELECT *
FROM 
(SELECT ename, sal, deptno, ROWNUM rn
    FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) ) a,

(SELECT deptno, lv, ROWNUM rn
  FROM 
    (SELECT a.deptno, b.lv
    FROM 
        (SELECT deptno, COUNT(*) cnt
        FROM emp
        GROUP BY deptno) a, 
            (SELECT LEVEL lv
             FROM dual
             CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp) ) b
    WHERE a.cnt >= b.lv
    ORDER BY a.deptno, b.lv )) b
WHERE a.rn = b.rn;




분석함수/ 윈도우함수 문법
SELECT 윈도우 함수 이름([인자]) OVER 
            ([PARTITION by columns][ORDER BY columns][WINDOWING])
PARTITION BY 영역설정
ORDER BY :영역내에서 순서설정 (RANK,ROW_NUMBER)
WINDOWING : 파티션 내에서 범위설정

부서별 급여순위구하기
순위 관련 분석함수 =동일 값에대한 순위처리에 따라 3가지 함수를제공
* RANK: 동일 값에대해서 동일순위부여
      후순위:1등이 2명이면 그 다음 순위가 3위(1,1,3)
* DENSE_RANK : 동일값에 대해 동일순위부여
            후순위: 1등이 2명이면 그 다음순위가 2위 (1,1,2)
            
* ROW_NUMBER: 동일값이라도 다른순위를 부여 (1.2.3)

실습
SELECT ename, sal,deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC)sal_rank,
        DENSE_RANK()OVER(PARTITION BY deptno ORDER BY sal DESC)sal_dence_rank,
       ROW_NUMBER()OVER(PARTITION BY deptno ORDER BY sal DESC)row_number
       

FROM emp;

실습1 사원전체의 급여순위
SELECT empno,ename,sal,deptno,
        RANK()OVER(ORDER BY sal DESC)sal_rank,
        DENSE_RANK()OVER(ORDER BY sal DESC)sal_dense_rank,
        ROW_NUMBER()OVER(ORDER BY sal DESC)row_number
FROM emp

분석함수 -집계함수
SUM(col), MIN(col),MAX(col),COUNT(col|*),AVG(col)
사원번호, 사원이름, 소속부서번호, 소속된 부서의 사원수
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno)cnt
FROM emp;

SELECT empno, ename,sal, deptno,ROUND(AVG(sal)OVER(PARTITION BY deptno),2)avg_sal
FROM emp;

분석함수 쓰지 않고 구하기
SELECT empno,ename ,sal,emp.deptno,a.avg_sal
FROM emp,
    (SELECT deptno, ROUND(AVG(sal),2)avg_sal
    FROM emp
    GROUP BY deptno)a
WHERE emp.deptno=a.deptno;
