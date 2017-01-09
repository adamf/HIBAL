pushd ../converted
cd laid_out/
files=$(find . -type f -name defisheye_G\*.JPG | grep -v - | sed -e 's/\.JPG//')
cd ..
mkdir cropped
# source image size is 4kx3k
# so we can assume no greater 16:9

# crop to 3000x2250 
x=0
for file in $files; do

convert laid_out/$file.JPG -gravity center -crop 2704x1521+0+0 cropped/${file}_3000-2250.JPG
done
popd
