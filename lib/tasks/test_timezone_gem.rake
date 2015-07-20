desc 'test time zone gem'
task test_timezone_gem: :environment do
	Timezone::Configure.begin do |c|
	  c.google_api_key = 'AIzaSyCwcXCOW86tACYxgx9GipuajLcyXfInHN8'
	end

	timezone = Timezone::Zone.new :latlon => [-34.92771808058, 138.477041423321]
	puts timezone.zone
end