Brainbaking.com hugo site.


### Screenshot png - jpg conversion

1. find . -name "*.png" -exec convert {} -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB {}.jpg \;
2. find ./ -name "*.png.jpg" -exec sh -c 'mv $0 `basename "$0" .png.jpg`.jpg' '{}' \;