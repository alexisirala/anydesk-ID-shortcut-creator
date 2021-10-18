Write-Host "Creador de accesos de Anydesk "
Write-Host
Write-Host "Cargando ..."
Start-Sleep -Seconds 2
cls
Write-Host "Creador de accesos de Anydesk de terminales "
Write-Host
Write-Host "Menú"
Write-Host
Write-Host "0- Crear Carpeta contenedora"
Write-Host "1- Crear un acceso"
Write-Host "2- Crear accesos por lotes"
Write-Host
$opcion = read-host "Ingrese una opcion"
cls
Write-Host "Creador de accesos de Anydesk de terminales "
cls

if(0 -eq $opcion){
    
    Write-Host "Carpeta de accesos creada en el escritorio"
    New-Item "C:\Users\$env:USERNAME\Desktop\Accesos a cajeros" -Type Directory
    Write-Host "Carpeta Accesos a terminales creada en el escritorio"
    Write-Host
    Write-Host "Volviendo al menú ..."
    Start-Sleep -Seconds 4
    cls
    Write-Host "Creador de accesos de Anydesk de terminales "
    Write-Host
    Write-Host "Menú"
    Write-Host
    Write-Host "1- Crear un acceso"
    Write-Host "2- Crear accesos por lotes"
    Write-Host
    $opcion = read-host "Ingrese una opcion"
    cls
    Write-Host "Creador de accesos de Anydesk de terminales"
    }


if (1 -eq $opcion){
        Write-Host
        $DestinationPath = read-host "Ingrese el nombre de la terminal "
        $prefijo = "C:\Users\$env:USERNAME\Desktop\Accesos a cajeros\"
        $sufijo = ".lnk"
        $DestinationPath = $prefijo + $DestinationPath + $sufijo
        Write-Host
        $ArgumentsToSourceExe = Read-Host "Ingrese el id"
        $SourceExe = "C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
        Write-Host
        Write-Host 'Creando acceso directo Anydesk en la direccion:'
        $DestinationPath
        Start-Sleep -Seconds 2
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($DestinationPath)
        $Shortcut.TargetPath = $SourceExe
        $Shortcut.Arguments = $ArgumentsToSourceExe
        $Shortcut.Save()
        Write-Host
        Write-host "Agregado exitosamente"
        Write-Host 
        write-Host "Presione una tecla para salir..."
        [void][System.Console]::ReadKey($true)

        }

if(2 -eq $opcion){
        Write-Host "Creador de accesos de Anydesk de terminales "
        Write-Host
        Write-Host "Los datos se deben ingresar separadas por comas"
        Write-Host
        $entrada = Read-Host "Ingrese la cadena de Nombres"
        $entrada=","+$entrada
        $entrada = $entrada.split(",")
        Write-Host
        $direccion = Read-Host "Ingrese la cadena de direcciones"
        $direccion=","+$direccion
        $direccion = $direccion.split(",")

        $prefijo = "C:\Users\$env:USERNAME\Desktop\Accesos a cajeros\"
        $sufijo= ".lnk"
        cls
        Write-Host "Creador de accesos de Anydesk de terminales "
        Write-Host
        Write-Output "Creando accesos de terminales"

        for ($i=1; $i -lt $entrada.count; $i++) {

         $SourceFileLocation = "C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
         $ShortcutLocation = $prefijo + $entrada[$i] + $sufijo
         $WScriptShell = New-Object -ComObject WScript.Shell
         $Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
         $Shortcut.TargetPath = $SourceFileLocation
         $Shortcut.IconLocation = "C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
         $acceso = $direccion[$i]
         $Shortcut.Arguments = "$acceso"
         $Shortcut.Save()

         Write-Host "Acceso Creado en:"
         $ShortcutLocation

        }
        Write-Host
        Write-host ($entrada.count-1)" accesos creados"
        Write-Host 
        Write-Host "Presione una tecla para salir..."
        [void][System.Console]::ReadKey($true)

        }
        




