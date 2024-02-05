with t1 as
(
    select
        empl.id as empl_id, dept.department, job.job, 'Q' + cast(datepart(quarter, convert(date, empl.datetime, 102)) as varchar) as hire_quarter
    from hired_employees as empl
    join departments as dept on empl.department_id = dept.id
    join jobs as job on empl.job_id = job.id  
    where year(convert(date, empl.datetime, 102)) = 2021
)
select
    department, job, Q1, Q2, Q3, Q4
from t1
pivot
(
    count(empl_id)
    for hire_quarter in (Q1, Q2, Q3, Q4)
) as pvt
order by department, job
