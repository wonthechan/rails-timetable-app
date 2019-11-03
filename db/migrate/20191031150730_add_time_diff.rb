class AddTimeDiff < ActiveRecord::Migration[5.2]
	def up
		add_column :courses, :time_diff, :integer
		Course.reset_column_information
		Course.all.each do |c|
			@t_diff = c.end_time - c.start_time
			c.update_columns(time_diff: @t_diff)
		end
	end
	
	def down
		remove_column :courses, :time_diff
		Course.reset_column_information
	end
end
