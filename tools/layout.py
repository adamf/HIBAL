#!/usr/bin/python

from PIL import Image
import subprocess
import math
import sys


convert_command="/usr/local/bin/convert"
# defisheye_G0012322 defisheye_G0012322_small_R_r15-mn20-mx50
source_base_name="defisheye_G0012322"
if len(sys.argv) > 1:
    source_base_name=sys.argv[1]


source_full_path="src/" + source_base_name + ".JPG"
rotated_full_path="rotated/" + source_base_name + "_rotated.JPG"
laid_out_full_path="laid_out/" + source_base_name + "_rotated_laid_out.JPG"
debug_laid_out_full_path="debug_laid_out/" + source_base_name + "_rotated_laid_out.JPG"
background_full_path="../white_background.JPG"

print source_base_name, "Working on", source_base_name

mvg_file_name=source_base_name + "_small_R_r15-mn20-mx50.mvg"

hough_image_height=750
hough_image_width=1000

output = subprocess.check_output("tail -1 hough/" + mvg_file_name + " | sed -e 's/,/ /g' | cut -d ' ' -f 2-5", shell=True)
print output
(x1, y1, x2, y2) = (float(d) for d in output.split(' '))

rotate_by=math.degrees(math.atan2((y1 - y2), x2))
len_line=math.sqrt(((x2 - x1)**2)-((y2 - y1)**2))
len_half_line=len_line/2.0
pixels_to_shift=(y2 - len_half_line) - (hough_image_height/2.0)

print source_base_name, "rotate by:", rotate_by, "degrees; line length:", len_line, "half of that:", len_half_line, "pixels to shift in 1000x750 image:", pixels_to_shift

# then solve for x in:  pixels_to_shift/750 = x/<y size of final image> to get the shift value for the final image.

rotate_command = convert_command + " "+ source_full_path +  " -rotate " + str(rotate_by) + " " + rotated_full_path
print source_base_name, "Rotating " + source_full_path
print rotate_command
output = subprocess.check_output(rotate_command, shell=True)


print source_base_name, "Checking for size of laid out image..."
im = Image.open(background_full_path)
print source_base_name, "size: ", im.size
(width, height) = im.size

# then solve for x in:  pixels_to_shift/750 = x/<y size of final image> to get the shift value for the final image.
final_shift = (pixels_to_shift * height) / hough_image_height
print source_base_name, "final shift should be", final_shift

# XXXX we need to flip the sign on final_shift!!
layout_command = convert_command + " ../white_background.JPG  " + rotated_full_path + " -gravity center -geometry +0+" + str(abs(final_shift)) + " -composite " + laid_out_full_path
layout_command = convert_command + " ../white_background.JPG  " + rotated_full_path + " -gravity center -geometry +0+0 -composite " + laid_out_full_path
print source_base_name, "Laying out on white background"
print layout_command
output = subprocess.check_output(layout_command, shell=True)

layout_command = convert_command + " ../white_background.JPG  " + rotated_full_path + " -gravity NorthWest -geometry +0+" + str(abs(final_shift)) +  " -composite "\
' -stroke black  -draw "line   0,0 5002,5002" -draw "line 0,5002 5002,0" -draw "line 0,2501 5002,2501" -draw "line 2501,0 2501,5002" '  + debug_laid_out_full_path
print source_base_name, "Laying out on white background with debug lines"
print layout_command
output = subprocess.check_output(layout_command, shell=True)


#lessthanzero=$(echo "$midpoint<0" | bc -l) 

#echo $lessthanzero
#exit

#convert ../white_background.JPG  rotated/defisheye_G0012322_rotated.JPG  -gravity center -geometry +0+0 -composite  test.jpg
#if [ $lessthanzero -eq 1 ];
#then 
#    convert ../white_background.JPG  rotated/${orig}_rotated.JPG  -gravity center -geometry +0${midpoint} -composite \
#    -stroke black  -draw "line   0,0 5002,5002" -draw "line 0,5002 5002,0" -draw "line 0,2501 5002,2501" -draw "line 2501,0 2501,5002" \
#    laid_out/${orig}_white_background.JPG
#    #composite -gravity center -geometry +0${midpoint} rotated/${orig}_rotated.JPG ../white_background.JPG laid_out/${orig}_white_background.JPG
#else
#    #composite -gravity center -geometry +0+${midpoint} rotated/${orig}_rotated.JPG ../white_background.JPG laid_out/${orig}_white_background.JPG
#    convert ../white_background.JPG  rotated/${orig}_rotated.JPG  -gravity center -geometry +0+${midpoint} -composite  \
#    -stroke black  -draw "line   0,0 5002,5002" -draw "line 0,5002 5002,0" -draw "line 0,2501 5002,2501" -draw "line 2501,0 2501,5002" \
#    laid_out/${orig}_white_background.JPG
#fi
