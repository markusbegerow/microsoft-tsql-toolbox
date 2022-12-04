
Create Procedure [dbo].[gridscale_with_python_code]
(@MyUrl nvarchar(max),@XAuthUserId nvarchar(max), @XAuthToken nvarchar(max), @Param nvarchar(max) )as  
begin


DECLARE @MyScript nvarchar(max) = N'
import requests
from requests.structures import CaseInsensitiveDict

url = "' + @MyUrl + '"

headers = CaseInsensitiveDict()
headers["Accept"] = "application/json"
headers["Content-Type"] = "application/json"
headers["X-Auth-UserId"] = "'+@XAuthUserId+'"
headers["X-Auth-Token"] = "' +@XAuthToken+'"

data = """{
  "power": '+@Param+'
}"""

resp = requests.patch(url, headers=headers, data=data)'


EXECUTE sp_execute_external_script @language = N'Python'
      , @script = @MyScript

end