USE [AdventureWorks2012]
GO
/****** Object:  StoredProcedure [core].[getFunds]    Script Date: 10/12/2015 5:54:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [core].[getFunds]
@start int,
@length int,
@searchKey varchar(max),
@recordsTotal int out,
@recordsFiltered int out
AS
BEGIN

set @recordsFiltered = (select COUNT(*) from core.Funds 
 wHERE  LOWER(fldFundName) like '%'+@searchKey+'%'
 or LOWER(fldFundServCode) like '%'+@searchKey+'%'
 or LOWER(fldFundType) like '%'+@searchKey+'%')

set @searchKey = RTRIM(LTRIM(LOWER(@searchKey)));

 
 set @recordsTotal = (
 select SUM(row_count)
 FROM sys.dm_db_partition_stats
 where object_id = OBJECT_ID('core.Funds') and (index_id = 0 or index_id = 1)
 )

 select fldInstrumentID,fldFundName,fldFundServCode,fldFundType from core.Funds
 where LOWER(fldFundName) like '%'+@searchKey+'%'
 or LOWER(fldFundServCode) like '%'+@searchKey+'%'
 or LOWER(fldFundType) like '%'+@searchKey+'%'
 order by fldInstrumentID asc
 offset @start rows
 fetch next @length rows only;

END

