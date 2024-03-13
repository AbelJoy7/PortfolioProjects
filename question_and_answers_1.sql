--1) Write a SQL query to fetch all the duplicate records from a table.

--Tables Structure:

drop table users;
create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

SELECT *
FROM users

SELECT *
FROM (SELECT *,ROW_NUMBER() OVER (PARTITION BY user_name ORDER BY user_id) AS rn
      FROM users) AS t1
WHERE t1.rn!=1


--2) Write a SQL query to fetch the second last record from employee table

--Tables Structure:

drop table employee;
create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

SELECT * 
FROM employee

SELECT * 
FROM (SELECT *,ROW_NUMBER() OVER (ORDER BY emp_ID DESC) AS rn
      FROM employee) AS t1 
WHERE rn=2

--3) Write a SQL query to display only the details of employees who either earn the highest salary or 
     --the lowest salary in each department from the employee table

SELECT *
FROM employee


SELECT *
FROM (SELECT *,FIRST_VALUE(SALARY) OVER (PARTITION BY DEPT_NAME ORDER BY SALARY ) AS min_salary,
       FIRST_VALUE(SALARY) OVER (PARTITION BY DEPT_NAME ORDER BY SALARY DESC) AS max_slary
      FROM employee) AS T1
WHERE SALARY = min_salary OR SALARY = max_slary


--4) From the doctors table, fetch the details of doctors who work in the same hospital but in different specialty

--Table Structure:

drop table doctors;
create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

SELECT *
FROM doctors

SELECT t1.id,t1.name,t1.speciality,t1.hospital,t1.city,t1.consultation_fee
FROM doctors AS t1
JOIN doctors AS t2
ON t1.hospital=t2.hospital AND t1.speciality!=t2.speciality

--Additional Query: Write SQL query to fetch the doctors who work in same hospital irrespective of their specialty.

SELECT t1.id,t1.name,t1.speciality,t1.hospital,t1.city,t1.consultation_fee
FROM doctors AS t1
JOIN doctors AS t2
ON t1.hospital=t2.hospital AND t1.name != t2.name

--5) From the login_details table, fetch the users who logged in consecutively 3 or more times

--Table Structure:

drop table login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
insert into login_details values
(101, 'Michael',GETDATE()),
(102, 'James', GETDATE()),
(103, 'Stewart', GETDATE()+1),
(104, 'Stewart', GETDATE()+1),
(105, 'Stewart', GETDATE()+1),
(106, 'Michael', GETDATE()+2),
(107, 'Michael', GETDATE()+2),
(108, 'Stewart', GETDATE()+3),
(109, 'Stewart', GETDATE()+3),
(110, 'James', GETDATE()+4),
(111, 'James', GETDATE()+4),
(112, 'James', GETDATE()+5),
(113, 'James', GETDATE()+6);

SELECT *
FROM login_details

SELECT DISTINCT user_name
FROM (SELECT *,CASE WHEN user_name = LEAD(user_name) OVER (ORDER BY login_id) AND
         user_name = LEAD(user_name,2) OVER (ORDER BY login_id)
		 THEN user_name ELSE NULL END AS sp
      FROM login_details) AS t1
WHERE sp IS NOT NULL

--6) From the students table, write a SQL query to interchange the adjacent student names

--Table Structure:

drop table students;
create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

SELECT *
FROM students

SELECT *,CASE WHEN id%2=1 THEN LEAD(student_name,1,student_name) OVER (ORDER BY id)
              WHEN id%2=0	THEN LAG(student_name) OVER (ORDER BY id) 
		      ELSE NULL END AS new
FROM students

--7) From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more

--Table Structure:

drop table weather;
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
delete from weather;
insert into weather values
(1, 'London', -1, '2021-01-01'),
(2, 'London', -2, '2021-01-02'),
(3, 'London', 4, '2021-01-03'),
(4, 'London', 1, '2021-01-04'),
(5, 'London', -2, '2021-01-05'),
(6, 'London', -5, '2021-01-06'),
(7, 'London', -7, '2021-01-07'),
(8, 'London', 5, '2021-01-08');

SELECT *
FROM Weather

SELECT id,city,temperature,day
FROM (SELECT *,CASE WHEN temperature <0 AND
                         LEAD(temperature) OVER (ORDER BY id) <0 AND
				         LEAD(temperature,2) OVER (ORDER BY id) <0
				         THEN 'true'
					WHEN temperature <0 AND
					     LEAD(temperature) OVER (ORDER BY id) <0 AND
						 LAG(temperature) OVER (ORDER BY id) <0
						 THEN 'true'
					WHEN temperature <0 AND
					     LAG(temperature) OVER (ORDER BY id) <0 AND
						 LAG(temperature,2) OVER (ORDER BY id) <0
						 THEN 'true'
					ELSE 'false' END AS flag
      FROM weather) AS t1
WHERE flag = 'true'

--8) From the following 3 tables (event_category, physician_speciality, patient_treatment),
     --write a SQL query to get the histogram of specialties of the unique physicians 
     --who have done the procedures but never did prescribe anything

--Table Structure:

drop table event_category;
create table event_category
(
  event_name varchar(50),
  category varchar(100)
);

drop table physician_speciality;
create table physician_speciality
(
  physician_id int,
  speciality varchar(50)
);

drop table patient_treatment;
create table patient_treatment
(
  patient_id int,
  event_name varchar(50),
  physician_id int
);


insert into event_category values ('Chemotherapy','Procedure');
insert into event_category values ('Radiation','Procedure');
insert into event_category values ('Immunosuppressants','Prescription');
insert into event_category values ('BTKI','Prescription');
insert into event_category values ('Biopsy','Test');


insert into physician_speciality values (1000,'Radiologist');
insert into physician_speciality values (2000,'Oncologist');
insert into physician_speciality values (3000,'Hermatologist');
insert into physician_speciality values (4000,'Oncologist');
insert into physician_speciality values (5000,'Pathologist');
insert into physician_speciality values (6000,'Oncologist');


insert into patient_treatment values (1,'Radiation', 1000);
insert into patient_treatment values (2,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 1000);
insert into patient_treatment values (3,'Immunosuppressants', 2000);
insert into patient_treatment values (4,'BTKI', 3000);
insert into patient_treatment values (5,'Radiation', 4000);
insert into patient_treatment values (4,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 5000);
insert into patient_treatment values (6,'Chemotherapy', 6000);

SELECT *
FROM event_category

SELECT *
FROM physician_speciality

SELECT *
FROM patient_treatment

SELECT speciality,Count(1)
FROM (SELECT pt.patient_id,pt.event_name,pt.physician_id,ps.speciality,ec.category
      FROM patient_treatment AS pt
      JOIN physician_speciality ps
      ON pt.physician_id = ps.physician_id
      JOIN event_category AS ec
      ON pt.event_name = ec.event_name
	  WHERE ec.category='Procedure'
	  AND pt.physician_id NOT IN (SELECT pt.physician_id
	                             FROM patient_treatment AS pt
								 JOIN event_category AS ec
								 ON pt.event_name=ec.event_name
								 WHERE ec.category='Prescription')) AS t1
	GROUP BY speciality

--9)  Find the top 2 accounts with the maximum number of unique patients on a monthly basis

--Table Structure:

drop table patient_logs;
create table patient_logs
(
  account_id int,
  day date,
  patient_id int
);

insert into patient_logs values (1, '2020-01-02', 100);
insert into patient_logs values (1, '2020-01-27', 200);
insert into patient_logs values (2, '2020-01-01', 300);
insert into patient_logs values (2, '2020-01-21', 400);
insert into patient_logs values (2, '2020-01-21', 300);
insert into patient_logs values (2, '2020-01-01', 500);
insert into patient_logs values (3, '2020-01-20', 400);
insert into patient_logs values (1, '2020-03-04', 500);
insert into patient_logs values (3, '2020-01-20', 450);


SELECT *
FROM patient_logs

WITH t2(month,account_id,cnt) AS 
(
SELECT  month,account_id,COUNT(patient_id)
FROM (SELECT DISTINCT FORMAT(day,'MMMMMM') AS month,account_id,patient_id
      FROM patient_logs) AS t1
GROUP BY month,account_id)

SELECT *
FROM (SELECT *,ROW_NUMBER() OVER (PARTITION BY month ORDER BY cnt DESC) AS rn
      FROM t2) AS t3
WHERE rn<3
	  
--10) SQL Query to fetch “N” consecutive records from a table based on a certain condition