class CreateMemos < ActiveRecord::Migration[5.2]
	def change
		create_table :memos do |t|
			t.string	:title
			t.text		:content
			t.timestamps
			t.references :course, foreign_key: true
		end
	end
end
