USE library;

-- Getting all staff (managers and department heads)
WITH
staff AS (
SELECT s.name, m.full_name
FROM sections s left JOIN managers m
ON s.manager_id = m.id
UNION
SELECT NULL, headmen_name FROM departments
),

-- Selecting staff members who are departments heads and manage more than 1 section
dep_sect_counts AS (
SELECT
count(staff.name) AS sections_count,
staff.full_name AS manager_name,
departments.name AS name
FROM staff inner JOIN departments ON staff.full_name = departments.headmen_name
WHERE staff.name IS NOT null
GROUP BY full_name, departments.name
HAVING count(staff.name)>1),

-- Getting reconstruction_founder for those departments
rec_fund AS (
SELECT sections_count,
dep_sc.manager_name,
departments.name AS dep_name,
departments.reconstruction_founder
FROM dep_sect_counts
AS dep_sc JOIN departments ON dep_sc.name =departments.name
ORDER BY sections_count DESC),

-- getting founders city for these reconstruction_founders
rec_fund_with_founders AS (SELECT * FROM rec_fund JOIN founders ON
rec_fund.reconstruction_founder = founders.name)

SELECT
bb.name AS book_name, bb.genre, bb.author,
c.sections_count, c.dep_name,
c.reconstruction_founder,
c.city
FROM rec_fund_with_founders AS c JOIN books_borrowed bb ON c.manager_name = bb.author
LIMIT 8






