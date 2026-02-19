# Timesheet Pro — Installation Guide

## What You Get

| File | Purpose |
|------|---------|
| `timesheet.html` | The main app (everything in one file) |
| `manifest.json` | PWA manifest (enables "Install as App") |
| `sw.js` | Service worker (offline support) |
| `TimesheetQuickEntry.ahk` | AutoHotkey script for Ctrl+Alt+T quick entry |
| `timesheet-context.reg` | *(Optional)* Windows registry for File Explorer right-click |

---

## Step 1 — Set Up the App

1. Create a folder anywhere, for example: `C:\TimesheetPro\`
2. Place these 3 files inside it:
   - `timesheet.html`
   - `manifest.json`
   - `sw.js`

---

## Step 2 — Run a Local Server

The app needs a web server to enable PWA features. Open **Command Prompt** or **PowerShell**, navigate to your folder, and run:

```
cd C:\TimesheetPro
python -m http.server 8080
```

> If you don't have Python, download it from https://www.python.org  
> During install, check **"Add Python to PATH"**

Leave this window open. Your app is now running at:  
**http://localhost:8080/timesheet.html**

---

## Step 3 — Install as a Desktop App (PWA)

1. Open **Google Chrome** or **Microsoft Edge**
2. Go to `http://localhost:8080/timesheet.html`
3. Click the **install icon** in the address bar (small monitor with arrow), or go to Menu → "Install Timesheet Pro..."
4. Click **Install** in the dialog

The app now opens in its own window, like a native app.

---

## Step 4 — Pin to Taskbar

After installing:
- **Right-click** the Timesheet Pro icon in your **taskbar** → **Pin to taskbar**
- Now it's always one click away

---

## Step 5 — Auto-Start on Boot (Optional)

To make the local server and app start automatically:

1. Press `Win + R`, type `shell:startup`, press Enter
2. Create a file called `start-timesheet.bat` with this content:

```bat
@echo off
cd /d C:\TimesheetPro
start /min python -m http.server 8080
```

3. Place it (or a shortcut to it) in the startup folder

---

## Step 6 — Quick Entry with Ctrl+Alt+T

This is the feature that lets you select text anywhere (Outlook, Teams, browser, etc.) and instantly create a timesheet entry.

### One-time setup:

1. **Install AutoHotkey v2** from https://www.autohotkey.com (download → install, takes 30 seconds)
2. Place `TimesheetQuickEntry.ahk` somewhere permanent, like `C:\TimesheetPro\`
3. **Double-click** the `.ahk` file — a small clock icon appears in your system tray (bottom-right)

### To auto-start the script:

1. Press `Win + R`, type `shell:startup`, press Enter
2. Right-click in the folder → **New → Shortcut**
3. Browse to `C:\TimesheetPro\TimesheetQuickEntry.ahk` and finish

### How to use it:

1. You're reading an email or a Teams message
2. **Select the text** describing the task
3. Press **Ctrl + Alt + T**
4. A compact popup opens with the text pre-filled
5. Pick Client, Project, Task, adjust hours → **Save**
6. Close the popup and keep working

---

## Summary — What Runs What

| What | How | Auto-start? |
|------|-----|-------------|
| Local server | `python -m http.server 8080` in the app folder | Put `.bat` file in `shell:startup` |
| The app itself | Chrome/Edge PWA, pinned to taskbar | Launches when you click the icon |
| Quick entry (Ctrl+Alt+T) | `TimesheetQuickEntry.ahk` running in tray | Put shortcut in `shell:startup` |

---

## Troubleshooting

- **"Install" button doesn't work?** → Make sure you're using Chrome or Edge, and accessing via `http://localhost:8080` (not by opening the file directly)
- **Ctrl+Alt+T doesn't work?** → Check the system tray for the AutoHotkey icon. If it's not there, double-click the `.ahk` file again
- **Popup opens but no text?** → Make sure you *selected* text before pressing the shortcut. It copies your selection automatically
- **Data disappeared?** → Data is stored in your browser's localStorage. If you clear browser data, use the Export feature first as backup
