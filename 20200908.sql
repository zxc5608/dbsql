
날짜 데이터 : emp , hiredate
            sysdate
TO_CHAR (날짜타입, '변경할 문자열 포맷')
현재설정된NLS DATE FORMAT :MMMM/MM/DD HH24:MI:SS

TO_DATE('날짜문자열','첫번재인자의 날짜 포맷')
TO_CHAR TO_DATE첫번째 인자 값을넣을때 문자열인지.날짜인지 구분


SELECT SYSDATE, TO_CHAR(SYSDATE,'DD-MM-YYYY'),
TO_CHAR(SYSDATE,'D')  ,TO_CHAR(SYSDATE,'IW')
FROM dual; 
--오늘 날짜의 주간일자 -오늘의 주차 37주차 

YYYYMMDD ==>YYYY/MM/DD
'20200908' ==> 2020/09/08


SELECT ename,
       --SUBSTR('2020008',1,4)||'/' || SUBSTR('20200908',5,2)'/' || SUBSTR('20200908',7,2)
        hiredate, TO_CHAR(hiredate, 'yyyy/mm/dd hh24:mi:ss')h1, 
        TO_CHAR(hiredate+1,'yyyy/mm/dd hh24:mi:ss')h2,
        TO_CHAR(hiredate+1/24,'yyyy/mm/dd hh24:mi:ss')h3,
        TO_CHAR(TO_DATE('20200908','YYYYMMDD'), 'YYYY-MM-DD')h4
FROM emp;


날짜: 일자+ 시분초
2020년9월8일 14시 10분 5초 ===> '20200908'===>2020년 9월 8일 00시0분0초  --시간을 날려버리기위해
SELECT TO_CHAR(SYSDATE,'YYYYMMDD')
FROM dual;

실습 fn2
SELECT  TO_CHAR(SYSDATE,'YYYY-MM-DD')DT_DASH,
        TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS')DT_DASH_WITH_TIME,
        TO_CHAR(SYSDATE,'DD-MM-YYYY')
FROM dual;

//149p  
날짜 조작함수
MONTHS_BETWEEN(date1.date2): 두날짜 사이의 개월수를 반환
                            두 날짜의 일정보가 틀리면소수점이 나오기때문에
                            잘사용하지 않는다
***ADD_MONTHS(DATE,NUMBER) :주어진 날짜에 기월수를 더하거나 뺀 날자를 반환 
                        한달이라는 기간이 월마다 다름 -직접구현이 힘듬
ADD_MONTHS(SYSDATE, 5): 오늘 날짜로부터 5개월 뒤의 날짜는 몇일인가
    
**NEXT_DAY(DATE, NUMBER(주간요일:1-7)) : DATE 이후에 등장하는첫번쨰 주간요일을 갖는 날짜
NEXT_DAY(SYSDATE, 6): SYSDATE이 이후에 등장하는 첫번쨰 금요일에 해당하는 날짜

*****LAST_DAY(DATE):마지막날짜 주어진 날짜가 속한 월의 마지막 일자를 날짜로 반환
LAST_DAY(SYSDATE):SYSDATE(2020/09/08)가 속한 9월의 마지막날짜 :2020/09/30
월마다 마지막 일자가 다르기 떄문에 해당 함수를 통해서 
마지막 일자를 편하게 구할수있다

해당월의 가장 첫날짜를 반환하는 함수는 없어>> 모든 월의 첫 날짜 1일이다. 
FIRST_DAY
SELECT MONTHS_BETWEEN( TO_DATE('20200915','YYYYMMDD'),TO_DATE('20200808','YYYYMMDD')),
       ADD_MONTHS(SYSDATE, 5),
       NEXT_DAY(SYSDATE,6),
       LAST_DAY(SYSDATE)
      
       --SYSDATE가 속한 월의 첫 날짜 구하기
       --(2020년 9월 1일의 날짜테이블 구하기 )
FROM dual;

SELECT TO_DATE('01','DD')
FROM dual;

SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYYMM')||'01','YYYYMMDD'),
        ADD_MONTHS(LAST_DAY(SYSDATE),-1)+1,
        SYSDATE-TO_CHAR(SYSDATE,'DD')+1
FROM dual;

주어진것 :년 월 문자열==> 날짜로변경==> 해당월의 마지막 날짜로 변경

SELECT TO_CHAR(LAST_DAY(TO_DATE( :yyyymm, 'YYYYMM')),'DD')
FROM dual;                               --yyyymm < 바인드변수

형변환
명시적형변환
 TO_CHAR ,TO_DATE,TO_NUMBER
 묵시적형변환
 ...ORACLE DBMS까 상황에 맞게 알아서 해주는것
  java시간에 8가지 원시타입 (Primitive type)간 형변환
  1가지 타입이다른 7가지 타입으로 변환될숭 ㅣㅅ는지 
  8*7=56가지
 
 두가지 가능한경우
 1.empno(숫자)를 문자로 묵시적변환
 2.7369(문자)를 숫자로 묵시적 형변환

알면 매우좋음, 몰라도 수업 진행하는데 문제업고  추후 취업해서도 큰 지장은 없음
다만 고급 개발자와 일반개발자를 구분하는 차이점이 됨.


실행계획 : 오라클에서 요청받음 sql으 처리하기 위한 절차를 수립한것
실행계획 보는 방법
1.EXPLAIN PLAN FOR
    실행계획을 분석할 SQL
2. SELECT *
    FROM TABLE(dbms_xplan.display);
실행계획의 operation을 해석하는 방법
1. 위에서 아래로
2. 단 지식노드(들여쓰기가 된 노드) 있을경우 지식부터 실행하고 본인노드를 실행
실행계획순서 1-0 
EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno ='7369';

    TABLE 함수: PL/SQL의 테이블 타입 자료형을 테이블로변환
    SELECT *
    FROM TABLE(dbms_xplan.display);
    
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno)='7369'

SELECT *
FROM TABLE(dbms_xplan.display);

1600==>1,600
숫자를 문자로 포맷팅:DB보다는 국제화 (i18n)에서 더 많이 활용을한다.
L== 원을 붙혀준다                 i(nternationalizatio)n
SELECT empno, ename, sal, TO_CHAR(sal,'009,999L')
FROM emp;

함수 
    문자열
    날짜
    숫자 
    null 과 관련된함수 4가지 (다 못외워도 괜찮음, 한가지를 주요 사용)
    오라클의 NVL함수와 동일한 역할을 하는 MS-sql SEVER의 함수이름?
    
    null의 의미: 아직모르는 값 할당되지 않은값
                0과 '' 문자와는 다르다
    null의 특징 : null을 포함한 연산의 결과는 항상 null
    sal컬럼에는null이 없지만 comm 에는 4개의 행을 제외하고 10개의 행이 null값을 갖는다
    
    SELECT ename, comm, sal+comm
    FROM emp;


NULL관련된함수
1.NVL (컬럼)|| 익스프레션,컬럼|| 익스프레션)
 NVL(expr1.expr2)
 
    if(expr1==null)
    System.out.println expr2;
    else
    system.out.println(expr1);
    
SELECT empno, sal, comm, sal+comm, sal+NVL(comm,0)
FROM emp;
