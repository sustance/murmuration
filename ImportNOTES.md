
Commands etc.

#Presize images
mkdir converted && magick mogrify -path converted -resize "1920x1080^" -gravity center -extent 1920x1080 -format webp *.webp
