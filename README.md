# commute_times

## Executive Summary
Traffic is something everyone has encountered, but are there any patterns to how long traveling takes? While traffic is far from optimized in the US, I wanted to investigate if any factors make traffic and commute times better or worse in certain areas. In addition, I also wanted to assess any correlations between commute time and other aspects of a county/state. Data can include (but is not limited to) geospatial data, count of objects by county, population trends, and government provided datasets. I will only be looking at US data as that is my primary focus. Anticipated challenges include loading sufficient data into a legible map, creating filters by time frame, and organizing/cleaning the data to be used.

## Motivation
Everyone encounters traffic whenever they need to travel. I wanted to see which states have better travel times and what other elements of a state correlate with commute times. If there are any surprising factors, I would like to dig in and see if there are any explanations for why. From there, I would hope to implement this knowledge to help lower overall travel times across the country in the future.

## Data Question
What factors correlate with commute time? To what extent do population and other modes of transportation affect travel times? Which modes of transportation are the most used and which ones yield the shortest commute times? Which states and counties have the most workers who commute?

## Minimum Viable Product (MVP)
Describe what factors influence commute times the most. Create heat maps based on traffic flow and charts to visualize what elements impact commute time. Can also filter data based on year. Audience would be for traffic engineers, transportation-based companies, and anyone who wants to advocate for shorter commute times.

## Schedule (through 1/4/2024)
1.	Get the Data (12/1/2023)
2.	Clean & Explore the Data (12/10/2023)
3.	Create Presentation of your Analysis (12/15/2023 – draft for internal demo)
4.	Internal demos (12/15/2023)
5.	Demo Day!! (1/4/2023)



## Data Sources
### My main datasets:
https://data.census.gov/table/ACSST1Y2010.S0802?q=commute%20time&g=010XX00US$0500000

### Other Possible datasets (if I have time):
https://cdan.dot.gov/Homepage/MotorVehicleCrashDataOverview.htm
https://www.bts.gov/topics/national-transportation-statistics
https://roundabouts.kittelson.com/Roundabouts/Search

## Known Issues and Challenges
Will need to convert Census data to csv and slice the data to find correlations.
Will need to determine how to combine different datasets (if other data is used).
May need to web-scrape some data from specific sites (namely the roundabouts site)



## Process

### Cleaning

#### Commute Times
There were many steps to clean the data. After downloading each dataset from each year (2010-2023, excluding 2020), I decided to slice the data into different categories. The first category I tackled was travel time.

This part of the process is chronicled in commute_cleaning.ipynb. After reading the data in, I filtered through the columns I needed (anything that had "Travel Time" in the name) to make into a new dataframe. From there, I needed to clean up the the columns names from the ones I kept. Afterward, I added a "State" column.

The first major roadblock I came across was how the data was shown. It gave most information as a percentage of a certain population. I could aggregate percentages and the results would still be percentages, but given how each county and state has a different sample size, taking percentages wouldn't be very useful (as percentages would easily become skewed if there was a very small or very large county).

In order to find a way around this, I found the work force size for each county (which was already present in the original dataset) and used those numbers to multiply to the percentages, giving me a raw number of how many people were taking which mode of transportation.

Now, this procedure had only been done on one dataset (the one from 2021), but now I needed to do it on every dataset. So, I created a function to do the whole process in one go.. except I soon realized that there was a clear distinction between table before and after 2018. The order of the columns and how they were named differed, so I needed to account for that in my function. After much hassle, I got it to work.

So with cleaned-up commute time tables, how hard could another category be?

#### Age
These tables had their own problems, but I was now well equiped to solve them. Once again, there was a difference between the tables before and after 2018, so I was able to work with that knowledge from the get-go. As such, the process went very smoothly (especially since I had already done the hard work of translating percentages to integers).

I was on a roll! The next thing I wanted to do was compare these two categories. But before I could do that, I wanted to get these tables into PostgreSQL since SQL could easily answer the questions I had asked for this project.

#### PostgresSQL
While I had all of these tables, I wanted to combine every table from each category into one giant table. So, I added a "Year" column and tried to concat them, but it didn't work. The thing is, not all of the column names matched and some of the dataframe sized were different, which caused issues. So, in order to fix this *and to come up with columns names that would be easy to call in SQL*, I had to overhaul the column names... again.

This took a while. I took the approach of using the string replace method for every phrase I wanted to replace (which sounds nice, but it quickly became tedious). I ended up using the sub regular expressions method for one specific thing since replace wasn't cutting it. If I had to do this part over, I would definitely use regex for as much as possible.

Still, I finally was able to line up all the column names and put everything into one table to send to PostgreSQL. Now, I could finally tackle some of the questions I was wondering about in an easy and straightforward approach.

#### Thought I was done yet?
After loading the tables into SQL, I came across something odd. There were a few values that said the median age of county workers was 23,658. Obviously, this is incorrect, and so I figured that there was an aggregation that went wrong (namely, a sum happening instead of an average). So now I had to track down this issue!

The only time this issue occurred was whenever the year was 2018, so I knew I had to focus on that original table to see what was up. After looking and some trial and error, here's what was up:
    1. There was a column called "Workers 16 and over who did not work *at* home" (emphasis added on "at"). This is a problem because the tables after 2018 use "from" and not "at."
    2. The order of the columns was quite silly. It had the total travel times together at the beginning, but then cycled through the other subcategories at the end, tagging the mean/median columns at the end of the dataframe. 
Before 2018, the subcategories cycled consistently, which made it easy. After 2018, each subcategory was grouped, which was also easy. The fact 2018 couldn't make up its mind was the source of the issue. I'm not sure what happened in 2018, but the way the data was collected had an impact on how this data was cleaned.

Well, it was after working on this, I made another shocking discovery: *every table has a column for workers who don't work at home!* Before 2019, it always used "at" and since 2019 it uses "from"! This minute detail has messed with me for a very long time: I was under the impression they didn't keep track of that until 2019, but I was very wrong. So after fixing some of that code, I now have the data in a good spot.