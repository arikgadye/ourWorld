require 'httparty'
require 'sinatra'
require 'securerandom'
require 'json'


CLIENT_ID = ENV["API_KEY"]
REDIRECT_URI = 'http://localhost:9393/logged_in'
STATE = SecureRandom.hex
CLIENT_SECRET = ENV["SECRET_KEY"]

get '/redirect_auth_url' do
  redirect_url = "https://accounts.google.com/o/oauth2/auth?" +
                  "response_type=code&" +
                  "redirect_uri=#{REDIRECT_URI}&" +
                  "scope=https://www.googleapis.com/auth/plus.me&" +
                  "client_id=#{CLIENT_ID}&" +
                  "state=#{STATE}"

  redirect redirect_url
end

get '/logged_in' do
  authorization_code = params[:code]
  first_response = HTTParty.post("https://accounts.google.com/o/oauth2/token", {
      :body => { code: authorization_code ,
                 client_id: CLIENT_ID ,
                 client_secret: CLIENT_SECRET,
                 redirect_uri: REDIRECT_URI,
                 grant_type: 'authorization_code',
      }
    })
  # p first_response
  access_token = first_response["access_token"]
  # p first_response
  # save into a database
  second_response = HTTParty.get("https://www.googleapis.com/plus/v1/people/me", {
    query: { access_token: access_token}
    })

  # save the user into a database, with access token
  response = second_response
  id = response["id"]
  username = response["displayName"]
  @user = User.find_or_create_by_google_id(id)
  @user.update_attributes(username: username)
  session[:user_id] = id
  flash[:welcome] = "Welcome #{@user.username}!"
  redirect to('/')
end


get '/' do
  # binding.pry
  erb :index
end

get '/times' do 
  @articles = []
  state = params[:state].strip.gsub(/\s+/, "")
  response = HTTParty.get("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=#{state}&api-key=3e12820f08431a42bc872573ba7b5f72:13:69616315")
  response["response"]["docs"].each do |article|
    if Article.find_by_headline(article["headline"]["main"])
      @articles << Article.find_by_headline(article["headline"]["main"])
    else 
      @articles << Article.create(headline: article["headline"]["main"], url: article["web_url"], snippet: article["snippet"])
    end
  end
  temp = @articles
  article = temp.delete(temp.sample)
  {
    state:    state,
    headline: article.headline,
    url:      article.url,
    snippet:  article.snippet
    }.to_json
  end


  # hash = {}
  # @articles.each do |article|
  #   new_hash = {state: state, headline: article.headline, url: article.url, snippet: article.snippet}
  #   hash.merge(new_hash)
  # end


post '/users/signin' do 
  # @user = User.find_by_username(params[:username])
  # if @user && @user.password == params[:password]
  #   session[:user_id] = @user.id
  #   p session[:user_id]
  #   redirect to('/')
  # else
  #   flash[:errors] = "meh"  
  #   redirect to ('/users/signin')
  # end
end

get '/users/new' do 
  erb :new
end
post '/users/new' do 
  @user = User.new(username: params[:username])
  @user.password = params[:password]
  @user.save!
  if @user.errors.any?
    redirect ('/users/new')
    flash[:errors] = @user.errors.full_messages
  end
  session[:user_id] = @user.id
  redirect to('/')
end 

post '/signout' do 
  session[:user_id] = nil
  session.destroy
  flash[:goodbye] = "Goodbye!"
  redirect to ('/')
end