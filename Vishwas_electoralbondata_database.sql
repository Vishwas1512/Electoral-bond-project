SELECT * FROM electoralbonddata.bankdata;
/* 1. Find out how much donors spent on bonds    */
select b.Unique_key, b.Denomination
from bonddata b
join donordata d on d.unique_key=b.unique_key
group by b.Unique_key ;
/*       2. Find out total fund politicians got       */
select r.PartyName,sum(b.Denomination) total_fund
from receiverdata r
left join bonddata b on b.unique_key=r.unique_key
group by r.PartyName
order by total_fund desc;

/*  3. Find out the total amount of unaccounted money received by parties     */ 
select sum(b.Denomination) total_fund
from bonddata b
join receiverdata r on b.unique_key=r.unique_key
left join donordata d on r.Unique_key=d.Unique_key
where d.Unique_key is null;

/*     4. Find year wise how much money is spend on bonds            */
select sum(b.denomination), year(d.purchaseDate) 
from donordata d
join bonddata b on d.Unique_key=b.Unique_key
group by year(d.purchasedate);

/*    5. In which month most amount is spent on bonds     */

select sum(b.denomination), month(d.purchaseDate) 
from donordata d
join bonddata b on d.Unique_key=b.Unique_key
group by month(d.purchasedate)
order by sum(b.denomination) desc;
   
/*      6. Find out which company bought the highest number of bonds.    */
select d.Purchaser,count(d.Purchaser) total_bonds_purchased
from donordata d
join bonddata b on d.Unique_key=b.Unique_key
group by d.Purchaser
order by d.Purchaser desc;

/*      7 . Find out which company spent the most on electoral bonds.      */
select d.Purchaser,sum(b.denomination)
from donordata d
join bonddata b on d.Unique_key=b.Unique_key
group by d.Purchaser
order by sum(b.Denomination) desc;

/*     8. List companies which paid the least to political parties.   */

select d.Purchaser
from donordata d
join bonddata b on d.Unique_key=b.Unique_key
group by d.Purchaser
order by sum(b.Denomination) asc;

/*    9. Which political party received the highest cash?    */
select r.PartyName,sum(b.denomination)
from bonddata b
join receiverdata r on r.Unique_key=b.Unique_key
group by r.PartyName
order by sum(b.Denomination) desc;

/*    10. Which political party received the highest number of electoral bonds?  */
select r.partyname,count(r.partyname)
from receiverdata r
group by r.PartyName
order by count(r.PartyName) desc;

/*   11. Which political party received the least cash?       */
select r.partyname,sum(b.denomination) total_amount
from receiverdata r
join bonddata b on b.Unique_key=r.Unique_key
group by r.PartyName
order by sum(b.Denomination) asc;
 
 /*   12. Which political party received the least number of electoral bonds?     */
 select r.partyname,count(r.partyname)
 from receiverdata r
 group by r.PartyName
 order by count(r.PartyName) asc;
 
 
 /*     13. Find the 2nd highest donor in terms of amount he paid?      */
 select d.purchaser,sum(b.denomination)
 from donordata d
 join bonddata b on d.Unique_key=b.Unique_key
 group by d.Purchaser
 order by sum(b.Denomination) desc
limit 1,1;

/*     14. Find the party which received the second highest donations?       */
select r.partyname,sum(b.denomination) total_donations
from receiverdata r
join bonddata b on r.Unique_key=b.Unique_key
group by r.PartyName
order by total_donations desc
limit 1,1;

/*  15. Find the party which received the second highest number of bonds?    */
select r.partyname,count(r.PartyName) total_no_bonds
from receiverdata r
group by r.PartyName
order by total_no_bonds desc
limit 1,1;


/*      16. In which city were the most number of bonds purchased?        */

select b.city,count(d.Purchaser) no_of_bonds
from bankdata b
join donordata d on b.branchCodeNo=d.PayBranchCode
group by b.city
order by no_of_bonds desc
limit 1;

/*   17. In which city was the highest amount spent on electoral bonds?    */
select ba.city,sum(b.Denomination) total_fund
from  receiverdata r
join bonddata b on b.Unique_key=r.Unique_key
join bankdata ba on ba.branchCodeNo=r.PayBranchCode
group by ba.city
order by total_fund desc
limit 1;

/*    18. In which city were the least number of bonds purchased?    */
select b.city,count(d.purchaser) no_of_bonds
from bankdata b
join donordata d on b.branchCodeNo=d.PayBranchCode
group by b.city
order by no_of_bonds asc
limit 1;


/*      19. In which city were the most number of bonds enchased?       */
select b.city,count(r.PartyName) no_of_bonds
from bankdata b
join receiverdata r on b.branchCodeNo=r.PayBranchCode
group by b.city
order by no_of_bonds desc
limit 1;


/*    20. In which city were the least number of bonds enchased?      */
select b.city,count(r.PartyName) no_of_bonds
from bankdata b
join receiverdata r on b.branchCodeNo=r.PayBranchCode
group by b.city
order by no_of_bonds asc
limit 1;

/*    21.List the branches where no electoral bonds were bought; if none, mention it as null.?       */
select b.city,count(d.purchaser)
from bankdata b
join donordata d on b.branchCodeNo=d.PayBranchCode
where d.Purchaser is null
group by b.city   ;

/*       RESULT        NULL       */


/*    22.Break down how much money is spent on electoral bonds for each year.      */

select year(d.purchasedate),sum(b.denomination) total_funds
from donordata d
join bonddata b on d.Unique_key=b.Unique_key
group by year(d.purchasedate)
order by sum(b.Denomination) desc;


/*   23. Break down how much money is spent on electoral bonds for each year and provide the year and the amount. Provide values
for the highest and least year and amount.   */
 
              
WITH CTE AS (
    SELECT YEAR(d.purchasedate) AS year, SUM(b.denomination) AS total_fund
    FROM bonddata b
    JOIN donordata d ON b.Unique_key = d.Unique_key
    GROUP BY YEAR(d.purchasedate)
)
SELECT 
    (SELECT year FROM CTE ORDER BY total_fund DESC LIMIT 1) AS year_max_fund,
    (SELECT total_fund FROM CTE ORDER BY total_fund DESC LIMIT 1) AS max_total_fund,
    (SELECT year FROM CTE ORDER BY total_fund ASC LIMIT 1) AS year_min_fund,
    (SELECT total_fund FROM CTE ORDER BY total_fund ASC LIMIT 1) AS min_total_fund;
    
 /*      24. Find out how many donors bought the bonds but did not donate to any political party?          */
SELECT count(d.purchaser)
FROM donordata d
JOIN bonddata b ON d.unique_key = b.Unique_key
LEFT JOIN receiverdata r ON d.unique_key = r.Unique_key
WHERE r.Unique_key IS NULL;

/*     25. Find out the money that could have gone to the PM Office, assuming the above question assumption (Domain Knowledge)        */
select sum(b.denomination)
from bonddata b 
join donordata d on b.Unique_key=d.Unique_key
left join  receiverdata r on b.Unique_key=r.Unique_key
where r.Unique_key is null;

/*     26. Find out how many bonds don't have donors associated with them.    */
select count(b.unique_key)
from bonddata b
left join donordata d on b.Unique_key=d.Unique_key
where d.Unique_key is null;
 
 /*     27. Pay Teller is the employee ID who either created the bond or redeemed it. So find the employee ID who issued the highest
number of bonds.   */

select d.payteller,count(Purchaser)
from donordata d
group by d.PayTeller
order by count(d.Purchaser) desc
limit 1;

/*   28. Find the employee ID who issued the least number of bonds.  */
select d.payteller,count(Purchaser)
from donordata d
group by d.PayTeller
order by count(d.Purchaser) asc
limit 1;


/*   29.Find the employee ID who assisted in redeeming or enchasing bonds the most.    */
select r.payteller,count(r.PartyName)
from receiverdata r
group by r.PayTeller
order by count(r.PartyName) desc
limit 1;


/*  30. Find the employee ID who assisted in redeeming or enchasing bonds the least     */
select r.payteller,count(r.PartyName)
from receiverdata r
group by r.PayTeller
order by count(r.PartyName) asc
limit 1;



/*  1. Tell me total how many bonds are created?*/ 
select count(Unique_key)
from bonddata b;

/*  2. Find the count of Unique Denominations provided by SBI? */
select count(distinct Denomination) 'total_unique_denominations'
from bonddata;



/*   3. List all the unique denominations that are available?      */
select distinct(denomination) 'unique_bonds'
from bonddata
order by Denomination asc;

/*     4. Total money received by the bank for selling bonds   */
select sum(b.denomination)
from bonddata b
right join donordata d on b.Unique_key=d.Unique_key;


/*     5. Find the count of bonds for each denominations that are created.     */
select distinct(b.denomination),count(b.denomination)
from bonddata b
group by b.denomination
order by b.denomination asc;


/*   6. Find the count and Amount or Valuation of electoral bonds for each denominations.     */
select distinct(b.denomination), count(b.denomination) 'no_of_bonds', sum(b.denomination) 'amount'
from bonddata b
group by b.denomination
order by b.denomination asc;


/*    7. Number of unique bank branches where we can buy electoral bond?     */
select count(distinct(branchcodeno))
from bankdata;


/*    8. How many companies bought electoral bonds      */
select count(distinct(purchaser))
from donordata;


/*   9. How many companies made political donations    */
select count(distinct(d.purchaser))
from donordata d
left join receiverdata r on d.Unique_key=r.Unique_key;

/*   10. How many number of parties received donations    */
SELECT COUNT(DISTINCT partyname)
FROM receiverdata;

/*  11. List all the political parties that received donations  */
select count(distinct(d.purchaser))
from donordata d
right join receiverdata r on d.Unique_key=r.Unique_key;

/*  12. What is the average amount that each political party received  */
select distinct r.partyname, round(avg(b.denomination))
from receiverdata r
right join bonddata b on b.Unique_key=r.Unique_key
group by r.PartyName;

/*   13. What is the average bond value produced by bank    */
SELECT 
    AVG(DISTINCT denomination)
FROM
    bonddata;

/*   14. List the political parties which have enchased bonds in different cities?  */
SELECT r.PartyName
FROM receiverdata r
JOIN bankdata ba 
ON r.PayBranchcode = ba.branchCodeNo
group by r.PartyName
having count(distinct ba.city)>1;

/*  15. List the political parties which have enchased bonds in different cities and list the cities in which the bonds have enchased
as well?   */
SELECT r.PartyName,ba.CITY
FROM receiverdata r
JOIN bankdata ba
ON r.PayBranchcode = ba.branchCodeNo
GROUP BY r.PartyName
HAVING COUNT(distinct ba.CITY)>1;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));






