# String together the hawk user functions to pull data for a single user
Function Start-HawkUserInvestigation {

    param
    (
        [Parameter(Mandatory = $true)]
        [array]$UserPrincipalName
    )

	Out-LogFile "Investigating Users"
	Send-AIEvent -Event "CmdRun"

	# Pull the tenent configuration
	Get-HawkTenantConfiguration

    # Verify our UPN input
    [array]$UserArray = Test-UserObject -ToTest $UserPrincipalName

    foreach ($Object in $UserArray) {
        [string]$User = $Object.UserPrincipalName

        Get-HawkUserConfiguration -User $User
        Get-HawkUserInboxRule -User $User
		Get-HawkUserEmailForwarding -User $User
		Get-HawkUserAutoReply -User $User
        Get-HawkUserAuthHistory -User $user -ResolveIPLocations
		Get-HawkUserMailboxAuditing -User $User
		Get-HawkUserAdminAudit -User $User
    }

    <#

	.SYNOPSIS
	Gathers common data about a provided user.

	.DESCRIPTION
	Runs all Hawk users related cmdlets against the specified user and gathers the data.

	Cmdlet								Information Gathered
	-------------------------			-------------------------
	Get-HawkTenantConfigurationn        Basic Tenant information
	Get-HawkUserConfiguration           Basic User information
	Get-HawkUserInboxRule               Searches the user for Inbox Rules
	Get-HawkUserEmailForwarding         Looks for email forwarding configured on the user
	Get-HawkUserAutoReply				Looks for enabled AutoReplyConfiguration
	Get-HawkuserAuthHistory             Searches the unified audit log for users logons
	Get-HawkUserMailboxAuditing         Searches the unified audit log for mailbox auditing information
	Get-HawkUserAdminAudit				Searches the EXO Audit logs for any commands that were run against the provided user object.	


	.PARAMETER UserPrincipalName
	Single UPN of a user, commans seperated list of UPNs, or array of objects that contain UPNs.

	.OUTPUTS
	See help from individual cmdlets for output list.
	All outputs are placed in the $Hawk.FilePath directory

	.EXAMPLE
	Start-HawkUserInvestigation -UserPrincipalName bsmith@contoso.com

	Runs all Get-HawkUser* cmdlets against the user with UPN bsmith@contoso.com

	.EXAMPLE

	Start-HawkUserInvestigation -UserPrincipalName (get-mailbox -Filter {Customattribute1 -eq "C-level"})

	Runs all Get-HawkUser* cmdlets against all users who have "C-Level" set in CustomAttribute1

	#>

    param
    (
        [Parameter(Mandatory = $true)]
        [array]$UserPrincipalName
    )

    Out-LogFile "Investigating Users"
    Send-AIEvent -Event "CmdRun"

    # Pull the tenent configuration
    Get-HawkTenantConfiguration	

    # Verify our UPN input
    [array]$UserArray = Test-UserObject -ToTest $UserPrincipalName

    foreach ($Object in $UserArray) {
        [string]$User = $Object.UserPrincipalName
		
		Out-LogFile "Running Get-HawkUserConfiguration"
		Get-HawkUserConfiguration -User $User
		
		Out-LogFile "Running Get-HawkUserInboxRule"
		Get-HawkUserInboxRule -User $User
		
		Out-LogFile "Running Get-HawkUserEmailForwarding"
		Get-HawkUserEmailForwarding -User $User
		
		Out-LogFile "Running Get-HawkUserAuthHistory"
		Get-HawkUserAuthHistory -User $user -ResolveIPLocations
		
		Out-LogFile "Running Get-HawkUserMailboxAuditing"
		Get-HawkUserMailboxAuditing -User $User
		
		Out-LogFile "Running Get-HawkUserAdminAudit"
        Get-HawkUserAdminAudit -User $User
    }
}