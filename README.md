# powershell-profile

## Overview 
A PowerShell profile is a script that runs when PowerShell starts. You can use the profile as a logon script to customize the environment. You can add commands, aliases, functions, variables, snap-ins, modules, and PowerShell drives. You can also add other session-specific elements to your profile so they are available in every session without having to import or re-create them.

PowerShell supports several profiles for users and host programs. However, it does not create the profiles for you. This topic describes the profiles, and it describes how to create and maintain profiles on your computer.

## Where to install 

PowerShell supports several profile files. Also, PowerShell host programs can support their own host-specific profiles.

For example, the PowerShell console supports the following basic profile files. The profiles are listed in precedence order. The first profile has the highest precedence.

| Description |	Path |
|-------------|-------|
|All Users, All Hosts	|$PsHome\Profile.ps1|
|All Users, Current Host	|$PsHome\Microsoft.PowerShell_profile.ps1|
|Current User, All Hosts	|$Home\[My ]Documents\PowerShell\Profile.ps1|
|Current user, Current Host	|$Home\[My ]Documents\PowerShell\Microsoft.PowerShell_profile.ps1|





[MicrosoftHelp](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-6)
