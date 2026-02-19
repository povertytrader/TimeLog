; ============================================================
; Timesheet Pro - Quick Entry (AutoHotkey v2)
; ============================================================
; 
; HOW IT WORKS:
;   1. Select any text in any app (Outlook, Teams, browser, etc.)
;   2. Press Ctrl+Alt+T
;   3. A popup appears with the selected text as the task
;   4. Fill in client, project, hours and save
;
; INSTALLATION:
;   1. Install AutoHotkey v2 from https://www.autohotkey.com
;   2. Double-click this file to run it
;   3. A clock icon appears in your system tray
;   4. To auto-start: press Win+R, type shell:startup, 
;      and paste a shortcut to this file there
;
; CONFIGURATION:
;   Change the URL below to match where your app is hosted
; ============================================================

APP_URL := "http://localhost:8080/timesheet.html"
BROWSER_PATH := ""

; Auto-detect browser
DetectBrowser() {
    chrome := "C:\Program Files\Google\Chrome\Application\chrome.exe"
    edge := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    if FileExist(chrome)
        return chrome
    if FileExist(edge)
        return edge
    return ""
}

BROWSER_PATH := DetectBrowser()

; System tray setup
A_IconTip := "Timesheet Pro - Ctrl+Alt+T to log entry"
TraySetIcon("shell32.dll", 22)

trayMenu := A_TrayMenu
trayMenu.Delete()
trayMenu.Add("New Timesheet Entry", (*) => CaptureAndOpen())
trayMenu.Add("New Entry (no text)", (*) => OpenBlank())
trayMenu.Add()
trayMenu.Add("Open Timesheet App", (*) => OpenApp())
trayMenu.Add()
trayMenu.Add("Exit", (*) => ExitApp())
trayMenu.Default := "New Timesheet Entry"

; Hotkey: Ctrl+Alt+T
^!t:: CaptureAndOpen()

CaptureAndOpen() {
    clipSaved := A_Clipboard
    A_Clipboard := ""
    Send("^c")
    if !ClipWait(1) {
        A_Clipboard := clipSaved
        OpenBlank()
        return
    }
    selectedText := A_Clipboard
    A_Clipboard := clipSaved
    
    ; Clean up the text - remove extra whitespace and newlines
    selectedText := RegExReplace(selectedText, "\r?\n", " ")
    selectedText := RegExReplace(selectedText, "\s+", " ")
    selectedText := Trim(selectedText)
    
    ; Truncate if too long (URL safe)
    if StrLen(selectedText) > 200
        selectedText := SubStr(selectedText, 1, 200)
    
    OpenWithTask(selectedText)
}

OpenWithTask(taskText) {
    encoded := UriEncode(taskText)
    url := APP_URL . "?task=" . encoded . "&hours=1&popup=1"
    LaunchApp(url)
}

OpenBlank() {
    url := APP_URL . "?popup=1"
    LaunchApp(url)
}

OpenApp() {
    LaunchApp(APP_URL)
}

LaunchApp(url) {
    if BROWSER_PATH = "" {
        Run(url)
        return
    }
    Run('"' . BROWSER_PATH . '" "--app=' . url . '"')
}

UriEncode(str) {
    result := ""
    loop parse, str {
        ch := A_LoopField
        if RegExMatch(ch, "[A-Za-z0-9_.~-]")
            result .= ch
        else {
            code := Ord(ch)
            if code < 128 {
                result .= "%" . Format("{:02X}", code)
            } else {
                ; Handle UTF-8 encoding for non-ASCII
                buf := Buffer(4)
                len := StrPut(ch, buf, "UTF-8") - 1
                loop len
                    result .= "%" . Format("{:02X}", NumGet(buf, A_Index - 1, "UChar"))
            }
        }
    }
    return result
}
