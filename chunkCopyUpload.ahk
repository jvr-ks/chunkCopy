; chunkCopyUpload.ahk
; Part of chunkCopy.ahk

;-------------------------------- uploadStart --------------------------------
uploadStart(*){
  global
  local logFile, sourcePathFrom, destinationPathTo
  local fileListString, fileListStringSorted, fileListInitial, fileList, msg, timestamp
  
  inhibitIfoperationRunning()
    
  operationRunning := 1
  
  bytesToken := "im).*?Bytes.*?:.*?(\d*\.\d*) m"
  bytesStartText := "Bytes: "
  bytesEndText := " Megabytes"
  
  speedToken := "im).*?" lang("Speed") ".*?:.*?(\d*\.\d*) " StrReplace(lang("MegaBytes/Min"), "/", "\/")
  speedStartText := lang("Speed") ": "
  speedEndText := " " lang("MegaBytes/Min")
  
  finishedToken := "im).*?" lang("Ended") ".*?: (.*)$"
  finishedStartText := lang("Ended") ": "
  finishedEndText := "`n`n"
      
  if (FileExist("_robo.txt")){
    FileDelete("_robo.txt")
    FileAppend "", "_robo.txt", "`n UTF-16"
  }
  
  ; read the file into a list
  logFile := ""
  if(testmode){
    sourcePathFrom := testmodeFrom
    destinationPathTo := testmodeTo
    logFile := "chunkCopyLogTest.txt"
  } else {
    sourcePathFrom := from
    destinationPathTo := to
    logFile := "chunkCopyLog.txt"
  }
  
  fileListString := ""
  Loop Files, sourcePathFrom "\*.*" {
    if A_LoopFileAttrib ~= "[HRS]"  ; Skip any file that is either H (Hidden), R (Read-only), or S (System).
      continue
    
    fileListString .= A_LoopFileName "`n"
  } else {
    operationRunning := 0
    exit("No files found in " sourcePathFrom)
  }
  
  fileListStringSorted := sort(fileListString, "N", fileListStringCompare)
    
  ; check if files already exist, remove them from the new list then
  
  mainGuiText1Append("Checking remote files ...")
  if (!testmode)
    mainGuiText1Append("Operation may take a long time, please be patient!")
    
  fileListStringSorted := SubStr(fileListStringSorted, 1, StrLen(fileListStringSorted) - 1) ; remove last ","

  fileListInitial := StrSplit(fileListStringSorted, "`n")
  
  fileList := []
  Loop fileListInitial.Length {
    mainGuiText1Append("Check: " destinationPathTo "\" fileListInitial[A_Index])
    if (FileExist(destinationPathTo "\" fileListInitial[A_Index])){
    } else {
      fileList.push(fileListInitial[A_Index])
      mainGuiText1Append("Found file to be uploaded: " fileListInitial[A_Index] " (" fileList.Length ")")
      if (testmode)
        sleep 3000 ;debug
      if (fileList.Length >= filesPerPass){ ; stop filecheck if enough new files found
        break
      }
    }
  }
  
  fileCounter := 0
  
  mainGuiText1Append("From: " quot sourcePathFrom quot " destinationPathTo: " quot destinationPathTo quot)
  
  if (fileList.Length > 0){
    FileAppend "`n", logFile, "`n"
  
    Loop fileList.Length {
      currentFile := fileList[A_Index]
      mainGuiText1Append("Uploading file: " currentFile " (File " A_Index " of " fileList.Length ")")
      mainGuiTextPg1.Value := ""
      
      showProgress := 1
      timestamp := FormatTime(, "dddd, d. MMMM yyyy HH:mm:ss")
      mainGuiText1Append("Gestarted: " timestamp)
      FileAppend "Gestarted: " timestamp "`n", logFile, "`n"
      
      cmd := "robocopy " quot sourcePathFrom quot " " quot destinationPathTo quot " File " currentFile " " roboParam
      
      FileAppend cmd "`n", logFile, "`n"

      RunWait cmd,,"Hide"
      
      showProgress := 0
      
      sleep 1000
        
      mainGuiTextPg1.Value := ""
      mainGui["uploadProgress"].Value := 0
      
      ; etract result to log file
      roboText := ""
      roboMBytes := ""
      roboSpeed := ""
      roboBeendet := ""
      
      if (FileExist("_robo.txt")){
        roboText := FileRead("_robo.txt", "`n")
        
        found := RegExMatch(roboText, bytesToken, &match)
        if (found)
          roboMBytes := match.1
        
        found := RegExMatch(roboText, speedToken, &match)
        if (found)
          roboSpeed := match.1
        
        found := RegExMatch(roboText, finishedToken, &match)
        if (found)
          roboBeendet := match.1
        
        FileAppend bytesStartText roboMBytes bytesEndText "`n", logFile, "`n"
        FileAppend speedStartText roboSpeed speedEndText "`n", logFile, "`n"
        FileAppend finishedStartText roboBeendet finishedEndText "`n", logFile, "`n"
        
        mainGuiText1Append(bytesStartText roboMBytes bytesEndText)
        mainGuiText1Append(speedStartText roboSpeed speedEndText)
        mainGuiText1Append(finishedStartText roboBeendet)
      }
      
      fileCounter += 1
      if (fileCounter >= filesPerPass){
        break
      }
      
      if(!testmode){
        mainGuiText1Append("Pause between uploads: (intermediateDelay=" intermediateDelay " msec) ...")
        sleep intermediateDelay
      } else {
        mainGuiText1Append("Testmode: 5 seconds pause between uploads!")
        sleep 5000
      }
      mainGuiText1Append("")
    }
  } else {
    mainGuiText1Append("There are " filesPerPass " files out of " fileList.Length " to be uploaded!")
  }

  mainGuiTextPg1.Value := ""
  mainGui["uploadProgress"].Value := 0
  sleep 1000
  mainGuiText1Append("Copied " fileCounter " of " filesPerPass " files!")
  mainGuiText1Append("Operation `"Upload`" successfully completed!")
  
  operationRunning := 0
  
  if(showlog){
    if (!testmode){
      showLogFile("chunkCopyLog.txt")
    } else {
      showLogFile("chunkCopyLogTest.txt")
    }
  }

  finishedAction()
}
;------------------------------ finishedAction ------------------------------
finishedAction(){
  global
  
  switch finishedActionMode {
    case 2:
      mainGuiText1.Value := "Shutdown started ..."
      sleep 2000
      Run A_ComSpec " /c shutdown.exe /s /soft"
      exitApp

    case 3:
      ; Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
      ; Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
      ; Parameter #3: Pass 1 instead of 0 to disable all wake events.
      mainGuiText1Append("Hibernate started ...")
      sleep 2000
      DllCall("PowrProf\SetSuspendState", "Int", 1, "Int", 0, "Int", 0)
      exitApp
      
    case 4:
      mainGuiText1Append("Sleep started ...")
      sleep 2000
      DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
      exitApp
      
    case 5:
      exitApp
  }
}
;--------------------------- fileListStringCompare ---------------------------
fileListStringCompare(a, b, *){
  global
  local ret, a1, b1, a2, b2

  ret := 0
  if (!InStr(a, ".mrimg") || !InStr(b, ".mrimg")){
    ret := 1
  } else {
    ; filenames like: "D5C133A9CAE62974-00-10.mrimg"
    a1 := RegExReplace(a, ".*?-", "") ; remove all to the first "-" -> "00-10.mrimg"
    b1 := RegExReplace(b, ".*?-", "")
    
    a2 := RegExReplace(a1, "[a-zA-Z-\.]", "") ; keep only numbers -> "10"
    b2 := RegExReplace(b1, "[a-zA-Z-\.]", "")
    
    ret := a2 - b2
  }
  return ret
}
;------------------------------ advanceProgress ------------------------------
advanceProgress(){
  global
  local text, m, n
  
  n := 0
  if (IsSet(mainGuiTextPg1)){
    if (FileExist("_robo.txt")){
      text := FileRead("_robo.txt")
      m := ""
      while RegExMatch(text, "(\d+).*?%", &m, !m || m.Pos + m.Len) {
        n := m[1]
      }
      if (IsNumber(n)){
        mainGuiTextPg1.Value := round(0 + n) " %"
        mainGui["uploadProgress"].Value := round(0 + n)
      }
    }
  }
}
;-------------------------- getRunningAppsAsString --------------------------
getRunningAppsAsString(){
  DetectHiddenWindows true
  
  runningApps := ""
  runningAppsList := WinGetList(,, "Program Manager")
  for key, idNumber in runningAppsList {
    idTitle := WinGetTitle(idNumber)
    runningApps .= idTitle . " | "
  }
  return runningApps
}

;----------------------------------------------------------------------------
















