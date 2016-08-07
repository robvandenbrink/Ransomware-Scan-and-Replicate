function checkfile($FNAME) {
# check file magic char for type - unknown file type has "data" as type
$cmd = "file -m c:\utils\magic `"" + $FNAME + "`""
$ftype = iex $cmd
$copy = 0
if ($ftype -notlike "*; data*") {$copy = 1 ; return $copy} 

# check on entropy. If less than 6, it's not encrypted well and is not compressed well, so it's likely data
$cmd = "sigcheck -a `"" + $FNAME + "`""
$a = (iex $cmd | select-string -pattern "Entropy:") -split ":"
#$cmd = "entropy `"" + $FNAME + "`""
#$a = iex $cmd  
$entropy = [double]$a[1]
$copy = 0
if ($entropy -lt 6) {$copy = 1 }
return $copy
}

$src = "c:\vmware"
$logfile = "logfile.out"


iex "cmd /c echo %time% >> t.out"

$files = Get-ChildItem -recurse $src
$files | foreach {
  # directories
  if ($_.psiscontainer) { 
       # nothing to do here
       }

  else {
     $go = checkfile($_.fullname)
     if ($go -eq 1) { 
        # nothing to do here
        # maybe add to the logfile if a -v option is added
        }
     else { 
       out-file -filepath $logfile -append -inputobject ($_.fullname + "  - SUSPECTED RANSOMWARE ENCRYPTED")
       write-host $_.fullname " - SUSPECTED RANSOMWARE ENCRYPTED"
       }
     }
  }


iex "cmd /c echo %time% >> t.out"