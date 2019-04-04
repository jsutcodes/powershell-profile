# Script: linux.ps1
<# .SYNOPSIS
     powershell user configurations [linux]
.DESCRIPTION
     Main use is to make Powershell feel more like linux
.NOTES
     Jordan     : Jordan Sutton <jsutcodes@gmail.com>
     Version    : 1.0
     
    This file should be stored in $PROFILE.CurrentUserAllHosts
    If $PROFILE.CurrentUserAllHosts doesn't exist, you can make one with the following:
        PS> New-Item $PROFILE.CurrentUserAllHosts -ItemType File -Force
    This will create the file and the containing subdirectory if it doesn't already 

    As a reminder, to enable unsigned script execution of local scripts on client Windows, 
    you need to run this line (or similar) from an elevated PowerShell prompt:
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
    This is the default policy on Windows Server 2012 R2 and above for server Windows. For 
    more information about execution policies, run Get-Help about_Execution_Policies.
    Find out if the current user identity is elevated (has admin rights)
.LINK
    taken from  : https://github.com/mikemaccana/powershell-profile notes here 
#>

function head {
  param($file)
  Get-Content $file | select -first 10

}

# want to make this method registry friendly
function ls-color
{
    param ($dir = ".", $all = $false) 
      # Add extensions here so only have to edit colors one place 
    function get-extension($extension) {
      if ($extension -eq ".Exe" -Or $extension -eq ".ps1" ) {return ".Exe"}
      elseif ( $Extension -eq ".Msi" -Or $Extension -eq ".lib" -Or $extension -eq ".dll" ) {return ".cmd"}
      elseif ($extension -eq ".cmd" -Or $extension -eq ".bat" ) {return ".cmd"}
      elseif ($extension -eq ".zip" -Or $extension -eq ".jar" -Or $extension -eq ".7z" ) {return ".zip"}
      elseif ($extension -eq ".jpg" -Or $extension -eq ".png" ) {return ".png"}
      else {
          return $extension
      }

    }


    $origFg = $host.ui.rawui.foregroundColor 
    $origBg = $host.ui.rawui.backgroundColor
    # Color LS: 
    $exec = "Yellow"
    $hidden = "Darkgray"
    $dirColor = "DarkCyan"
    $device = "blue"
    $softlink = "Cyan"
    $image = "green" # normally magenta but turned it to green since magenta is my background terminal color 
    $compressed = "Red"
    $cmd = "Red"

    if ( $all ) { $toList = Get-ChildItem -force $dir}
    else { $toList = Get-ChildItem $dir -ErrorAction "ignore"}

    foreach ($Item in $toList)  
    {   if($item.Extension -eq $null) # This is used for registry browsing
        {
          $item
          continue
        }
        Switch (get-extension $Item.Extension )  
        { 
            ".Exe" {$host.ui.rawui.foregroundColor = $exec} 
            ".cmd" {$host.ui.rawui.foregroundColor = $cmd} 
            ".png" {$host.ui.rawui.foregroundColor = $image} 
            ".zip" {$host.ui.rawui.foregroundColor = $compressed} 
            ".lnk" {$host.ui.rawui.foregroundColor = $softlink} 
            Default {$host.ui.rawui.foregroundColor = $origFg} 
        }
        if((Get-Item $Item).Name.StartsWith('.')) {$host.ui.rawui.foregroundColor = $hidden}
        if ($item.Mode.StartsWith("d")) {$host.ui.rawui.foregroundColor = $dirColor}
        if ((get-item $Item).Attributes.ToString() -match "ReparsePoint" ) {$host.ui.rawui.foregroundColor = $softlink }
        if (((get-item $Item).Attributes.ToString() -match "ReparsePoint") -And !((Get-Item $Item).Target | Test-Path > $null)) # still causing issues with onenote link
        {
          $host.ui.rawui.foregroundColor = "Red"
          $host.ui.rawui.backgroundColor = "Black"
        }
        $item 
        $host.ui.rawui.foregroundColor = $origFg 
        $host.ui.rawui.backgroundColor = $origBg 
    }  
    # $host.ui.rawui.foregroundColor = $origFg 
    # $host.ui.rawui.backgroundColor = $origBg 

}

function ln($target, $link) {
  New-Item -ItemType SymbolicLink -Path $link -Value $target
}

function rmln ($link){
  if((get-item $link).Attributes.ToString() -match "ReparsePoint"){
  (Get-Item $link).Delete()  
  } else {
      Write-Host "$link is not a symlink. only use this command to remove symlinks."
  }
}
# make call to rmln if deleting a link otherwise do regurlar rm
function rm-safe($item) {
  if((get-item $item).Attributes.ToString() -match "ReparsePoint"){
    rmln $item  
  } else {
      remove-item $item
  }
}

function tail {
  param($file)
  Get-Content $file -Tail 10 

}

function tail-f {
  param($file)
  Get-Content $file -Tail 10 -Wait

}
# Like Unix touch, creates new files and updates time on old ones
# PSCX has a touch, but it doesn't make empty files
# remove-item  alias:touch

function touch($file) {
  if ( Test-Path $file ) {
    Set-FileTime $file
  } else {
    New-Item $file -type file
  }
}

function which($cmd) { (Get-Command $cmd).Definition }



# grep???


#################################################################################
# Aliases
#################################################################################
remove-item  alias:ls
set-alias ls ls-color

remove-item  alias:rm
set-alias rm rm-safe



# set-alias new-link ln

write-output 'linux.ps1 loaded.'
