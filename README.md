# Daily Maintenance Automation

A tiny DevOps exercise that shows how to:

* answer common questions about **cron** and automation best-practices  
* write a robust Bash script (`daily_maintenance.sh`) for daily maintenance tasks  
* run that script automatically every day at **08:45 AM** via *cron*  
* document tests, results, and usage

---

## Part 1 · Research

### 1. What is *cron* and how is it used for automation?
*Cron* is the built-in Unix/Linux job scheduler.  
It reads a per-user table called **crontab** and runs listed commands at the exact minute, hour, day, or month you specify. Typical use-cases include:

| Use-case                            | Example                                    |
|------------------------------------|--------------------------------------------|
| System maintenance                 | rotate logs, run backups                   |
| Development workflows              | nightly builds or test suites              |
| Monitoring / alerting              | poll APIs, check disk space, send e-mail   |
| Data collection                    | download datasets, scrape pages daily      |

Because *cron* is lightweight, timezone-aware (via the system clock), and well-tested, it remains the default choice for repetitive, time-based tasks.

### 2. Good practices when writing automation scripts
| # | Guideline | Why it matters |
|---|-----------|----------------|
| 1 | **Use `set -euo pipefail`**           | Fail fast on any error, undefined var, or broken pipe |
| 2 | **Log verbosely** (stdout + a logfile)| Easier debugging & auditing |
| 3 | **Check prerequisites** (commands, permissions)| Prevent partial runs and cryptic errors |
| 4 | **Idempotency**                       | Safe to run multiple times without harm |
| 5 | **Secure file paths & permissions**   | Avoid leaking credentials or logs |
| 6 | **Parameterise when useful**          | Re-use the same script in staging/prod |
| 7 | **Exit with meaningful codes**        | Lets *cron* e-mail failures only |

---

## Part 2 · `daily_maintenance.sh`

```bash
#!/usr/bin/env bash
# daily_maintenance.sh
# Description: Fetches a web page daily, stores result & logs actions.
# Author: <your-name>
# -----------------------------------------------------------------------------

set -euo pipefail

# 1. Ensure curl exists -------------------------------------------------------
if ! command -v curl >/dev/null 2>&1; then
  echo "[INFO] curl not found. Installing…" >&2
  sudo apt-get update -qq
  sudo apt-get install -y curl
fi

# 2. Prepare log directory ----------------------------------------------------
LOG_DIR="/var/log/devops-logs"
sudo mkdir -p "$LOG_DIR"
sudo chown "$(id -u)":"$(id -g)" "$LOG_DIR"

# 3. Download web page --------------------------------------------------------
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="$LOG_DIR/assuresoft_${TIMESTAMP}.html"

echo "[INFO] Downloading assuresoft.com → $OUTPUT_FILE"
curl -sSL "https://assuresoft.com" -o "$OUTPUT_FILE"
CURL_EXIT_CODE=$?

# 4. Write to script log ------------------------------------------------------
{
  echo "-------------------------------------------"
  echo "Run date : $(date --rfc-3339=seconds)"
  echo "Output    : $OUTPUT_FILE"
  echo "curl code : $CURL_EXIT_CODE"
} >> "$LOG_DIR/script.log"
Tip: make it executable once, then move it somewhere in $PATH

bash
Copiar
Editar
chmod +x daily_maintenance.sh
sudo mv daily_maintenance.sh /usr/local/bin/

Part 3 · Cron scheduling
cron
Copiar
Editar
# ┌─ Minute (0-59)
# │ ┌─ Hour   (0-23)
# │ │ ┌─ Day-of-month (1-31)
# │ │ │ ┌─ Month (1-12)
# │ │ │ │ ┌─ Day-of-week (0-7, Sun=0/7)
# │ │ │ │ │
45 8 * * * /usr/local/bin/daily_maintenance.sh
Add it interactively:

bash
Copiar
Editar
crontab -e               # choose nano/vim, paste the line, save

Part 4 · Documentation & Results
A. Script walk-through
Section	What it does
Prerequisites	Detects curl; if missing, installs it via apt
Setup	Creates /var/log/devops-logs/, fixes ownership
Fetch	Downloads assuresoft.com, names file with a timestamp
Logging	Appends run date, saved file path, and curl exit code to script.log

B. Testing procedure
Dry-run the script manually:

bash
Copiar
Editar
./daily_maintenance.sh
Verify outputs

bash
Copiar
Editar
ls -l /var/log/devops-logs/
tail -n 5 /var/log/devops-logs/script.log
Simulate cron: run with bash -x and/or adjust cron to */2 * * * * temporarily.

C. Command used to register cron
bash
Copiar
Editar
( crontab -l ; echo "45 8 * * * /usr/local/bin/daily_maintenance.sh" ) | crontab -
(Keeps existing entries intact.)

D. Evidence / Screenshots
Replace the placeholders below with your actual screenshots.

File	Description
Portion of script.log after several days
Output of crontab -l, showing our entry