pushd ../converted
r=15
n=20
x=50

mkdir hough
mkdir canny
mkdir tmp
mkdir rotated
mkdir laid_out

echo "Creating resized images for edge detection..."
ls src/*.JPG | parallel --bar convert {} -resize 1000x1000 tmp/{/.}_small.JPG

echo "Removing all but the red channel..."
ls tmp/*_small.JPG | parallel --bar convert {} -channel R  -separate tmp/{/.}_R.JPG

echo "Doing Canny edge detection..."
ls tmp/*_small_R.JPG | parallel --bar convert {} -canny 0x$r+$n%%+$x%% canny/{/.}_r$r-mn$n-mx$x.JPG

echo "Finding Hough lines..."
ls canny/*.JPG | parallel --bar 'convert {} \( +clone -stroke red -fill red -background none -strokewidth 2 -write 2 \
   -hough-lines 500x50+100 -write hough/{/.}.mvg \) -composite hough/{/.}_hough.JPG'

echo "Rotating images so the horizons are straight..."
ls hough/*.mvg | sed -e 's/hough\/\(.*\)\(_small.*\)\.mvg/\1 \1\2/' | parallel -C ' ' ./rotate_from_line.sh {1} {2}


#echo "Rotating images so the horizons are straight..."
#ls hough/*.mvg | sed -e 's/hough\/\(.*\)\(_small.*\)\.mvg/\1 \1\2/' | parallel -C ' ' ./rotate_from_line.sh {1} {2}


#echo "Placing on background..."
#ls hough/*.mvg | sed -e 's/hough\/\(.*\)\(_small.*\)\.mvg/\1 \1\2/' | parallel --bar -C ' ' ./lay_out_and_shift.sh {1} {2}
popd
