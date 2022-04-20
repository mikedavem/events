param(
    [string]$ServerName,
    [string]$InstanceName
)

Try {
    If (-Not (Get-Module -Name dbatools)){
        Import-Module -Name dbatools
    }

    Switch ($InstanceName){
        'MSSQLSERVER' { $sqlInstance = $ServerName }
        default       { $sqlInstance = $ServerName + '\' + $InstanceName }
    }

    # Check if DBA database exists
    $db = Invoke-DbaQuery `
            -SqlInstance $sqlInstance `
            -Database 'master' `
            -Query "SELECT name FROM sys.databases WHERE name = N'DBA'" `
            -EnableException 

    If ($db){
        Write-Host "Database already exists"
    }
    Else{
        $files = Get-ChildItem -Path C:\mo\DBA -Filter "*.sql"

        [int]$i = 0

        Foreach($file in ($files.FullName | Sort-Object)){
            # First script (at position 0 will create DBA database)
            If ($i -eq 0){ $database = 'master'} Else { $database = 'DBA' }

            Invoke-DbaQuery `
                -SqlInstance $sqlInstance `
                -Database $database `
                -File $file `
                -EnableException 

            $i++
        }

        Write-Host "OK"
    }
}
Catch{
    Write-Host $_
    Write-Host "KO"
}
