날짜 관련된 함수
TO_CHAR 날짜 ==>문자
TO_DATE 문자==> 날짜

날짜==>문자==>날짜
문자==>날짜==>문자

SYSDATE(날짜)를 이용하여 현재월의 1일자 날짜로 변경하기

NULL관련 함수 -NULL과 관련된 연산의 결과는 NULL 
총 4가지 존재 . 다 외우진 않아도 괜찮음 ,본인이 편한 함수하나 정해서 사용방법을 숙지

1.NVL(expr1.expr2)
    if(expr1==null)
     system.out.println(expr2);
     else
      system.out.println(expr1);

2.NVL2(expr1,expr2,expr3)
    
    if(expr1 != null)  
        system.out.println(expr2);
    else
    system.out,println(expr3)

3. NULLIF(expr1,expr2)
    if(expr1==expr2)
    system.out.println(null);
    else
    system.out.println(expr1);
함수의 인자 개수가 정해지지 않고 유동적으로 변경이 가능한 인자: 가변인자
4.cialesce(expr1,expr2,expr3....

if(expr1!=null)
system.out.println(expr1)
:coalesce의 인자중 가장처음으로 등장하는 null이 아닌 인자를 반환
else
system.out.println(expr2,expr3)
 
 
 coalesce(null,null,5,4)
   ==>coalesce(null,5,4)
   ==>coalesce(5,4)
   ==>system.out.println(5)
 
 
 comm 컬럼이 null일때 0으로 변경하여 sal 컬럼과 합계를구한다.     
SELECT empno, ename,sal,comm,
    sal+NVL(comm,0)nvl_sum,
    sal+NVL2(comm,comm,0)nvl2_sum,
    NVL2(comm,sal+comm,sal)nvl2_sum2,
    NULLIF(sal,sal)nullif,            --sal을 null로
    NULLIF(sal,5000)nullif_sal,  --5000을 널로만들어라
    sal+coalesce(comm,0)coalese_sum,
    coalesce(sal+comm,sal)coalesce_sum2
FROM emp;
문제
SELECT empno, ename,comm, mgr,
        NVL(mgr, 9999)mgr_n,  --mgr컬럼이 null일때 9999로 바꿔라 
        NVL2(mgr,mgr,9999)mgr_n1,
        coalesce(mgr,9999)mgr_n2
FROM emp;

SELECT*
FROM users;


**문제
SELECT userid, usernm,reg_dt,NVL(reg_dt,SYSDATE)N_REG_DT
FROM users
WHERE usernm !='브라운';--부정형
WHERE userid IN ('cony','sally','james','moon');--긍정형


조건:condition
java 조건체크: if,switch
else if(조건)
    실행할문장
else
    실행할문장 

SQL: CASE절
CASE 
    WHEN 조건 THEN반환할 문장
    WHEN 조건2 THEN반환할 문장
    ELSE 반환할 문장 
END


emp 테이블에서 job컬럼의 값이 'SALESMAN'이면 sal값에 5%를 인상한 급여를 반환 sal*1.05
                          'MANAGER'면 sal값에 10%를 인상한 급여를 반환 sal*1.10
                          'PRESIDENT'면 sal값에 10%를 인상한 급여를 반환 sal*1.20
                               그 밖의 직군 ('CLERK','ANALYST')은 SAL값 그대로 반환            
case절을 이용 새롭게 계산한
smith:800,allen:1680

SELECT ename,job,sal,
    CASE
        WHEN job='SALESMAN' THEN sal *1.05
        WHEN job='MANAGER' THEN sal*1.10
        WHEN job='PRESIDENT' THEN sal*1.20
        ELSE sal
END sal_b
FROM emp;

가변인자  인자의 갯수가 정해져있지 않다.
DECODE(col||expr1,
                 search1, return1 
                 search2, return2 
                 search3, return3 
                 [default] )
첫번째 컬럼이 두번째 컬럼 search1과 같으면 세번쨰 컬럼return2을 리턴
첫번째 컬럼이 네번째 컬럼 search1과 같으면 다섯번쨰 컬럼return2을 리턴
첫번째 컬럼이 여섯번째 컬럼 search1과 같으면 일곱번쨰 컬럼return2을 리턴
일치하는 값이 없을떄는 default를 리턴 

SELECT ename,job,sal,
    CASE
        WHEN job='SALESMAN' THEN sal *1.05
        WHEN job='MANAGER' THEN sal*1.10
        WHEN job='PRESIDENT' THEN sal*1.20
        ELSE sal
END sal_b,
   
    DECODE(job,
                'SALESMAN', sal*1.05,
                'MANAGER', sal*1.10,
                'PRESIDENT', sal*1.20,
                sal) sal_decode
                
FROM emp;

CASE ,DECODE 둘다 조건비교시 사용
차이점 ,DECODE의 경우 값 비교가 =(equal)에 대해서만 가능 
            복수조건은 DECODE를 중첩하여 표현
        CASE는 부등호 사용가능, 복수개의 조건 사용가능
    (CASE
            WHEN sal>3000 AND job='MANAGER'
            
SELECT deptno
FROM emp

SELECT empno, ename,      
    CASE
        WHEN deptno=10 THEN 'ACCOUNTING'
        WHEN deptno=20 THEN 'RESEARCH'
        WHEN deptno=30 THEN 'SALES'
         WHEN deptno=40 THEN 'OPERATIONS'
        ELSE 'DDIT'
END D_NAME,

 DECODE(deptno,
                10, 'ACCOUNTING',
                20, 'RESEARCH',
                30, 'SALES',
                40, 'OPERATIONS',
                'DDIT') dname
            FROM emp;
 ==========  
 
건강검진 대상여부 : 출생년도의 짝수 구분과 건강검잔 실시년도(올해)의짞수 구분이 같을때
ex:1983년생을 홀수년도 출생임으로 2020년도 건강검진대상
    
    어떤양의 정수x가 짝수인지 홀수인지 구별법?
    짝수는 2로 나눴을떄 나머지가0
    홀수는 2로 나눴을때 나머지가 1
    
    나머지는 나누는수(2)
    나머지는 항상 0,1
    
SELECT empno,ename,hiredate,
CASE
        WHEN MOD(TO_CHAR(hiredate,'yyyy'),2)= MOD(TO_CHAR(SYSDATE,'yyyy'),2) 
        THEN '건강검진대상자'
        ELSE '건강검진 비대상자'
            
       END CONTACT
FROM emp;


SELECT userid, usernm, reg_dt, 
CASE
    WHEN MOD(TO_CHAR(reg_dt,'yyyy'),2)= MOD(TO_CHAR(reg_dt,'yyyy'),2)
    THEN '건강검진 대상자'
    ELSE '건강검진 대상자'
    END CONTECT,
    
DECODE(MOD(TO_CHAR(reg_dt,'yyyy'),2),
                MOD(TO_CHAR(reg_dt,'yyyy'),2),'건강검진대상자',
                '건강검진 비대상자') CONTACT
                
FROM users;


SELECT *
FROM emp
ORDER BY 