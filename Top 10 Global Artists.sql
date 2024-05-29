-- Top 5 artists whose songs appear most frequently in the Top 10 global rankings
WITH Top_Ten AS
(
SELECT
a.artist_name,
DENSE_RANK() OVER(
ORDER BY COUNT (s.song_id) DESC) as artist_rank
FROM artists a
JOIN songs s
ON a.artist_id = s.artist_id
JOIN global_song_rank gsr 
ON s.song_id = gsr.song_id
WHERE rank <=10
GROUP BY a.artist_name
)

SELECT 
artist_name,
artist_rank
FROM Top_Ten
WHERE artist_rank <= 5;