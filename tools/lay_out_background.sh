pushd ../converted
cd rotated/
files=$(find . -type f -name defisheye_G\*.JPG | grep -v - | sed -e 's/\.JPG//')
cd ..
mkdir laid_out
for file in $files; do
composite -gravity center rotated/$file.JPG  ../white_background.JPG laid_out/${file}_white_background.JPG
done
popd
