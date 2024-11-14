#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 3
; ctrl alt z toggles the afk mode

toggle := false
title := "Roblox"
interval := 10000
mode := "click"
; screenX := SysGet(78)
; screenY := SysGet(79)

mainLoop() {
    global toggle, title, mode, screenX, screenY
    h := 0
    w := 0
    ; WinExist("A") && WinGetPos(&x, &y, &w, &h, "A")
    proceed := true
    proceed := proceed && WinExist("A") && InStr(WinGetTitle("A"), title, false)
    ; proceed := proceed && (w = screenX && h = ScreenY)
    return proceed ? Action() : Sleep(0)
}

SetTimer(mainLoop, "Off")

Action() {
    global mode
    switch mode {
        case "click":
            Click()
        case "switch":
            Send(1)
            Send(2)
        case "jump":
            Send(" ")
    }
    return
}

^!z:: {
    global toggle
    toggle := !toggle
    SoundBeep(toggle ? 1000 : 200)
    SetTimer(mainLoop, toggle ? interval : "Off")
}
