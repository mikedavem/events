param(
    [string]$SqlInstance
)

Try {
    If (-Not (Get-Module -Name dbatools)){
        Import-Module -Name dbatools
    }

    $files = Get-ChildItem -Path C:\mo\DBA

    [int]$i = 0

    Foreach($file in ($files.FullName | Sort-Object)){
        If ($i -eq 0){ $database = 'master'} Else { $database = 'DBA' }

        #Write-Host "Executing file $file - DB $database"
        Invoke-DbaQuery -SqlInstance $SqlInstance -Database $database -File $file -EnableException 

        $i++
    }
    
    Write-Host "OK"
}
Catch{
    Write-Host "KO"
}