set -euo pipefail

# 1. Verificar/instalar curl
if ! command -v curl >/dev/null 2>&1; then
  echo "[INFO] curl no encontrado. Instalando…" >&2
  sudo apt-get update -qq
  sudo apt-get install -y curl
fi

# 2. Crear carpeta de logs
LOG_DIR="/var/log/devops-logs"
sudo mkdir -p "$LOG_DIR"
sudo chown "$(id -u)":"$(id -g)" "$LOG_DIR"

# 3. Descargar la página
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="$LOG_DIR/assuresoft_${TIMESTAMP}.html"

echo "[INFO] Descargando assuresoft.com → $OUTPUT_FILE"
curl -sSL "https://assuresoft.com" -o "$OUTPUT_FILE"
CURL_EXIT_CODE=$?

# 4. Registrar en script.log
{
  echo "-------------------------------------------"
  echo "Run date : $(date --rfc-3339=seconds)"
  echo "Output    : $OUTPUT_FILE"
  echo "curl code : $CURL_EXIT_CODE"
} >> "$LOG_DIR/script.log"
