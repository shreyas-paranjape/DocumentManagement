require 'sinatra'

get '/search' do
	erb :search
end

post '/results' do
	msg = params[:keywords]
	newfile = File.new('transport.txt','w+')
	newfile.syswrite(msg)
	#load 'my_erb.rb'
	system ('ruby my_erb.rb ' + msg)
	erb :show_results
end
	
	