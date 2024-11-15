## README: Job Postings Data Analysis with SQL

### Overview
This repository contains the full documentation and SQL scripts for a comprehensive project focused on analyzing job postings data. The project demonstrates data cleaning, transformation, and analysis to derive key insights into job market trends, demand for specific skills, and salary distributions across various roles and locations.

### Project Objectives
- Clean and prepare raw job postings data for analysis.
- Create a structured database to organize the data.
- Analyze job demand, skill distribution, average salaries, and hiring trends.

### Data Cleaning and Preparation Steps
1. **Data Import**: Imported raw data into newly created tables using MySQL Workbench.
2. **Database Creation**:
   - Created a new database `job_postings`.
   - Established tables such as `company_dim`, `job_postings_fact`, `skills_dim`, and `skills_job_dim` with appropriate data types and primary/foreign key relationships.
3. **Data Type Modifications**:
   - Adjusted conflicting data types for columns such as `job_work_from_home`, `job_no_degree_mention`, `job_health_insurance`, and salary-related columns.
4. **Disabling Constraints**:
   - Temporarily disabled foreign key checks for seamless data import.
5. **Data Validation**:
   - Verified successful data imports with sample `SELECT` queries.
6. **Duplicate Removal**:
   - Used `ROW_NUMBER()` in subqueries to remove duplicate entries across key tables.

### Data Analysis Steps
1. **Job Demand Analysis**:
   - Identified the top 10 most in-demand job titles using aggregation and ordering.
2. **Skill Demand by Location**:
   - Determined which locations have the highest demand for specific skills by joining the `job_postings_fact`, `skills_job_dim`, and `skills_dim` tables.
3. **Salary Analysis**:
   - Calculated average annual and hourly salaries for job titles across different locations.
4. **Company Hiring Trends**:
   - Highlighted companies leading in job postings for in-demand skills and their corresponding salary averages.
5. **Top Companies for Key Roles**:
   - Identified the top 5 companies with the highest number of job postings for roles such as Data Analyst, Data Engineer, and Business Analyst.
6. **Gaps in Skill Requirements**:
   - Listed companies with missing skill requirements by leveraging subqueries to identify gaps in data.

### Key SQL Techniques Used
- **Joins**: Combined data across multiple tables for comprehensive analysis.
- **Subqueries**: Utilized nested subqueries to filter data and aggregate insights.
- **Aggregation Functions**: Employed `COUNT()`, `AVG()`, and `SUM()` for data summarization.
- **Window Functions**: Used `ROW_NUMBER()` for duplicate identification and removal.
- **Conditional Filtering**: Applied `HAVING` and `WHERE` clauses for targeted analysis.

### Results and Insights
- **High-Demand Roles**: Revealed key job titles with the highest posting counts.
- **Skill Distribution**: Showed the geographical demand for skills, aiding job seekers and employers.
- **Salary Insights**: Provided average salaries for major job titles and analyzed how these vary by location.
- **Top Hiring Companies**: Identified top companies leading in job postings for high-demand skills.
- **Skill Requirement Gaps**: Uncovered companies lacking detailed skill requirements, presenting opportunities for data enhancement.

### How to Use This Repository
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/job-postings-sql-analysis.git
   ```
2. **Database Setup**:
   - Ensure you have MySQL installed and set up.
   - Run the SQL scripts provided in the `scripts` folder to create the database and tables.
3. **Load the Data**:
   - Use the `import_data.sql` script to import data into the tables.
4. **Run the Analysis**:
   - Execute the analysis queries found in the `analysis_queries.sql` script for results.

### Conclusion
This project showcases the application of SQL for data cleaning, transformation, and insightful analysis. The approach taken provides a structured and scalable method for analyzing job market data.

### SQL Skills Applied
- Data Cleaning and Transformation
- Advanced Query Writing (Joins, Subqueries, Aggregation)
- Database Schema Design
