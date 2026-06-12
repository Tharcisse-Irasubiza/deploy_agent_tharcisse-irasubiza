# Attendance Tracker Project Factory

## 📦 Setup Instructions

1. Make the script executable:

```bash
chmod +x setup_project.sh
```

2. Run the script with a project name:

```bash
./setup_project.sh myproject
```

This will create a directory named `attendance_tracker_myproject` with all required files and subfolders.

### ⚠️ Reminder

You must provide a project name when running the script.

If you forget, the script will stop and display:

```text
⚠️ You must provide a project name!
Usage: ./setup_project.sh <project_name>
Example: ./setup_project.sh classA
```

---

## ⚙️ Configuration

During setup, the script prompts you to enter:

* Warning threshold (default: 75)
* Failure threshold (default: 50)
* Total sessions (default: 15)
* Run mode (`live` or `dry`, default: `live`)

These values are saved in `Helpers/config.json` in the following format:

```json
{
  "total_sessions": 15,
  "run_mode": "live",
  "thresholds": {
    "warning": 75,
    "failure": 50
  }
}
```

---

## 🛑 Archive Feature (Signal Trap)

If you press **Ctrl+C** while the script is running:

* The script catches the interrupt signal.
* It creates a compressed archive of the current project state.
* The archive is named:

```text
attendance_tracker_myproject_archive.tar.gz
```

* The incomplete project directory is then removed to keep the workspace clean.

---

## 🧩 Reports

The script creates an initial log file:

```text
reports/reports.log
```

with a placeholder message.

When you run:

```bash
python3 attendance_checker.py
```

the Python program:

1. Reads `Helpers/assets.csv`
2. Reads `Helpers/config.json`
3. Calculates attendance percentages for each student
4. Archives old report logs automatically
5. Generates a new `reports/reports.log`
6. Creates warning and failure alerts when required

### Example Output

```text
--- Attendance Report Run: 2026-06-12 14:00:00 ---
[INFO] Current thresholds: Warning=75%, Failure=50%
[INFO] Alice Johnson is SAFE (93.3%).
[ALERT] SENT TO bob@example.com: URGENT: Bob Smith, your attendance is 46.7%. You will fail this class.
[ALERT] SENT TO charlie@example.com: URGENT: Charlie Davis, your attendance is 26.7%. You will fail this class.
[INFO] Diana Prince is SAFE (100.0%).
```

---

## 📂 Project Structure

```text
attendance_tracker_myproject/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
├── reports/
    └── reports.log
```

---

## 🚀 Quick Start Demo

```bash
chmod +x setup_project.sh
./setup_project.sh classA
cd attendance_tracker_classA
python3 attendance_checker.py
```

Expected result:

```text
Project created successfully!
Attendance checker initialized.
Report generated in reports/reports.log
```

---

## ✅ Requirements

* Bash shell environment
* Python 3 installed

Check Python installation:

```bash
python3 --version
```

Example:

```text
Python 3.12.3
```

---

## 📝 Notes

* The project factory automatically creates the required folder structure.
* Configuration values can be customized during setup.
* Existing reports are archived before new reports are generated.
* The signal trap prevents incomplete project folders from being left behind if setup is interrupted.
