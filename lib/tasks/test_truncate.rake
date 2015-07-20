
# The truncate method clears everything within a file
desc "see if I can get the truncate method to work on a file"
task test_truncate: :environment do
	file = File.join(Rails.root, "log", "test_2.log")
	# the #zero? method checks to see if a file is empty
	if File.zero?(file)
		p "file is empty"
	else
		File.truncate(file, 0)
		p "contents of file are now cleared"
	end
end