#!/usr/bin/env bash
# daily_maintenance.sh 

set -euo pipefail

# 1. Verificar/instalar curl 
if ! command -v curl >/dev/null 2>&1; then
  echo "[INFO] curl no encontrado. Instalando con Homebrew…" >&2
  # Instala Homebrew si no existe
  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew install curl
fi

# 2. Carpeta de logs (usa /usr/local/var/log para evitar SIP)
LOG_DIR="/usr/local/var/log/devops-logs"
sudo mkdir -p "$LOG_DIR"
sudo chown "$USER":"$(id -gn)" "$LOG_DIR"

# 3. Descargar la página
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="$LOG_DIR/assuresoft_${TIMESTAMP}.html"

echo "[INFO] Descargando assuresoft.com → $OUTPUT_FILE"
curl -sSL https://assuresoft.com -o "$OUTPUT_FILE"
CURL_EXIT_CODE=$?

# 4. Registrar en script.log  (usa formato de fecha compatible BSD)
{
  echo "-------------------------------------------"
  echo "Run date : $(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo "Output    : $OUTPUT_FILE"
  echo "curl code : $CURL_EXIT_CODE"
} >> "$LOG_DIR/script.log"
