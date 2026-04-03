/* =========================================================
   📊 ROAD ACCIDENT RISK ANALYSIS - SQL PROJECT
   ========================================================= */

-- 1️⃣ View Dataset
SELECT *
FROM accidents;


-- 2️⃣ Top City in Each State by Accident Count
WITH accident_count AS (
    SELECT 
        state,
        city,
        COUNT(accident_id) AS total_accidents,
        ROW_NUMBER() OVER (
            PARTITION BY state 
            ORDER BY COUNT(accident_id) DESC
        ) AS accident_rank
    FROM accidents
    GROUP BY state, city
)
SELECT 
    state AS "State",
    city AS "City",
    total_accidents AS "Total Accidents",
    accident_rank AS "Rank"
FROM accident_count
WHERE accident_rank = 1;


-- 3️⃣ State-wise Risk Analysis
SELECT 
    state AS "State",
    ROUND(AVG(risk_score)::numeric, 3) AS "Average Risk Score",
    COUNT(accident_id) AS "Total Accidents"
FROM accidents
GROUP BY state
ORDER BY "Average Risk Score" DESC;


-- 4️⃣ Accident Count by Cause
SELECT 
    cause AS "Accident Cause",
    COUNT(accident_id) AS "Total Accidents"
FROM accidents
GROUP BY cause
ORDER BY "Total Accidents" DESC;


-- 5️⃣ Top 5 High-Risk Cities
SELECT 
    city AS "City",
    ROUND(AVG(risk_score)::numeric, 3) AS "Average Risk Score"
FROM accidents
GROUP BY city
ORDER BY "Average Risk Score" DESC
LIMIT 5;


-- 6️⃣ Risk by Vehicle Category
WITH vehicle_base AS (
    SELECT 
        CASE 
            WHEN vehicles_involved = 1 THEN 'One Wheeler'
            WHEN vehicles_involved = 2 THEN 'Two Wheeler'
            WHEN vehicles_involved = 3 THEN 'Three Wheeler'
            WHEN vehicles_involved = 4 THEN 'Four Wheeler'
            ELSE 'Five or More'
        END AS vehicle_type,
        risk_score
    FROM accidents
)
SELECT 
    vehicle_type AS "Vehicle Type",
    ROUND(AVG(risk_score)::numeric, 3) AS "Average Risk Score"
FROM vehicle_base
GROUP BY vehicle_type
ORDER BY "Average Risk Score" DESC;


-- 7️⃣ Weekend Accidents in Urban Areas
SELECT 
    COUNT(accident_id) AS "Weekend Urban Accidents"
FROM accidents
WHERE road_type = 'Urban'
  AND is_weekend = 'Yes';


-- 8️⃣ Peak Hour Accidents in Urban Areas
SELECT 
    COUNT(accident_id) AS "Peak Hour Urban Accidents"
FROM accidents
WHERE road_type = 'Urban'
  AND is_peak_hour = 'Yes';


-- 9️⃣ Fatal Accidents by Cause
SELECT 
    cause AS "Cause",
    COUNT(accident_id) AS "Fatal Accidents"
FROM accidents
WHERE accident_severity = 'Fatal'
GROUP BY cause
ORDER BY "Fatal Accidents" DESC;


-- 🔟 Festival vs Normal Day Risk Comparison
SELECT 
    CASE 
        WHEN festival = 'Normal Day' THEN 'Normal Days'
        ELSE 'Festival Days'
    END AS "Event Type",
    COUNT(accident_id) AS "Total Accidents"
FROM accidents
GROUP BY "Event Type"
ORDER BY "Total Accidents" DESC;


-- 1️⃣1️⃣ Most Dangerous Day of the Week
SELECT 
    day_of_week AS "Day",
    COUNT(accident_id) AS "Total Accidents"
FROM accidents
GROUP BY day_of_week
ORDER BY "Total Accidents" DESC;