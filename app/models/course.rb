class Course < ApplicationRecord
	has_many :memos, :dependent => :destroy
end
