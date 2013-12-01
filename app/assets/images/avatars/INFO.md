# Resize to 128x128

    brew install imagemagick
    mogrify -strip -interlace Plane -gaussian-blur 0.05 -quality 80% -resize 128 *.jpg


# Remove the HD suffix

    brew install rename
    rename 's/-hd.jpg/.jpg/' *.*
