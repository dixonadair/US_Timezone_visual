
# desc "make path arrays with coordinates"
# task create_tz_paths: :environment do
# 	# 
# end

# ==================================


# ==================================

# WEBSITE WHERE I WAS ABLE TO IMPORT MY GOOGLE-EARTH PATHS FOLDER (KML/KMZ FILE FOLDER) AND GET BACK THE DATA FOR EACH PATH (THE COORDINATES OF EACH POINT MAKING UP EACH PATH):
# http://www.zonums.com/online/kml2x/

# ==================================

desc "make path arrays with coordinates"
task create_tz_paths: :environment do
	tz_textfile = File.join(Rails.root, 'lib', 'assets', 'timeZoneTxtfile.txt')
	coord_parsing_time = false
	full_path_arr = []

	IO.foreach(tz_textfile) do |line|
		if line.include? "<coordinates>"
			coord_parsing_time = true
		elsif coord_parsing_time == true
			gsub_line = line.gsub(/\t*/, "")
			gsub_line = gsub_line.chomp(",0 ")
			path_arr = gsub_line.split(',0 ').map { |e| e.split(',').reverse.map { |ele| ele.to_f } }

			if path_arr[-1] == [0.0]
				path_arr.pop
			end

			full_path_arr << path_arr

			coord_parsing_time = false
		else
			coord_parsing_time = false
		end
	end

	File.open("log/test_2.log","a") do |f|
		f.write full_path_arr
	end
end

# ==================================
	# File.open("my/file/path", "r") do |f|
	#   f.each_line do |line|
	#     puts line
	#   end
	# end

