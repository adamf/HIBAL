pushd ../converted
RGB="R G B"
rs="0 1 3 5 7 12 15 20 25 30 35 40 45 50 55"
mn="1 5 10 15 20"
mx="5 10 15 20 25 30"


mkdir test_canny

convert src/defisheye_G0013363.JPG -resize 1000x1000 test_canny/defisheye_G0013363_small.JPG

tmpfile=`mktemp`

for c in $RGB; do
    echo "convert test_canny/defisheye_G0013363_small.JPG -channel $c  -separate test_canny/defisheye_G0013363_small_$c.JPG" >> $tmpfile
done

parallel -a $tmpfile --bar

rm $tmpfile


tmpfile=`mktemp`

for r in $rs; do
    for n in $mn; do
        for m in $mx; do
            let x=$n+$m
            for c in $RGB; do
                echo "convert test_canny/defisheye_G0013363_small_$c.JPG -canny 0x$r+$n%%+$x%% test_canny/defisheye_G0013363_small_$c-r$r-mn$n-mx$x.JPG" >> $tmpfile
            done
        done
    done
done

parallel -a $tmpfile --bar
rm $tmpfile
popd
