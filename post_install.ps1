param(
    [string]$SqlInstance,
    [PSCredential]$SqlCredential
)

Try {
    If (-Not (Get-Module -Name dbatools)){
        Import-Module -Name dbatools
    }

    $files = Get-ChildItem -Path C:\mo\DBA -Filter "*.sql"

    [int]$i = 0

    Foreach($file in ($files.FullName | Sort-Object)){
        # First script (at position 0 will create DBA database)
        If ($i -eq 0){ $database = 'master'} Else { $database = 'DBA' }

        Invoke-DbaQuery `
            -SqlInstance "localhost\$SqlInstance" `
            -Database $database `
            -File $file `
            -SqlCredential $SqlCredential `
            -EnableException 

        $i++
    }

    Write-Host "OK"
}
Catch{
    Write-Host $_
    Write-Host "KO"
}
