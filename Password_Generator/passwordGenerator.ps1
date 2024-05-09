$pathToFile = "C:\Users\mathe\Documents\GitHub\powershell_training\Password_Generator\allPassword.txt"

function Generate-Password {
    param (
        [int]$length = 12
    )

    $charList = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+"
    $result = ""

    1..$length | ForEach-Object {
        $result += $charList[(Get-Random -Minimum 0 -Maximum $charList.Length)]
    }

    return $result
}


function Add-Password {
    param (
        [string]$application,
        [string]$username,
        [string]$password
    )

    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $encryptedPassword = ConvertFrom-SecureString $securePassword

    "$application -> $username : $encryptedPassword" | Out-File -FilePath $pathToFile -Append

    Write-Output "Ajoute correctment"
}


function Get-Password {
    param (
        [string]$application
    )
    
    $content = Get-Content -Path $pathToFile | Where-Object {$_ -match "^$application -> "}
    $result = @()

    if ($content) {
        foreach ($c in $content) {
            $username, $encryptedPassword = $c -split " : "
            $app, $username = $username -split " -> "

            $securePassword = ConvertTo-SecureString $encryptedPassword
            $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

            $result += @{
                Username = $username
                Password = $password
            }
        }
        return $result
    } else {
        Write-Warning "rien trouve sur l'appli" #a change plus tard
    }
}