CREATE TABLE [dbo].[REST_via_PowerShell_with_Params_from_Database_TBL](
	[Id] int NOT NULL,
	[Command] [nvarchar](max) NULL)
GO

CREATE FUNCTION [dbo].[fn_str_TO_BASE64]
(
    @STRING NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN (
        SELECT
            CAST(N'' AS XML).value(
                  'xs:base64Binary(xs:hexBinary(sql:column("bin")))'
                , 'NVARCHAR(MAX)'
            )   Base64Encoding
        FROM (
            SELECT CAST(@STRING AS VARBINARY(MAX)) AS bin
        ) AS bin_sql_server_temp
    )
END
GO

INSERT [dbo].[REST_via_PowerShell_with_Params_from_Database_TBL] ([Id], [Command]) VALUES (1, N'{function MyFunction {  $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]";  $headers.Add("X-Auth-UserId", "xxx");  $headers.Add("X-Auth-Token", "xxx");  $headers.Add("Content-Type", "application/json"); $body = "{  `n    `"power`": true  `n}"; $response = Invoke-RestMethod "https://api.gridscale.io/objects/servers/xxx/power" -Method "PATCH" -Headers $headers -Body $body;  $response | ConvertTo-Json;} MyFunction}')

GO

CREATE Procedure [dbo].[REST_via_PowerShell_with_Params_from_Database] (@MyId nvarchar(max))as  
begin

	DECLARE @MyScript nvarchar(max) = (SELECT [Command] FROM [dbo].[REST_via_PowerShell_with_Params_from_Database_TBL] where Id = @MyId)

	declare @CMD varchar(7000) = @MyScript
	declare @CMD2 varchar(7000) = 'powershell.exe -EncodedCommand "' + [dbo].[fn_str_TO_BASE64]('powershell -command' + @cmd) +'"'

	exec xp_cmdshell @CMD2
end
GO

Exec [REST_via_PowerShell_with_Params_from_Database] @MyId=1