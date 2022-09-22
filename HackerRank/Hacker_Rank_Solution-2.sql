with t1 as(
select * , iif(dense_rank() over(order by [submission_date]) =
         dense_rank() over(partition by [hacker_id] order by [submission_date]),1,0) rank_1
from [Submissions]
),t2 as(
select *,dense_rank() over(partition by [submission_date] order by [hacker_id]) rank_2
from t1
where rank_1=1
),t3 as(
select    distinct [submission_date]
        ,first_value(rank_2) over(partition by [submission_date] order by rank_2 desc) rank_3
from t2
),t4 as(
select *, 1 num_
from [Submissions]
),t5 as(
select *, sum(num_) over(partition by hacker_id, [submission_date] order by submission_id) sum_
from t4
)
select distinct A.[submission_date],rank_3
,first_value(A.[hacker_id]) over(partition by A.[submission_date] order by sum_ desc, A.[hacker_id] asc) as hacker_id
,first_value(B.[name]) over(partition by A.[submission_date] order by sum_ desc, A.[hacker_id] asc) as name_
from t5 A,[Hackers] B, t3 C
where A.[hacker_id]=B.[hacker_id]
    and A.[submission_date]=C.[submission_date]
order by 1