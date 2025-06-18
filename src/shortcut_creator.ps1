param (
    [string]$scriptPath = "src/shortcut_creator.ps1"
)

# Define Anydesk Path - Make sure this is correctly defined or passed if needed by functions directly
$anydeskExeGlobal = "C:\Program Files (x86)\AnyDesk\AnyDesk.exe"

# --- Function Definitions ---

$createFolderFunction = @"
function Create-AnydeskShortcutFolder {
    param()
    Write-Host "Verificando/Creando carpeta de accesos..."
    `$folderPath = Join-Path -Path [System.Environment]::GetFolderPath('Desktop') -ChildPath "Accesos_terminales"
    if (-not (Test-Path `$folderPath)) {
        New-Item -Path `$folderPath -ItemType Directory -Force | Out-Null
        Write-Host "Carpeta 'Accesos_terminales' creada en el escritorio."
    } else {
        Write-Host "Carpeta 'Accesos_terminales' ya existe en el escritorio."
    }
    Write-Host "" # Newline for spacing
    return `$folderPath
}
"@

$createSingleFunction = @"
function New-AnydeskShortcut {
    param (
        [string]`$FolderLocation,
        [string]`$AnyDeskProgramPath # Pasar la ruta de Anydesk como parámetro
    )
    Write-Host "Crear un acceso directo individual:"
    if (-not (Test-Path `$AnyDeskProgramPath)) {
        Write-Warning "AnyDesk no encontrado en: `$AnyDeskProgramPath`. Verifique la ruta en la configuración del script."
        return
    }
    `$shortcutName = Read-Host "Nombre de la terminal (para el archivo .lnk)"
    `$anydeskID = Read-Host "ID de Anydesk"

    # Validar entradas básicas
    if ([string]::IsNullOrWhiteSpace(`$shortcutName)) {
        Write-Warning "El nombre de la terminal no puede estar vacío."
        return
    }
    if (-not (`$anydeskID -match '^[0-9]+`$')) {
        Write-Warning "El ID de Anydesk debe ser numérico."
        return
    }

    `$shortcutPath = Join-Path -Path `$FolderLocation -ChildPath ("`$shortcutName" + ".lnk")

    `$WshShell = New-Object -ComObject WScript.Shell
    `$Shortcut = `$WshShell.CreateShortcut("`$shortcutPath")
    `$Shortcut.TargetPath = `$AnyDeskProgramPath
    `$Shortcut.Arguments = "`$anydeskID"
    `$Shortcut.IconLocation = `$AnyDeskProgramPath # Usar la misma ruta para el ícono
    `$Shortcut.Save()
    Write-Host "Acceso directo '`$shortcutName.lnk' creado para el ID `$anydeskID` en `$FolderLocation`."
    Write-Host "" # Newline
}
"@

$createBatchFunction = @"
function New-AnydeskShortcutBatch {
    param (
        [string]`$FolderLocation,
        [string]`$AnyDeskProgramPath # Pasar la ruta de Anydesk
    )
    Write-Host "Crear accesos directos por lotes:"
    if (-not (Test-Path `$AnyDeskProgramPath)) {
        Write-Warning "AnyDesk no encontrado en: `$AnyDeskProgramPath`. Verifique la ruta en la configuración del script."
        return
    }
    Write-Host "Los nombres y IDs deben estar separados por comas."
    `$namesInput = Read-Host "Nombres de las terminales (ej: term1,term2,term3)"
    `$idsInput = Read-Host "IDs de Anydesk (ej: 123456789,987654321,112233445)"

    `$namesArray = `$namesInput.Split(',') | ForEach-Object { `$_.Trim() }
    `$idsArray = `$idsInput.Split(',') | ForEach-Object { `$_.Trim() }

    if (`$namesArray.Count -ne `$idsArray.Count) {
        Write-Warning "La cantidad de nombres (`$(`$namesArray.Count`)) no coincide con la cantidad de IDs (`$(`$idsArray.Count`)). No se crearon accesos."
        return
    }

    if (`$namesArray.Count -eq 0 -or (`$namesArray.Count -eq 1 -and [string]::IsNullOrWhiteSpace(`$namesArray[0]))) {
        Write-Warning "No se proporcionaron nombres para los accesos directos."
        return
    }

    Write-Host "Creando accesos directos..."
    for (`$i = 0; `$i -lt `$namesArray.Count; `$i++) {
        `$currentName = `$namesArray[`$i]
        `$currentID = `$idsArray[`$i]

        if ([string]::IsNullOrWhiteSpace(`$currentName)) {
            Write-Warning "Nombre vacío en la posición `$(`$i+1`)`, se omite este acceso directo."
            continue
        }
        if (-not (`$currentID -match '^[0-9]+`$')) {
            Write-Warning "ID '`$currentID' para '`$currentName' no es numérico, se omite este acceso directo."
            continue
        }

        `$shortcutPath = Join-Path -Path `$FolderLocation -ChildPath ("`$currentName" + ".lnk")

        `$WshShell = New-Object -ComObject WScript.Shell
        `$Shortcut = `$WshShell.CreateShortcut("`$shortcutPath")
        `$Shortcut.TargetPath = `$AnyDeskProgramPath
        `$Shortcut.Arguments = "`$currentID"
        `$Shortcut.IconLocation = `$AnyDeskProgramPath
        `$Shortcut.Save()
        Write-Host " - Acceso '`$currentName.lnk' creado para el ID `$currentID`."
    }
    Write-Host "Proceso por lotes completado."
    Write-Host "" # Newline
}
"@

# --- Script principal ---
# Usar la variable global definida al inicio del script para la ruta de Anydesk
$mainScriptLogic = @"

# --- Configuración Global ---
# Esta variable `$anydeskExeGlobal` es accesible por las funciones si no se sombrea localmente.
# `$anydeskExeGlobal` se define al inicio del script que contiene este bloque.

# --- Definiciones de Funciones (ya definidas arriba en el script de subtask) ---
# Create-AnydeskShortcutFolder
# New-AnydeskShortcut
# New-AnydeskShortcutBatch

# Bucle del menú principal
do {
    cls
    Write-Host "Creador de accesos de Anydesk de terminales" -ForegroundColor Yellow
    Write-Host "--------------------------------------------"
    Write-Host "Menú Principal:"
    Write-Host "0- Crear/Verificar Carpeta de Accesos ('Accesos_terminales' en el escritorio)"
    Write-Host "1- Crear un acceso directo de Anydesk"
    Write-Host "2- Crear accesos directos de Anydesk por lotes"
    Write-Host "Q- Salir"
    Write-Host ""
    `$opcion = Read-Host "Seleccione una opción"
    cls

    # La ruta de Anydesk se pasa ahora a las funciones que la necesitan.
    `$anydeskPathForFunctions = `$anydeskExeGlobal # Usar la variable global

    switch (`$opcion.ToUpper()) {
        '0' {
            Create-AnydeskShortcutFolder # Esta función no necesita la ruta de Anydesk
        }
        '1' {
            `$shortcutsDestFolder = Create-AnydeskShortcutFolder
            if (Test-Path `$shortcutsDestFolder) {
                New-AnydeskShortcut -FolderLocation `$shortcutsDestFolder -AnyDeskProgramPath `$anydeskPathForFunctions
            } else {
                Write-Warning "La carpeta de destino no existe o no pudo ser creada."
            }
        }
        '2' {
            `$shortcutsDestFolder = Create-AnydeskShortcutFolder
            if (Test-Path `$shortcutsDestFolder) {
                New-AnydeskShortcutBatch -FolderLocation `$shortcutsDestFolder -AnyDeskProgramPath `$anydeskPathForFunctions
            } else {
                Write-Warning "La carpeta de destino no existe o no pudo ser creada."
            }
        }
        'Q' {
            Write-Host "Saliendo del script."
        }
        default {
            Write-Warning "Opción no válida. Intente de nuevo."
        }
    }

    if (`$opcion.ToUpper() -ne 'Q') {
        Write-Host "Presione cualquier tecla para continuar..."
        [System.Console]::ReadKey(`$true) | Out-Null
    }

} while (`$opcion.ToUpper() -ne 'Q')

Write-Host "Script finalizado."
"@

# Ensamblar el script final
$finalScript = @"
# ===================================================
# Script para crear accesos directos de Anydesk
# Refactorizado para modularidad y mejor manejo de rutas.
# Version: 2.1
# ===================================================

# --- Configuración Global ---
# Ruta al ejecutable de Anydesk. Modifique esta línea si Anydesk está instalado en otra ubicación.
`$anydeskExeGlobal = "$anydeskExeGlobal"

# --- Autoverificación de la ruta de Anydesk ---
if (-not (Test-Path `$anydeskExeGlobal)) {
    Write-Warning "¡ADVERTENCIA! AnyDesk NO fue encontrado en la ruta especificada: `$anydeskExeGlobal"
    Write-Warning "Por favor, verifique que Anydesk esté instalado y que la ruta sea correcta en la variable `$anydeskExeGlobal` al inicio del script."
    Write-Host "Presione cualquier tecla para salir..."
    [System.Console]::ReadKey(`$true) | Out-Null
    exit 1 # Salir si Anydesk no se encuentra, ya que es crucial.
}

# --- Definiciones de Funciones ---
$createFolderFunction

$createSingleFunction

$createBatchFunction

# --- Lógica Principal del Script ---
$mainScriptLogic
"@

# Guardar el script refactorizado
# Asegurarse de que el directorio src exista (creado en el paso anterior del plan)
if (-not (Test-Path (Split-Path $scriptPath -Parent))) {
    New-Item -ItemType Directory -Path (Split-Path $scriptPath -Parent) -Force | Out-Null
}
Set-Content -Path $scriptPath -Value $finalScript -Force -Encoding UTF8
Write-Host "El script ha sido refactorizado y guardado en: $scriptPath"

# Opcional: Mostrar el contenido del script para verificación
# Get-Content -Path $scriptPath
