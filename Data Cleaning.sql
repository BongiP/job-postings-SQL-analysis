-- Importing the data
-- Creating new tables to load the data into
CREATE DATABASE job_postings;
USE job_postings;

CREATE TABLE company_dim (
	company_id INT AUTO_INCREMENT,
    job_title_short VARCHAR(255),
    link VARCHAR(255),
    PRIMARY KEY (company_id)
    );

CREATE TABLE job_postings_fact (
	job_id INT,
    company_id INT,
    job_title_short VARCHAR(50),
    job_title VARCHAR(255),
    job_location VARCHAR(50),
    job_via VARCHAR(50),
    job_schedule_type VARCHAR(50),
    job_work_from_home BOOL,
    search_location VARCHAR(50),
    job_posted_date DATETIME,
    job_no_degree_mention BOOL,
    job_health_insurance BOOL,
    job_country VARCHAR(50),
    salary_rate VARCHAR(50),
    salary_year_avg INT,
    salary_hour_avg INT,
    PRIMARY KEY (job_id),
    FOREIGN KEY (company_id) REFERENCES company_dim(company_id)
    );
    
CREATE TABLE skills_dim (
	skill_id INT AUTO_INCREMENT,
    skills VARCHAR(50),
    type VARCHAR(50),
    PRIMARY KEY (skill_id)
    );
    
CREATE TABLE skills_job_dim (
	job_id INT,
	skill_id INT,
    FOREIGN KEY (job_id) REFERENCES job_postings_fact(job_id),
    FOREIGN KEY (skill_id) REFERENCES skills_dim(skill_id)
    );
    
-- Importing the data into each table and confirming import
-- Fixing data types conflict in import
ALTER TABLE job_postings_fact MODIFY job_work_from_home VARCHAR(20);
ALTER TABLE job_postings_fact MODIFY job_no_degree_mention VARCHAR(20);
ALTER TABLE job_postings_fact MODIFY job_health_insurance VARCHAR(20);

ALTER TABLE job_postings_fact MODIFY salary_rate VARCHAR(20);
ALTER TABLE job_postings_fact MODIFY salary_year_avg VARCHAR(20);
ALTER TABLE job_postings_fact MODIFY salary_hour_avg VARCHAR(20);

SET FOREIGN_KEY_CHECKS=0;

-- Performing data import again

SET FOREIGN_KEY_CHECKS=1;

-- confirming import
SELECT * FROM company_dim
LIMIT 100;

SELECT * FROM job_postings_fact
LIMIT 100;

SELECT * FROM skills_dim
LIMIT 100;

SELECT * FROM skills_job_dim
LIMIT 100;

-- Removing Duplicates on all key tables

DELETE FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM (
        SELECT company_id,
               ROW_NUMBER() OVER (PARTITION BY name ORDER BY company_id) AS row_num
        FROM company_dim
    ) AS temp
    WHERE row_num > 1
);

DELETE FROM job_postings_fact
WHERE job_id IN (
    SELECT job_id
    FROM (
        SELECT job_id,
               ROW_NUMBER() OVER (PARTITION BY job_title, company_id ORDER BY job_id) AS row_num
        FROM job_postings_fact
    ) AS temp
    WHERE row_num > 1
);


DELETE FROM skills_job_dim
WHERE job_id IN (
    SELECT job_id
    FROM (
        SELECT job_id,
               ROW_NUMBER() OVER (PARTITION BY skill_id, job_id ORDER BY job_id) AS row_num
        FROM skills_job_dim
    ) AS temp
    WHERE row_num > 1
);

-- Handling Missing on all tables

UPDATE company_dim
SET name = 'Unknown'
WHERE name IS NULL;

UPDATE company_dim
SET link = 'Unknown'
WHERE link = '';

DELETE FROM company_dim
WHERE company_id = '' AND name = '';

UPDATE job_postings_fact
SET job_title_short = 'Unknown'
WHERE job_title_short IS NULL;

UPDATE job_postings_fact
SET job_title = 'Unknown'
WHERE job_title IS NULL;

DELETE FROM job_postings_fact
WHERE job_id = '' AND job_title_short = '' AND job_title = '';

UPDATE job_postings_fact
SET company_id = (SELECT company_id FROM company_dim WHERE name = 'Unknown')
WHERE company_id IS NULL;

UPDATE skills_dim
SET skills = 'Unknown'
WHERE skills IS NULL;

UPDATE skills_job_dim
SET job_id = (SELECT job_title_short FROM job_postings_fact WHERE job_title = 'Unknown')
WHERE job_id IS NULL;

-- Normalizing Data In All The Tables

ALTER TABLE company_dim
MODIFY company_id INT,
MODIFY name VARCHAR(255);

ALTER TABLE job_postings_fact
MODIFY job_id INT,
MODIFY job_title VARCHAR(255),
MODIFY company_id INT;

ALTER TABLE skills_dim
MODIFY skill_id INT,
MODIFY skills VARCHAR(255),
MODIFY type VARCHAR (255);

ALTER TABLE skills_job_dim
MODIFY JOB_id INT,
MODIFY skill_id INT;

-- Ensuring Referential Integrity for proper joins

DELETE FROM job_postings_fact
WHERE company_id NOT IN (SELECT company_id FROM company_dim);

DELETE FROM skills_job_dim
WHERE job_id NOT IN (SELECT job_id FROM job_postings_fact);

-- Rechecking Tables to see if they are cleaned and consistent
SELECT * FROM company_dim
LIMIT 100;

SELECT * FROM job_postings_fact
LIMIT 100;

SELECT * FROM skills_dim
LIMIT 100;

SELECT * FROM skills_job_dim
LIMIT 100;
