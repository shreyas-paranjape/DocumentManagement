require 'erb'
require 'mysql'
require 'sequel'
#require 'sinatra'

class Display
	attr_reader :string
	
	def initialize (text)
		@text  = text
	end
	
	def build
		b = binding
		template = "<title>Results</title><h1>Search Results</h1><body><table style = width:50%><%=@text%></table></body>"
		ERB.new(template,0,"","@string").result(binding)
	end
end



def db_search(key)
	c = "%"+key+"%"
	ret_dis = ""
	DB.fetch("Select * from docs where keywords like ?", c) do |row|
		ret_dis = ret_dis+"Doc_id = "+row[:doc_id].to_s+",File_no = "+row[:file_no].to_s+","
	end
	return ret_dis
end

def temp_entry(array)
	s = array.size
	i=0;
	tb_entry = ""
	while i < s
		tb_entry = tb_entry + "<tr><td>" + array[i] + "</td><td>" + array[i+1]+ "</td></tr>"
		i=i+2
	end
	return tb_entry
end	


DB = Sequel.mysql(:host =>'localhost', :user=>'doc_user', :password=>'123456', :database=>'doc_c')


	#F = open("./transport.txt")
	text = ARGV.first  #"#{F.read}"
	show_text = db_search(text)
	puts show_text
	send = show_text.split(",")
	pass = temp_entry(send)
	#puts pass
	result = Display.new(pass)
	result.build
	#puts result.string + "\n"
	new_result = File.new("./views/show_results.erb","w+")
	new_result.syswrite(result.string)
	
	