df -Pk | awk '
BEGIN {print "Filesystem                          Mount Point                 Total GB   Avail GB    Used GB  Used"
       print "----------------------------------- ------------------------- ---------- ---------- ---------- -----"}
END {print ""}
/dev/ || /^[0-9a-zA-Z.]*:\// {
printf ("%-35.35s %-25s %10.2f %10.2f %10.2f %4.0f%\n",$1,$6,$2/1024/1024,$4/1024/1024,$3/1024/1024,$5)
}'
