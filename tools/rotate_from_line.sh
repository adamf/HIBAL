pushd ../converted
orig=$1
mvg=$2.mvg

read x1 y1 x2 y2 <<< $(tail -1 hough/${mvg} | sed -e 's/,/ /g' | cut -d ' ' -f 2-5)

rotate_by=$(python -c "import math; foo=math.degrees(math.atan2(($y1-$y2), $x2)); print foo")
len_line=$(python -c "import math; foo=math.sqrt((($x2 - $x1)**2)-(($y2 - $y1)**2)); print foo")
len_half_line=$(python -c "import math; foo=math.sqrt((($x2 - $x1)**2)-(($y2 - $y1)**2)); print foo/2.0")
echo "length of line: $len_line len_half: $len_half_line"

# take the original y2, subtract the len_half_line
# we want to then subtract the midpoint of the image (750/2) by the value in the last calc
# that's our pixels to shift.
pixels_to_shift=$(python -c "foo=($y - $len_half_line) - 375); print foo")

echo "pixels to shift: $pixels_to_shift"

# then solve for x in:  pixels_to_shift/750 = x/<y size of final image> to get the shift value for the final image.

echo "Rotating ${orig}_small.JPG by $rotate_by degrees."
convert tmp/${orig}_small.JPG -rotate $rotate_by ${orig}_small_rotated.JPG
echo "XXXX exiting"
exit

echo "Rotating ${orig}.JPG by $rotate_by degrees."

convert src/${orig}.JPG -rotate $rotate_by rotated/${orig}_rotated.JPG

echo "Laying out on white background"
convert ../white_background.JPG  rotated/defisheye_G0012322_rotated.JPG  -gravity center -geometry +0+0 -composite  test.jpg


#lessthanzero=$(echo "$midpoint<0" | bc -l) 

#echo $lessthanzero
exit

#convert ../white_background.JPG  rotated/defisheye_G0012322_rotated.JPG  -gravity center -geometry +0+0 -composite  test.jpg
if [ $lessthanzero -eq 1 ];
then 
    convert ../white_background.JPG  rotated/${orig}_rotated.JPG  -gravity center -geometry +0${midpoint} -composite \
    -stroke black  -draw "line   0,0 5002,5002" -draw "line 0,5002 5002,0" -draw "line 0,2501 5002,2501" -draw "line 2501,0 2501,5002" \
    laid_out/${orig}_white_background.JPG
    #composite -gravity center -geometry +0${midpoint} rotated/${orig}_rotated.JPG ../white_background.JPG laid_out/${orig}_white_background.JPG
else
    #composite -gravity center -geometry +0+${midpoint} rotated/${orig}_rotated.JPG ../white_background.JPG laid_out/${orig}_white_background.JPG
    convert ../white_background.JPG  rotated/${orig}_rotated.JPG  -gravity center -geometry +0+${midpoint} -composite  \
    -stroke black  -draw "line   0,0 5002,5002" -draw "line 0,5002 5002,0" -draw "line 0,2501 5002,2501" -draw "line 2501,0 2501,5002" \
    laid_out/${orig}_white_background.JPG
fi
popd
