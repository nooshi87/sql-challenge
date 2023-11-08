-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Create a view with only information of employees requested for part 1
DROP VIEW  IF EXISTS employees_salary;

CREATE VIEW  employees_salary AS
select employees.*, salaries.salary
from employees
left join salaries on salaries.emp_no = employees.emp_no;
-- Data analysis Part 1
SELECT * FROM employees_salary;
SELECT emp_no, last_name, first_name, sex, salary from employees_salary
ORDER BY emp_no;

-- Create sub-query to selecting appropriate information for Data analysis Part 2 (hired only after 1986):
SELECT first_name, last_name, hire_date 
FROM employees 
WHERE (hire_date >= CAST ('1986-01-01' AS DATE))
ORDER BY hire_date;

--Data analysis part 3
--Create a view where department numbers are added to employee table
DROP VIEW  IF EXISTS employee_departments;

CREATE VIEW employee_departments AS
select employees.*, dept_emp.dept_no
from employees
left join dept_emp on dept_emp.emp_no = employees.emp_no;

--Add department name to employees_departments view
CREATE VIEW dept_manager_info AS
SELECT employee_departments.*, departments.dept_name
FROM employee_departments
JOIN departments 
  ON departments.dept_no = employee_departments.dept_no;
  
-- Join dept_manager table
DROP VIEW IF EXISTS dept_managers_deets; 
Create view dept_managers_deets AS
SELECT dept_manager_info.* from dept_manager_info
JOIN dept_manager ON dept_manager.emp_no = dept_manager_info.emp_no;

--select columns requested for data analysis part 3
Select dept_no,dept_name,emp_no, last_name, first_name FROM dept_managers_deets;

--Data analysis part 4
--Use view created above called 'dept_manager_info' to get department name and dept_no for every employee
SELECT * FROM dept_manager_info;
--Select columns requested for part 4 using view
SELECT dept_no, emp_no, last_name, first_name, dept_name FROM dept_manager_info;

--Data analysis part 5: List of employees with first name = Hercules & last name starts with B
SELECT * FROM employees;
SELECT first_name, last_name, sex 
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--Data analysis part 6
--Use view created above called 'dept_manager_info' 
--This view has the department no and dept name for every employee. Get list of employees in 'Sales'
SELECT * FROM dept_manager_info;
SELECT dept_name, emp_no, last_name, first_name 
FROM dept_manager_info
WHERE dept_name = 'Sales';

--Data analysis part 7
--Use view created above called 'dept_manager_info' 
--This view has the department no and dept name for every employee . Get list of employess in 'Sales' or 'Development'
SELECT * FROM dept_manager_info;
SELECT dept_name, emp_no, last_name, first_name 
FROM dept_manager_info
WHERE dept_name = 'Sales' OR dept_name = 'Development';

--Data analysis part 8
--Use 'employees' table since only last name per employee info is required
SELECT last_name, COUNT(last_name) AS "last_name_ct"
FROM employees
GROUP BY last_name
ORDER BY "last_name_ct" DESC;