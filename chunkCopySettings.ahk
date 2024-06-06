; chunkCopySettings.ahk
; Part of chunkCopy.ahk

;----------------------------- openSettingsMenu -----------------------------
openSettingsMenu(*){
  global
  
  inhibitIfoperationRunning()

  if (guiSettingsHWND = 0){
    readConfig()
    chunkCopySettings()
  } else {
    ;guiSettings.Show()
    saveConfig()
  }
}
;----------------------------- chunkCopySettings -----------------------------
chunkCopySettings(*){
  global
  
  guiSettingsMenu := MenuBar()
  ; guiSettingsMenu.Add("Testmode", toggleTestmode)
  guiSettingsMenu.Add("🗙 Close", saveConfig)
  
  guiSettings := Gui("+resize +owner", "Settings (Autosaved if closed!) [" configFile "]")
  guiSettings.SetFont("s" fontsize, fontname)
  
  guiSettings.MenuBar := guiSettingsMenu
  
  guiSettings.add("Text", "x5 y5 " , "from:                              ")
  from_Edit := guiSettings.add("Edit", " x+m y5 r1 w500 section", from)

  guiSettings.add("Text", "x5" , "to: ")
  to_Edit := guiSettings.add("Edit", " xs yp+0 r1 w500", to)

  guiSettings.add("Text", "x5" , "filesPerPass: ")
  filesPerPass_Edit := guiSettings.add("Edit", "xs yp+0 r1 w500", filesPerPass)
  
  guiSettings.add("Text", "x5" , "testmodeFrom: ")
  testmodeFrom_Edit := guiSettings.add("Edit", "xs yp+0 r1 w500", testmodeFrom)
  
  guiSettings.add("Text", "x5" , "testmodeTo: ")
  testmodeTo_Edit := guiSettings.add("Edit", "xs yp+0 r1 w500", testmodeTo)
  
  guiSettings.add("Text", "x5" , "fontname: ")
  fontname_Edit := guiSettings.add("Edit", "xs yp+0 r1 w500", fontname)
  
  guiSettings.add("Text", "x5" , "fontsize: ")
  fontsize_Edit := guiSettings.add("Edit", "xs yp+0 r1 w500", fontsize)
  
  guiSettings.add("Text", "x5" , "uploadDelay (millisec.): ")
  uploadDelay_Edit := guiSettings.add("Edit", "xs yp+0 r1 w500", uploadDelay)
  
  guiSettings.Show("center autosize")
  
  guiSettings.OnEvent("Close", saveConfig)
  
  guiSettingsHWND := guiSettings.hwnd
  
  return
}
;-------------------------------- saveConfig --------------------------------
saveConfig(*){
  global 
  
  from := from_Edit.Value
  to := to_Edit.Value
  filesPerPass := filesPerPass_Edit.Value
  uploadDelay := uploadDelay_Edit.Value
  testmodeFrom := testmodeFrom_Edit.Value
  testmodeTo := testmodeTo_Edit.Value
  fontname := fontname_Edit.Value
  fontsize := fontsize_Edit.Value
  
  saveConfigTo(configFile)
  
  guiSettings.Destroy()
  guiSettingsHWND := 0

}
;------------------------------- saveConfigTo -------------------------------
saveConfigTo(cfgFile){
  global
  
  IniWrite from, cfgFile, "config", "from"
  IniWrite to, cfgFile, "config", "to"
  IniWrite filesPerPass, cfgFile, "config", "filesPerPass"
  IniWrite testmodeFrom, cfgFile, "config", "testmodeFrom"
  IniWrite testmodeTo, cfgFile, "config", "testmodeTo"
  IniWrite fontname, cfgFile, "config", "fontname"
  IniWrite fontsize, cfgFile, "config", "fontsize"
  IniWrite uploadDelay, cfgFile, "config", "uploadDelay"
  
}
;---------------------------------- openDir ----------------------------------
openDir(d, *){
  global
  
  switch d {
    case "To":
      run A_ComSpec " /c start " to

    case "From":
      run A_ComSpec " /c start " from

    case "To (testmode)":
      run A_ComSpec "  /c start " testmodeTo

    case "From (testmode)":
      run A_ComSpec " /c start " testmodeFrom
          
    case "App":
      run A_ComSpec " /c start " A_ScriptDir
      
    case "Config":
      run A_ComSpec " /c start " appDataDir
  }
}

;------------------------------ toggleTestmode ------------------------------
toggleTestmode(*){
  global
  
  testmode := !testmode
  IniWrite testmode, configFile, "config", "testmode"
  if (testmode){
    settingsMenu.Check("Testmode")
    mainGuiText1Append("Please select a menu entry! (`"testmode`" is activated)")
  } else {
    settingsMenu.UnCheck("Testmode")
    mainGuiText1Append("Please select a menu entry! (`"testmode`" is deactivated)")
  }
}

;----------------------------------------------------------------------------














