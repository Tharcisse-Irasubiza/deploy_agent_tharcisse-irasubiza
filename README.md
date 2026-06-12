markdown
# Attendance Tracker Project Factory

## 📦 Setup Instructions
1. Make the script executable:
   ```bash
   chmod +x setup_project.sh
Run the script with a project name:

bash
./setup_project.sh myproject
This will create a directory named attendance_tracker_myproject with all required files and subfolders.

⚠️ Reminder: You must provide a project name when running the script.
If you forget, the script will stop and show:

Code
⚠️  You must provide a project name!
Usage: ./setup_project.sh <project_name>
Example: ./setup_project.sh classA
⚙️ Configuration
During setup, the script will prompt you to enter:

Warning threshold (default 75)

Failure threshold (default 50)

Total sessions (default 15)

Run mode (live or dry, default live)

These values are written into Helpers/config.json in the following format:

json
{
  "total_sessions": 15,
  "run_mode": "live",
  "thresholds": {
    "warning": 75,
    "failure": 50
  }
}
🛑 Archive Feature (Signal Trap)
If you press Ctrl+C while the script is running:

The script catches the interrupt signal.

It bundles the current project state into an archive file named:

Code
attendance_tracker_myproject_archive.tar.gz
It then deletes the incomplete directory to keep your workspace clean.

🧩 Reports
The script creates an initial reports/reports.log file with a placeholder message.

When you run:

bash
python3 attendance_checker.py
the Python program:

Reads Helpers/assets.csv and Helpers/config.json

Calculates attendance percentages for each student

Archives old logs automatically

Writes alerts into a new reports/reports.log

Example Output
Code
--- Attendance Report Run: 2026-06-12 14:00:00 ---
[INFO] Current thresholds: Warning=75%, Failure=50%
[INFO] Alice Johnson is SAFE (93.3%).
[ALERT] SENT TO bob@example.com: URGENT: Bob Smith, your attendance is 46.7%. You will fail this class.
[ALERT] SENT TO charlie@example.com: URGENT: Charlie Davis, your attendance is 26.7%. You will fail this class.
[INFO] Diana Prince is SAFE (100.0%).
📂 Project Structure
Code
attendance_tracker_myproject/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
├── reports/
│   └── reports.log
└── image.png
✅ Requirements
Bash shell environment

Python3 installed (python3 --version)

Code

---

This single README file now covers **everything in one place**: setup, user input, archive behavior, reports generation, sample output, and folder structure. It’s ready to be committed alongside your script.  

Would you like me to also add a **quick-start demo section** (showing the exact commands and outputs
