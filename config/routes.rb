Rails.application.routes.draw do
	root 'home#index'
	post '/register' => 'home#register'
	post '/delete' => 'home#delete'
	post '/result' => 'home#result'
	post '/create_memo' => 'home#create_memo'
	post '/delete_memo' => 'home#delete_memo'
	post '/load_memos' => 'home#load_memos'
	post '/get_target_course' => 'home#get_target_course'
end
