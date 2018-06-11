11 June 2018 - RoC (user on the English Amiga Board http://eab.abime.net/)

This archive contains the Arcade Game Selector 2 entries and it is meant for the HstWB enahnced Amiga Workbench:

- Cracktros
- Magazines
- Beta

Each entry includes the following:

- text file, to describe the item to be launched - e.g. 42.txt
- run file, to launch the WHDLoad with the customised HstWB settings - e.g. 42.run
- iff file, with a screenshot of the item to be launched - e.g. - e.g. 42.iff

On top of the above, there is also a powershell script which is meant to create those entries based on the English Amiga Board WHDLoad packages in LHA format: WHDLoad_Beta-Magazines-Cracktros_roc_v1.ps1

USAGE within HstWB:
The entries should be copied into an AGS2 menu folder in the Amiga hard disk, regardless if this is physical or a WinUAE HDF image. The standard HstWB path is DH1:Menus/AGS2Demos and then create the following directories and copy the .txt .run and .iff files into:
- zzCracktros
- zzMagazines
- zzBeta

The folder could have any names you like. With the prefix zz they stay at the end of the list but this could be changed according to your taste.

The PowerShell script requires to insert the three WHDLOAD LHA archive paths, in order to create the txt and run files. It will create two subfolders, one temp and one Output which contains the end-result of the files creation.

The images are not automated, therefore they should be downloaded/created manually and renamed accordingly.

BUGS/To-Do:
- The script creates the entry with a slight different naming convenction - e.g. BlackMonks-TestDrive2.txt instead of Black-Monks_Test-Drive_2.txt
- There is not an automatical procedure to download/create the images :-(
- My knowledge of PowerShell is limited, therefore the script could be optimised/enhanced in many ways. I count on the skills of HST to make it better ;-)

DISCLAIMER:

- These packages do not contain software or applications. Just text files and images that have been downloaded from Janeway. The picture rights are the following http://janeway.exotica.org.uk/imprint.php?from=/search.php
- The PowerShell script was based on the Henrik Nørfjand Stengaard ones and adjusted for cracktros, Magazines and beta. It is realased with the same kind of license (I guess GNU/GPL but might be wrong).
- The entries are based on the Henrik Nørfjand Stengaard's ones and adjusted for cracktros, Magazines and beta. Again they are released with the same kind of license (I guess GNU/GPL but might be wrong).
- Although these entries and the script are meant for Henrik Nørfjand Stengaard, these files are GNU/GPL and can be re-utlised by any member of the Amiga communitty who feels they could be of any help.
- The creator of these entries do not hold responsabilities for the usage of those files. The script and the entries do not contain viruses.

CREDITS:

Credits goes to:
 -- Henrik Nørfjand Stengaard for having created the HstWB, which is a minimalistic Workbench enhancement based on BetterWB. https://hstwb.firstrealize.com/ and https://github.com/henrikstengaard/hstwb-package
 -- MergerValp for the Arcade Game Selector 2, which is the amiga launcher for WHDLoad. https://github.com/MagerValp/ArcadeGameSelector and https://paradroid.automac.se/ags/
 -- The creators and mantainers of the WHDLoad and everyone who contributed with their "WHDLoad Slaves". http://whdload.de/team.html
 -- Janeway Amiga Scene Demo Search Engine, where among many other productions, the great majority of the images have been downloaded. http://janeway.exotica.org.uk
 -- The creator(s) of XNView, which has been used to convert the images from PNG to IFF. https://www.xnview.com/en/
 -- Master Toni Willem for the WinUAE Amiga emulator that improves year-after-year. http://www.winuae.net/
 -- The English Amiga Board community, for keeping the Amiga flame over the years. http://eab.abime.net/


