# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

CSV.foreach(Rails.root.join('lib/seeds/courses.csv'), headers: true) do |row|
	Course.create! do |c|
		c.code = row[0]
		c.lecture = row[1]
		c.professor = row[2]
		c.location = row[3]
		c.start_time = row[4]
		c.end_time = row[5]
		c.dayofweek = row[6]
	end
end