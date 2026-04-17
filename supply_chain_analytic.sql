-- data cleaning 
select *
from supply_chain_data; 

-- Remove duplicates 
-- standardise the datasupply_staging
-- null values or blank values
-- remove any columns 

create table supply_staging
like supply_chain_data;

insert supply_staging
select *
from supply_chain_data;

-- check duplication 
select SKU, count(distinct "Product type" ) as so_lan_xuat_hien
from supply_staging
group by SKU
having count(distinct "Product type") > 1; 

-- standardizing data 
set SQL_safe_updates = 0; 
update supply_staging
set`Product type`= trim(`Product type`); 
set `Transportation modes` = trim (`Transportation modes`);
set `Location` = trim (`Location`);
set SQL_safe_updates = 1; 

-- A. PRODUCT ANALYSIS 
-- tổng doanh thu theo từng loại sản phẩm 
select `Product type`, sum(`Revenue generated`) as total_revenue
from supply_staging
group by `Product type`; 

-- giá trung bình theo loại sản phẩm 
select `Product type`, sum(`Price`) as avg_price 
from supply_staging
group by `Product type`;

-- top 10 sản phẩm bán chạy nhất theo số lượng 
select SKU, `Product type`, `Number of products sold`
from supply_staging
order by `Number of products sold` desc 
limit 10; 

-- thời gian giao hàng trung bình của nhà cung cấp 
select avg(`Lead times`) as avg_lead_time_days
from supply_staging;

select * from (
	select 
		`Product type`,
		SKU,
		`Revenue generated`, 
		dense_rank() over (
		partition by `Product type`
        -- xếp hạng dựa trên doanh thu giảm dần trong từng nhóm sản phẩm 
		order by `Revenue generated` desc
    ) as rev_rank 
    from supply_staging
) as ranked_revenue
where rev_rank <= 3; 

-- B. PROCUREMENT ANALYSIS 
-- Thời gian chờ trung bình của mỗi nhà cung cấp 
select `Supplier name`, avg(`Lead time`) as avg_lead_time
 from supply_staging
 group by `Supplier name`; 

-- top 3 nhà cung cấp có tỷ lệ lỗi cao nhất 
select `Supplier name`, avg(`Defect rates`) as avg_defect_rate
 from supply_staging
 group by `Supplier name`
 order by avg_defect_rate desc
 limit 3; 
 
 -- nhà cung cấp được sử dụng nhiều nhất cho mỗi loại sản phẩm 
 select `Product type`, `Supplier name`, count(*) as usage_count 
 from supply_staging
 group by `Product type`, `Supplier name`
 having usage_count = (
	select max(cnt) from (
		select `Product type`, count(*) as cnt from supply_staging group by `Product type`, `Supplier name`
	) as tmp
); 

-- C. PRODUCTION ANALYSIS
-- Tổng khối lượng sản xuất của mỗi nhà cung cấp 
select `Supplier name`, sum(`Production volumes`) as total_production
from supply_staging
group by `Supplier name`; 

-- Nhà cung cấp, sản phẩm. có tỷ lệ bị lỗi thấp nhất 
select `Supplier name`, SKU, `Product type`, `Defect rates`
from supply_staging
order by `Defect rates`asc
limit 1; 

-- Chi phí sản xuất trung bình mỗi đơn vị theo loại sản phẩm 
select `Product type`, avg(`Manufacturing costs`) as avg_manufacturing_cost
from supply_staging
group by `Product type`
order by `Product type`; 

-- Mối quan hệ giữa khối lượng sản xuất và tỷ lệ lỗi 
select `Supplier name`, sum(`Production volumes`) as total_vol, avg(`Defect rates`) as avg_defect
from supply_staging
group by `Supplier name`
order by total_vol desc; 

-- C. LOGISTIC ANALYSIS 
-- Tổng chi phí vận chuyển theo đơn vị vận chuyển
select `Shipping carriers`, sum(`Shipping costs`) as total_shipping_cost
from supply_staging
group by `Shipping carriers`; 

-- Thời gian vận chuyển trung bình cho đường hàng không 
select avg(`Shipping times`) as avg_shipping_time
from supply_staging
where `Transportation modes` = 'Air'; 

-- Top 5 nhà cung cấp có chi phí vận chuyển trung bình cao nhất 
select `Supplier name`, avg(`Shipping costs`) as avg_shipping_cost
from supply_staging
group by `Supplier name`
order by  avg_shipping_cost desc
limit 3; 

-- Các tuyến đường có chi phí vận chuyển cao hơn mức trung bình 
select Routes, avg(`Shipping costs`) as avg_route_shipping_cost
from supply_staging
group by Routes
having avg_route_shipping_cost > (Select avg(`Shipping costs`) from supply_staging); 

-- Đơn vị vận chuyển hàng đầu theo từng địa điểm dựa trên khối lượng 
select Location, `Shipping carriers`, sum(`Order quantities`) as total_quanitities
from supply_staging
group by Location, `Shipping carriers`
order by Location, total_quanitities desc; 

-- Phân loại hiệu suất vận chuyển 
select `Shipping carriers`,
		avg(`Shipping times`),
        sum(`Shipping costs`),
        case
			when avg(`Shipping times`) < (select avg(`Shipping times`) from supply_staging) *0.8 then 'Good'
            when avg(`Shipping times`) > (select avg(`Shipping times`) from supply_staging) *1.2 then 'Poor'
			else 'average'
        end as performance_category
from supply_staging
group by `Shipping carriers`; 







