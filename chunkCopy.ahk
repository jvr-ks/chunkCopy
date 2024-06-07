/*
 *********************************************************************************
 * 
 * chunkCopy.ahk
 *
 * Version: -> appVersion
 * 
 * Copyright (c) 2024 jvr.de. All rights reserved.
 *
 * File encoding: "*.ahk" UTF-8-BOM, "*.ini" UTF-16 LE-BOM
 *
 *********************************************************************************
*/
/*
 *********************************************************************************
 * 
 * GNU GENERAL PUBLIC LICENSE
 * 
 * A copy is included in the file "license.txt"
 *
  *********************************************************************************
*/

#Requires AutoHotkey v2

#SingleInstance Force
#Warn

#Include chunkCopyParams.ahk
#Include chunkCopyMainGui.ahk
#Include chunkCopySettings.ahk
#Include chunkCopyHelper.ahk
#Include chunkCopyConfig.ahk
#Include language\language.ahk
#Include chunkCopyUpload.ahk

FileEncoding "UTF-8"

InstallKeybdHook 1
KeyHistory 50

SetWorkingDir A_ScriptDir

underConstruction := 1

appname := "ChunkCopy"
appnameLower := "chunkCopy"
appVersion := "0.021"
operationRunning := 0
currentFile := ""
showProgress := 0
finishedActionMode := 1
testmode := 0
autoAction := ""
autoclose := 0
showlog := 0
guiSettingsHWND := 0
mainGuiText1Buffer := []
mainGuiText1Pointer := 1

quot := "`""
;"

appDataDir := A_AppDataCommon "\" appnameLower "\"

if (!FileExist(AppDataDir)){
  DirCreate(AppDataDir)
}

configFile := appnameLower ".ini"
configFileAppData := appDataDir appnameLower "_" A_ComputerName ".ini"

if (FileExist(configFileAppData)){
  configFile := configFileAppData
}

if (FileExist("_" appnameLower ".ini")){
  configFile := "_"  appnameLower ".ini"
}
  
readConfig()

HotIfWinActive "ChunkCopy"
hotkey abortHotkey, stopChunkCopy, "On"

if (WinExist("ahk_exe robocopy.exe")){
  showHintColoredTop("WARNING: Robocopy is already running, if it was started by chunkCopy press ESCAPE key now!")
  sleep 6000
}

checkLanguageFiles()
lang_init() ; language initialization function

createMainGui()

lang_init()

handleParams() ; partially overwrites config values!

msg2 := "Please select a menu entry!"

if (testmode){
  settingsMenu.Check("Testmode")
  msg2 .= " (`"testmode`" is activated)"
} else {
  settingsMenu.UnCheck("Testmode")
}

mainGuiText1Append(msg2)



settimer heartbeat, -1

sleep 3000

switch autoAction {
  case "startupload":
    finishedActionMode := 5
    automode := 1
    uploadStart()
  
  case "createtestfile":
    automode := 1
    createTestfile()
    exitApp
    
  case "createtestfiles5":
    automode := 1
    createTestfiles5()
    exitApp
    
  case "createtestfiles10":
    automode := 1
    createTestfiles10()
    exitApp
    
  case "compare":
    automode := 1
    compareFiles()
    exitApp
  
  case "deleteTestfilesTo":
    automode := 1
    deleteTestfilesTo()
    exitApp

  case "deleteTestfiles":
    automode := 1
    deleteTestfiles()
    exitApp
}


return

;--------------------------------- heartbeat ---------------------------------
heartbeat(){
  global
  local l

  l := mainGuiText1Buffer.Length
  if ( l > 0){
    if (mainGuiText1Pointer > 0 && mainGuiText1Pointer <= l){
      mainGuiText1.Value .= mainGuiText1Buffer[mainGuiText1Pointer]
      SendMessage 0x0115, 7, 0, hwndText1 ; SB_LINEDOWN : 1;  SB_PAGEDOWN : 3; SB_BOTTOM: 7 ; SB_LINEUP : 0
      mainGuiText1Pointer += 1
    }
  }
  if (showProgress)
    advanceProgress()
    
  settimer heartbeat, -100
}
;------------------------------- stopChunkCopy -------------------------------
stopChunkCopy(*){
  exit()
}
;----------------------------------- exit -----------------------------------
exit(s1 := "Escape key pressed!", s2 := "Thank you for using `"chunkCopy`", by, by ...", *){
  global
  
  if (s1 != "")
    mainGuiText1Append(s1)
  
  if (InStr(getRunningAppsAsString(), "robocopy")){
    s1 := "Exiting `"chunkCopy`" does NOT STOP the current upload!"
  }
  
  if (WinExist("ahk_exe fc.exe")){
    s1 := "Exiting `"chunkCopy`" does NOT STOP the compare upload!"
  }
  mainGuiText1Append(s2)
  
  sleep 3000
  
  cleanMemory()
    
  exitApp
}

;----------------------------------------------------------------------------




