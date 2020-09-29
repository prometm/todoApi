--1. get all statuses, not repeating, alphabetically ordered

SELECT DISTINCT status FROM tasks ORDER BY status;


--2. get the count of all tasks in each project, order by tasks count descending

SELECT COUNT(*) FROM tasks, projects WHERE projects.id = tasks.project_id 
GROUP BY projects.id ORDER BY COUNT(*) DESC;


--3. get the count of all tasks in each project, order by projects names

SELECT COUNT(*) FROM tasks, projects WHERE tasks.project_id = projects.id 
GROUP BY projects.id ORDER BY projects.name;


--4. get the tasks for all projects having the name beginning with “N” letter

SELECT tasks.* FROM tasks, projects WHERE projects.name LIKE 'N%' 
AND projects.id = tasks.project_id;

--5. get the list of all projects containing the ‘a’ letter in the middle of the name, and
-- show the tasks count near each project. mention that there can exist projects without 
-- tasks and tasks with project_id=NULL

SELECT projects.*, (SELECT COUNT(*) FROM tasks WHERE projects.id = tasks.project_id) AS 'tasks' 
FROM tasks, projects 
WHERE SUBSTR(projects.name, LENGTH(projects.name)/2, 1) = 'a' 
GROUP BY projects.id;


--6. get the list of tasks with duplicate names. order alphabetically

SELECT name FROM tasks GROUP BY name 
HAVING COUNT(*) > 1 ORDER BY name;


--7. get the list of tasks having several exact matches of both name and status, from
-- the project ‘Garage’. Order by matches count

SELECT tasks.name, tasks.status, COUNT(*) AS exact_matches FROM projects, tasks
WHERE tasks.project_id = projects.id AND projects.name LIKE 'Garage'
GROUP BY tasks.name, tasks.status HAVING COUNT(*) > 1 ORDER BY exact_matches ASC;


--8. get the list of project names having more than 10 tasks in status ‘completed’.
-- order by project_id
SELECT projects.name FROM tasks, projects 
WHERE (SELECT COUNT(*) FROM tasks WHERE project_id = projects.id AND status = 'completed') > 10 
GROUP BY projects.id ORDER BY projects.id;