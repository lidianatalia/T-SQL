# T-SQL using cursor

In the real project the table named 'selection' is actually a view. However, as an example below, I will use table without decreasing the problem level.
```ruby
-- create table
CREATE table selection (
	id char (3) NOT NULL PRIMARY KEY
	,patient char (4)
	,revision char (3)
	,startDate char (4)
	,endDate datetime);
	
--insert data
INSERT INTO selection (id,patient, revision, startDate,endDate)
VALUES
('1','0056','001','2012-05-30','2012-05-30')
,('2','0056','001','2013-08-01','2014-09-01')
,('3','0056','002','2015-08-01','2016-01-02')
,('4','0056','001','2014-08-01','2014-09-03')
,('5','0056','001','2015-08-01','2016-01-01')
,('6','0056','112','2016-03-01','2017-02-28')
,('7','0005','001','2015-08-01','2014-04-30')
,('8','0005','006','2013-05-01','2015-03-27');
```

The query above must be  :

![alt text](https://github.com/lidianatalia/T-SQL/blob/master/Capture.JPG)

We should retrieve a record with conditions : 
1. non intersect patient's start date or end date.
2. if it intersect, get the highest revision number
3. if the revision still same, retrieve the latest endDate.

Solution :
1. Order the records by patient, revision, startDate and endDate. The result must be :
```ruby
,('7','0005','001','2013-05-01','2014-04-30')
,('8','0005','006','2013-05-01','2015-03-27')
,('1','0056','001','2012-05-30','2012-05-30')
,('2','0056','001','2013-08-01','2014-09-01')
,('4','0056','001','2014-08-01','2014-09-03')
,('5','0056','001','2015-08-01','2016-01-01')
,('3','0056','002','2015-08-01','2016-01-02')
,('6','0056','112','2016-03-01','2017-02-28');
```
2. Then "CHECK ONE BY ONE RECORD BASED ON CONDITION ABOVE USING CURSOR". 
* Id number 7 is deleted since the highest revision is number 8
* Id number 1,2 are deleted since the latest date end is number 4
* Id number 5 is not deleted since the date is not intersect with number 4.
* Id number 5 is deleted since the date latest date is number 3 and it is the latest revision
