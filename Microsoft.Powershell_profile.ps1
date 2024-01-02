function Add-Path($Path) {
    $Path = [Environment]::GetEnvironmentVariable("PATH") + [IO.Path]::PathSeparator + $Path
    [Environment]::SetEnvironmentVariable( "Path", $Path)
}

# Add starship
$ENV:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
$ENV:STARSHIP_DISTRO = "者 xcad"
Invoke-Expression (&starship init powershell)

# Change directory color away from stupid text with background
$PSStyle.FileInfo.Directory = "`e[34m"

# Add to path
#Add-Path("C:\Program Files\Vim\vim90")