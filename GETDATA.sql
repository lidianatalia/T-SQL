CREATE PROCEDURE [dbo].[GETDATA]
AS

DECLARE		 @prev_id CHAR(3)= NULL
			,@prev_patient CHAR (3) = NULL
			,@prev_revision Char(3) = NULL
			,@prev_startDate DATETIME= NULL
			,@prev_endDate DATETIME= NULL
			
			,@cur_id CHAR(3)
			,@cur_patient CHAR (3)
			,@cur_revision Char(3)
			,@cur_startDate DATETIME
			,@cur_endDate DATETIME


DECLARE THE_CURSOR CURSOR FOR
	SELECT * FROM SELECTION GROUP BY  id ,patient, revision, startDate,endDate

BEGIN TRY
OPEN THE_CURSOR;

FETCH NEXT FROM THE_CURSOR 
INTO @cur_id
	,@cur_patient
	,@cur_revision
	,@cur_startDate
	,@cur_endDate

WHILE (@@FETCH_STATUS=0)
	BEGIN

		IF (@prev_patient= @cur_patient)
		BEGIN
			IF (((@cur_startDate >= @prev_startDate) AND (@cur_startDate <=@prev_endDate)) AND (@cur_endDate >= @prev_endDate))
			BEGIN 
			  DELETE FROM selection WHERE id=@prev_id 
			END
			IF ((@cur_startDate >= @prev_startDate) AND (@cur_startDate <= @prev_endDate) AND (@cur_endDate < @prev_endDate))
			BEGIN 
			  DELETE FROM selection WHERE id=@cur_id
			END
		END

		SET @prev_id = @cur_id;
		SET @prev_patient = @cur_patient;
		SET @prev_revision = @cur_revision;
		SET	@prev_startDate = @cur_startDate;
		SET	@prev_endDate = @cur_endDate;

		FETCH NEXT FROM THE_CURSOR 
		INTO @cur_id
			,@cur_patient
			,@cur_revision
			,@cur_startDate
			,@cur_endDate

	END
	CLOSE THE_CURSOR;
	DEALLOCATE THE_CURSOR;
END TRY

BEGIN CATCH
	PRINT 'ERROR function error (' +convert(varchar, error_number())+ ':' + error_message() + ')';
END CATCH






GO


