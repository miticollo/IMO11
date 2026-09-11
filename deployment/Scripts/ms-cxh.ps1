#Requires -Version 5.1

function Deserialize {
<#
.SYNOPSIS
    Converts a JSON-formatted string to a custom object.

.DESCRIPTION
    The `Deserialize` cmdlet converts a JavaScript Object Notation (JSON) formatted string to a **System.Object[]** object that has a property for each field in the JSON string. JSON is commonly used by web sites
    to provide a textual representation of objects. The cmdlet adds the properties to the new object as it processes each line of the JSON string.

.PARAMETER InputObject
    Specifies the JSON strings to convert to JSON objects. Enter a variable that contains the string,
    or type a command or expression that gets the string.

    The **InputObject** parameter is required.

.EXAMPLE
     Deserialize $(Get-Content "$file" -Raw)

.NOTES
    The `Deserialize` cmdlet is implemented using the
    [JavaScriptSerializer class](/dotnet/api/system.web.script.serialization.javascriptserializer).

.LINK
    https://github.com/PowerShell/PowerShell/issues/3705

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-5.1#input-processing-methods

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_outputtypeattribute?view=powershell-5.1#syntax
#>

    [CmdletBinding()]
    [OutputType('System.Object[]')]
    Param(
	    [Parameter(Mandatory = $true, Position = 0)]
        [string]$InputObject
    )
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Web.Extensions')
    $serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    Return ,$serializer.DeserializeObject($InputObject)
}

#region OOBE
    # https://youtu.be/tKtmzLpZ3RQ?si=K-XX9Q-bjLfy2jsY
    # https://www.hexacorn.com/blog/2022/01/16/ms-cxh-and-ms-cxh-full-handlers/
    # https://forums.mydigitallife.net/threads/discussion-new-local-account-method-access-unused-setup-screen-s-mode-supported.88718/#post-1858745

    #region Allow an empty string as a password hint
        $file = Get-ChildItem "$Env:windir\SystemApps\Microsoft.Windows.CloudExperienceHost_*\js\uiHelpers.js"
        (Get-Content "$file") -replace 'hint\.length === 0', 'false' | Set-Content "${file}"

        $file = Get-ChildItem "$Env:windir\SystemApps\Microsoft.Windows.CloudExperienceHost_*\webapps\inclusiveOobe\view\oobelocalaccount-main.html"
        (Get-Content "$file") -replace '(?<=placeholderResourceId:\s+'')PasswordHintPlaceHolder', 'PasswordHintPlaceHolder2' | Set-Content "${file}"

        $file = Get-ChildItem "$Env:windir\SystemApps\Microsoft.Windows.CloudExperienceHost_*\webapps\inclusiveOobe\js\oobelocalaccount-page.js"
        (Get-Content "$file") -replace '(?<=this\.resourceStrings\s=\s.*;)', ' this.resourceStrings[''PasswordHintPlaceHolder2''] = ''Empty strings are allowed!'';' | Set-Content "${file}"
    #endregion

    #region Skip OOBE ZDP and NDUP page
        # https://msendpointmgr.com/2024/09/19/oobe-will-force-you-to-quality-update-during-onboarding/
        # https://patchtuesday.com/blog/quality-updates-during-oobe-how-deferral-works/
        # More aggressive than https://aka.ms/WU2026update/#:~:text=Skip%20updates%20immediately%20during%20OOBE

        $file = Get-ChildItem "$Env:windir\SystemApps\Microsoft.Windows.CloudExperienceHost_*\data\prod\navigation.json"
        $content = Deserialize $(Get-Content "$file" -Raw)

        # https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/windows-updates-during-oobe-in-windows-11
        $experienceName = 'FRXINCLUSIVE'
        $skippedCXIds = @('OobeZdp', 'OobeNDUP')
        foreach ($key in ($content."$experienceName").Keys) {
            'success', 'fail', 'cancel', 'offline', 'abort' | ForEach-Object -Process {
                foreach ($id in $skippedCXIds) {
                    if ($content."$experienceName"."$key"."${_}ID" -ceq "$id") {
                        $content."$experienceName"."$key"."${_}ID" = $content."$experienceName"."$id".successID
                        break
                    }
                }
            }
        }

        ($content | ConvertTo-Json -Depth 100 -Compress) -replace '\\u0026', '&' | Set-Content "${file}"

        # https://www.elevenforum.com/t/integrate-new-oobe-bypass-ms-cxh-localonly-in-a-autounattend-xml-script.34826/post-613661
    #endregion
#endregion
