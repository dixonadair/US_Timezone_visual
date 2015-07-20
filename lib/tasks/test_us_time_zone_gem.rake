desc 'test_us_time_zone_gem'
task test_us_time_zone_gem: :environment do
	p TZ.whichTZ?([45,-116]) # in US
	p TZ.whichTZ?([55,-116]) # not in US (in Canada)
	p TZ.whichTZ?([45,-156]) # zero results (middle of the ocean)
end