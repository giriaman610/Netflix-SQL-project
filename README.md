# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select type,count(*) as Total_count
from netflix
group by type

```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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

```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select * from netflix
where release_year=2020 and type='Movie'

```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select unnest(string_to_array(country,',')) as new_countries,count(*) as total_content_released
from netflix
group by 1
order by 2 desc
limit 5
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select type,title,duration,
cast(split_part(duration,' ',1)as integer) as longest_movie
from netflix
where type= 'Movie' and duration is not null
order  by 4 desc
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select *
from netflix
where date_added>=current_date -  interval' 5 year'
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from
  netflix
where director ILIKE'%Rajiv Chilaka%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select duration,
cast(split_part(duration,' ',1)as integer) as number_of_seasons,title
from netflix
where type='TV Show' and cast(split_part(duration,' ',1)as integer)>5
order by 2 desc

```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select unnest(string_to_array(listed_in,',')) as genres,count(*) as number_of_items
from netflix
group by 1
order by 2 desc
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select unnest(string_to_array(listed_in,',')) as genre
from netflix
where listed_in='Documentaries'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select * from netflix
where director is null

```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select * from netflix
where cast_ like '%Salman Khan%' and
release_year >extract(year from current_date)-10

```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
select unnest(string_to_array(cast_,',')) as actors,count(*) as total_count
from netflix
where country ilike '%India%' and type='Movie'
group by 1
order by 2 desc
limit 10
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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

```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


