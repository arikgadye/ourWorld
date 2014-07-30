get '/' do
	erb :index
end

get '/times' do 
	state = params[:state].strip
	response = HTTParty.get("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=#{state}&api-key=3e12820f08431a42bc872573ba7b5f72:13:69616315")
	parsed_data = JSON.parse(response.body)["response"]["docs"][1]
	if Article.find_by_headline(parsed_data["headline"]["main"])
		@article = Article.find_by_headline(parsed_data["headline"]["main"])
	else
		@article = Article.create(headline: parsed_data["headline"]["main"], url: parsed_data["web_url"], snippet: parsed_data["snippet"])
	end
	{state: state, headline: parsed_data["headline"]["main"], url: parsed_data["web_url"], snippet: parsed_data["snippet"]}.to_json
end
