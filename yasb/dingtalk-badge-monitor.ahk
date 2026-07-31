#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

CoordMode("Pixel", "Screen")
A_IconTip := "钉钉提醒"
TraySetIcon("C:\Program Files (x86)\DingDing\main\current\DingTalk.exe", 1, true)

global DingTalkUnread := false
global StateInitialized := false
global StatePath := EnvGet("LOCALAPPDATA") "\YASB\dingtalk_badge_state.txt"
global ToastExe := EnvGet("LOCALAPPDATA") "\YASB\DingTalkToast.exe"
global BlinkGui := 0
global BlinkEnabled := false
global BlinkVisible := false
global BlinkX := 0
global BlinkY := 0
global BlinkColor := 0x181825

SetTimer(CheckDingTalkBadge, 2000)
CheckDingTalkBadge()

CheckDingTalkBadge() {
    global DingTalkUnread, StateInitialized, StatePath, ToastExe, BlinkGui, BlinkVisible

    Critical("On")
    if IsObject(BlinkGui) && BlinkVisible {
        BlinkGui.Hide()
        BlinkVisible := false
        Sleep(30)
    }

    screenLeft := SysGet(76)
    screenTop := SysGet(77)
    screenWidth := SysGet(78)
    scanLeft := screenLeft + Floor(screenWidth * 0.65)
    scanRight := screenLeft + screenWidth - 20
    scanBottom := screenTop + 60
    searchX := scanLeft
    foundUnread := false

    while searchX <= scanRight && PixelSearch(&redX, &redY, searchX, screenTop, scanRight, scanBottom, 0xF94D19, 45) {
        blueLeft := Max(screenLeft, redX - 24)
        blueTop := Max(screenTop, redY - 6)
        blueRight := Min(screenLeft + screenWidth - 1, redX + 5)
        blueBottom := redY + 24

        if PixelSearch(&blueX, &blueY, blueLeft, blueTop, blueRight, blueBottom, 0x007CFE, 55) {
            foundUnread := true
            break
        }

        searchX := redX + 1
    }

    if !StateInitialized {
        StateInitialized := true
        WriteState(foundUnread ? "unread" : "clear")
    }

    if foundUnread && !DingTalkUnread {
        DingTalkUnread := true
        WriteState("unread")
        SoundPlay("*64")
        Run('"' ToastExe '"', , "Hide")
        StartBlink(redX, redY)
    } else if foundUnread {
        UpdateBlinkPosition(redX, redY)
    } else if !foundUnread && DingTalkUnread {
        DingTalkUnread := false
        WriteState("clear")
        StopBlink()
    }
    Critical("Off")
}

StartBlink(redX, redY) {
    global BlinkGui, BlinkEnabled, BlinkVisible

    if !IsObject(BlinkGui) {
        BlinkGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    }

    UpdateBlinkPosition(redX, redY)
    BlinkEnabled := true
    BlinkVisible := false
    SetTimer(BlinkBadge, 500)
    BlinkBadge()
}

UpdateBlinkPosition(redX, redY) {
    global BlinkX, BlinkY, BlinkColor
    BlinkX := redX - 17
    BlinkY := redY - 2
    BlinkColor := PixelGetColor(redX + 8, redY + 10)
}

BlinkBadge() {
    global BlinkGui, BlinkEnabled, BlinkVisible, BlinkX, BlinkY, BlinkColor

    if !BlinkEnabled || !IsObject(BlinkGui)
        return

    if BlinkVisible {
        BlinkGui.Hide()
        BlinkVisible := false
    } else {
        BlinkGui.BackColor := Format("{:06X}", BlinkColor)
        BlinkGui.Show("NA x" BlinkX " y" BlinkY " w22 h22")
        WinSetTransparent(255, "ahk_id " BlinkGui.Hwnd)
        BlinkVisible := true
    }
}

StopBlink() {
    global BlinkGui, BlinkEnabled, BlinkVisible
    BlinkEnabled := false
    SetTimer(BlinkBadge, 0)
    if IsObject(BlinkGui)
        BlinkGui.Hide()
    BlinkVisible := false
}

WriteState(state) {
    global StatePath
    if FileExist(StatePath)
        FileDelete(StatePath)
    FileAppend(state, StatePath, "UTF-8")
}
