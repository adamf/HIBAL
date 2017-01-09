pushd ../converted

orig=$1
mvg=$2.mvg


# remember that when dealing with imags on a computer, the point 0,0 is the upper left corner of the image,
# unlike the co-ordinate system you learned in math class. So if y1 is -100, that's way up in the upper left, 
# off the screen.
# We're only interested in the midpoint of the _visible_ line when trying to shit the horizon to the center of the image.

# we rotated on 5002x5002 page, but we ran our transforms on a 1000x750 image so we need to scale up by
# this is 6.669

read x1 y1 x2 y2 <<< $(tail -1 hough/${mvg} | sed -e 's/,/ /g' | cut -d ' ' -f 2-5)
initial_shift=`awk -v num1=$y1 -v num2=$y2 -v scale=6.669 -v midypos=2501 'BEGIN{ print (num2>num1) ? midypos - ((num2/2) * scale) : midypos - ((num1/2) * scale) }'`
echo $initial_shift

convert ../white_background.JPG  rotated/${orig}_rotated.JPG  -gravity center -geometry +0-${initial_shift} -composite \
    -stroke black  -draw "line   0,0 5002,5002" -draw "line 0,5002 5002,0" -draw "line 0,2501 5002,2501" -draw "line 2501,0 2501,5002" \
    test_neg.jpg

convert ../white_background.JPG  rotated/${orig}_rotated.JPG  -gravity center -geometry +0+${initial_shift} -composite \
    -stroke black  -draw "line   0,0 5002,5002" -draw "line 0,5002 5002,0" -draw "line 0,2501 5002,2501" -draw "line 2501,0 2501,5002" \
    test_pos.jpg

convert ../white_background.JPG  rotated/${orig}_rotated.JPG  -gravity center -geometry +0+0 -composite \
    -stroke black  -draw "line   0,0 5002,5002" -draw "line 0,5002 5002,0" -draw "line 0,2501 5002,2501" -draw "line 2501,0 2501,5002" \
    test_none.jpg


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
