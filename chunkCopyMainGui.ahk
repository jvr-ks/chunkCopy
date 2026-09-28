; chunkCopyMainGui.ahk
; Part of chunkCopy.ahk

;------------------------------- createMainGui -------------------------------
createMainGui(fg := "c000000", bg := "FFFFFF"){
  global
  
  testMenu := Menu()
  testMenu.Add("Testmode", toggleTestmode)
  testMenu.Add("Open .\To directory (testmode)", openDir.Bind("To (testmode)"))
  testMenu.Add("Open .\From directory (testmode)", openDir.Bind("From (testmode)"))
  testMenu.Add("Create testfile", actionDo.Bind("Create testfile"))
  testMenu.Add("Create 5 testfiles", actionDo.Bind("Create 5 testfiles"))
  testMenu.Add("Create 10 testfiles", actionDo.Bind("Create 10 testfiles"))
  testMenu.Add("")
  testMenu.Add("Show testmode logfile (ext)", showLogFile.Bind("chunkCopyLogTest.txt"))
  testMenu.Add("")
  testMenu.Add("Delete testfiles in the `"To`" folder", actionDo.Bind("Delete testfiles in the `"To`" folder"))
  testMenu.Add("Delete all testfiles (From and To)", actionDo.Bind("Delete all testfiles (From and To)"))
  testMenu.Add("")
  
  
  openDirMenu := Menu()
  openDirMenu.Add("To", openDir.Bind("To"))
  openDirMenu.Add("From", openDir.Bind("From"))

  openDirMenu.Add("App", openDir.Bind("App"))
  openDirMenu.Add("Config", openDir.Bind("Config"))
  
  logFileMenu := Menu()
  logFileMenu.Add("Show logfile (ext)", showLogFile.Bind("chunkCopyLog.txt"))
  logFileMenu.Add("Show Robocopy temporary log file (ext)", showRoboLogFile)
  
  actionMenu := Menu()
  actionMenu.Add("Taskscheduler (ext)", startTaskschd)
  actionMenu.Add("Compare", actionDo.Bind("Compare"))
  actionMenu.Add("Start update (ext) [app is closed]", startUpdate)
  actionMenu.Add("Open Github webpage (Browser)", openGithub)
  
  settingsMenu := Menu()
  settingsMenu.Add("Settings", openSettingsMenu)
  settingsMenu.Add("Testmode", toggleTestmode)
  
  mainGuiMenu := MenuBar()
  mainGuiMenu.Add("Start Upload", uploadStart)
  mainGuiMenu.Add("Logfile", logFileMenu)
  mainGuiMenu.Add("Settings", settingsMenu)
  mainGuiMenu.Add("Commands", actionMenu)
  mainGuiMenu.Add("Open Directories", openDirMenu)
  mainGuiMenu.Add("Test", testMenu)
  mainGuiMenu.Add("🗙", closeMainGui)
  
 
  width := 600
  xStart := 12
  mainGui := Gui("+AlwaysOnTop +caption +maximizebox -resize", appName " " appVersion " [" lang("language") "]" )
  mainGui.SetFont("s" fontsize, fontname)
  
  mainGui.MenuBar := mainGuiMenu
  
  GB1 := mainGui.Add("GroupBox", "x" xStart " y2 r1 section w" width - 10, "Files per chunk")
  
  chchecked1 := (filesPerPass = 1) ? "checked" : ""
  chchecked2 := (filesPerPass = 2) ? "checked" : ""
  chchecked3 := (filesPerPass = 3) ? "checked" : ""
  chchecked4 := (filesPerPass = 4) ? "checked" : ""
  chchecked5 := (filesPerPass = 5) ? "checked" : ""
  chchecked10 := (filesPerPass = 10) ? "checked" : ""
  chchecked15 := (filesPerPass = 15) ? "checked" : ""
  chchecked20 := (filesPerPass = 20) ? "checked" : ""
  
  chunkNumberAction_1 := mainGui.add("Radio", "xs+4 yp+25 section Group VchunkNumber1 " chchecked1, "1")
  chunkNumberAction_2 := mainGui.add("Radio", "x+m yp+0 VchunkNumber2 " chchecked2, "2")
  chunkNumberAction_3 := mainGui.add("Radio", "x+m yp+0 VchunkNumber3 " chchecked3, "3")
  chunkNumberAction_4 := mainGui.add("Radio", "x+m yp+0 VchunkNumber4 " chchecked4, "4")
  chunkNumberAction_5 := mainGui.add("Radio", "x+m yp+0 VchunkNumber5 " chchecked5, "5")
  chunkNumberAction_10 := mainGui.add("Radio", "x+m yp+0 VchunkNumber10 " chchecked10, "10")
  chunkNumberAction_15 := mainGui.add("Radio", "x+m yp+0 VchunkNumber15 " chchecked15, "15")
  chunkNumberAction_20 := mainGui.add("Radio", "x+m yp+0 VchunkNumber20 " chchecked20, "20")
  chunkNumberAction_9999 := mainGui.add("Radio", "x+m yp+0 VchunkNumber9999 " chchecked20, "9999")

  chunkNumberAction_1.OnEvent("Click", (*) => (filesPerPass := 1, filesPerPassSave()))
  chunkNumberAction_2.OnEvent("Click", (*) => (filesPerPass := 2, filesPerPassSave()))
  chunkNumberAction_3.OnEvent("Click", (*) => (filesPerPass := 3, filesPerPassSave()))
  chunkNumberAction_4.OnEvent("Click", (*) => (filesPerPass := 4, filesPerPassSave()))
  chunkNumberAction_5.OnEvent("Click", (*) => (filesPerPass := 5, filesPerPassSave()))
  chunkNumberAction_10.OnEvent("Click", (*) => (filesPerPass := 10, filesPerPassSave()))
  chunkNumberAction_15.OnEvent("Click", (*) => (filesPerPass := 15, filesPerPassSave()))
  chunkNumberAction_20.OnEvent("Click", (*) => (filesPerPass := 20, filesPerPassSave()))
  chunkNumberAction_9999.OnEvent("Click", (*) => (filesPerPass := 9999, filesPerPassSave()))
  
  GB2 := mainGui.Add("GroupBox", "x" xStart " r1 section w" width - 20, "After completion")
  
  finishedActionChecked1 := (finishedActionMode = 1) ? "checked" : ""
  finishedActionChecked2 := (finishedActionMode = 2) ? "checked" : ""
  finishedActionChecked3 := (finishedActionMode = 3) ? "checked" : ""
  finishedActionChecked4 := (finishedActionMode = 4) ? "checked" : ""

  finishedAction_1 := mainGui.add("Radio", "xs+4 yp+25 Group " finishedActionChecked1, "do nothing")
  finishedAction_2 := mainGui.add("Radio", "x+m yp+0 " finishedActionChecked2, "shutdown")
  finishedAction_3 := mainGui.add("Radio", "x+m yp+0 " finishedActionChecked3, "hibernate")
  finishedAction_4 := mainGui.add("Radio", "x+m yp+0 " finishedActionChecked4, "sleep")

  finishedAction_1.OnEvent("Click", (*) => (finishedActionMode := 1, finishedActionModeSave()))
  finishedAction_2.OnEvent("Click", (*) => (finishedActionMode := 2, finishedActionModeSave()))
  finishedAction_3.OnEvent("Click", (*) => (finishedActionMode := 3, finishedActionModeSave()))
  finishedAction_4.OnEvent("Click", (*) => (finishedActionMode := 4, finishedActionModeSave()))
  
  ; mainGuiTextPg1 := mainGui.add("Text", "x" xStart " w40")
  ; mainGuiPg1 := mainGui.add("Progress",  "x+m yp+0 w" round(width - 40) " h20 cBlue VuploadProgress Smooth")
  
  mainGuiPg1 := mainGui.add("Progress",  "x" xStart " w" (width - 45) " h20 cBlue VuploadProgress Smooth")
  mainGuiTextPg1 := mainGui.add("Text", "x+m yp+0 w40")
  mainGuiText1 := mainGui.add("Edit", "x" xStart " w" width " r5 readonly")
  hwndText1 := mainGuiText1.hwnd
  
  if (testmode){
    settingsMenu.Check("Testmode")
  } else {
    settingsMenu.UnCheck("Testmode")
  }
  
  mainGui.Show("y10 xcenter")
  mainGui.OnEvent("Size", mainGui_Size , 1)
  mainGui.OnEvent("Close", mainGui_Close)
}

;------------------------------- mainGui_Size -------------------------------
mainGui_Size(*){
  global
  
  ; Currently, the window is fixed ...
}
;------------------------------- mainGui_Close -------------------------------
mainGui_Close(*){
  global
  
  if (guiSettingsHWND != 0){
    saveConfig()
  }
  
  exit("")
}
;------------------------------- closemainGui -------------------------------
closeMainGui(*){
  global
  
  if (guiSettingsHWND != 0){
    saveConfig()
  }
  
  exit("")
}
;---------------------------- mainGuiText1Append ----------------------------
mainGuiText1Append(s := ""){
  global
  
  mainGuiText1Buffer.push(s "`n")
}
;-------------------------- finishedActionModeSave --------------------------
finishedActionModeSave(){
  global

  IniWrite finishedActionMode, configFile, "config", "finishedActionMode"
}

;---------------------------- filesPerPassSave ----------------------------
filesPerPassSave(){
  global

  IniWrite filesPerPass, configFile, "config", "filesPerPass"
}
;--------------------------------- actionDo ---------------------------------
actionDo(action, *){
  global
  
  switch action {
    case "Compare":
      compareFiles()

    case "Create testfile":
      createTestfile()

    case "Create 5 testfiles":
      createTestfiles5()
      
    case "Create 10 testfiles":
      createTestfiles10()

    case "Delete testfiles in the `"To`" folder":
      deleteTestfilesTo()
      
    case "Delete all testfiles (From and To)":
      deleteTestfiles()

  }
}
;------------------------------- startTaskschd -------------------------------
startTaskschd(*){
  global

  run "taskschd.msc", A_ScriptDir

}
;-------------------------------- startUpdate --------------------------------
startUpdate(*){
  global  
  
  run A_ComSpec " /C updater.exe",,"Hide"
  
  exitApp
}
;-------------------------------- openGithub --------------------------------
openGithub(*){
  global  
  
  run A_ComSpec " /C start https://github.com/jvr-ks/chunkCopy#chunkcopy",,"Hide"
  
}
;----------------------------------------------------------------------------
















