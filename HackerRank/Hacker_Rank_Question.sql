
CREATE TABLE #temp1 (
date_ DATE,
count_ INT);
DECLARE @GUN INT = 0
DECLARE @COUNT INT
DECLARE @DAY DATE
WHILE @GUN < 15
BEGIN
	SELECT TOP 1 @COUNT = COUNT( DISTINCT hacker_id)
	FROM Submissions
	WHERE hacker_id IN (
					SELECT DISTINCT hacker_id
					FROM Submissions
					WHERE submission_date <= DATEADD(DAY,@GUN,'2016-03-01')
					GROUP BY hacker_id
					HAVING COUNT(DISTINCT submission_date) = @GUN+1
					)
	GROUP BY submission_date
	SET @DAY =DATEADD(DAY,@GUN,'2016-03-01')
	INSERT INTO #temp1 VALUES (@DAY,@COUNT)
	SET @GUN = @GUN +1
END;

SELECT submission_date, hacker_id, name
INTO #temp2
FROM(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY count_hacker DESC, hacker_id  ) AS row_num
	FROM (
		SELECT DISTINCT S.submission_date, S.hacker_id , H.name,
			COUNT(S.hacker_id) OVER (PARTITION BY S.submission_date,S.hacker_id) as count_hacker
		FROM Submissions S, Hackers H
		WHERE S.hacker_id = H.hacker_id ) AS table1) AS table2
WHERE row_num=1;

SELECT A.date_, A.count_, B.hacker_id, B.name
FROM #temp1 A
INNER JOIN #temp2 B
	ON A.date_ = B.submission_date;




