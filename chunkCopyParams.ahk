; chunkCopyParams.ahk
; Part of chunkCopy.ahk

;------------------------------- handleParams -------------------------------
handleParams(){
  global
  local ffp
  
  match := ""
  hasParams := A_Args.Length
  if (hasParams != 0){
    Loop hasParams {
    ; "remove" was checked already 
      ffpFound := RegExMatch(A_Args[A_index],"i).*?ffp.*?(\d+)", &match)
      if(ffpFound){
        ffp := match[1]
        if (IsNumber(ffp)){
          filesPerPass := ffp
          IniWrite filesPerPass, configFile, "config", "filesPerPass"
        }
        chunkNumberAction_%ffp%.Value := 1
      }
      if(A_Args[A_index] = "startupload"){
        finishedActionMode := 5
        autoAction := "startupload"
      }

      if(A_Args[A_index] = "compare"){
        finishedActionMode := 5
        autoAction := "compare"
      }
      
      if(A_Args[A_index] = "createtestfile"){
        finishedActionMode := 5
        autoAction := "createtestfile"
      }
      
      if(A_Args[A_index] = "createtestfiles5"){
        finishedActionMode := 5
        autoAction := "createtestfiles5"
      }
      
      if(A_Args[A_index] = "createtestfiles10"){
        finishedActionMode := 5
        autoAction := "createtestfiles10"
      }
      
      if(A_Args[A_index] = "deleteTestfilesTo"){
        finishedActionMode := 5
        autoAction := "deleteTestfilesTo"
      }
      
      if(A_Args[A_index] = "deleteTestfiles"){
        finishedActionMode := 5
        autoAction := "deleteTestfiles"
      }
      
      if(A_Args[A_index] = "showLog"){
        showlog := 1
      }
      
      if(A_Args[A_index] = "testmode"){
        testmode := 1
        IniWrite testmode, configFile, "config", "testmode"
      }
      
      if(A_Args[A_index] = "testmodeoff"){
        testmode := 0
        IniWrite testmode, configFile, "config", "testmode"
      }
      
      if(A_Args[A_index] = "shutdown"){
         finishedActionMode := 2
      }
      
      if(A_Args[A_index] = "hibernate"){
        finishedActionMode := 3
      }
      
      if(A_Args[A_index] = "sleep"){
        finishedActionMode := 4
      }
      if(A_Args[A_index] = "remove"){
        exitApp
      }
    }
  }

  if (testmode){
    settingsMenu.Check("Testmode")
    if (!FileExist(testmodeFrom)){
      showHintColoredTop("SEVERE ERROR occured:`n`nSource directory from=" quot from quot " does not exist or is not readable!`n`nExiting the app due to this error", 10000)
      exitApp
    }
    if (!FileExist(testmodeTo)){
      showHintColoredTop("SEVERE ERROR occured:`n`nDestination directory to=" quot to quot " does not exist or is not readable!`n`nExiting the app due to this error!", 10000)
      exitApp
    }
  } else {
    settingsMenu.UnCheck("Testmode")
    if (!FileExist(from)){
      showHintColoredTop("SEVERE ERROR occured:`n`nSource directory from=" quot from quot " does not exist or is not readable!`n`nExiting the app due to this error", 10000)
      exitApp
    }
    if (!FileExist(to)){
      showHintColoredTop("SEVERE ERROR occured:`n`nDestination directory to=" quot to quot " does not exist or is not readable!`n`nExiting the app due to this error!", 10000)
      exitApp
    }
  }
  

}

;----------------------------------------------------------------------------














