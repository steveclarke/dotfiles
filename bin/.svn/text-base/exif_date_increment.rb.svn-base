#!/opt/local/bin/ruby

# automatically modify the EXIF and increment each photo timestamp by 1 minute
# so they each have unique names

# format "mm/dd/yy[yy] hh:mm:ss"
time = Time.parse(ARGV[0])

Dir["*.{jpg,JPG}"].each do |file|
	ts = time.strftime("%Y:%m:%d:%H:%M:%S")
	cmd = "jhead -ts#{ts} #{file}"
	puts cmd
	system(cmd)
	time += 1
end

