require 'json'

def createPathsArray(readfile)
	tz_textfile = File.join(Rails.root, 'lib', 'assets', "#{readfile}")
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

	return full_path_arr

	# File.open("log/#{writetofile}","a") do |f|
	# 	f.write full_path_arr
	# end
end

# below function no longer necessary
# def logfileToArray(readfile)
# 	file = File.join(Rails.root, 'log', "#{readfile}")
# 	whole_path_arr = nil
# 	IO.foreach(file) do |line|
# 		whole_path_arr = JSON.parse(line)
# 	end
# 	return whole_path_arr
# end

def pointDist(loc1, loc2)
  rad_per_deg = Math::PI/180  # PI / 180
  rkm = 6371                  # Earth radius in kilometers
  rm = rkm * 1000             # Radius in meters

  dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
  dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  rm * c # Delta in meters
end

# for explanation of this function, see order_paths.rake file
def joinPaths1(arr)
	ordered_arr = arr[0]
	arr.delete_at(0)

	closestIdx = 0
	arbDist = 1500

	len = arr.length
	for i in 0..len
		reverseNext = false

		while arr.empty? == false
			closestDist = pointDist(ordered_arr[-1], arr[0][0])
			arr.each_with_index do |subarr, idx|
				if pointDist(ordered_arr[-1], subarr[0]) <= closestDist
					closestDist = pointDist(ordered_arr[-1], subarr[0])
					closestIdx = idx
					reverseNext = false
				end
				if pointDist(ordered_arr[-1], subarr[-1]) <= closestDist
					closestDist = pointDist(ordered_arr[-1], subarr[-1])
					closestIdx = idx
					reverseNext = true
				end
			end

			if closestDist > arbDist
				ordered_arr.reverse!
			else
				if reverseNext == true
					ordered_arr += arr[closestIdx].reverse!
				elsif reverseNext == false
					ordered_arr += arr[closestIdx]
				end
				arr.delete_at(closestIdx)
			end
		end
	end
	return ordered_arr
end

desc "create line array"
task create_line_array: :environment do
	zone_prefixes = %w[mountain]
	zone_prefixes.each do |prefix|
		paths = createPathsArray("#{prefix}TZ.txt")
		sorted_fullpath = joinPaths1(paths)
		File.open("log/#{prefix}_tz.log", "w") do |file|
			if File.zero?(file) == false
				File.truncate(file, 0)
			end
			file.write sorted_fullpath
		end
	end
end