
find originals -type f | while read f ; do
    fname=$(basename "$f")
    dname=$(dirname "$f")
#    mkdir -p converted/$f
    convert "$f" -distort Barrel 0.10,-0.32,0 converted/defisheye_$fname

done

#for orig in $origs; do
##dirname $orig
#echo convert $orig -distort Barrel 0.10,-0.32,0 defisheye_$orig 
#done

