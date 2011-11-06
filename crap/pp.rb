#!/opt/local/bin/ruby

# Photo Process
# This script processes a folder of photos by calling jhead.exe to
# rename the file according to the date/time in the EXIF header
# and then setting the file time stamp to the same as the EXIF header
#
# To add an EXIF header to an image that doesn't have one, use
# exifadd.rb

# Rename the file according to the date/time in the EXIF header
`jhead -nf%Y-%m-%d-%H%M%S *`

# Set the file time stamp to the same as the EXIF header
`jhead -ft *`
