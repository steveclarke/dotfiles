time = Time.parse(ARGV[0])

Dir["*.{jpg,JPG}"].each do |f|
	ts = time.strftime("%Y:%m:%d %H:%M:%S")
	cmd = "perl c:\\utils\\exiftool\\exiftool.pl -overwrite_original -DateTimeOriginal=\"#{ts}\" \"#{f}\"" 
	puts cmd
	system(cmd)
	time += 1
end
