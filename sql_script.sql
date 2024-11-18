-- drop database if exists retail_sales;

/*`````````````````````````````````````````````````
Nayab Irfan
Data Science & AI - Cohort 08
`````````````````````````````````````````````````*/

create database Retail_Sales;
use Retail_Sales;

show tables;
describe products;
describe customers;
describe sales;

-- ``````````````````````Adding Primary Keys and Foreign Keys for the Tables

-- 1. Customers Table
alter table customers
add constraint primary key (customer_id);

-- 2. Products Table
alter table products
add constraint primary key (product_id);

-- 3. Sales Table
alter table sales
add constraint primary key (sale_id),
add constraint FK_SC foreign key (customer_id) 
    references customers(customer_id) 
    on delete cascade 
    on update cascade,
    
add constraint FK_SP foreign key (product_id) 
    references products(product_id) 
    on delete cascade 
    on update cascade;

-- 4. Inventory Movements Table
alter table inventory_movements
add constraint primary key (movement_id),
add constraint FK_IP foreign key (product_id) 
    references products(product_id) 
    on delete cascade 
    on update cascade;

-- ``````````````````````````````Module 1: Sales Performance Analysis``````````````````````````````

-- Calculate total revenue and units sold per month.

select 
    date_format(sale_date, '%Y-%m') as SaleMonth,
    sum(quantity_sold) as UnitsSold,
    sum(total_amount) as Revenue
from 
    Sales
group by
    SaleMonth
order by 
    SaleMonth;

-- Assess monthly discount strategies.

select 
    date_format(sale_date, '%Y-%m') as SaleMonth,
    avg(discount_applied) as AvgDiscount,
    sum(total_amount) as Revenue
from 
    Sales
group by 
    SaleMonth
order by 
    SaleMonth;

-- ``````````````````````````````Module 2: Customer Behavior and Insights``````````````````````````````

-- Identify high-value customers:

select 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.email, 
    sum(s.total_amount) as total_spent
from 
    customers c
join 
    sales s 
on 
    c.customer_id = s.customer_id
group by 
    c.customer_id, c.first_name, c.last_name, c.email
order by 
    total_spent desc
limit 5;

-- Identify the oldest Customer:

select 
    c.customer_id as ID,
    concat(c.first_name, ' ', c.last_name) as FullName,
    c.date_of_birth as DOB,
    sum(s.total_amount) as Total_Spent
from 
    customers c
join 
    sales s on c.customer_id = s.customer_id
where 
    c.date_of_birth between '1990-01-01' and '1999-12-31'
group by
    c.customer_id, FullName, c.date_of_birth
order by 
    c.date_of_birth asc
limit 1;

-- Find customers with the highest spending.

select 
    c.customer_id as C_ID,
    concat(c.first_name, ' ', c.last_name) as FullName,
    c.email as Email,
    sum(s.total_amount) as Spent
from 
    Customers c
join 
    Sales s on c.customer_id = s.customer_id
group by 
    C_ID, FullName, Email
order by
    Spent DESC
limit 10;

-- Focus on customers born in the 1990s.

select 
    c.customer_id as ID,
    concat(c.first_name, ' ', c.last_name) as FullName,
    c.date_of_birth as DOB,
    sum(s.total_amount) as Total_Spent
from 
    Customers c
join 
    Sales s on c.customer_id = s.customer_id
where 
    c.date_of_birth between '1990-01-01' and '1999-12-31'
group by
    c.customer_id, FullName, c.date_of_birth
order by 
    total_spent asc;
    
-- Classify customers into spending groups.

select 
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as FullName,
    sum(s.total_amount) as total_spent,
    case 
        when sum(s.total_amount) < 500 then 'Low Spender'
        when sum(s.total_amount) between 500 and 2000 then 'Medium Spender'
        else 'High Spender'
    end as CategorySpent
from 
    Customers c
join 
    Sales s ON c.customer_id = s.customer_id
group by 
    c.customer_id, FullName
order by
    total_spent desc;

-- ``````````````````````````````Module 3: Inventory and Product Management``````````````````````````````
-- Identify low-stock products and suggest restocks.

select 
    p.product_id as ID,
    p.product_name as ProductName,
    p.stock_quantity as StockQuantity,
    round(avg(s.quantity_sold), 2) as AvgDailySales,
    (10 - p.stock_quantity) as RecommendedRestock
from 
    Products p
join 
    Sales s on p.product_id = s.product_id
group by 
    p.product_id, p.product_name, p.stock_quantity
having 
    p.stock_quantity < 10
order by 
    p.stock_quantity asc;

-- Analyze restocks and sales over time.

select 
    i.product_id,
    p.product_name,
    date(i.movement_date) as movement_day,
    sum(
		case when i.movement_type = 'IN' 
        then i.quantity_moved 
        else 0 
        end) as TotalRestocked,
    sum(
		case when i.movement_type = 'OUT' 
        then i.quantity_moved 
        else 0 end) as TotalSold
from 
    Inventory_Movements i
join 
    Products p on i.product_id = p.product_id
group by
    i.product_id, p.product_name, movement_day
order by 
    movement_day asc;

-- Rank products within each category.

select 
    category as Categorey,
    product_name as PName,
    price as Price,
    rank() over (
			partition by category 
            order by price desc
            ) as PriceRank
from 
    Products;

-- Determine average quantities per product.

select 
    product_id as ID,
    avg(quantity_sold) as AvgOrderSize
from 
    Sales
group by 
    product_id
order by 
    AvgOrderSize desc;

-- Find products recently restocked.

select 
    i.product_id as PID,
    p.product_name as ProductName,
    max(i.movement_date) as LastRestockDate
from 
    Inventory_Movements i
join 
    Products p on i.product_id = p.product_id
where 
    i.movement_type = 'IN'
group by 
    i.product_id, p.product_name
order by 
    LastRestockDate desc
limit 5;


-- ``````````````````````````````Dynamic Pricing Simulation``````````````````````````````````

with PriceImpact as (
    select 
        p.product_id as PID,
        p.product_name as PName,
        s.sale_date as SalesDate,
        p.price as OriginalPrice,
        avg(s.total_amount / s.quantity_sold) as AvgSellPrice,
        sum(s.quantity_sold) as UnitsSold,
        sum(s.total_amount) as Revenue
    from 
        Sales s
    join 
        Products p on s.product_id = p.product_id
    group by 
        p.product_id, p.product_name, p.price, s.sale_date
)
select 
    PID,
    PName,
    OriginalPrice,
    round(avg(AvgSellPrice), 2) as Adjusted_Price,
    sum(UnitsSold) AS TotalUnits,
    sum(Revenue) as Total_Revenue,
    round((sum(Revenue) / sum(UnitsSold)), 2) as Rev_perUnit
from 
    PriceImpact
group by 
    PID, PName, OriginalPrice
order by 
    Rev_perUnit desc;

-- ``````````````````````````````Customer Purchase Patterns``````````````````````````````````

with PurchasePatterns as (
    select 
        c.customer_id as C_ID,
        concat(c.first_name, ' ', c.last_name) as FullName,
        date_format(s.sale_date, '%Y-%m') as PurchaseMonth,
        count(s.sale_id) as PurchaseCount,
        sum(s.total_amount) as SpentAmount,
        row_number() over 
        (
        partition by c.customer_id 
        order by 
        sum(s.total_amount) 
        ) as `rank`
    from 
        Customers c
    join 
        Sales s on c.customer_id = s.customer_id
    group by 
        C_ID, FullName, PurchaseMonth
)
select 
    C_ID,
    FullName,
    PurchaseMonth,
    PurchaseCount,
    SpentAmount
from 
    PurchasePatterns
where 
    `rank` = 1
order by 
    PurchaseCount desc, SpentAmount desc
limit 10;

-- ``````````````````````````````Predictive Analytics: Customer Churn``````````````````````````````

with ChurnRisk as (
    select 
        c.customer_id as C_ID,
        concat(c.first_name, ' ', c.last_name) as FullName,
        max(s.sale_date) as LastestPurchase,
        datediff(curdate(), max(s.sale_date)) as PurchaseLag
    from 
        Customers c
    left join 
        Sales s on c.customer_id = s.customer_id
    group by
        C_ID, FullName
)
SELECT 
    C_ID,
    FullName,
    LastestPurchase,
    PurchaseLag,
    case 
        when PurchaseLag > 180 then '@High Churn Risk'
        when PurchaseLag between 90 and 180 then 'Might Churn'
        else 'Loyal Customer :)'
    end as Churn_Risk
from 
    ChurnRisk
order by 
    PurchaseLag desc;



