function checkfile($FNAME) {
# check file magic char for type - unknown file type has "data" as type
$cmd = "file -m c:\utils\magic `"" + $FNAME + "`""
$ftype = iex $cmd
$copy = 0
if ($ftype -notlike "*; data*") {$copy = 1 ; return $copy} 

# check on entropy. If less than 6, it's not encrypted well and is not compressed well, so it's likely data
$cmd = "sigcheck -a `"" + $FNAME + "`""
$a = (iex $cmd | select-string -pattern "Entropy:") -split ":"
$entropy = [double]$a[1]
$copy = 0
if ($entropy -lt 6) {$copy = 1 }
return $copy
}

$src = "c:\cust\sans\isc\"
$dst = "c:\cust\s2\"
$logfile = "logfile.out"

$files = Get-ChildItem -recurse $src
$files | foreach {
  # directories
  if ($_.psiscontainer) { 
       $b = ($_.fullname -split ":")[1]
       New-Item -ItemType Directory -Force -Path ($dst + $b)
       out-file -filepath $logfile -append -inputobject ($_.fullname+" directory created")
       write-host $dst $b created
       }

  else {
     $go = checkfile($_.fullname)
     if ($go -eq 1) { 
        $b = ($_.fullname -split ":")[1]
        copy-item -container -force -path $_.fullname -destination ( $dst + $b ) 
        out-file -filepath $logfile -append -inputobject ($_.fullname+" copied")
        write-host $_.fullname
        }
     else { 
       out-file -filepath $logfile -append -inputobject ($_.fullname + " NOT COPIED - SUSPECTED RANSOMWARE ENCRYPTED")
       write-host $_.fullname " NOT COPIED - SUSPECTED RANSOMWARE ENCRYPTED"
       }
     }
  }




