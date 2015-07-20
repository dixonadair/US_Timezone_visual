require 'gon'

class MainController < ApplicationController
  	def main
		zone_prefixes = %w[alaska hawaii_aleutian central eastern pacific]

		alaska = nil
		file = File.join(Rails.root, "log", "alaska_tz.log")
		IO.foreach(file) { |line| alaska = JSON.parse(line) }
		gon.alaska = alaska

		hawaii_aleutian = nil
		file = File.join(Rails.root, "log", "hawaii_aleutian_tz.log")
		IO.foreach(file) { |line| hawaii_aleutian = JSON.parse(line) }
		gon.hawaii_aleutian = hawaii_aleutian

		central = nil
		file = File.join(Rails.root, "log", "central_tz.log")
		IO.foreach(file) { |line| central = JSON.parse(line) }
		gon.central = central

		eastern = nil
		file = File.join(Rails.root, "log", "eastern_tz.log")
		IO.foreach(file) { |line| eastern = JSON.parse(line) }
		gon.eastern = eastern

		pacific = nil
		file = File.join(Rails.root, "log", "pacific_tz.log")
		IO.foreach(file) { |line| pacific = JSON.parse(line) }
		gon.pacific = pacific

		mountain = nil
		file = File.join(Rails.root, "log", "mountain_tz.log")
		IO.foreach(file) { |line| mountain = JSON.parse(line) }
		gon.mountain = mountain
  	end
end