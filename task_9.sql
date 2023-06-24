

update cran_logs_2015_01_01
 set download_date=replace(download_date,'"','');
 update cran_logs_2015_01_01
 set ip_id=replace(ip_id,'"','');
 
-- 9.1 Give the package name and how many times they're downloaded. Order by the 2nd column descently.
select distinct package,
count(package) over (PARTITION by package) as count_download
from cran_logs_2015_01_01
order by count_download DESC; 
 -- or
select *, count(package)
from cran_logs_2015_01_01
group by package
order by count(package) desc;
-- 9.2 Give the package ranking (based on how many times it was downloaded) during 9AM to 11AM
select package,time, count(*),
    rank() over(ORDER BY COUNT(*) DESC) as rnk
    from cran_logs_2015_01_01
    where time BETWEEN "09:00:00" and  "11:00:00"
    group by package;

-- or
select *, count(package) as ranking
from cran_logs_2015_01_01
where time between '09:00:00' and '11:00:00'
group by package
order by count(package) desc



-- 9.3 How many recordings are from China ("CN") or Japan("JP") or Singapore ("SG")?
select count(country) as count, country
from cran_logs_2015_01_01
group by country
having country like 'cn'
UNION
select count(country) as count, country
from cran_logs_2015_01_01
group by country
having country like 'jp'
UNION
select count(country) as count, country
from cran_logs_2015_01_01
group by country
having country like 'sn'

-- or here you can see the effect of speeding of query by using  INDEX
CREATE INDEX cranCountry 
ON cran_logs_2015_01_01(country);
SELECT DISTINCT(country), (SELECT count(*) from cran_logs_2015_01_01  x where c.country = x.country) as "Number"
FROM cran_logs_2015_01_01 c
where c.country IN ("CN","JP","SG");

-- 9.4 Print the countries whose downloaded are more than the downloads from China ("CN")
select count(country) as count, country
from cran_logs_2015_01_01
group by country
having count(country) > (select count(country) 
from cran_logs_2015_01_01
group by country
having country like 'cn')
-- 9.5 Print the average length of the package name of all the UNIQUE packages
SELECT length(package),package
from cran_logs_2015_01_01;

SELECT avg(length(package))
from cran_logs_2015_01_01;
-- 9.6 Get the package whose download count ranks 2nd (print package name and its download count).
select m.package
FROM
(
    select package, count(*),
    rank() over (order by count(*) DESC) as ranking
FROM cran_logs_2015_01_01
group by package
) as m
WHERE m.ranking = 2;

-- or

select m.package
from
 (select package, count(*),
row_number() over (order by count(*) DESC) as ranking
FROM cran_logs_2015_01_01
group by package) as m
where m.ranking =2;
;

-- 9.7 Print the name of the package whose download count is bigger than 1000.
select m.count_download, m.package
from
(select distinct package,
count(package) over (PARTITION by package) as count_download
from cran_logs_2015_01_01
order by count_download DESC) as m
where m.count_download > 1000;

-- 9.8 The field "r_os" is the operating system of the users.
    -- 	Here we would like to know what main system we have (ignore version number), the relevant counts, and the proportion (in percentage).
create TEMPORARY table if not exists table1  as
SELECT count(r_os)
from cran_logs_2015_01_01;


select distinct r_os, (select count(r_os) from cran_logs_2015_01_01) as sum,
count(r_os) over (PARTITION by r_os) as count_download
from cran_logs_2015_01_01
order by count_download  desc


select r_os, count(r_os) as 'Count', round((count(r_os) * 100.0 / (select count(r_os) from cran_logs_2015_01_01)),4) as 'proportion'
from cran_logs_2015_01_01
group by r_os
order by count(r_os) desc;

---- the most correct answer is: 
with r_os_new as (
select substr(r_os, 1,5) as r_new  from cran_logs_2015_01_01)

select r_new, count(r_new) as 'Count', round((count(r_new) * 100.0 / (SELECT count(r_os) from cran_logs_2015_01_01)),4) as 'proportion'
from r_os_new
group by r_new
order by count(r_new) desc;

-- even better one
select rtrim(r_os, "0123456789.") as os, count(*) as "count_of_os", round(100* count(*)/(SELECT count(*) FROM cran_logs_2015_01_01),2) as percentage
from cran_logs_2015_01_01
GROUP by os;



-- not so good one

SELECT "Darwin" AS r_os ,count(r_os) as "count_of_os", 100*count(r_os)/(SELECT count() FROM cran_logs_2015_01_01) AS percentage
FROM cran_logs_2015_01_01
Where r_os like "darwin%"
UNION
SELECT "Linux",count(r_os)as "count_of_os", 100*count(r_os)/(SELECT count() FROM cran_logs_2015_01_01)
FROM cran_logs_2015_01_01
Where r_os like "linux%"
UNION
SELECT "Ming", count(r_os)as "count_of_os", 100*count(r_os)/(SELECT count() FROM cran_logs_2015_01_01)
FROM cran_logs_2015_01_01
Where r_os like "ming%"
UNION 
SELECT "NA", count(r_os)as "count_of_os", 100*count(r_os)/(SELECT count() FROM cran_logs_2015_01_01)
FROM cran_logs_2015_01_01
WHERE r_os like "N%"
;
