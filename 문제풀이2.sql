-- finde the users who have never posted a photo

SELECT username
    FROM users
    LEFT JOIN photos
        ON users.id = photos.user_id
    WHERE photos.created_at IS NULL;

/* 
   We're running a new contest
   to see who can get the most likes
   on a single photo.
   WHO WON??!!
*/

SELECT 
    username,
    photos.id,
    photos.image_url, 
    COUNT(*) AS total
FROM photos
INNER JOIN likes
    ON likes.photo_id = photos.id
INNER JOIN users
    ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;

/*
Our Investors want to know...
How many times does the average user post?
*/

SELECT username,
       COUNT(*)
FROM users
LEFT JOIN photos
    ON users.id = photos.user_id
GROUP BY username
LIMIT 30;

SELECT (SELECT Count(*) 
        FROM   photos) / (SELECT Count(*) 
                          FROM   users) AS avg; 
/*
A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?
*/

SELECT tag_name
    COUNT(tag_name)
FROM tags
    INNER JOIN photo_tags
        ON tags.id = photo_tags.tag_id
GROUP BY tag_name
ORDER BY COUNT(tag_name) desc
LIMIT 1;

/*
We have a small problem with bots on our site...
Find users who have liked every single photo on the site
*/

SELECT username,COUNT(photos.id) as count
FROM users
    INNER JOIN likes
        ON likes.user_id = users.id    
    INNER JOIN photos
        ON likes.photo_id = photos.id
GROUP BY username
;


