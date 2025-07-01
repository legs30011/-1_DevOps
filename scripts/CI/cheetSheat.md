🗓️ Script de Automatización (Bash) 
markdown

### Script de Automatización (Bash)

**Encabezado y permisos**
#!/usr/bin/env bash
# → Permite ejecutar el script con ./mi_script.sh
chmod +x mi_script.sh
Variables y parámetros


NOMBRE="Docker App"
echo "Hola, $NOMBRE"
# Parámetros posicionales: $1, $2, ..., $# (número de args), $@ (todos)
Estructuras de control

# if / else
if [ -f "$1" ]; then
  echo "El archivo existe."
else
  echo "No existe."
fi

# case
case "$1" in
  start)   echo "Iniciando...";;
  stop)    echo "Deteniendo...";;
  *)       echo "Uso: $0 {start|stop}"; exit 1;;
esac

# for
for archivo in *.txt; do
  echo "Procesando $archivo"
done

# while
contador=1
while [ $contador -le 5 ]; do
  echo "Iteración $contador"
  ((contador++))
done
Funciones

mi_funcion() {
  echo "Argumentos: $*"
}
# Invocar:
mi_funcion a b c
I/O y redirecciones

# Salida estándar y error
echo "Mensaje" > salida.log
echo "Error" 2>> errores.log

# Tubos (pipes)
grep "ERROR" /var/log/syslog | wc -l

# Lectura interactiva
read -p "¿Continuar? (s/n) " RESP
Gestión de ficheros y directorios


mkdir -p carpeta/subcarpeta    # crear
cp origen.txt destino.txt      # copiar
mv viejo.txt nuevo.txt         # mover/renombrar
rm archivo.txt                 # eliminar
Programación de tareas con cron

Editar crontab: crontab -e

Ejemplo: ejecutar mi_script.sh cada jueves a las 9 AM


0 9 * * 4 /ruta/mi_script.sh >> /ruta/log.txt 2>&1
yaml---

## 🗓️ Cheat Sheet de PowerShell – Lunes

```markdown
### Cheat Sheet de PowerShell

**Ayuda y descubrimiento**
```powershell
Get-Help <cmdlet> -Full       # Documentación completa
Get-Command *Service*         # Buscar cmdlets relacionados
Navegación y archivos

powershell

Get-Location                  # Ruta actual (pwd)
Set-Location C:\Users         # Cambiar directorio (cd)
Get-ChildItem -Path .         # Listar ficheros (ls, dir)
Copy-Item .\origen.txt .\destino.txt   # cp
Move-Item .\a.txt .\b.txt                # mv
Remove-Item .\archivo.txt                 # rm
New-Item -ItemType Directory -Name "Carpeta"  # mkdir
Contenido y filtrado


Get-Content archivo.txt            # cat
Select-String -Pattern "error" archivo.log  # grep
Procesos y servicios

Get-Process                       # ps / top
Stop-Process -Name notepad        # kill
Get-Service                       # listar servicios
Start-Service -Name wuauserv      # iniciar servicio
Stop-Service -Name wuauserv       # detener servicio
Variables y pipelines


$usuario = "admin"
Get-Process | Where-Object {$_.CPU -gt 100} | Sort-Object CPU -Descending
Administración remota

Enter-PSSession -ComputerName Servidor01   # Remoto interactivo
Invoke-Command -ComputerName Servidor01 -ScriptBlock { Get-Service }
Exportación e importación


Get-Process | Export-Csv procesos.csv -NoTypeInformation
Import-Csv usuarios.csv | Format-Table
Ejecución de scripts

# Habilitar ejecución local
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Ejecutar
.\mi_script.ps1

---

## 🗓️ Cheat Sheet de Comandos Linux – Lunes

```markdown
### Cheat Sheet de Comandos Linux

**Navegación**
```bash
pwd                # Mostrar ruta actual
cd /ruta/destino   # Cambiar directorio
ls -la             # Listar con detalles y archivos ocultos
Gestión de archivos y directorios

cp origen.txt copia.txt        # Copiar
mv archivo.txt ../otra_ruta/   # Mover/renombrar
rm archivo.txt                 # Eliminar
mkdir -p carpeta/nueva         # Crear (incluye padres)
rmdir carpeta/vacía            # Eliminar directorio vacío
Permisos y propietarios

chmod u=rwx,g=rx,o= file.txt   # Cambiar permisos
chown usuario:grupo archivo    # Cambiar propietario
Mostrar contenido

cat archivo.txt                # Imprimir todo
head -n 10 archivo.txt         # Primeras 10 líneas
tail -n 20 archivo.log         # Últimas 20 líneas
less archivo.txt               # Paginar
grep "texto" archivo.txt       # Buscar patrón
Búsqueda


find /ruta -name "*.log"       # Buscar por nombre
grep -R "ERROR" /var/log       # Buscar recursivo
Compresión y archivo


tar -czvf backup.tar.gz /carpeta    # Crear .tar.gz
tar -xzvf archivo.tar.gz            # Extraer
gzip archivo.txt                    # Comprimir .gz
Red y transferencia


ping ejemplo.com
ssh usuario@servidor
scp archivo.txt usuario@servidor:/ruta
wget https://url/archivo.zip
curl -O https://url/archivo.zip
Procesos y recursos

ps aux           # Listar procesos
top              # Monitor en tiempo real
kill <PID>       # Matar proceso
df -h            # Uso de disco
du -sh carpeta/  # Tamaño carpeta
free -m          # Memoria libre
Sistema


uname -a         # Info del kernel
whoami           # Usuario actual
uptime           # Tiempo de actividad

---

### 📚 Recursos

- **Bash (SWC Shell Novice)**  
  https://opsis.eci.ox.ac.uk/swc-shell-novice/instructor/02-filedir.html#top

- **PowerShell / Bash Cheatsheet**  
  https://blog.ironmansoftware.com/daily-powershell/bash-powershell-cheatsheet

