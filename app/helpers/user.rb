helpers do 
	def signed_in?
		session[:user_id] != nil ? true : false
	end
end