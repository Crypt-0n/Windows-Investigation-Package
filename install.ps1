Add-Type -AssemblyName System.IO.Compression.FileSystem
$Shell = New-Object -ComObject Wscript.Shell


function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Function ClearWindows
{  
    $AppsList = "Microsoft.BingFinance","9E2F88E3.Twitter","Flipboard.Flipboard","ShazamEntertainmentLtd.Shazam","king.com.CandyCrushSaga","king.com.CandyCrushSodaSaga","king.com.*","ClearChannelRadioDigital.iHeartRadio","Microsoft.BingHealthAndFitness","Microsoft.Getstarted","Microsoft.MicrosoftOfficeHub","Microsoft.MicrosoftSolitaireCollection","Microsoft.3DBuilder","Microsoft.SkypeApp","Microsoft.XboxGamingOverlay","Microsoft.YourPhone","Microsoft.BingWeather","Microsoft.Microsoft3DViewer","Microsoft.Wallet","Microsoft.WindowsCamera","Microsoft.Office.OneNote","Microsoft.WindowsAlarms","Microsoft.MixedReality.Portal","Microsoft.People","Microsoft.ScreenSketch","Microsoft.WindowsMaps","Microsoft.MicrosoftStickyNotes","Microsoft.Messaging","Microsoft.Print3D","Microsoft.WindowsStore","Microsoft.Messaging","Microsoft.WindowsSoundRecorder","Microsoft.StorePurchaseApp","microsoft.windowscommunicationsapps"
    Get-AppXProvisionedPackage -online | ? { $AppsList -contains $_.DisplayName } | Remove-AppxProvisionedPackage –online
    $AppsList | % { Get-AppXPackage -Name $_ | Remove-AppxPackage }
}


Function DisableCortana
{  
    #New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 0 -PropertyType DWORD -Force | Out-Null

    #if( [bool]([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -notcontains "S-1-5-32-544") {
    #    Start Powershell -ArgumentList "& '$MyInvocation.MyCommand.Path'" -Verb runas
    #}

    $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"    
    IF(!(Test-Path -Path $path)) { 
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search"
    } 
    Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0 
    #Restart Explorer to change it immediately    
    Stop-Process -name explorer
}


Function DownloadELK
{ 
    Remove-Item "c:\elk" -Recurse -ErrorAction Ignore

    $elasticsearch_version = "7.3.0-windows-x86_64"
    $elasticsearch_url = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($elasticsearch_version).zip"
    Write-host "Téléchargement de Elasticsearch"
    Start-BitsTransfer -Source $elasticsearch_url -Destination c:\elasticsearch.zip
    Write-host "Unzip de Elasticsearch"
    Unzip "c:\elasticsearch.zip" "c:\elk\elasticsearch"
    $Shortcute = $Shell.CreateShortcut($env:USERPROFILE + "\Desktop\Start Elasticsearch.lnk")
    $Shortcute.TargetPath = "C:\elk\elasticsearch\elasticsearch-7.3.0\bin\elasticsearch.bat"
    $Shortcute.Save()

    $kibana_version = "7.3.0-windows-x86_64"
    $kibana_url = "https://artifacts.elastic.co/downloads/kibana/kibana-$($kibana_version).zip"
    Write-host "Téléchargement de Kibana"
    Start-BitsTransfer -Source $kibana_url -Destination c:\kibana.zip
    Write-host "Unzip de Kibana"
    Unzip "c:\kibana.zip" "c:\elk\kibana"
    $Shortcutk = $Shell.CreateShortcut($env:USERPROFILE + "\Desktop\Start Kibana.lnk")
    $Shortcutk.TargetPath = "C:\elk\kibana\kibana-7.3.0-windows-x86_64\bin\kibana.bat"
    $Shortcutk.Save()
}


Function DownloadC0-FF-EE
{
    $C0FFEE_path = $env:USERPROFILE + "\Desktop\C0-FF-EE.zip"
    Start-BitsTransfer -Source https://github.com/Crypt-0n/C0-FF-EE/archive/master.zip -Destination $C0FFEE_path

}

Function DownloadKali
{
    $KALI_path = "c:\KaliLinux.AppxBundle"
    Start-BitsTransfer -Source https://aka.ms/wsl-kali-linux -Destination $KALI_path
    DISM /online /add-provisionedappxpackage /packagepath:"c:\KaliLinux.AppxBundle" /skiplicense
}

Function Chocolatey
{
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

    choco install googlechrome -y --force
    choco install ublockorigin-chrome -y --force
    choco install firefox -y --force
    choco install python -y --force
    C:\Python37\python -m pip install --upgrade pip
    C:\Python37\python -m pip install evtxtoelk
    $ete = $env:USERPROFILE + "\Desktop\EvtxToElk.py"
    "from evtxtoelk import EvtxToElk" > $ete
    'EvtxToElk.evtx_to_elk("Security.evtx","http://localhost:9200")' >> $ete
    choco install yed -y --force
    choco install ida-free -y --force
    choco install 7zip -y --force
    choco install adobereader -y --force
    choco install autoit -y --force
    choco install cmder -y --force
    choco install sysinternals -y --force
    $Shortcuts = $Shell.CreateShortcut($env:USERPROFILE + "\Desktop\Sysinternals.lnk")
    $Shortcuts.TargetPath = "C:\ProgramData\Chocolatey\lib\sysinternals\tools"
    $Shortcuts.Save()
    choco install winscp -y --force
    choco install keepass -y --force
    choco install notepadplusplus -y --force
    choco install processhacker -y --force
    choco install sublimetext3 -y --force
    choco install vlc -y --force
    choco install hashmyfiles -y --force
    choco install kitty -y --force
    choco install upx -y --force
    choco install .\pkg\libreoffice.6.2.7.nupkg -y --force
}


ClearWindows
DisableCortana
DownloadELK
DownloadC0-FF-EE
Chocolatey


#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
