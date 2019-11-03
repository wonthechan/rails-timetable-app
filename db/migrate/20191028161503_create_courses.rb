class CreateCourses < ActiveRecord::Migration[5.2]
	def change
		create_table :courses do |t|
			t.string	:code
			t.string	:lecture
			t.string	:professor
			t.string	:location
			t.integer	:start_time
			t.integer	:end_time
			t.string	:dayofweek
			t.boolean	:display, default: false
			t.timestamps
		end
	end
end
