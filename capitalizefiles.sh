for f in *; do mv -i "$f" "`echo $f | sed -e 's/\(.*\)/\L\1/' -e 's/\( .\)/\U\1/g' -e 's/\(^.\)/\U\1/g'`"; done
