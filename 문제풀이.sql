SELECT
    title,
    avg(rating) as 'avg_rating'
FROM series
JOIN reviews
    ON series.id = reviews.series_id
GROUP BY series.id
ORDER BY avg_rating;


SELECT * FROM reviewers;

select genre,avg(rating)as avg_rating from series
    INNER JOIN reviews
    ON series.id = reviews.series_id
    GROUP BY genre

    reviewers.first_name as first_name,
    reviewers.last_name as last_name, 

SELECT 
    MAX(reviewers.first_name),
    MAX(reviewers.last_name),
    COUNT(reviews.reviewer_id) as COUNT,
    IFNULL(MIN(reviews.rating),0) as MIN,
    IFNULL(MAX(reviews.rating),0) as MAX,
    IFNULL(AVG(reviews.rating),0) as AVG,
    CASE 
        WHEN reviews.reviewer_id IS NULL THEN 'INACTIVE'
        ELSE 'ACTIVE'
    END AS 'STATUS'
FROM reviewers
    LEFT JOIN reviews
    ON reviewers.id = reviews.reviewer_id
    GROUP BY reviews.reviewer_id;



