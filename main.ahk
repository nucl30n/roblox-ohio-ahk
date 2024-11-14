#Requires AutoHotkey v2.0
; Author:
; Version: 0.1
; Alt + H toggles the auto-heal (higher pitched beep = ON; lower tone == OFF
; Only works when Roblox is the active window and full screen
; Assumes heals are in slot 8 and up
; Slot 8 should be medkit, slot 9, 10, 11, 12 etc should be bandage, etc.
; 1080p support oly (so far)
; to-do: checkMedkit func, check type of heal in slot and calibrate number of heals to health needed

toggle := false
lowHealth := 0x000000
checkInterval := 100
coords := {
    1080p: {
        w: 1920,
        h: 1080,
        healthY: 900,
        gunY: 951,
        gunX: [540, 644, 750, 855, 960, 1065, 1170, 1275, 1380],
        healthX: [875, 900, 925, 950, 975, 1000, 1025, 1050]
    }
}
hasMedkit := true
medkitSlot := "8"
healSlot := "9"
title := "Roblox"
activeGun := "2"
resolution := "1080p"

mainLoop() {
    global coords, toggle, title
    h := 0
    w := 0
    WinExist("A") && WinGetPos(&x, &y, &w, &h, "A")
    proceed := true
    proceed := proceed && toggle
    proceed := proceed && WinExist("A") && InStr(WinGetTitle("A"), title, false)
    proceed := proceed && (w = coords[resolution].w && h = coords[resolution].h)
    checkEquipped()
    checkMedkit()
    return proceed ? Heal() : Sleep(20)
}

Heal() {
    global coords, resolution, lowHealth, hasMedkit
    x := coords[resolution].healthX
    y := coords[resolution].healthY
    for i, val in x {
        amount := x.Length - i
        if (PixelGetColor(val, y, "RGB") == lowHealth) && amount > 0 {
            return useHeal(amount)
        }
    }
    return
}

checkEquipped() {
    global coords, resolution, activeGun
    x := coords[resolution].gunX
    y := coords[resolution].gunY
    for i, val in x {
        min := 200
        color := PixelGetColor(x[i], y, "RGB") & 0xFFFFFF
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF
        if ((r > min) && (b > min) && (g > min)) {
            activeGun := Format("{:d}", i)
            return
        }
    }
    return
}

checkMedkit() {
    ; not implemented
    return true
}

useHeal(count) {
    global hasMedkit, medkitSlot, healSlot, activeGun
    hasMedkit := checkMedkit()
    Send((hasMedkit && count > 5) ? medkitSlot : (hasMedkit ? healSlot : medkitSlot))
    loop count {
        ; need to align count better to healing amount per eat
        Click()
        Sleep(10)
    }
    Send(activeGun)
}

XButton2:: {
    useHeal(1)
}

!h:: {
    global toggle
    hasMedkit := !toggle
    toggle := !toggle
    SoundBeep(toggle ? 1000 : 200)
}

SetTimer(mainLoop, checkInterval)
