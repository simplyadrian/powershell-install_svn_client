# Powershell 2.0


# Stop and fail script when a command fails.
$errorActionPreference = "Stop"

# load library functions
$rsLibDstDirPath = "$env:rs_sandbox_home\RightScript\lib"
. "$rsLibDstDirPath\tools\PsOutput.ps1"
. "$rsLibDstDirPath\tools\ResolveError.ps1"
. "$rsLibDstDirPath\win\Version.ps1"

try {
        $DestFolder = "C:\Program Files (x86)\RightScale\SandBox\"
        $SvnPath = $DestFolder +"SVN\bin\svn.exe"
        if (Test-Path $SvnPath) 
        {
            Write-Host "svn is already installed, exiting."
            exit 0
        }

        cd "$env:RS_ATTACH_DIR"
        mv SVN SVN.zip
        $svnZipPath =$env:RS_ATTACH_DIR +"\SVN.zip"
        Write-Host "SVN client path $svnZipPath"

        if(!$(test-path $DestFolder))
        { 
            New-Item -type directory -path $DestFolder |out-null
        }

        $unzipper = New-Object -com shell.application 
        $svnzip = $unzipper.namespace($svnZipPath)
        $destination = $unzipper.namespace($DestFolder)
        $destination.Copyhere($svnzip.items(),20)
        if (-not (Test-Path $SvnPath)) 
        {
            Write-Host "svn.exe not found"
            exit 1
        }
        else
        {
            Write-Host "SVN client installation successfully completed"
        }
}
Catch
{
    ResolveError
    exit 1
}
