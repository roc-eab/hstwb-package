# Build WHDLoad Install for Magazines and Cracktros
# -------------------------
#
# Author: Henrik Noerfjand Stengaard
# Date:   2018-04-18
# 
# Based on Henrik Noerfjand Stengaard script and adjusted by RoC
# version 1: 02 June 2018 - Initial version

# Set variables, paths, applications and create dir

$WHDLoad_Cracktros_Path = "INSERT-PATH\Cracktros"
$WHDLoad_Magazines_Path = "INSERT-PATH\Magazines"
$WHDLoad_Beta_Path      = "INSERT-PATH\Beta"

$date = get-date
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"}
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe" 
if (! (test-path "$WHDLoad_Cracktros_Path\Output")) {New-Item -ItemType Directory -Force -Path $WHDLoad_Cracktros_Path\Output}
if (! (test-path "$WHDLoad_Cracktros_Path\temp")) {New-Item -ItemType Directory -Force -Path $WHDLoad_Cracktros_Path\temp}
if (! (test-path "$WHDLoad_Magazines_Path\Output")) {New-Item -ItemType Directory -Force -Path $WHDLoad_Magazines_Path\Output}
if (! (test-path "$WHDLoad_Magazines_Path\temp")) {New-Item -ItemType Directory -Force -Path $WHDLoad_Magazines_Path\temp}
if (! (test-path "$WHDLoad_Beta_Path\Output")) {New-Item -ItemType Directory -Force -Path $WHDLoad_Beta_Path\Output}
if (! (test-path "$WHDLoad_Beta_Path\temp")) {New-Item -ItemType Directory -Force -Path $WHDLoad_Beta_Path\temp}

# Prepare Arcade Game Selector 2 (AGS2) text and run files for CRACKTROS

$files = @()
$files += Get-ChildItem -Path $WHDLoad_Cracktros_Path -Recurse -name -Include *.lha, *.lzx | Sort-Object @{expression={$_.FullName};Ascending=$true}

     foreach ($file in $files)
   
                    {

                        #Extract group and cracktro name from LHAs
                        
                        $pos = $file.IndexOf("_")
                        $group = $file.Substring(0,$pos)
                        $cracktro1 = $file.Substring($pos+1)
                        $pos1 = $cracktro1.IndexOf("_")
                        #$cracktro = $cracktro1.Substring(0,$pos) -csplit "(?<=.)(?=[A-Z])"
                        $cracktro = $cracktro1.Substring(0,$pos1)
    
                        # Extract the whdload slave and folder names from LHAs
                        
                        sz x -r -o"$WHDLoad_Cracktros_Path\temp\" $WHDLoad_Cracktros_Path\$file
                        $WhdLoadName1  = Get-ChildItem -Path "$WHDLoad_Cracktros_Path\temp\" -Recurse -name -Include *.slave
                        $pos2 = $WhdLoadName1.IndexOf("\")
                        $WhdLoadName = $WhdLoadName1.Substring($pos2+1)
                        $WhdLoadFolderName1  = Get-ChildItem -Path "$WHDLoad_Cracktros_Path\temp\"  -name -Include *.info
                        $pos3 = $WhdLoadFolderName1.IndexOf(".")
                        $WhdLoadFolderName = $WhdLoadFolderName1.Substring(0,$pos3)
                        Remove-Item -force -recurse $WHDLoad_Cracktros_Path"\temp\*"
                            
                        # Prepare Text entries  for AGS2
    
                        $textfile = $WHDLoad_Cracktros_Path + "\output\$group-" + $cracktro + ".txt"
                        $runfile  = $WHDLoad_Cracktros_Path + "\output\$group-" + $cracktro + ".run"
                        New-Item $textfile -ItemType file
                        New-Item $runfile  -ItemType file
                        
                        "Name      : Cracktro for " + $cracktro                            | Out-file -filepath $textfile -encoding ASCII -append 
                        "Group     : " + $group                                            | Out-file -filepath $textfile -encoding ASCII -append 
                        "Runfile   : " + $WhdLoadName                                      | Out-file -filepath $textfile -encoding ASCII -append 

                        # Prepare Run entries for AGS2
                        
                        "; HstWB Menu Item Run script for AGS2"                            | Out-file -filepath $runfile -encoding ASCII -append 
                        "; Created by Henrik Stengaard"                                    | Out-file -filepath $runfile -encoding ASCII -append 
                        "; https://github.com/henrikstengaard/hstwb-package"               | Out-file -filepath $runfile -encoding ASCII -append 
                        "; Adapted by RoC for Beta, Magazines and Cracktros"               | Out-file -filepath $runfile -encoding ASCII -append 
                        "; -----------------------------------"                            | Out-file -filepath $runfile -encoding ASCII -append 
                        "; $date"                                                          | Out-file -filepath $runfile -encoding ASCII -append 
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        " ; Favourites Mode"                                               | Out-file -filepath $runfile -encoding ASCII -append
                        'IF EXISTS ENV:ags2favouritesmode'                                 | Out-file -filepath $runfile -encoding ASCII -append
                        '  execute S:AGS2Favourites "Cracktros"' + " " +  """$group $cracktro"""| Out-file -filepath $runfile -encoding ASCII -append
                        ' IF $ags2favouritesmode EQ "add"'                                 | Out-file -filepath $runfile -encoding ASCII -append
                        '    SKIP end'                                                     | Out-file -filepath $runfile -encoding ASCII -append
                        '  ENDIF'                                                          | Out-file -filepath $runfile -encoding ASCII -append
                        '  IF $ags2favouritesmode EQ "remove"'                             | Out-file -filepath $runfile -encoding ASCII -append
                        '     SKIP end'                                                    | Out-file -filepath $runfile -encoding ASCII -append
                        '  ENDIF'                                                          | Out-file -filepath $runfile -encoding ASCII -append
                        'ENDIF'                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        "; Start AGS2 Run Pre Script, if it would exists"                  | Out-file -filepath $runfile -encoding ASCII -append
                        'IF EXISTS S:AGS2RunPre'                                           | Out-file -filepath $runfile -encoding ASCII -append
                        '  execute S:AGS2RunPre'                                           | Out-file -filepath $runfile -encoding ASCII -append
                        'ENDIF'                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        '; Run WHDLoad'                                                    | Out-file -filepath $runfile -encoding ASCII -append
                        'cd "DH1:WHDLoad/Cracktros/' + "$WhdLoadFolderName"""              | Out-file -filepath $runfile -encoding ASCII -append
                        'IF EXISTS ENV:whdloadargs'                                        | Out-file -filepath $runfile -encoding ASCII -append
                        "  whdload " + """$WhdLoadName"" " + '$whdloadargs'                | Out-file -filepath $runfile -encoding ASCII -append
                        'ELSE'                                                             | Out-file -filepath $runfile -encoding ASCII -append
                        "  whdload "+ """$WhdLoadName"""                                   | Out-file -filepath $runfile -encoding ASCII -append
                        "ENDIF"                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        "; Start AGS2 Run Post Script, if it exists"                       | Out-file -filepath $runfile -encoding ASCII -append
                       'IF EXISTS S:AGS2RunPost'                                           | Out-file -filepath $runfile -encoding ASCII -append
                       '  execute S:AGS2RunPost'                                           | Out-file -filepath $runfile -encoding ASCII -append
                       'ENDIF'                                                             | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        "; End"                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        'LAB end'                                                          | Out-file -filepath $runfile -encoding ASCII -append

                        
                    }

# Prepare Arcade Game Selector 2 (AGS2) text and run files for MAGAZINES

$files = @()
$files += Get-ChildItem -Path $WHDLoad_Magazines_path -Recurse -name -Include *.lha, *.lzx | Sort-Object @{expression={$_.FullName};Ascending=$true}
    

     foreach ($file in $files)
   
                    {

                        #Extract group and cracktro name from LHAs
                        
                        $pos = $file.IndexOf("_")
                        $Magazine = $file.Substring(0,$pos)
    
                        # Extract the whdload slave and folder names from LHAs
                                                
                        sz x -r -o"$WHDLoad_Magazines_Path\temp\" $WHDLoad_Magazines_Path\$file
                        $WhdLoadName1  = Get-ChildItem -Path "$WHDLoad_Magazines_Path\temp\" -Recurse -name -Include *.slave
                        $pos2 = $WhdLoadName1.IndexOf("\")
                        $WhdLoadName = $WhdLoadName1.Substring($pos2+1)
                        $WhdLoadFolderName1  = Get-ChildItem -Path "$WHDLoad_Magazines_Path\temp\"  -name -Include *.info
                        $pos3 = $WhdLoadFolderName1.IndexOf(".")
                        $WhdLoadFolderName = $WhdLoadFolderName1.Substring(0,$pos3)
                        Remove-Item -force -recurse $WHDLoad_Magazines_Path"\temp\*"                
                                           
                        # Prepare Text entries for AGS2
    
                        $textfile = $WHDLoad_Magazines_Path + "\output\$Magazine" + ".txt"
                        $runfile  = $WHDLoad_Magazines_Path + "\output\$Magazine" + ".run"
                        New-Item $textfile -ItemType file
                        New-Item $runfile  -ItemType file
      
                        "Name      : Magazine " + $Magazine                                | Out-file -filepath $textfile -encoding ASCII -append 
                        "Runfile   : " + $WhdLoadName                                      | Out-file -filepath $textfile -encoding ASCII -append 

                        # Prepare Run entries for AGS2
                        
                        "; HstWB Menu Item Run script for AGS2"                            | Out-file -filepath $runfile -encoding ASCII -append 
                        "; Created by Henrik Stengaard"                                    | Out-file -filepath $runfile -encoding ASCII -append 
                        "; https://github.com/henrikstengaard/hstwb-package"               | Out-file -filepath $runfile -encoding ASCII -append 
                        "; Adapted by RoC for Beta, Magazines and Cracktros"               | Out-file -filepath $runfile -encoding ASCII -append 
                        "; -----------------------------------"                            | Out-file -filepath $runfile -encoding ASCII -append 
                        "; $date"                                                          | Out-file -filepath $runfile -encoding ASCII -append 
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        " ; Favourites Mode"                                               | Out-file -filepath $runfile -encoding ASCII -append
                        'IF EXISTS ENV:ags2favouritesmode'                                 | Out-file -filepath $runfile -encoding ASCII -append
                        '  execute S:AGS2Favourites "Magazines"' + " " +  """$Magazine"""  | Out-file -filepath $runfile -encoding ASCII -append
                        ' IF $ags2favouritesmode EQ "add"'                                 | Out-file -filepath $runfile -encoding ASCII -append
                        '    SKIP end'                                                     | Out-file -filepath $runfile -encoding ASCII -append
                        '  ENDIF'                                                          | Out-file -filepath $runfile -encoding ASCII -append
                        '  IF $ags2favouritesmode EQ "remove"'                             | Out-file -filepath $runfile -encoding ASCII -append
                        '     SKIP end'                                                    | Out-file -filepath $runfile -encoding ASCII -append
                        '  ENDIF'                                                          | Out-file -filepath $runfile -encoding ASCII -append
                        'ENDIF'                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        "; Start AGS2 Run Pre Script, if it would exists"                  | Out-file -filepath $runfile -encoding ASCII -append
                        'IF EXISTS S:AGS2RunPre'                                           | Out-file -filepath $runfile -encoding ASCII -append
                        '  execute S:AGS2RunPre'                                           | Out-file -filepath $runfile -encoding ASCII -append
                        'ENDIF'                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        '; Run WHDLoad'                                                    | Out-file -filepath $runfile -encoding ASCII -append
                        'cd "DH1:WHDLoad/Magazines/' + "$WhdLoadFolderName"""              | Out-file -filepath $runfile -encoding ASCII -append
                        'IF EXISTS ENV:whdloadargs'                                        | Out-file -filepath $runfile -encoding ASCII -append
                        "  whdload " + """$WhdLoadName"" " + '$whdloadargs'                | Out-file -filepath $runfile -encoding ASCII -append
                        'ELSE'                                                             | Out-file -filepath $runfile -encoding ASCII -append
                        "  whdload "+ """$WhdLoadName"""                                   | Out-file -filepath $runfile -encoding ASCII -append
                        "ENDIF"                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        "; Start AGS2 Run Post Script, if it exists"                       | Out-file -filepath $runfile -encoding ASCII -append
                       'IF EXISTS S:AGS2RunPost'                                           | Out-file -filepath $runfile -encoding ASCII -append
                       '  execute S:AGS2RunPost'                                           | Out-file -filepath $runfile -encoding ASCII -append
                       'ENDIF'                                                             | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        "; End"                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        'LAB end'                                                          | Out-file -filepath $runfile -encoding ASCII -append
                                               
                    }


# Prepare Arcade Game Selector 2 (AGS2) text and run files for BETA RELASEAS

$files = @()
$files += Get-ChildItem -Path $WHDLoad_Beta_path -Recurse -name -Include *.lha, *.lzx | Sort-Object @{expression={$_.FullName};Ascending=$true}
    

     foreach ($file in $files)
   
                    {

                        #Extract group and cracktro name from LHAs
                        
                        $pos = $file.IndexOf("_")
                        $Beta = $file.Substring(0,$pos)
    
                        # Extract the whdload slave and folder names from LHAs
                                                
                        sz x -r -o"$WHDLoad_Beta_Path\temp\" $WHDLoad_Beta_Path\$file
                        $WhdLoadName1  = Get-ChildItem -Path "$WHDLoad_Beta_Path\temp\" -Recurse -name -Include *.slave
                        $pos2 = $WhdLoadName1.IndexOf("\")
                        $WhdLoadName = $WhdLoadName1.Substring($pos2+1)
                        $WhdLoadFolderName1  = Get-ChildItem -Path "$WHDLoad_Beta_Path\temp\"  -name -Include *.info
                        $pos3 = $WhdLoadFolderName1.IndexOf(".")
                        $WhdLoadFolderName = $WhdLoadFolderName1.Substring(0,$pos3)
                        Remove-Item -force -recurse $WHDLoad_Beta_Path"\temp\*"                
                                           
                        # Prepare Text entries for AGS2
    
                        $textfile = $WHDLoad_Beta_Path + "\output\$Beta" + ".txt"
                        $runfile  = $WHDLoad_Beta_Path + "\output\$Beta" + ".run"
                        New-Item $textfile -ItemType file
                        New-Item $runfile  -ItemType file
      
                        "Name      : Beta " + $Beta                                        | Out-file -filepath $textfile -encoding ASCII -append 
                        "Runfile   : " + $WhdLoadName                                      | Out-file -filepath $textfile -encoding ASCII -append 

                        # Prepare Run entries for AGS2
                        
                        "; HstWB Menu Item Run script for AGS2"                            | Out-file -filepath $runfile -encoding ASCII -append 
                        "; Created by Henrik Stengaard"                                    | Out-file -filepath $runfile -encoding ASCII -append 
                        "; https://github.com/henrikstengaard/hstwb-package"               | Out-file -filepath $runfile -encoding ASCII -append 
                        "; Adapted by RoC for Beta, Magazines and Cracktros"               | Out-file -filepath $runfile -encoding ASCII -append 
                        "; -----------------------------------"                            | Out-file -filepath $runfile -encoding ASCII -append 
                        "; $date"                                                          | Out-file -filepath $runfile -encoding ASCII -append 
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        " ; Favourites Mode"                                               | Out-file -filepath $runfile -encoding ASCII -append
                        'IF EXISTS ENV:ags2favouritesmode'                                 | Out-file -filepath $runfile -encoding ASCII -append
                        '  execute S:AGS2Favourites "Beta"' + " " +  """$Beta"""           | Out-file -filepath $runfile -encoding ASCII -append
                        ' IF $ags2favouritesmode EQ "add"'                                 | Out-file -filepath $runfile -encoding ASCII -append
                        '    SKIP end'                                                     | Out-file -filepath $runfile -encoding ASCII -append
                        '  ENDIF'                                                          | Out-file -filepath $runfile -encoding ASCII -append
                        '  IF $ags2favouritesmode EQ "remove"'                             | Out-file -filepath $runfile -encoding ASCII -append
                        '     SKIP end'                                                    | Out-file -filepath $runfile -encoding ASCII -append
                        '  ENDIF'                                                          | Out-file -filepath $runfile -encoding ASCII -append
                        'ENDIF'                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        "; Start AGS2 Run Pre Script, if it would exists"                  | Out-file -filepath $runfile -encoding ASCII -append
                        'IF EXISTS S:AGS2RunPre'                                           | Out-file -filepath $runfile -encoding ASCII -append
                        '  execute S:AGS2RunPre'                                           | Out-file -filepath $runfile -encoding ASCII -append
                        'ENDIF'                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        '; Run WHDLoad'                                                    | Out-file -filepath $runfile -encoding ASCII -append
                        'cd "DH1:WHDLoad/Beta/' + "$WhdLoadFolderName"""                   | Out-file -filepath $runfile -encoding ASCII -append
                        'IF EXISTS ENV:whdloadargs'                                        | Out-file -filepath $runfile -encoding ASCII -append
                        "  whdload " + """$WhdLoadName"" " + '$whdloadargs'                | Out-file -filepath $runfile -encoding ASCII -append
                        'ELSE'                                                             | Out-file -filepath $runfile -encoding ASCII -append
                        "  whdload "+ """$WhdLoadName"""                                   | Out-file -filepath $runfile -encoding ASCII -append
                        "ENDIF"                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        "; Start AGS2 Run Post Script, if it exists"                       | Out-file -filepath $runfile -encoding ASCII -append
                       'IF EXISTS S:AGS2RunPost'                                           | Out-file -filepath $runfile -encoding ASCII -append
                       '  execute S:AGS2RunPost'                                           | Out-file -filepath $runfile -encoding ASCII -append
                       'ENDIF'                                                             | Out-file -filepath $runfile -encoding ASCII -append
                        " "                                                                | Out-file -filepath $runfile -encoding ASCII -append
                        "; End"                                                            | Out-file -filepath $runfile -encoding ASCII -append
                        'LAB end'                                                          | Out-file -filepath $runfile -encoding ASCII -append
                                               
                    }
