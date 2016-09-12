require 'pry'
require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do
		erb :index #renders an index.erb file with links to signup or login.
	end

	get "/signup" do
		erb :signup #renders a form to create a new user. The form includes fields form username and password.
	end

	post "/signup" do
		user = User.new(:username => params[:username], :password => params[:password])
		if user.save
			redirect '/login'
		else 
			redirect '/failure'
		end
	end


	get "/login" do
		erb :login #renders a form for logging in
	end

	post "/login" do
		user = User.find_by(:username => params[:username]) #find the user by username
		if user && user.authenticate(params[:password]) #did we find the user (set as user) and the authenticate takes in a string as an argument and sees if it matches up against the password digest. It will return the user object
			session[:user_id] = user.id #set the session's user id and redirect to /success route
			redirect "/success"
		else
			redirect "/failure"
		end
	end

	get "/success" do
		if logged_in?
			erb :success #renders a success.erb page, which should display once a user is successfully logged in
		else
			redirect "/login"
		end
	end

	get "/failure" do
		erb :failure
	end

	get "/logout" do
		session.clear
		redirect "/"
	end

	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

end