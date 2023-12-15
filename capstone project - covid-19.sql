/* ========================================== CAPSTONE PROJECT ON COVID-19 ======================================================================= */

-- 1) Find the number of corona patients who faced shortness of breath.
select count(Corona) as no_of_corona_patients, shortness_of_breath from undersampled_covid_19 where shortness_of_breath = "True";

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 2) Find the number of negative corona patients who have fever and sore_throat.
select count(Corona) as no_of_negative_corona_patients, fever, sore_throat 
from undersampled_covid_19 
where fever ="True" and sore_throat = "True" and Corona = "negative";
-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- 3) Group the data by month and rank the number of positive cases.
SET SQL_SAFE_UPDATES = 0;

UPDATE undersampled_covid_19
SET Test_date = STR_TO_DATE(Test_date, '%d-%m-%Y');
select * from undersampled_covid_19;
ALTER TABLE undersampled_covid_19
MODIFY Test_date DATE;


SELECT
    DATE_FORMAT(Test_date, '%Y-%m') AS Month,
    SUM(CASE WHEN Corona = 'positive' THEN 1 ELSE 0 END) AS Positive_Cases,
    RANK() OVER (ORDER BY SUM(CASE WHEN Corona = 'positive' THEN 1 ELSE 0 END) DESC) 
FROM
    undersampled_covid_19 
GROUP BY
    DATE_FORMAT(Test_date, '%Y-%m')
ORDER BY
    Month desc;
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- 4) Find the female negative corona patients who faced cough and headache.

select count(Corona) as no_of_negative_corona_patients, sex 
from undersampled_covid_19 
where cough_symptoms="True" and headache ="True" and sex = "female" and corona ="negative";

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5) How many elderly corona patients have faced breathing problems?

select count(Corona) as no_of_corona_patients, age_60_above, Shortness_of_breath 
from undersampled_covid_19 
where age_60_above='Yes' and Shortness_of_breath ="True";

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- 6) Which three symptoms were more common among COVID positive patients?
WITH SymptomCounts AS (
    SELECT
        CASE WHEN Corona = 'positive' AND Cough_symptoms = "True" THEN 'Cough_symptoms'
             WHEN Corona = 'positive' AND Fever = "True" THEN 'Fever'
             WHEN Corona = 'positive' AND Sore_throat= "True" THEN 'Sore_throat'
             WHEN Corona = 'positive' AND Shortness_of_breath= "True" THEN 'Shortness_of_breath'
             WHEN Corona = 'positive' AND Headache= "True" THEN 'Headache'
        END AS Symptom
    FROM undersampled_covid_19
)
SELECT Symptom, COUNT(Symptom) AS Positive_Count
FROM SymptomCounts
GROUP BY Symptom
ORDER BY Positive_Count DESC
limit 3;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- 7) Which symptom was less common among COVID negative people?
SELECT 'Cough_symptoms' AS Symptom,
    SUM(Cough_symptoms = 'True' AND Corona = 'negative') AS Count
FROM undersampled_covid_19
UNION ALL
SELECT 'Fever' AS Symptom,
    SUM(Fever = 'True' AND Corona = 'negative') AS Count
FROM undersampled_covid_19
UNION ALL
SELECT 'Headache' AS Symptom,
    SUM(Headache = 'True' AND Corona = 'negative') AS Count
FROM undersampled_covid_19
UNION ALL
SELECT 'Sore_throat' AS Symptom,
    SUM(Sore_throat = 'True' AND Corona = 'negative') AS Count
FROM undersampled_covid_19
UNION ALL
SELECT 'Shortness_of_breath' AS Symptom,
    SUM(Shortness_of_breath = 'True' AND Corona = 'negative') AS Count
FROM undersampled_covid_19
ORDER BY Count ASC
limit 1;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- 8) What are the most common symptoms among COVID positive males whose known contact was abroad?
SELECT 'Cough_symptoms' AS Symptom,
    SUM(Cough_symptoms = 'True' AND Corona = 'positive' AND Sex = 'male' AND Known_contact = 'Abroad') AS Count
FROM undersampled_covid_19
UNION ALL
SELECT 'Fever' AS Symptom,
    SUM(Fever = 'True' AND Corona = 'positive' AND Sex = 'male' AND Known_contact = 'Abroad') AS Count
FROM undersampled_covid_19
UNION ALL
SELECT 'Headache' AS Symptom,
    SUM(Headache = 'True' AND Corona = 'positive' AND Sex = 'male' AND Known_contact = 'Abroad') AS Count
FROM undersampled_covid_19
UNION ALL
SELECT 'Sore_throat' AS Symptom,
    SUM(Sore_throat = 'True' AND Corona = 'positive' AND Sex = 'male' AND Known_contact = 'Abroad') AS Count
FROM undersampled_covid_19
UNION ALL
SELECT 'Shortness_of_breath' AS Symptom,
    SUM(Shortness_of_breath = 'True' AND Corona = 'positive' AND Sex = 'male' AND Known_contact = 'Abroad') AS Count
FROM undersampled_covid_19
ORDER BY Count DESC;



