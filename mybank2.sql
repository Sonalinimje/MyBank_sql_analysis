use mybank;

-- retrieve all table data
 select * from accounts;
 select * from atms;
 select * from branches;
 select * from customers;
 select * from loans;
 select * from transactions;
 select * from credit_cards;
 
 -- aggreegate queries
 
-- calculate total no of customers
select count(*) as totalcustomer from customers;

-- calculate total no of accounts
select count(*) as totalaccounts from accounts;

-- calculate total loan amount
select sum(amount) as totalloansamount from loans;

-- calculate total credit limit across all credit cards
select sum(creditlimit) as totalcreditlimit from credit_cards;

-- find all active accounts
select * from accounts where status = 'active';

-- final all accounts made on 15th jan 2023
select * from transactions where transactiondate >'2023-01-15';

-- find loans with interest rates above 0.5
select * from loans where interestrate> 0.5;

-- find credit cards with balances exceeding the credit limit
select * from credit_cards where balance > creditlimit;

-- join queries

-- retrive customer details along with their accounts
select c.customerid, c.name, c.age, a.accountnumber, a.accounttype, a.balance from customers c 
join accounts a on c.customerid = a.customerid;

-- retrive transaction details along with associated account and customer information
select t.transactionid, t.transactiondate, t.amount, t.type, t.description,
a.accountnumber, a.accounttype, c.name as customername
from transactions t
join accounts a on t.accountnumber = a.accountnumber
join customers c on a.customerid = c.customerid;

-- top 10 customers with highest loan amount
select c.name, l.amount as loanamount
from customers c 
join loans l on c.customerid = l.customerid
order by l.amount desc limit 10;

-- delete inactive accounts
set sql_safe_updates = 0;
delete from accounts
where status = 'inactive';

-- find customers with multiple accounts
select c.customerid, c.name, count(a.accountnumber) as numacccounts
from customers c 
join accounts a on c.customerid = a.customerid
group by c.customerid, c.name
having count(a.accountnumber) > 1;

-- print thr first 3 characters of name from customers table
 select substring(name,1,3) as firstthreecharactersofname from customers;
 
-- SQL query to show only odd rows from Customers Table
SELECT * FROM Customers
WHERE MOD(CustomerID, 2) <> 0;

 -- sql query to determine the 5th highest loan amount without using limit keyword
select distinct amount
from loans l1
where 5 = (select count(distinct amount)
from loans l2
where l2.amount >= l1.amount);

-- sql query to show the second highest loan from the loans table using sub-query
select max(amount) as secondhighestloan
from loans
where amount <(select max(amount) from loans);

-- swl query to list customerid whose account is inactive
select customerid from accounts where status = 'inactive';

-- sql query to fetch the first row of the customer table
select * from customers limit 1;

-- sql query to show the current date and time
select now() as currentdatetime;

-- print the name from customers table into two columns firstname and lastname
select substring_index(name, ' ', 1) as firstname,
substring_index(name, ' ', -1) as lastname
from customers;

-- sql query to create a now table which consists of data and structure copied from the customers
create table customersclone like customers;
insert into customersclone select * from customers;

-- sql query to calculate how many days are remaining for customers to pay off the loans
select customerid, datediff(enddate, curdate()) as daysremaining
from loans where enddate > curdate();

-- query to find the latest transaction date for each account
select accountnumber, max(transactiondate) as latesttransactiondate
from transactions group by accountnumber;

-- find the avg age of customers
select avg(age) as averageage from customers;

-- fing accounts with less than minimum amount for accounts openedbefore 1st jan 2022
select accountnumber, balance
from accounts where balance < 25000 and opendate <= '2022-01-01';

-- find loans that are currently active
select * from loans where enddate >= curdate() and status = 'active';

-- Find the total amount of transactions for each account for a specific month
select accountnumber, sum(amount) as totalamount
from transactions where month(transactiondate) = 6
and year(transactiondate) = 2023 group by accountnumber;

-- find the avg credit card balance for each customer
select customerid, avg(balance) as averagecreditcardbalance
from credit_cards group by customerid;

-- find the number of inactive atms per location
select location, count(*) as numberofactiveatms
from atms where status = 'out of service' group by location;

select * from customers where name like 'j%';

select * from customers where email like '%outlook.com';

-- Categorize customers into three age groups
select 
name, age,
case 
when age < 30 then 'below 30'
when age between 30 and 60 then '30 to 60'
else 'above 60'
end as age_group from customers;

select * from transactions
where type='withdrawal' and amount>2000 and month(transactiondate)=5;
