-- Assignment------>Social Media 
-- Project overview----->
-- The social media analytics tool aims to provide comprehensive insights 
-- into understand social media dynamic and including engagement pattern
-- inside the project involved user interaction, content performance and engagement metrics on social media platform.
-- user behaviour and content trends.The project involves managing and analyzing a variety of data 
-- points, such as user profiles, posts, comments, likes, and followers, to enable 
-- detailed performance tracking and trend analysis.


CREATE DATABASE social_media;
USE social_media;

CREATE TABLE users (
    user_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    profile_photo_url VARCHAR(255) DEFAULT 'https://picsum.photos/100',
    bio VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE users
ADD email VARCHAR(30) NOT NULL;

CREATE TABLE photos (
    photo_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    photo_url VARCHAR(255) NOT NULL UNIQUE,
    post_id	INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    size FLOAT CHECK (size<5)
);

CREATE TABLE videos (
  video_id INTEGER AUTO_INCREMENT PRIMARY KEY,
  video_url VARCHAR(255) NOT NULL UNIQUE,
  post_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  size FLOAT CHECK (size<10)
  
);

CREATE TABLE post (
	post_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    photo_id INTEGER,
    video_id INTEGER,
    user_id INTEGER NOT NULL,
    caption VARCHAR(200), 
    location VARCHAR(50) ,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(user_id),
	FOREIGN KEY(photo_id) REFERENCES photos(photo_id),
    FOREIGN KEY(video_id) REFERENCES videos(video_id)
);

CREATE TABLE comments (
    comment_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    comment_text VARCHAR(255) NOT NULL,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(post_id) REFERENCES post(post_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE post_likes (
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(user_id),
    FOREIGN KEY(post_id) REFERENCES post(post_id),
    PRIMARY KEY(user_id, post_id)
);

CREATE TABLE comment_likes (
    user_id INTEGER NOT NULL,
    comment_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(user_id),
    FOREIGN KEY(comment_id) REFERENCES comments(comment_id),
    PRIMARY KEY(user_id, comment_id)
    
);

CREATE TABLE follows (
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES users(user_id),
    FOREIGN KEY(followee_id) REFERENCES users(user_id),
    PRIMARY KEY(follower_id, followee_id)
);

CREATE TABLE hashtags (
  hashtag_id INTEGER AUTO_INCREMENT PRIMARY KEY,
  hashtag_name VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE hashtag_follow (
	user_id INTEGER NOT NULL,
    hashtag_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(user_id),
    FOREIGN KEY(hashtag_id) REFERENCES hashtags(hashtag_id),
    PRIMARY KEY(user_id, hashtag_id)
);

CREATE TABLE post_tags (
    post_id INTEGER NOT NULL,
    hashtag_id INTEGER NOT NULL,
    FOREIGN KEY(post_id) REFERENCES post(post_id),
    FOREIGN KEY(hashtag_id) REFERENCES hashtags(hashtag_id),
    PRIMARY KEY(post_id, hashtag_id)
);

CREATE TABLE bookmarks (
  post_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY(post_id) REFERENCES post(post_id),
  FOREIGN KEY(user_id) REFERENCES users(user_id),
  PRIMARY KEY(user_id, post_id)
);

CREATE TABLE login (
  login_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INTEGER NOT NULL,
  ip VARCHAR(50) NOT NULL,
  login_time TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY(user_id) REFERENCES users(user_id)
);
USE social_media;
select * from users; 
select * from photos; 
select * from videos; 
select * from post; 
select * from comments; 
select * from post_likes;
select * from comment_likes; 
select * from follows; 
select * from hashtags; 
select * from hashtag_follow; 
select * from post_tags; 
select * from bookmarks; 
select * from login;

-- Q.1) Identify Users by Location Write a query to find all posts made by users in specific locations such as 'Agra', 
-- 'Maharashtra', and 'West Bengal'.
select * from social_media.post 
where location = 'agra' or location='maharashtra' or location='west bengal';
--  Problem: It is difficult to understand the geographical 
-- distribution of content created by users in specific locations.
-- Solution: The query retrieves posts from users located in "Agra," "maharashtra," and "west bengal," 
-- helping to analyze regional content trends and user engagement.
-- output: "maharashtra" is the location where the most posts have been made.
-- West Bengal has a moderate number of posts, while Agra shows the lowest level 
-- of activity. 

-- Q.2) Determine the most followed Hashtags
 -- Write a query to list the top 5 most-followed hashtags on the platform.
  select h.hashtag_name, count(hf.user_id) as most_followed
from hashtags h
join hashtag_follow hf on h.hashtag_id = hf.hashtag_id
group  by h.hashtag_name
order by most_followed desc
limit 5;
-- problam: Understanding which hashtags are the 
-- most popular and influential on the platform is challenging.
-- solution: The query retrieves the top 5 hashtags with the highest number of followers.
-- This helps in identifying the most-followed hashtags and understanding user interests and trends.
-- output: festivesale is the most-followed hashtag with the highest number 4 of followers.
-- studentlivesmatter is the second followed hashtag with the highest number 3 of followers.
 
-- Q.3. Find the Most Used Hashtags Identify the top 10 most-used hashtags in posts.
select h.hashtag_name, count(pt.hashtag_id) as most_use_hashtags from hashtags h
join post_tags pt on h.hashtag_id=pt.hashtag_id
group by hashtag_name
order by most_use_hashtags desc limit 10; 
-- problam: Determining which hashtags are most frequently used in posts is essential 
-- for understanding popular topics and trends on the platform.
-- solution: The query retrieves the top 10 hashtags that are most frequently used in posts. 
-- This helps identify the most popular hashtags and gauge their relevance in the content shared by users.
-- output: "beautiful" is the most used hashtag with 21 occurrences, followed by "festivesale" and "socialmedia" 
-- with 19 occurrences each. 
-- Q.4 Identify the Most Inactive User 
-- Write a query to find users who have never made any posts on the platform. 
select  u.user_id, u.username, u.email
from  users u where u.user_id not in (select p.user_id from post p);
--  problam: Identifying users who have never contributed any posts on the platform is challenging. 
-- This information is crucial for understanding user engagement and targeting reactivation strategies.
--  solution:The query retrieves users who do not have any entries in the post table.
--  output: these users Joshua,Ollie,Cameron,George and Jamie users never made any posts.

-- Q.5 Identify the Posts with the Most Likes
-- Write a query to find the posts that have received the highest number of likes.
select p.post_id, p.caption, count(pl.user_id) as most_like_count
from post p
join post_likes pl on p.post_id = pl.post_id
group by  p.post_id, p.caption
order by most_like_count DESC;
--  problam:Identifying which posts have received the highest number of likes is essential 
-- for understanding user engagement and determining the most popular content on the platform.
-- solution: The query retrieves posts along with their like counts and orders them to find the top posts 
-- with the highest number of likes. This helps to highlight the most liked posts and gauge their popularity.
-- output: Post ID 42 has the most likes (24), followed by Post IDs 76 and 16 with 23 likes each.

-- Q.6. Calculate Average Posts per User
-- Write a query to determine the average number of posts made by users.
select (select count(*) from post) / 
    (select count(distinct user_id) from post) as avg_posts_per_user;
-- problam: Problem: It is challenging to understand the overall engagement level of users on the platform.
-- solution: Calculate the average number of posts per user.
-- output:  The average number of posts per user is 2.2222

-- Q.7 Track the Number of Logins per User
-- Write a query to track the total number of logins made by each user.
select u.user_id, u.username, count(l.login_id) as total_logins_per_user
from users u
right join login l on u.user_id = l.user_id
group by u.user_id, u.username
order by total_logins_per_user desc;
-- problam: Track the total number of logins made by each user and identify the top 5 users with the most logins.
-- solution: Count and list the total logins for each user, showing the top 5.
-- output: William is the most active user with 7 logins, followed by Mason and Oscar  with 5 logins. 

-- Q.9. Find Users Who Never Commented
-- Write a query to find users who have never commented on any post.
select u.user_id, u.username
from users u
where  u.user_id not in (
    select c.user_id
    from comments c
);
-- problam: Identify users who have never commented on any post to understand engagement levels.
 -- solution:  Use a NOT IN subquery to filter users whose IDs do not appear in the comments table,
 -- ensuring the final result includes only those who have not commented.
 -- output: The query confirms that "Raj Gupta" has not liked any posts, and his details are returned. 
 
-- Q.10 Identifie the user who Commented on Every Post
-- Write a query to find any user who has commented on every post on the platform.
select u.user_id, u.username
from users u
where (
    select count(distinct p.post_id)
    from post p
) = (
	select count(distinct c.post_id)
    from comments c
    where c.user_id = u.user_id
);
--  problam: It is challenging to determine which users have engaged with every post on the platform by commenting on each one. 
-- Identifying such users is important for understanding complete user engagement and interaction with all available content.
-- solution: The SQL query compares the number of distinct posts commented on by each user with the total number of posts.
--  It selects users who have commented on all posts.
-- output: There are no users who have commented every post

-- Q.11. Identify Users Not Followed by Anyone
-- Write a query to find users who are not followed by any other users.
select u.user_id, u.username
from users u
where u.user_id not in (
    select f.followee_id
    from  follows f
);
 -- Problam: It is challenging to determine which users are not followed by any other users. Identifying such users helps  
-- in understanding which users have no followers, which could be important for engagement analysis or platform growth strategies.
-- solution: The SQL query uses a subquery to find users who do not have any followers by checking for NULL values in the follow relationship.
-- output: There are no users followed by any other users. 

-- Q.12. Identify Users Who Are Not Following Anyone
-- Write a query to find users who are not following anyone.
select u.user_id, u.username
from users u
where u.user_id not in (
    select f.follower_id
    from follows f
);
-- problam: Identifying users who are not following anyone is important for understanding user engagement and activity on the platform.
-- solution: he SQL query uses a subquery to find users who do not have any following relationships by checking for NULL values
-- in the follower relationships.
-- output: There are no users who following anyone.  

-- Q.13. Find Users Who Have Posted More than 5 Times
-- Write a query to find users who have made more than five posts.
select p.user_id, u.username, count(p.post_id) as total_posts
from post p
join users u on p.user_id = u.user_id
group by p.user_id
having count(p.post_id) > 5;
--  problam: It is important to determine which users are highly active on the platform by making
-- more than five posts. This helps in identifying active users and understanding their engagement level. 
-- solution: The SQL query counts the number of posts for each user and filters to include those with more than five posts.
-- output: user_id 37 Ethan made 6 post.  

-- Q.14.Identify Users with More than 40 Followers
-- Write a query to find users who have more than 40 followers.
select f.followee_id as user_id, u.username, count(f.follower_id) as total_followers
from follows f
join users u on f.followee_id = u.user_id
group by f.followee_id
having count(f.follower_id) > 40 ;
-- problam: It is important to identify users who have a significant following on the platform, i.e., 
-- users who have more than 40 followers. This helps in understanding the reach and influence of users on the platform.
-- solution: The SQL query counts the number of followers each user has and filters to include only those with more than 40 followers.
-- output: the user "Charlie" has the highest 45 follower count, followed by others with equal counts.

-- Q.15.Search for Specific Words in Comments
-- Write a query to find comments containing specific words like "good" or "beautiful."
select c.comment_id, c.comment_text, c.created_at, u.username
from comments c
join users u on c.user_id = u.user_id
where c.comment_text regexp '\\b(good|beautiful)\\b';
-- problam: Understanding which comments contain specific positive or aesthetically pleasing words like "good" or "beautiful" 
-- is crucial for analyzing user sentiment and identifying popular themes in user feedback.
-- solution: The query retrieves comments from the comments table that include either the word "good" or "beautiful" in 
-- their text.
-- This helps in identifying and analyzing comments that use these keywords, which can be useful for sentiment analysis or 
-- content evaluation. 
-- output: The results show that most comments are about beauty and looking good. They reflect a lot of positive feedback 
-- and admiration.   

-- Q.16. Identify the Longest Captions in Posts
-- Write a query to find the posts with the longest captions.
select p.post_id, p.caption, u.username, LENGTH(p.caption) AS caption_length
from post p
join users u on p.user_id = u.user_id
order by caption_length desc
limit 5;
-- problam: Identifying which posts have the longest captions is useful for understanding which posts provide the most 
-- detailed or descriptive content.
-- solution: calculates the length of each caption, and sorts the posts by caption length in descending order. This allows you to find 
-- and list the posts with the longest captions. 
-- output: Post_id 81 has the longest caption with 80 characters and the second Post_id 98 has the second-longest caption with 76 characters 

-- we learned from about database and their queries with insights----->

-- Analyze User Activity: Understand how users interact with the platform by looking at posts, likes, and logins.
-- Identify Trends: Find out which hashtags are popular and which posts get the most attention.
-- Understand Engagement: See how active users are and identify those who are less engaged or not contributing.
-- Improve Strategies: Use these insights to develop strategies for increasing user interaction and optimizing content.
-- Overall, the project helps in making informed decisions to enhance user experience and platform growth.



