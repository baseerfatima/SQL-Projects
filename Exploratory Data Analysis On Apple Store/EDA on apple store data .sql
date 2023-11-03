Create Table Apple_store_description_combined AS

Select * From appleStore_description1
Union ALL
Select * From appleStore_description2
Union ALL
Select * From appleStore_description3
Union ALL
Select * From appleStore_description4

**Exploratory Data Analysis**
---check number of unique apps in Both Tables
Select Count (DISTINCT id) As Unique_ID FRom AppleStore

Select Count (DISTINCT id) As Unique_ID FRom Apple_store_description_combined

---check for missing value in key fields

Select Count(*) As Missing_Val
From AppleStore
Where track_name is NUll Or user_rating is Null Or prime_genre Is Null

Select Count(*) As Missing_Val
From Apple_store_description_combined
Where app_desc is NUll 

---Find Number of Apps Per Genre
Select prime_genre , COUNT(*) As numapps
From AppleStore
GROUP BY prime_genre
order BY numapps DESC

--Find User Rating

Select max(user_rating) as max_rating,
min(user_rating) As min_rating,
avg(user_rating) AS avg_rating
from AppleStore

** DATA ANALYSIS **
--check whether paid apps have higher ratings than free apps
SElect case 
			When price > 0 Then 'paid'
			else 'free
'	   end as App_Type,
	   avg(user_rating) as Avg_rating 
    
    from AppleStore
    group by App_Type
    
 -- check whether apps with more supported languages have higher ratings
 
 SElect case 
			When lang_num < 10 Then '< than 10 langauges'
            When lang_num Between 10 And 30 Then '10-30 langauges'
			else '> than 30 languages
'	   end as language_bucket,
	   avg(user_rating) as Avg_rating 
    
    from AppleStore
    group by language_bucket
    order by Avg_rating DESC
    
    --check genre with low rating
    select prime_genre, avg(user_rating) as Avg_rating
    from AppleStore
    group by prime_genre
    order by Avg_rating Asc
    limit 10
    
    -- check if there is correaltion between lenght  app description and user rating 
    SElect case 
			When length(b.app_desc) < 500 Then 'short'
            When length(b.app_desc) between 500 and 1000 Then 'medium'
			else 'long
'	   end as description_length_bucket,
	   avg(a.user_rating) as Avg_rating 
 
    from AppleStore as a 
    join Apple_store_description_combined As b 
    on a.id=b.id 
    group by description_length_bucket
    order by Avg_rating desc 
    
  -- Check the Top Rated apps for each genre 
  select prime_genre,
  track_name,
  user_rating
  from
  (
   select prime_genre,
  track_name,
  user_rating,
  Rank() OVER(PARTITION By prime_genre order by user_rating desc, rating_count_tot Desc ) as rank
    from AppleStore
  ) 
    as a
  where a.rank=1
  
 