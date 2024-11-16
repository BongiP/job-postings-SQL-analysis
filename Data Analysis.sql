-- What are the most in-demand job titles?
SELECT job_title, COUNT(*) AS posting_count
FROM job_postings_fact
GROUP BY job_title
ORDER BY posting_count DESC
LIMIT 10;

-- Which locations have the highest demand for specific skills?
SELECT s.skills, j.job_location, COUNT(*) AS demand_count
FROM job_postings_fact j
JOIN skills_job_dim d ON j.job_id = d.job_id
JOIN skills_dim s ON s.skill_id = d.skill_id
GROUP BY s.skills, j.job_location
ORDER BY demand_count DESC
LIMIT 10;

-- What is the average salary offered for key job titles, and how does it vary across locations?
SELECT job_title, job_location, AVG(salary_year_avg) AS average_annual_salary
FROM job_postings_fact
GROUP BY job_title, job_location
ORDER BY average_annual_salary DESC
LIMIT 10;

SELECT job_title, job_location, AVG(salary_hour_avg) AS average_hourly_salary
FROM job_postings_fact
GROUP BY job_title, job_location
ORDER BY average_hourly_salary DESC
LIMIT 10;

/* Which companies are leading in hiring for high-demand skills, 
and what are the average salaries offered by these companies for those roles? */

SELECT 
    c.name,
    d.skills,
    COUNT(j.job_id) AS job_postings_count,
    AVG(j.salary_year_avg) AS average_annual_salary,
    COUNT(j.job_id) AS job_postings_count,
    AVG(j.salary_hour_avg) AS average_hourly_salary
FROM 
    job_postings_fact j
JOIN 
    company_dim c ON j.company_id = c.company_id
JOIN 
    skills_job_dim s ON j.job_id = s.job_id
JOIN 
	skills_dim d ON s.skill_id = d.skill_id
GROUP BY 
    c.name, d.skills
HAVING 
    COUNT(j.job_id) > 5  -- A filter for companies with more than 5 job postings for the skill
ORDER BY 
    job_postings_count DESC, average_hourly_salary, average_annual_salary DESC
LIMIT 10;

-- Top 5 Companies with the Most Job Postings for Data Analyst, Data Engineer, and Business Analysit jobs
SELECT name, total_postings
FROM (
    SELECT c.name, COUNT(j.job_id) AS total_postings
    FROM job_postings_fact j
    JOIN company_dim c ON j.company_id = c.company_id
     WHERE j.job_title IN ('Data_Analyst', 'Data_Engineer', 'Business_Analysit')
    GROUP BY c.name
) AS subquery 
ORDER BY total_postings DESC
LIMIT 5;

-- Companies with Missing Skill Requirements
SELECT c.name
FROM company_dim c
WHERE c.company_id NOT IN (
    SELECT DISTINCT j.company_id
    FROM job_postings_fact j
    JOIN skills_job_dim s ON j.job_id = s.job_id
    JOIN skills_dim d ON d.skill_id = s.skill_id
);

-- Average Salary Offered by Companies with Specific Skills
SELECT d.skills, AVG(j.salary_year_avg) AS average_annual_salary, AVG(j.salary_hour_avg) AS average_hourly_salary
FROM job_postings_fact j
JOIN skills_job_dim s ON j.job_id = s.job_id
JOIN skills_dim d ON d.skill_id = s.skill_id
WHERE d.skills IN (
    SELECT skills
    FROM skills_job_dim
    WHERE job_id = j.job_id
)
GROUP BY d.skills;


