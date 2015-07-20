require 'dixonadairdogeify'
# require 'dixonadair_hola'

desc "test my practice gem  called dixonadairdogeify"
task test_my_practice_gem: :environment do
	Dixonadairdogeify::Hola.hi
	Dixonadairdogeify::Array.bark
	Dixonadairdogeify::String.bark
end