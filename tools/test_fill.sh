pushd ../converted
r=40
n=10
x=40
bname=defisheye_G0013363
fname=$bname.JPG
alname=$bname-al
#rname=$alname-R
rname=$bname-R

#cname=$rname-r$r-mn$n-mx$x
cname=$bname-r$r-mn$n-mx$x
flname=$cname-fill
ename=$flname-edge

#convert defisheye_G0013363_R.JPG -canny 0x20+5%%+30% defisheye_G0013363_c.JPG

#convert defisheye_G0013363.JPG -channel R -separate defisheye_G0013363_R.JPG

#convert $fname -auto-level $alname.JPG
#convert $fname -channel R -separate  $rname.JPG
#convert $rname.JPG -canny 0x$r+$n%%+$x%% $cname.JPG
convert $fname -canny 0x$r+$n%%+$x%% $cname.JPG
convert $cname.JPG -fill red -draw "color 0,0 floodfill" -alpha off  -fill black +opaque red -fill white -opaque red $flname.JPG 
convert $flname.JPG -morphology edgein octagon:1 $ename.JPG

popd

