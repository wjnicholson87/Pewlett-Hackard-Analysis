-- Join employee and title tables to create new table "retirement by title"
Select ce.emp_no, ce.first_name, ce.last_name,
	ti.titles, ti.from_date, ti.to_date
INTO emp_titles
FROM current_emp as ce
Inner Join titles as ti
ON (ce.emp_no = ti.emp_no)
Order by (ce.emp_no)

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
titles

INTO unique_titles
FROM emp_titles
ORDER BY emp_no, to_date DESC;

-- Use unique titles table to create new table "retiring titles"
SELECT COUNT(emp_no), titles
INTO retiring_titles
FROM unique_titles
GROUP BY titles
ORDER BY count(emp_no) DESC;

-- Join employee, dept_emp, and title tables to create eligibility table
SELECT DISTINCT ON (e.emp_no) e.emp_no, 
    e.first_name, e.last_name,e.birth_date,
    de.from_date, de.to_date,
    ti.titles
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no;

-- Count all employees eligible for mentorship per department
SELECT titles, COUNT(*)
FROM mentorship_eligibility
GROUP BY titles
