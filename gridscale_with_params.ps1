<#
#########################################################
Author:			Markus Begerow
Created on:		01.09.2022
Description:	Handling Gridscale VM via T-SQL & PowerShell
Version:		1.0.0
#########################################################
#>

param (
$MyUrl,
$XAuthUserId,
$XAuthToken,
$Param
)

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("X-Auth-UserId", $XAuthUserId)
$headers.Add("X-Auth-Token", $XAuthToken)
$headers.Add("Content-Type", "application/json")

$body = "{
`n    `"power`": $Param
`n}"

$response = Invoke-RestMethod $MyUrl -Method 'PATCH' -Headers $headers -Body $body
$response | ConvertTo-Json
