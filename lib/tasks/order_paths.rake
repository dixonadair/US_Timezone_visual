
require 'json'

# This function, copied from stackoverflow, calculates the distance in meters between any two GIS coordinates on the globe
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

# This function takes a triply nested array (e.g. [ [[a,b],[c,d]], [[e,f],[g,h]] ]), where the main array is an array of line segments. Each line segment is an array of coordinate (point) arrays (e.g. [lat, lng]). These line segments should be connected into one line, but have been drawn separately, so they are still seperate line objects. This functions combines all the line segments together in the right order to make one full line.
def orderPaths(arr)
	ordered_arr = [arr[0]]
	arr.delete_at(0)

	closestIdx = 0
	arbDist = 1500 # if the closest distance between one point and any of the remaining points is more than 1.5 kilometer (1500 meters), interpret this to mean that we are actually dealing with one of the endpoints of the line.

	len = arr.length
	for i in 0..len
		reverseNext = false

		while arr.empty? == false
			closestDist = pointDist(ordered_arr[-1][-1], arr[0][0])
			# p "bla bla: #{ordered_arr[-1][-1]} and #{arr[0][0]}"
			arr.each_with_index do |subarr, idx|
				if pointDist(ordered_arr[-1][-1], subarr[0]) <= closestDist
					closestDist = pointDist(ordered_arr[-1][-1], subarr[0])
					closestIdx = idx
					reverseNext = false
				end
				if pointDist(ordered_arr[-1][-1], subarr[-1]) <= closestDist
					# p "backwards"
					closestDist = pointDist(ordered_arr[-1][-1], subarr[-1])
					closestIdx = idx
					reverseNext = true
				end
			end

			if closestDist > arbDist
				# p "hello"
				ordered_arr.each do |subarr|
					subarr.reverse!
				end
			else
				if reverseNext == true
					# p "This is arr[closestIdx]: #{arr[closestIdx]}."
					# p "This is arr[closestIdx]: #{arr[closestIdx].reverse!} reversed."
					ordered_arr << arr[closestIdx].reverse!
				elsif reverseNext == false
					ordered_arr << arr[closestIdx]
				end
				arr.delete_at(closestIdx)
			end

			# p ordered_arr
		end
	end

	p ordered_arr
end

file = File.join(Rails.root, 'log', 'test_3.log')
whole_path_arr = nil

desc "order paths"
task order_paths: :environment do
	IO.foreach(file) do |line|
		whole_path_arr = JSON.parse(line)
	end
	orderPaths(whole_path_arr)
end

# ===========================

# version without all the comments and better name :)
def joinPaths(arr)
	ordered_arr = [arr[0]]
	arr.delete_at(0)

	closestIdx = 0
	arbDist = 1500

	len = arr.length
	for i in 0..len
		reverseNext = false

		while arr.empty? == false
			closestDist = pointDist(ordered_arr[-1][-1], arr[0][0])
			arr.each_with_index do |subarr, idx|
				if pointDist(ordered_arr[-1][-1], subarr[0]) <= closestDist
					closestDist = pointDist(ordered_arr[-1][-1], subarr[0])
					closestIdx = idx
					reverseNext = false
				end
				if pointDist(ordered_arr[-1][-1], subarr[-1]) <= closestDist
					closestDist = pointDist(ordered_arr[-1][-1], subarr[-1])
					closestIdx = idx
					reverseNext = true
				end
			end

			if closestDist > arbDist
				ordered_arr.each do |subarr|
					subarr.reverse!
				end
			else
				if reverseNext == true
					ordered_arr << arr[closestIdx].reverse!
				elsif reverseNext == false
					ordered_arr << arr[closestIdx]
				end
				arr.delete_at(closestIdx)
			end
		end
	end
	return ordered_arr
end