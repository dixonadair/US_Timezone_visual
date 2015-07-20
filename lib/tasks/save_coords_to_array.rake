
require 'json'

file = File.join(Rails.root, 'log', 'test_2.log')
whole_path_arr = nil

desc "save_coords_to_array"
task save_coords_to_array: :environment do
	IO.foreach(file) do |line|
		whole_path_arr = JSON.parse(line)
	end
end