<a name="chunkCopy">&nbsp;</a>  
# chunkCopy  
Helper to copy (called "upload" also) large files (backup etc.) in chunks to the cloud or to an USB stick.  
(Made with Autohotkey 2)  
All *.exe are 64 bit.  
  
All files are licensed under the **GNU GENERAL PUBLIC LICENSE**  
A copy is included of the file "license.txt" is included in each download.  
  
### <a name="overview">Table of contents</a>  
  
<a href="#latestchanges">Latest changes</a>  
<a href="#chunkCopydescription">chunkCopy description</a>  
<a href="#configuration">Configuration</a>  
<a href="#configurationfile">Configuration file</a>  
<a href="#commandlineparameter">chunkCopy commandline parameter</a>  
<a href="#multilanguage">chunkCopy multilanguage</a>  
<a href="#actions">Actions after a run</a>  
<a href="#temporaryfiles">Temporary files</a>  
<a href="#download">Download</a>  
<a href="#installation">Start installation / update</a>  
  
#### <a name="latestchanges">Latest changes</a><a href="#overview"> &uarr;</a>  
  
Version (&gt;=)| Change  
------------ | -------------  
0.018 | uploadDelay rename to intermediateDelay (USB stick cool down time)  
0.017 | Move to a project of its own! [chunkCopy](https://github.com/jvr-ks/chunkCopy). 
  
#### <a name="chunkCopydescription">chunkCopy description</a><a href="#overview"> &uarr;</a>  
Copy all files inside the source directory to a destination directory using Windows "robocopy" command.  
  
Pressing the ESCAPE key while "chunkCopy" has the focus aborts the app,  
but the copy operation to the cache is continued until the current file copy operation has finished.  
  
chunkCopy can be used by a scheduler via the command line.  
  
##### <a name="configuration">Configuration</a><a href="#overview"> &uarr;</a>  
Select Menu » "Settings" to edit the Configuration.  
  
Example of the produced Configuration file:  
```
[config]
from=.\testmodeFrom
to=.\testmodeTo
filesPerPass=1
testmodeFrom=.\testmodeFrom
testmodeTo=.\testmodeTo
fontname=Segoe UI
fontsize=10
intermediateDelay=60000
... more internally used parameters
```
"from=" is the source directory,  
"to= is the destination directory,  
"roboParam=" should no be changed (besides setting a filename filter etc.),  
"filesPerPass=" holds the number of files that should be copied at once.  
  
The size of “filesPerPass” can be set via the radio buttons or as a value in the Configuration file.  
(Changes of “filesPerPass” in the Configuration file are reflected after a restart only).     
  
#### <a name="configurationfile">Configuration file</a><a href="#overview"> &uarr;</a>  
(**Changed from version >= 0.018**)  

The "standard location" of the Configuration file "chunkCopy.ini" is the app directory.  
  
If the file:  
C:\\ProgramData\\chunkCopy\\chunkCopy_&lt;COMPUTER_NAME&gt;.ini  
exists, it is used as the Configuration file.  

If the file "_chunkCopy.ini" exists in the app directory, it is used as the Configuration file
  
If no Configuration file is found at all,  
default values are used and the Configuration file "chunkCopy.ini" is created.  
   
#### <a name="commandlineparameter">Commandline parameter</a><a href="#overview"> &uarr;</a>  
(To be used with a scheduler like Windows "Taskschd", open with menu ➝ "Commands" ➝ "Taskscheduler (ext)" )  
  
If commandline parameters are use, one distinct "Operation type parameters" is required:  
  
Operation type parameters:  

* "startupload"  
    Automatically starts the upload.  
    
* "compare"  
    Starts the comparing of all uploaded files (using the Windows "fc.exe" command).  
    Each "fc.exe" operations opens a window of it own.  
    Those windows are not hidden otherwise errors would not be seen!  
    Very slow! (TODO: find a better solution...)  
  
* "createtestfile"  
    Adding the word "createtestfile" as a commandline parameter generates the file "testfile.txt".  
    in the testmodeFrom directory.  
    The filesize is 500 MB filled with sorted the numbers, each of them has 15 places followed by a blank.  
  
* "createtestfile5"  
    As "createtestfile", but creates five testfiles "testfile1-5.txt" in the "testmodeFrom" folder.  
  
* "createtestfile10"  
    As "createtestfile", but creates ten testfiles "testfile1-10.txt" in the "testmodeFrom" folder.  
    
* "deleteTestfilesTo"  
    Removes all "testfileN.txt" files from the "testmodeTo" folder.  
  
* "deleteTestfiles"  
    Removes all "testfilesN.txt" files from the "testmodeTo" and the "testmodeFrom" folder.      
  
Additional parameters to the operation type parameter:  
  
* "fpp '&lt;NUMBER&gt;'" or "ffp&lt;NUMBER&gt;" (surrounded by quotation marks or no blank between ffp and the number)  
   Set files per pass.  
   **Value is stored in the Configuration files**  
   
* "testmode"  
    Using local directories (testmodeFrom and testmodeTo) instead of network directories.  
    Turns testmode on, **status is stored in the Configuration files**.  
    Progressdisplay is not valid in testmode, because the upload is to fast, besides your system speed is very low.  
    
* "testmodeoff"  
   Turns testmode off, **status is stored in the Configuration files**.  
  
* "showlog"  
    Opens the logfile with the system default editor (automode has a logfile of its own) after an upload operation.  
    **status is not stored**
  
Any of the following additional parameter must be the last one on the commandline:  
  
* "hibernate"  
  Performs a shutdown to hibernate operation after the current operation.  
  
* "sleep"  
  Performs a shutdown to sleep operation after the current operation.  
  
* "shutdown"  
  Performs a shutdown operation after the current operation. 
  
   
Hints:  
- Parameter are not case sensitiv, 
- Without a "testmode / testmodeoff" parameter,  
the state of the "testmode" is defined by the Configuration file setting,  
- Without a "shutdown/sleep/hibernate" chunkcopy is closed only after the operation.  
- The window is fixed to the top/center!  
  
#### <a name="multilanguage">chunkCopy multilanguage </a><a href="#overview"> &uarr;</a> 
Not the gui, Robocopy output to logfile only:  
Language files are stored as \*.ini files (encoding UTF-16 LE-BOM) in the folder "language".  
Simple pairs of words are used. The format is: english word=other language word.  
Supplied language files are (files are automatically created if missing):  
"en-US.ini", "de-DE.ini", "fr-FR.ini", "ru-RU.ini".
  
#### <a name="actions">Actions after a run</a><a href="#overview"> &uarr;</a> 
There are four possible outcomes (finishedActionMode 1 to 4) selectable by the radio buttons:  
- Do nothing ,  
- Shutdown,  
- Hibernate \*1),  
- Sleep  

Please close all open files / apps if using finishedActionMode 2,3, or 4.  
 
If the "Sleep mode" is active for a long time, Windows automatically switches to the "Hibernate mode".  
  
The mode differences are:  
- "Sleep mode"  
  Very fast recovery triggered by the "blank" key or by a mouse move, low power consumption,    
- "Hibernate mode" very low power consumption, fast recovery triggered by the power on switch.  
  
\*1) Hibernate mode must first be enabled by running "powercfg.exe /hibernate on" as an administrator.  
You may use the files: "hibernate_enable.cmd" / "hibernate_disable.cmd".  
  
#### <a name="temporaryfiles">Temporary files</a><a href="#overview"> &uarr;</a> 
A temporary file "_robo.txt" is used to transfer the status from Robocopy to chunkCopy.  
If chunkCopy is aborted via the Escape key, the upload is not stopped.  
The file "_robo.txt" is not deleted then (as in automode). 
  
#### <a name="download">Download</a><a href="#overview"> &uarr;</a> 
Download via "Updater" is the preferred method!  
Portable, run from any directory, but running from a subdirectory of the windows programm-directories   
(C:\Program Files, C:\Program Files (x86) etc.)  
requires admin-rights and is not recommended!  
**Installation-directory (is created by the Updater) must be writable by the app!**  
  
To download from Github please use:  
  
[updater.exe 64bit](https://github.com/jvr-ks/chunkCopy/raw/main/updater.exe)  
  
(Updater viruscheck please look at the [Updater repository](https://github.com/jvr-ks/updater)) 
  
#### <a name="installation">Start installation / update</a><a href="#overview"> &uarr;</a> 
* Run "updater.exe", example: "C:\jvrks\chunkCopy\updater.exe" once to download/update chunkCopy.  
  (Menu ➝ Commands ➝ Start Updater)  
* Then start "chunkCopy.exe", example: "C:\jvrks\chunkCopy\chunkCopy.exe" !  
* Create a desktop-icon and/or a taskbar entry. 

  
**More to come ...**  
  
Copyright (c) 2024 J. v. Roos  

Virustotal virusscan results, please use [CTRL] + Click to open in a new window! 

<a name="virusscan">



##### Virusscan at Virustotal 
[Virusscan at Virustotal, chunkCopy.exe 64bit-exe, Check here](https://www.virustotal.com/gui/url/2905ae18866b7f67d6c765ed575cc21d38817982f49a1f69212b12dbaef31a1e/detection/u-2905ae18866b7f67d6c765ed575cc21d38817982f49a1f69212b12dbaef31a1e-1718098189
)  
