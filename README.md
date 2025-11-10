# Pong - Proyecto de Programación en Bajo Nivel

## 📖 Descripción

Implementación del clásico juego **Pong** en **MASM32** (Microsoft Assembler 32 bits), desarrollado como trabajo de la materia **Taller de Programación en Bajo Nivel** - Gestión 3/2017 - **Universidad Mayor de San Simón**.

Este proyecto demuestra el uso de programación en lenguaje ensamblador x86 de 32 bits, haciendo uso de APIs de Windows para la gestión de ventanas y la manipulación directa de gráficos mediante GDI.

## 📄 Archivos del Proyecto

- **`pong.asm`** - Archivo principal con la implementación del juego

- **`gdibits.inc`** - Archivo de inclusión con configuración y utilidades

## 🔧 Instalación y Configuración

### 📥 Instalar MASM32

1. Descarga MASM32 desde: https://www.masm32.com/
2. Ejecuta el instalador y sigue las instrucciones
3. Por defecto se instala en `C:\masm32\` (Recomendado)
4. Verifica que existan las carpetas:
   - `C:\masm32\bin\` (contiene ml.exe y link.exe)
   - `C:\masm32\include\` (archivos .inc)
   - `C:\masm32\lib\` (librerías)

## 🔨 Compilación y Vinculación

### 1️⃣ Compilar el archivo ensamblador

```powershell
C:\masm32\bin\ml.exe /c /coff /Cp .\pong.asm
```

**Opciones utilizadas:**
- `/c` - Compilar solo (no vincular)
- `/coff` - Formato de objeto COFF
- `/Cp` - Preservar mayúsculas/minúsculas

### 2️⃣ Vincular el objeto

```powershell
C:\masm32\bin\link.exe /subsystem:windows /libpath:C:\MASM32\LIB pong.obj
```

**Opciones utilizadas:**
- `/subsystem:windows` - Aplicación de Windows (GUI)
- `/libpath:C:\MASM32\LIB` - Ruta de las librerías

### ✅ Resultado

Después de ejecutar ambos comandos, se generará el ejecutable `pong.exe` que podrá ejecutarse directamente desde Windows.

## 📄 Licencia

Trabajo académico - Uso educativo únicamente.

---
