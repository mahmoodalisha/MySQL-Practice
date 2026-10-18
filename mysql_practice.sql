-- Active: 1792237210773@@127.0.0.1@3307@mysql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50)
);

INSERT INTO employees (id, name, department) VALUES
(1, 'Alice', 'IT'),
(2, 'Bob', 'IT'),
(3, 'Charlie', 'IT'),
(4, 'David', 'IT'),
(5, 'Eva', 'IT'),
(6, 'Frank', 'IT'),
(7, 'Grace', 'HR'),
(8, 'Hannah', 'HR'),
(9, 'Ian', 'HR'),
(10, 'Jack', 'Sales'),
(11, 'Karen', 'Sales'),
(12, 'Leo', 'Sales'),
(13, 'Mona', 'Sales'),
(14, 'Nick', 'Sales'),
(15, 'Olivia', 'Sales'),
(16, 'Paul', 'Marketing'),
(17, 'Quinn', 'Marketing');

SELECT * FROM employees;

ALTER TABLE employees ADD COLUMN salary DECIMAL(10, 2);

UPDATE employees 
SET salary = 30000.00 
WHERE department = 'Sales';
/*
WHERE vs HAVING: The WHERE clause filters individual rows before any grouping or aggregation happens.
COUNT(*) is an aggregate function that only exists after rows are grouped together, the database throws an error.
To filter based on aggregated results (like counts)
we must use HAVING.
Order of Execution: In SQL, the logical order of execution is FROM -> WHERE -> GROUP BY -> HAVING -> SELECT
Putting WHERE after GROUP BY is syntactically invalid.
 */
SELECT department, COUNT(*)
FROM employees
GROUP BY department
HAVING COUNT(*) > 5

/*
1. FROM employees (Step 1: Get the data)
What it means: "Go grab the employees table."

2. GROUP BY department (Step 2: Sort them into piles)
What we are grouping: We are grouping the rows by the department column.
The story: Instead of looking at a chaotic list of 500 individual employees, you take all their files and sort them into separate colored folders on your desk based on their department:

📁 IT Department folder (contains 12 employee files)
📁 HR Department folder (contains 3 employee files)
📁 Sales Department folder (contains 20 employee files)
📁 Marketing Department folder (contains 4 employee files)

3. SELECT department, COUNT(*) (Step 3: Count each pile)
What COUNT(*) does here: It looks inside each of those folders you just made and counts how many files (people) are inside that specific folder.
The story: For the IT folder, it counts 12. For HR, it counts 3. For Sales, it counts 20.
SELECT department: It says, "Print the name of the department next to its final count."
At this exact moment, your paper has:
IT: 12
HR: 3
Sales: 20
Marketing: 4

4. HAVING COUNT(*) > 5 (Step 4: Filter out the small ones)
What HAVING does: It looks at the final counts you just generated and throws away any department that doesn't meet the rule.
The story: You look at your list of counts and say:
IT (12) -> Keep! (12 is > 5)
HR (3) -> Throw away! (3 is not > 5)
Sales (20) -> Keep! (20 is > 5)
Marketing (4) -> Throw away! (4 is not > 5)

Your final output on the screen will only show IT and Sales because they are the only ones with more than 5 people.
 */

-- =================================================================================================== --

SELECT COUNT(*) FROM employees; --looks at that table and gives a single number—the total count of how many rows are in that table
-- We use WHERE when we want to filter individual rows before we do anything else with them

-- ================================================================================================== --
-- --Sorts all the employees based on their salary, starting with the highest salary at the very top and going down to the lowest --
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 3;

SELECT * FROM employees 
ORDER BY salary DESC;

-- ==================================================================================================== --

SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

-- ==================================================================================================== --
-- Create a new table

CREATE TABLE department_info (
    department_name VARCHAR(50),
    building_name VARCHAR(50)
);

INSERT INTO department_info (department_name, building_name) VALUES
('IT', 'Building A'),
('HR', 'Building B'),
('Sales', 'Building C');

SELECT * FROM department_info

SELECT employees.name, employees.department, department_info.building_name
FROM employees
INNER JOIN department_info
ON employees.department = department_info.department_name;

SELECT employees.name, employees.department, department_info.building_name
FROM employees
LEFT JOIN department_info
ON employees.department = department_info.department_name;

SELECT employees.name, employees.department, department_info.building_name
FROM employees
RIGHT JOIN department_info
ON employees.department = department_info.department_name;