
-- Creates a View for the Union of the QBs, RBs, and WRs Tables
CREATE VIEW Union_Stats AS
SELECT rk, Year, Player, Pos, Yards, Wins, Playoffs,`Cap Pct`, `Draft Pos`, age
FROM QBs
UNION ALL
SELECT rk, Year, Player, Pos, Yards, Wins, Playoffs,`Cap Pct`, `Draft Pos`, age
FROM RBs
UNION ALL
SELECT rk, Year, Player, Pos, Yards, Wins, Playoffs,`Cap Pct`, `Draft Pos`, age
FROM WRs;


-- Average yards for Top 15 in each position between given years
SELECT 
    Pos,
    ROUND((AVG(CASE WHEN Year BETWEEN 1994 AND 2003 THEN Yards ELSE NULL END)),2) AS avg_yards_1994_to_2003,
    ROUND((AVG(CASE WHEN Year BETWEEN 2004 AND 2013 THEN Yards ELSE NULL END)),2) AS avg_yards_2004_to_2013,
    ROUND((AVG(CASE WHEN Year BETWEEN 2014 AND 2023 THEN Yards ELSE NULL END)),2) AS avg_yards_2014_to_2023
FROM Union_Stats
GROUP BY Pos;

-- Average yards for each position between given years for playoff teams
SELECT 
    Pos,
    ROUND((AVG(CASE WHEN Year BETWEEN 1994 AND 2003 AND Playoffs = 'Yes' THEN Yards ELSE NULL END)),2) AS avg_yards_1994_to_2003,
    ROUND((AVG(CASE WHEN Year BETWEEN 2004 AND 2013 AND Playoffs = 'Yes' THEN Yards ELSE NULL END)),2) AS avg_yards_2004_to_2013,
    ROUND((AVG(CASE WHEN Year BETWEEN 2014 AND 2023 AND Playoffs = 'Yes' THEN Yards ELSE NULL END)),2) AS avg_yards_2014_to_2023
FROM Union_Stats
GROUP BY Pos;

-- Average wins by Top 15 for each position between given years
SELECT 
    Pos,
    ROUND((AVG(CASE WHEN Year BETWEEN 1994 AND 2003 THEN Wins ELSE NULL END)),2) AS avg_wins_1994_to_2003,
    ROUND((AVG(CASE WHEN Year BETWEEN 2004 AND 2013 THEN Wins ELSE NULL END)),2) AS avg_wins_2004_to_2013,
    ROUND((AVG(CASE WHEN Year BETWEEN 2014 AND 2023 THEN Wins ELSE NULL END)),2) AS avg_wins_2014_to_2023
FROM Union_Stats
GROUP BY Pos;

-- Number of playoff wins by the top 15 productive players between given years
SELECT 
    Pos,
    ROUND((SUM(CASE WHEN Year BETWEEN 1994 AND 2003 AND Playoffs = 'yes' AND rk < 15 THEN 1 ELSE 0 END)),2) AS playoffs_wins_1994_to_2003,
    ROUND((SUM(CASE WHEN Year BETWEEN 2004 AND 2013 AND Playoffs = 'yes' AND rk < 15 THEN 1 ELSE 0 END)),2) AS playoffs_wins_2004_to_2013,
    ROUND((SUM(CASE WHEN Year BETWEEN 2014 AND 2023 AND Playoffs = 'yes' AND rk < 15 THEN 1 ELSE 0 END)),2) AS playoffs_wins_2014_to_2023
FROM Union_Stats
GROUP BY Pos;

-- Average Draft position for each position who made the playoffs
SELECT 
    Pos,
    ROUND((AVG(CASE WHEN Year BETWEEN 1994 AND 2003 AND Playoffs = 'yes' THEN `Draft Pos` ELSE NULL END)),0) AS avg_wins_1994_to_2003,
    ROUND((AVG(CASE WHEN Year BETWEEN 2004 AND 2013 AND Playoffs = 'yes' THEN `Draft Pos` ELSE NULL END)),0) AS avg_wins_2004_to_2013,
    ROUND((AVG(CASE WHEN Year BETWEEN 2014 AND 2023 AND Playoffs = 'yes' THEN `Draft Pos` ELSE NULL END)),0) AS avg_wins_2014_to_2023
FROM Union_Stats
GROUP BY Pos;

-- Average age for players who made the playoffs between given years
SELECT 
    Pos,
    ROUND((AVG(CASE WHEN Year BETWEEN 1994 AND 2003 AND Playoffs = 'yes' THEN age ELSE NULL END)),0) AS avg_wins_1994_to_2003,
    ROUND((AVG(CASE WHEN Year BETWEEN 2004 AND 2013 AND Playoffs = 'yes' THEN age ELSE NULL END)),0) AS avg_wins_2004_to_2013,
    ROUND((AVG(CASE WHEN Year BETWEEN 2014 AND 2023 AND Playoffs = 'yes' THEN age ELSE NULL END)),0) AS avg_wins_2014_to_2023
FROM union_stats us 
GROUP BY Pos;

-- Average salary cap percentage for players who made the playoffs vs Top Teams Overall between given years
SELECT 
    Pos,
    ROUND((AVG(CASE WHEN Year BETWEEN 1994 AND 2003 AND Playoffs = 'yes' THEN `Cap Pct` ELSE NULL END)),2) AS avg_cap_playoffs_1994_to_2003,
    ROUND((AVG(CASE WHEN Year BETWEEN 1994 AND 2003 THEN `Cap Pct` ELSE NULL END)),2) AS avg_cap_TopTeams_1994_to_2003,
    ROUND((AVG(CASE WHEN Year BETWEEN 2004 AND 2013 AND Playoffs = 'yes' THEN `Cap Pct` ELSE NULL END)),2) AS avg_cap_playoffs_2004_to_2013,
    ROUND((AVG(CASE WHEN Year BETWEEN 2004 AND 2013 THEN `Cap Pct` ELSE NULL END)),2) AS avg_cap_TopTeams_2004_to_2013,
    ROUND((AVG(CASE WHEN Year BETWEEN 2014 AND 2023 AND Playoffs = 'yes' THEN `Cap Pct` ELSE NULL END)),2) AS avg_cap_playoffs_2014_to_2023,
    ROUND((AVG(CASE WHEN Year BETWEEN 2014 AND 2023 THEN `Cap Pct` ELSE NULL END)),2) AS avg_cap_TopTeams_2014_to_2023
FROM union_stats us 
GROUP BY Pos;


-- MAX salary cap percentage for top teams

SELECT 
    us.Pos,
    (SELECT MAX(`Cap Pct`) FROM union_stats us1 WHERE us1.Pos = us.Pos AND us1.Year BETWEEN 1994 AND 2003) AS max_cap_1994_to_2003,
    (SELECT MAX(`Cap Pct`) FROM union_stats us2 WHERE us2.Pos = us.Pos AND us2.Year BETWEEN 2004 AND 2013) AS max_cap_2004_to_2013,
    (SELECT MAX(`Cap Pct`) FROM union_stats us3 WHERE us3.Pos = us.Pos AND us3.Year BETWEEN 2014 AND 2023) AS max_cap_2014_to_2023
FROM 
    union_stats us
GROUP BY 
    us.Pos;

SELECT *
FROM union_stats us 
	

