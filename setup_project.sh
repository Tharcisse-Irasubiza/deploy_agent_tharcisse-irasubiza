#!/bin/bash
set -e

# Check if user provided a project name
# Check if user provided a project name
if [ -z "$1" ]; then
  echo "⚠️  You must provide a project name!"
  echo "Usage: $0 <project_name>"
  echo "Example: ./setup_project.sh classA"
  exit 1
fi

PROJECT_NAME="attendance_tracker_$1"


# Trap for Ctrl+C (SIGINT)
trap 'echo "Interrupt detected. Archiving project..."; 
      tar -czf ${PROJECT_NAME}_archive.tar.gz "$PROJECT_NAME"; 
      rm -rf "$PROJECT_NAME"; 
      echo "Project archived and cleaned."; 
      exit 1' SIGINT

# Create directories
mkdir -p "$PROJECT_NAME/Helpers"
mkdir -p "$PROJECT_NAME/reports"

# ===========================
# Create attendance_checker.py with provided source code
# ===========================
cat > "$PROJECT_NAME/attendance_checker.py" <<'EOL'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    # 1. Load Config
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    
    # 2. Archive old reports.log if it exists
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    # 3. Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\\n")
        
        for row in reader:
            name = row['Name']
            email = row['Email']
            attended = int(row['Attendance Count'])
            
            # Simple Math: (Attended / Total) * 100
            attendance_pct = (attended / total_sessions) * 100
            
            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
EOL

# ===========================
# Create assets.csv with sample data
# ===========================
cat > "$PROJECT_NAME/Helpers/assets.csv" <<EOL
Email,Name,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOL

# ===========================
# Prompt for thresholds
# ===========================
warning=75
failure=50
total_sessions=15
run_mode="live"

read -p "Enter Warning threshold (default 75): " input_warning
read -p "Enter Failure threshold (default 50): " input_failure
read -p "Enter Total Sessions (default 15): " input_sessions
read -p "Run mode (live/dry, default live): " input_mode

if [[ $input_warning =~ ^[0-9]+$ ]]; then
  warning=$input_warning
fi
if [[ $input_failure =~ ^[0-9]+$ ]]; then
  failure=$input_failure
fi
if [[ $input_sessions =~ ^[0-9]+$ ]]; then
  total_sessions=$input_sessions
fi
if [[ $input_mode == "dry" ]]; then
  run_mode="dry"
fi

# ===========================
# Create config.json
# ===========================
cat > "$PROJECT_NAME/Helpers/config.json" <<EOL
{
  "total_sessions": $total_sessions,
  "run_mode": "$run_mode",
  "thresholds": {
    "warning": $warning,
    "failure": $failure
  }
}
EOL

# ===========================
# Generate reports.log dynamically from assets.csv
# ===========================
{
  echo "--- Attendance Report Run: $(date) ---"
  echo "[INFO] Current thresholds: Warning=$warning%, Failure=$failure%"
  
  # Skip header line and process each student
  tail -n +2 "$PROJECT_NAME/Helpers/assets.csv" | while IFS=',' read -r email name attended absent; do
    total=$((attended + absent))
    if [ $total -gt 0 ]; then
      percent=$(( attended * 100 / total ))
    else
      percent=0
    fi

    if [ $percent -lt $failure ]; then
      echo "[ALERT] SENT TO $email: URGENT: $name, your attendance is $percent%. You will fail this class."
    elif [ $percent -lt $warning ]; then
      echo "[ALERT] SENT TO $email: WARNING: $name, your attendance is $percent%. You are at risk."
    else
      echo "[INFO] $name is SAFE ($percent%)."
    fi
  done
} > "$PROJECT_NAME/reports/reports.log"


# ===========================
# Create image placeholder
# ===========================
echo "Image placeholder" > "$PROJECT_NAME/image.png"

# ===========================
# Environment validation
# ===========================
if command -v python3 &>/dev/null; then
  echo "✅ Python3 is installed: $(python3 --version)"
else
  echo "⚠️ Warning: Python3 is not installed."
fi

echo "Project setup complete in $PROJECT_NAME"

