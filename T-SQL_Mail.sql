-- show advanced options
EXEC sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
 
-- enable Database Mail XPs
EXEC sp_configure 'Database Mail XPs', 1
GO
RECONFIGURE
GO
 
-- check if it has been changed
EXEC sp_configure 'Database Mail XPs'
GO
 
-- hide advanced options
EXEC sp_configure 'show advanced options', 0
GO
RECONFIGURE
GO

Use MSDB
go
IF NOT EXISTS(SELECT * FROM msdb.dbo.sysmail_account WHERE  name = 'SQLServer Express') 
  BEGIN 
    --CREATE Account [SQLServer Express] 
    EXECUTE msdb.dbo.sysmail_add_account_sp 
    @account_name            = 'SQLServer Express', 
    @email_address           = '###', 
    @display_name            = 'SQL Server Database Mail', 
    @replyto_address         = '', 
    @description             = '', 
    @mailserver_name         = 'smtp.office365.com', 
    @mailserver_type         = 'SMTP', 
    @port                    = '587', 
    @username                = '###', 
    @password                = '###',  
    @use_default_credentials =  0 , 
    @enable_ssl              =  1 ; 
  END --IF EXISTS  account

go
IF NOT EXISTS(SELECT * FROM msdb.dbo.sysmail_profile WHERE  name = 'SQLServer Express Edition')  
  BEGIN 
    --CREATE Profile [SQLServer Express Edition] 
    EXECUTE msdb.dbo.sysmail_add_profile_sp 
      @profile_name = 'SQLServer Express Edition', 
      @description  = 'This db mail account is used by SQL Server Express edition.'; 
  END --IF EXISTS profile
  
go
IF NOT EXISTS(SELECT * 
              FROM msdb.dbo.sysmail_profileaccount pa 
                INNER JOIN msdb.dbo.sysmail_profile p ON pa.profile_id = p.profile_id 
                INNER JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id   
              WHERE p.name = 'SQLServer Express Edition' 
                AND a.name = 'SQLServer Express')  
  BEGIN 
    -- Associate Account [SQLServer Express] to Profile [SQLServer Express Edition] 
    EXECUTE msdb.dbo.sysmail_add_profileaccount_sp 
      @profile_name = 'SQLServer Express Edition', 
      @account_name = 'SQLServer Express', 
      @sequence_number = 1 ; 
  END


--EXECUTE msdb.dbo.sysmail_delete_account_sp  
--    @account_name = 'SQLServer Express' ;
--
--  EXECUTE msdb.dbo.sysmail_delete_profile_sp  
--    @profile_name = 'SQLServer Express Edition' ;  

--  EXEC msdb.dbo.sp_send_dbmail  
--    @profile_name = 'SQLServer Express Edition',  
--    @recipients = '###',  
--    @body = 'This is an email with attachment from a SQL Server Express Edition.',  
--    @subject = 'SQL Server Express Edition',
--	@importance='High',
--	@sensitivity='Confidential',  
--	@file_attachments='C:\###\###\###\Hello_world.txt';