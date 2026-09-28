; chunkCopyConfig.ahk
; Part of chunkCopy.ahk

;-------------------------------- readConfig --------------------------------
readConfig() {
  global 
  

  ; "config":
  from := IniRead(configFile, "config", "from" , "")
  to := IniRead(configFile, "config", "to", "")
  filesPerPass := IniRead(configFile, "config", "filesPerPass" , 5)
  testmodeFrom := IniRead(configFile, "config", "testmodeFrom" , ".\testmodeFrom")
  testmodeTo := IniRead(configFile, "config", "testmodeTo" , ".\testmodeTo")
  fontname := IniRead(configFile, "config", "fontname" , "Segoe UI")
  fontsize := IniRead(configFile, "config", "fontsize" , 11)
  intermediateDelay := IniRead(configFile, "config", "intermediateDelay" , 60000)

  testmode := IniRead(configFile, "config", "testmode" , 0)
  finishedActionMode := IniRead(configFile, "config", "finishedActionMode" , 1)
  abortHotkey := IniRead(configFile, "config", "abortHotkey" , "Escape")
  roboParam := IniRead(configFile, "config", "roboParam", "/E /ETA /NJH /R:0 /W:0 /LOG:_robo.txt")
}

;----------------------------------------------------------------------------














