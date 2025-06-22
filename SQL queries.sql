drop table if exists netflix
create table Netflix(
show_id varchar(15) primary key ,
type TEXT,
title TEXT,
director TEXT,
cast_ TEXT,
country	TEXT,
date_added DATE,
release_year integer,
rating	varchar(30),
duration TEXT,
listed_in	varchar(100),
description varchar(250)
)

select * from netflix

--Q1.Count the Number of Movies vs TV Shows
select type,count(*) as Total_count
from netflix
group by type

--Q2.Find the Most Common Rating for Movies and TV Shows
select * from netflix
with ans as(
select type ,rating,count(rating),
row_number() over(partition by type order by count(rating) desc) as row_num
from netflix
group by 1,2
order by type,3 desc
)
select * from ans
where row_num<=1

--Q3.List All Movies Released in a Specific Year (e.g., 2020)
select * from netflix
where release_year=2020 and type='Movie'

--Q4.Find the Top 5 Countries with the Most Content on Netflix

select unnest(string_to_array(country,',')) as new_countries,count(*) as total_content_released
from netflix
group by 1
order by 2 desc
limit 5

--Q5.Identify the Longest Movie

select type,title,duration,cast(split_part(duration,' ',1)as integer) as longest_movie
from netflix
where type= 'Movie' and duration is not null
order  by 4 desc

--Q6.Find Content Added in the Last 5 Years
select date_added as before_five_years ,*
from netflix
where date_added>=current_date -  interval' 5 year'

--Q7.Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select director,* from  netflix
where director ILIKE'%Rajiv Chilaka%' -- ilike handles the case sensitive
--names and ingnore small and large letters to give all names of the director

--Q8.List All TV Shows with More Than 5 Seasons

select duration,
cast(split_part(duration,' ',1)as integer) as number_of_seasons,title
from netflix
where type='TV Show' and cast(split_part(duration,' ',1)as integer)>5
order by 2 desc


--Q9.Count the Number of Content Items in Each Genre

select unnest(string_to_array(listed_in,',')) as genres,count(*) as number_of_items
from netflix
group by 1
order by 2 desc

--Q10.Find each year and the average  content release in India on netflix.
--return top 5 year with highest avg content release!

with content_count as(
select extract(year from date_added) as year_,count(*) as number_of_content
from netflix
where country='India'
group by  1
)
select  year_,number_of_content,
round(number_of_content::numeric/(select count(*)from netflix where country='India')::numeric*100,2) as avg_value
from content_count
group by  1,2
order by 2 desc
limit 5

--Q11.List All Movies that are Documentaries

select unnest(string_to_array(listed_in,',')) as genre
from netflix
where listed_in='Documentaries'


--Q12.Find All Content Without a Director
select * from netflix
where director is null

--Q13.Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
 
select * from netflix
where cast_ like '%Salman Khan%' and
release_year >extract(year from current_date)-10

--Q14.Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

select unnest(string_to_array(cast_,',')) as actors,count(*) as total_count
from netflix
where country ilike '%India%' and type='Movie'
group by 1
order by 2 desc
limit 10

--Q15.Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords in the description field
-- Label this content as 'Bad' and other content is 'good' and also count the number of items in each category

select description,* from netflix
where description ilike '%Kill%' or
description ilike '%violence%'

ALTER TABLE netflix
ADD COLUMN keyword TEXT;

update netflix
set  keyword='Bad'
where description ilike '%Kill%' or
description ilike '%violence%'

update netflix
set  keyword='Good'
where description not ilike '%Kill%' and
description not ilike '%violence%'


select keyword,count(*) as category_count
from netflix
group by 1






