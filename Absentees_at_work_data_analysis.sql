SELECT *
FROM Absenteeism_at_work

SELECT *
FROM compensation

SELECT *
FROM Reasons

--Joining tables

SELECT *
FROM Absenteeism_at_work AS abs
JOIN compensation AS comp
ON abs.ID=comp.ID
JOIN Reasons AS rea
ON abs.Reason_for_absence=rea.Number

--Find the healthiest for bonus

SELECT * FROM Absenteeism_at_work WHERE Social_smoker = 0 AND Social_drinker = 0 AND
                                        Body_mass_index<25 AND
                                        Absenteeism_time_in_hours<(SELECT AVG(Absenteeism_time_in_hours) FROM Absenteeism_at_work)



ALTER TABLE Absenteeism_at_work
ADD Healthier INT


UPDATE Absenteeism_at_work
SET Healthier = (CASE WHEN ID IN (SELECT ID FROM Absenteeism_at_work WHERE Social_smoker = 0 AND Social_drinker = 0 AND
      Body_mass_index<25 AND
      Absenteeism_time_in_hours<(SELECT AVG(Absenteeism_time_in_hours) FROM Absenteeism_at_work))
	  THEN 1 ELSE 0 END)

--Rate of non smokers 

WITH t1(non_smk_cnt) AS 
(
SELECT CAST(COUNT(*) AS float) 
FROM Absenteeism_at_work 
WHERE Social_smoker=0),

t2(ttl_cnt) AS
(
SELECT CAST(COUNT(*) AS float) 
FROM Absenteeism_at_work)

SELECT (t1.non_smk_cnt/t2.ttl_cnt)*100 
FROM t1,t2

--Optimizing the query

SELECT abs.ID,abs.Month_of_absence,abs.Day_of_the_week,abs.Seasons,abs.Transportation_expense,abs.Distance_from_Residence_to_Work,
      abs.Service_time,abs.Age,abs.Work_load_Average_day,abs.Hit_target,abs.Disciplinary_failure,abs.Education,abs.Son,
	  abs.Social_drinker,abs.Social_smoker,abs.pet,abs.Weight,abs.Height,abs.Body_mass_index,abs.Absenteeism_time_in_hours,
	  abs.Healthier,comp.comp_hr,rea.Reason,
	  CASE WHEN abs.Month_of_absence IN (12,1,2) THEN 'winter'
	       WHEN abs.Month_of_absence IN (3,4,5) THEN 'spring'
		   WHEN abs.Month_of_absence IN (6,7,8) THEN 'summer'
		   WHEN abs.Month_of_absence IN (9,10,11) THEN 'fall'
	       ELSE null END AS Seoson_of_absence,
	  CASE WHEN Body_mass_index < 18 THEN 'under wieght'
	       WHEN Body_mass_index BETWEEN 18 AND 25 THEN 'healthy weight'
		   WHEN Body_mass_index BETWEEN 25 AND 30 THEN 'over weight'
		   WHEN Body_mass_index > 30 THEN 'obese'
		   ELSE 'unknown' END AS BMI_category
FROM Absenteeism_at_work AS abs
JOIN compensation AS comp
ON abs.ID=comp.ID
JOIN Reasons AS rea
ON abs.Reason_for_absence=rea.Number


--Workers age wise count where Disciplinary_failure =1

WITH t1 AS 
(
SELECT abs.ID,abs.Month_of_absence,abs.Day_of_the_week,abs.Seasons,abs.Transportation_expense,abs.Distance_from_Residence_to_Work,
      abs.Service_time,abs.Age,abs.Work_load_Average_day,abs.Hit_target,abs.Disciplinary_failure,abs.Education,abs.Son,
	  abs.Social_drinker,abs.Social_smoker,abs.pet,abs.Weight,abs.Height,abs.Body_mass_index,abs.Absenteeism_time_in_hours,
	  abs.Healthier,comp.comp_hr,rea.Reason,
	  CASE WHEN abs.Month_of_absence IN (12,1,2) THEN 'winter'
	       WHEN abs.Month_of_absence IN (3,4,5) THEN 'spring'
		   WHEN abs.Month_of_absence IN (6,7,8) THEN 'summer'
		   WHEN abs.Month_of_absence IN (9,10,11) THEN 'fall'
	       ELSE null END AS Seoson_of_absence,
	  CASE WHEN Body_mass_index < 18 THEN 'under wieght'
	       WHEN Body_mass_index BETWEEN 18 AND 25 THEN 'healthy weight'
		   WHEN Body_mass_index BETWEEN 25 AND 30 THEN 'over weight'
		   WHEN Body_mass_index > 30 THEN 'obese'
		   ELSE 'unknown' END AS BMI_category
FROM Absenteeism_at_work AS abs
JOIN compensation AS comp
ON abs.ID=comp.ID
JOIN Reasons AS rea
ON abs.Reason_for_absence=rea.Number)

SELECT Age,COUNT(*) AS cnt
FROM t1
WHERE Disciplinary_failure=1
GROUP BY age
ORDER BY cnt DESC


--Age category of worker with obese 

WITH t1 AS 
(
SELECT abs.ID,abs.Month_of_absence,abs.Day_of_the_week,abs.Seasons,abs.Transportation_expense,abs.Distance_from_Residence_to_Work,
      abs.Service_time,abs.Age,abs.Work_load_Average_day,abs.Hit_target,abs.Disciplinary_failure,abs.Education,abs.Son,
	  abs.Social_drinker,abs.Social_smoker,abs.pet,abs.Weight,abs.Height,abs.Body_mass_index,abs.Absenteeism_time_in_hours,
	  abs.Healthier,comp.comp_hr,rea.Reason,
	  CASE WHEN abs.Month_of_absence IN (12,1,2) THEN 'winter'
	       WHEN abs.Month_of_absence IN (3,4,5) THEN 'spring'
		   WHEN abs.Month_of_absence IN (6,7,8) THEN 'summer'
		   WHEN abs.Month_of_absence IN (9,10,11) THEN 'fall'
	       ELSE null END AS Seoson_of_absence,
	  CASE WHEN Body_mass_index < 18 THEN 'under wieght'
	       WHEN Body_mass_index BETWEEN 18 AND 25 THEN 'healthy weight'
		   WHEN Body_mass_index BETWEEN 25 AND 30 THEN 'over weight'
		   WHEN Body_mass_index > 30 THEN 'obese'
		   ELSE 'unknown' END AS BMI_category
FROM Absenteeism_at_work AS abs
JOIN compensation AS comp
ON abs.ID=comp.ID
JOIN Reasons AS rea
ON abs.Reason_for_absence=rea.Number)

SELECT Age,COUNT(*)
FROM t1
WHERE BMI_category='Obese'
GROUP BY Age
ORDER BY Age