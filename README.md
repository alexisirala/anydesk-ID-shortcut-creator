# PowerShell Anydesk Shortcut Creator

Este proyecto proporciona un script de PowerShell para crear accesos directos de Anydesk de manera eficiente.

## Características

*   **Creación de Carpeta Dedicada:** Crea automáticamente una carpeta llamada `Accesos_terminales` en el escritorio del usuario para almacenar todos los accesos directos generados.
*   **Acceso Directo Individual:** Permite crear un único acceso directo proporcionando el nombre de la terminal y su ID de Anydesk.
*   **Creación por Lotes:** Facilita la creación de múltiples accesos directos ingresando una lista de nombres y sus correspondientes IDs de Anydesk, separados por comas.
*   **Verificación de Anydesk:** Comprueba si Anydesk está instalado en la ruta configurada (`C:\Program Files (x86)\AnyDesk\AnyDesk.exe`) antes de intentar crear accesos directos.

## Estructura del Proyecto

```
.
├── README.md               <-- Este archivo
├── src/
│   └── shortcut_creator.ps1  <-- El script principal de PowerShell
├── config/                 <-- (Reservado para futuras configuraciones, actualmente vacío)
│   └── settings.ini          <-- (Archivo de ejemplo, no utilizado por el script actual)
└── extras/
    └── config.reg          <-- Archivo de registro de configuración para Altap Salamander 4.0
```

### Descripción de Archivos y Carpetas

*   **`src/shortcut_creator.ps1`**: Es el script principal que se debe ejecutar. Contiene toda la lógica para la creación de los accesos directos de Anydesk.
*   **`config/`**: Esta carpeta está destinada a futuros archivos de configuración del script. Actualmente, el archivo `settings.ini` es un marcador de posición y no es utilizado por `shortcut_creator.ps1`.
*   **`extras/config.reg`**: Este es un archivo de configuración del Registro de Windows para la herramienta Altap Salamander 4.0. Altap Salamander es un gestor de archivos que el autor original menciona utilizar para visualizar los accesos directos. **Este archivo no es necesario para el funcionamiento del script `shortcut_creator.ps1`** y se incluye como un extra, posiblemente para uso personal del autor original o como ejemplo de configuración de dicha herramienta.

## Requisitos

*   Windows PowerShell.
*   Anydesk instalado. La ruta por defecto configurada en el script es `C:\Program Files (x86)\AnyDesk\AnyDesk.exe`. Si su instalación de Anydesk se encuentra en una ruta diferente, deberá modificar la variable `\$anydeskExeGlobal` al inicio del script `src/shortcut_creator.ps1`.

## ¿Cómo Usar?

1.  **Descargar o Clonar el Proyecto:**
    *   Asegúrese de tener todos los archivos, especialmente `src/shortcut_creator.ps1`.

2.  **Verificar la Ruta de Anydesk (Opcional pero Recomendado):**
    *   Abra el archivo `src/shortcut_creator.ps1` con un editor de texto.
    *   Localice la línea: `\$anydeskExeGlobal = "C:\Program Files (x86)\AnyDesk\AnyDesk.exe"`
    *   Si su Anydesk está instalado en una ubicación diferente, actualice esta ruta.

3.  **Ejecutar el Script:**
    *   Abra PowerShell.
    *   Navegue hasta el directorio donde clonó o descargó el proyecto.
    *   Ejecute el script usando el comando: `.\src\shortcut_creator.ps1`
    *   Si encuentra problemas de ejecución debido a la política de ejecución de scripts de PowerShell, puede que necesite ejecutar el siguiente comando en PowerShell (con permisos de administrador):
        ```powershell
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
        ```
        Y luego intente ejecutar el script nuevamente:
        ```powershell
        .\src\shortcut_creator.ps1
        ```

4.  **Seguir las Instrucciones del Menú:**
    *   **Opción 0:** Crea (si no existe) o verifica la carpeta `Accesos_terminales` en su escritorio.
    *   **Opción 1:** Le guiará para crear un acceso directo individual.
    *   **Opción 2:** Le guiará para crear accesos directos por lotes.
    *   **Opción Q:** Sale del script.

## Contribuciones

Las contribuciones para mejorar este script son bienvenidas. Por favor, siéntase libre de hacer un fork del repositorio, realizar sus cambios y enviar un pull request.
