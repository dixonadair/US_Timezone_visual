

desc "write to another file as a test"
task test_task: :environment do 
	File.open("log/test.log","a") do |f|
		f.write "some"
	end
end