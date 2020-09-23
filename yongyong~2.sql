

SELECT gb,sido, sigungu
FROM fastfood
WHERE SIDO ='충청남도';


SELECT sido, sigungu , COUNT(*)cnt
FROM fastfood
WHERE gb IN ('맥도날드','버거킹','kfc')
GROUP BY sido, sigungu;
