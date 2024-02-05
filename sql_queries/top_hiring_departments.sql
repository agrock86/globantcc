with t1 as
(
    select
        dept.id, dept.department, count(empl.id) * 1.0 as hired
    from hired_employees as empl
    join departments as dept on empl.department_id = dept.id
    join jobs as job on empl.job_id = job.id  
    where year(convert(date, empl.datetime, 102)) = 2021
    group by dept.id, dept.department
),
t2 as
(
    select
        *,
        avg(hired) over(order by (select null)) as hired_avg
    from t1
)
select id, department, hired
from t2
where hired > hired_avg
order by hired desc