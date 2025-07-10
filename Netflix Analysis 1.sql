-- Netflix Project 

-- Creating Database

Drop table if exists netflix;

Create Table Netflix 
(
	show_id varchar(7) Primary Key,
	type varchar(10),
	title varchar(150),
	director varchar(210),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year int, 
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(150),
	description varchar(250)
)

select * from netflix;

select count(*) from netflix;


-- Q1. Count the number of Movies and TV Shows

--select * from netflix where type = 'Movies' and type = 'TV Show'; 

Select type, count(*) as total_count from netflix group by type;


-- Q2. Find the most commmon ratings for the Movies and TV Shows

Select 
	Type,
	rating
from
(
Select 
	Type,
	rating,
	count(*),
	Rank() Over(Partition By Type Order by count(*) DESC) as ranking
from netflix
group by 1, 2
) as t1
where ranking = 1
	

-- Q3. List all the movies released in a specific year(e.g., 2020)

Select 
	title
from netflix as movie_name
where type = 'Movie' and release_year = '2020';


-- Q4. Find the top 5 countries with the most content on Netflix

select 
	Unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1 
order by 2 DESC 
limit 5


-- Q5. Identify the longest Movie?

-- select 
-- 	title
-- from netflix 
-- where type = 'movie'
-- group by 1;

select 
	title, 
	duration
from netflix 
where 
	type = 'Movie'
	And
	duration = (select Max(duration) from netflix)

-- Q6. Find the content added in the last 5 years

Select *
from netflix
where To_date(date_added, 'Month DD, YYYY') >= CURRENT_DATE - interval '5 years'


-- Q7. Find all the movies/tv shows by director 'Rajiv Chilaka'

Select * from netflix
where director = 'Rajiv Chilaka';

 -- OR

 select * from netflix
 where director LIKE '%Rajiv Chilaka%';

-- Q8. List all TV shows with more than 5 seasons 

Select * 	
from netflix 
where 
	type = 'TV Show' 
	And 
	SPLIT_PART(duration, ' ', 1) :: numeric > 5;


-- Q9. Count the number of content items in each genre

Select 
	UNNEST(string_to_Array(listed_in, ',')) as genre,
	count(show_id)
from netflix
group by 1


-- Q10. Find each year and the average numbers of content release in India on netflix. Return top 5 year with highest avg content release

Select 
	Extract(Year From To_date(date_added, 'Month DD, YYYY')) as year,
	count(*) as yearly_content,
	Round(
	count(*) :: numeric/(select count(*) from netflix where country = 'India') :: numeric * 100
	,2) as avg_content_per_year
from netflix
where country = 'India'
Group by 1;



-- Q11. List all the movies that are documentaries.

Select * from netflix where listed_in ILIKE '%documentaries%'


-- Q12. Find all content without a director

select 
	*
from netflix 
where director IS NULL;



-- Q13. Find how many movies actor 'Salman Khan' appeared in last 10 year.

Select * from netflix
where 
	casts Ilike '%Salman Khan%'
	And 
	release_year > Extract(Year From Current_Date) - 10


-- Q14. Find the top 10 actors who have appeared in the highest number of  movies produced in India.



	

