; chunkCopyHelper.ahk
; Part of chunkCopy.ahk


;------------------------------- compareFiles -------------------------------
compareFiles(){
  global
  local msg, sourcePath
  
  inhibitIfoperationRunning()
  
  operationRunning := 1
  
  msg := ""
  ; read the file into a list
  sourcePath := ""
  if(testmode){
    sourcePathFrom := testmodeFrom
    sourcePathTo := testmodeTo
  } else {
    sourcePathFrom := from
    sourcePathTo := to
  }
  fileListInitial := []
  Loop Files, sourcePathFrom "\*.*" {
    if A_LoopFileAttrib ~= "[HRS]"  ; Skip any file that is either H (Hidden), R (Read-only), or S (System).
      continue

    fileListInitial.push(A_LoopFileName)
  } else {
    operationRunning := 0
    exit("No files found in " sourcePath)
  }
  cmpLen := fileListInitial.Length
  exitCode := 0
  nonFound := 1
  
  Loop cmpLen {
    mainGuiText1Append("Comparing: " fileListInitial[A_Index] " (Number " A_Index " of " cmpLen " files to compare)")
    if (FileExist(sourcePathTo "\" fileListInitial[A_Index])){
      exitCode := RunWait("fc " sourcePathFrom "\" fileListInitial[A_Index] " " sourcePathTo "\" fileListInitial[A_Index])
      if (exitCode){
        mainGuiText1Append("Not identical: " fileListInitial[A_Index])
        nonFound := 0
      }
    } else {
      mainGuiText1Append("File to be uploaded: " fileListInitial[A_Index])
    }
  }
  if (nonFound){
    mainGuiText1Append("Operation `"Compare`" successfully completed, all files are identical!")
    
  } else {
    mainGuiText1Append("Operation `"Compare`" completed with messages!")
  }
  operationRunning := 0
}
;------------------------------ createTestfile ------------------------------
createTestfile(n := 1){
  global
  local i, j, s, l
  
  inhibitIfoperationRunning()
  operationRunning := 1

  targetFile := testmodeFrom "\testfile1.txt"
  mainGuiText1Append("Generating the Testfile (" quot targetFile quot ")")
  if (!FileExist(targetFile)){
    i := 0
    j := 0
    s := ""
    Loop 512 {
      i := A_Index - 1
      s := ""
      Loop 65535 {
        j := A_Index
        s .= format("{:015d}", i * 65535 + j) " " ; 64k x 16 characters each = 1 MB
      }
      FileAppend(s, targetFile, "`n CP0")
      mainGuiTextPg1.Value := i " MB"
      mainGui["uploadProgress"].Value := round(i / 5)
    }
    s .= "`n"
    FileAppend(s, targetFile, "`n CP0")
  } else {
    mainGuiText1Append("Using already existing file `"testfile1.txt`"!")
  }
  
  if (n > 1){
    l := n - 1
    freeSpace := DriveGetSpaceFree(testmodeFrom)
    fn := testmodeFrom "\testfile1.txt"
    fH := FileOpen(fn, "r")
    fL := fH.Length
    fH.Close()
    fL := round(fL/1000000 * n)
    freeSpaceLeft := freeSpace - fL
    mainGuiText1Append("Disc space required: " fL " MB")
    mainGuiText1Append("Space on disc left: " freeSpaceLeft " MB")
    if (freeSpaceLeft < 10000){
      msgbox "Not enough disc space left (< 10 GB), operation canceled!"
      mainGuiText1Append("Not enough disc space left, operation canceled!")
      return
    }
    Loop l {
      fn := "testfile" A_Index + 1 ".txt"
      mainGuiTextPg1.Value := "File: " A_Index + 1
      mainGui["uploadProgress"].Value := round(10 + (A_Index * 10))
      if (!FileExist(testmodeFrom "\" fn)){
        FileCopy(targetFile, testmodeFrom "\" fn, true)
      }
    }
  }
  mainGuiText1Append("Operation `"Create Testfile(s)`" successfully completed!")
  mainGuiTextPg1.Value := ""
  mainGui["uploadProgress"].Value := 0
  
  operationRunning := 0
}
;----------------------------- createTestfiles5 -----------------------------
createTestfiles5(){
  createTestfile(5)
}
;----------------------------- createTestfiles10 -----------------------------
createTestfiles10(){
  createTestfile(10)
}
;----------------------------- deleteTestfilesTo -----------------------------
deleteTestfilesTo(){
  global
  
  inhibitIfoperationRunning()
  operationRunning := 1

  FileDelete testmodeTo "\testfile*.txt"
  mainGuiText1Append("Files left in " testmodeTo ":")
  Loop Files testmodeTo "\*.*" {
    mainGuiText1Append(A_LoopFileName)
  }
  mainGuiText1Append("Operation `"DeleteTestfiles (" testmodeTo ")`" successfully completed!")
  operationRunning := 0
}
;------------------------------ deleteTestfiles ------------------------------
deleteTestfiles(){
  global
  
  inhibitIfoperationRunning()
  operationRunning := 1
  
  FileDelete testmodeFrom "\testfile*.txt"
  mainGuiText1Append("Files left in " testmodeFrom ":")
  Loop Files testmodeFrom "\*.*" {
    mainGuiText1Append(A_LoopFileName)
  }
  
  FileDelete testmodeTo "\testfile*.txt"
  mainGuiText1Append("Files left in " testmodeTo ":")
  Loop Files testmodeTo "\*.*" {
    mainGuiText1Append(A_LoopFileName)
  }
  mainGuiText1Append("Operation `"DeleteTestfiles`" successfully completed!")
  operationRunning := 0
  
}
;---------------------------- showHintColoredTop ----------------------------
showHintColoredTop(s := "", n := 4000, fg := "cFFFFFF", bg := "a900ff"){
  global
  local t
  
  if (IsSet(hintColored))
    destroyHintColored()
  
  hintColored := Gui("+0x80000000 -Caption +ToolWindow +AlwaysOnTop")
  hintColored.SetFont("s" fontsize " c" fg)
  hintColored.BackColor := bg
  hintColoredText := hintColored.add("Text", , s)
  hintColored.Show("y10 xcenter")
   
  if (n > 0){
    sleep n
    destroyHintColored()
  }
  if (n < 0){
    settimer destroyHintColored, n
  }
  ; keep open if n == 0
}
;---------------------------- destroyHintColored ----------------------------
destroyHintColored(*){
  global
  
  hintColored.Destroy()
}
;------------------------- inhibitIfoperationRunning -------------------------
inhibitIfoperationRunning(){
  global

  if (operationRunning){
    showHintColoredTop("Please wait until the current operation has finished!")
    
    return
  }
}
;---------------------------- checkLanguageFiles ----------------------------
checkLanguageFiles(){
  global
  local l, d
  
  d := ".\language\"
  l := "en-US.ini"
  
  DirCreate(d)

  if (!FileExist(d l)){
    FileAppend "
    (
[language_info]
enname=English (United States)
name=English (United States)
[translations]
language=English (United States)
Speed=Speed
Ended=Ended
MegaBytes/Min=Megabytes/min
    )", d l, "`n UTF-16"
  }

  l := "de-DE.ini"
  
  if (!FileExist(d l)){
    FileAppend "
    (
[language_info]
enname=German (Germany)
name=Deutsch 
[translations]
language=Deutsch
Speed=Geschwindigkeit
Ended=Beendet
MegaBytes/Min=Megabytes/Min
    )", d l, "`n UTF-16"
  }
  
  l := "fr-FR.ini"
  
  if (!FileExist(d l)){
    FileAppend "
    (
[language_info]
enname=French (France)
name=French
[translations]
language=French (France)
Speed=D,bitÿ
Ended=Finÿ
MegaBytes/Min=Mégaoctets/min
    )", d l, "`n UTF-16"
  }
  
  l := "ru-RU.ini"
  
  if (!FileExist(d l)){
    FileAppend "
    (
    [language_info]
    enname=Russian (Russia)
    name=Русский
    [translations]
    language=Russian (Russia)
    Speed=Скорость
    Ended=Закончено
    Megabytes/min=Мегабайты/минута
    )", d l, "`n UTF-16"
  }
}
;-------------------------------- showLogFile --------------------------------
showLogFile(logFile, *){
  global
  
  if (FileExist(logFile))
    run logFile, A_ScriptDir
  else
    mainGuiText1Append("File `"" logFile "`" does not exist!")
}
;------------------------------ showRoboLogFile ------------------------------
showRoboLogFile(*){
  global
  
  if (FileExist("_robo.txt"))
    run "_robo.txt", A_ScriptDir
  else
    mainGuiText1Append("File `"_robo.txt`" does not exist!")
}
; =================================================================================
; From https://www.autohotkey.com/boards/viewtopic.php?style=1&f=83&t=114445
;
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;       add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;       add a 't' to DimSize to tell AutoXYWH that the controls in cList are on/in a tab3 control
;   cList   - variadic list of GuiControl objects
;
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
;   AutoXYWH("t x h0.5", "Btn1")
; ---------------------------------------------------------------------------------
; Version: 2023-02-25 / converted to v2 (Relayer)
;      2020-5-20 / small code improvements (toralf)
;      2018-1-31 / added a line to prevent warnings (pramach)
;      2018-1-13 / added t option for controls on Tab3 (Alguimist)
;      2015-5-29 / added 'reset' option (tmplinshi)
;      2014-7-03 / mod by toralf
;      2014-1-02 / initial version tmplinshi
; requires AHK version : v2+
; =================================================================================

AutoXYWH2(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079

  static cInfo := map()

  if (DimSize = "reset")
  Return cInfo := map()

  for i, ctrl in cList {
    ctrlObj := ctrl
    ctrlObj.Gui.GetPos(&gx, &gy, &gw, &gh)
    if !cInfo.Has(ctrlObj) {
      ctrlObj.GetPos(&ix, &iy, &iw, &ih)
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      f := map( "x", 0
        , "y", 0
        , "w", 0
        , "h", 0 )

      for i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
      if !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", &tmp)
        f[dim] := 1
      else
        f[dim] := tmp

      if (InStr(DimSize, "t")) {
      hWnd := ctrlObj.Hwnd
      hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
      RECT := buffer(16, 0)
      DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", RECT)
      DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", RECT, "UInt", 1)
      ix := ix - NumGet(RECT, 0, "Int")
      iy := iy - NumGet(RECT, 4, "Int")
      }
      cInfo[ctrlObj] := {x:ix, fx:f["x"], y:iy, fy:f["y"], w:iw, fw:f["w"], h:ih, fh:f["h"], gw:gw, gh:gh, a:a, m:MMD}
    } else {
      dg := map( "x", 0
         , "y", 0
         , "w", 0
         , "h", 0 )
      dg["x"] := dg["w"] := gw - cInfo[ctrlObj].gw, dg["y"] := dg["h"] := gh - cInfo[ctrlObj].gh
      ctrlObj.Move(  dg["x"] * cInfo[ctrlObj].fx + cInfo[ctrlObj].x
         , dg["y"] * cInfo[ctrlObj].fy + cInfo[ctrlObj].y
         , dg["w"] * cInfo[ctrlObj].fw + cInfo[ctrlObj].w
         , dg["h"] * cInfo[ctrlObj].fh + cInfo[ctrlObj].h  )
      if (cInfo[ctrlObj].m = "MoveDraw")
      ctrlObj.Redraw()
    }
  }
}

;----------------------------------------------------------------------------














