

#### Wi/Fi utilities



<#
.Synopsis
Returns the signal strength of the Wi-Fi network to which the current host is
connected (if any).
.Description
Returns the signal strength of the Wi-Fi network to which the current host is
connected (if any).
# .Parameter Path
This method does not take any parameters.
#>
function GetWifiStrength()
{
	$ret = (netsh wlan show interfaces) -Match '^\s+Signal' -Replace '^\s+Signal\s+:\s+','' | Out-String
	return $ret
}


<#
.Synopsis
Returns a string containing Wi-Fi interfaces connected as string.
.Description
See Synopsis.
#>
function GetWifiInterfaceStr()
{
	return $(netsh wlan show interfaces)
}



