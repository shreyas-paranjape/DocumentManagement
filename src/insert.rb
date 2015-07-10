#Kindly install these gems
require 'fileutils'
require 'mysql'
require 'sequel'
require 'tesseract'
#Converts string array into string
def stringmake (array)
	string = ""
	if array.size>0
		array.each do |item|
			ele = item.to_s
			string = string +" "+ ele
		end
	end
	return string
end

def db_insert(text,file)
	DB[:docs].insert(:keywords => text, :file_no => file)
end

def db_file_insert(f_id,b_no)
	file_set = DB['select * from Location where file_id = ?',f_id]
	f_c = file_set.count
	if f_c == 0
		DB[:Location].insert(:file_id => f_id, :Box_no => b_no)
	end
	fn = DB[:Location].where(:file_id => f_id)
	return fn.select(:file_no)
		
end
	

#Ypu will also need a metadata file that contails the list of .txt files
#establishing connection with mysql server
DB = Sequel.mysql(:host =>'localhost', :user=>'doc_user', :password=>'123456', :database=>'doc_c')

#initaiating tesseract
e = Tesseract::Engine.new {|e|
  e.language  = :eng
  e.blacklist = '|'
}


doc = open("./metadata.txt") #metadata contains filenames of all text files
list = "#{doc.read}"
arr = list.split(" ") #each entry in arr contains 1 filename
len = arr.size
#input file number and box_number
puts "Enter File number";
fn = gets
file_id = fn.to_s
puts "Enter box number"
bn = gets
box_no = bn.to_i
file_no = db_file_insert(file_id,box_no)
#initialising

=begin this is the begining of comment
DB.create_table :docs do						This is table creation....
s	primary_key :doc_id							You can only run this
	String		:keywords,	:text=>true			To uncomment just remove =begin and =end from
	String		:disk_loc,	:size=>100			the lines.
	String		:phy_loc,	:size =>100
end
=end
#ocr_ret = e.text_for('./image/DSCN1865.JPG').strip
entry = "" 
i=0
j=1
=begin
Dir.glob('./image/**/*.JPG').each do |image|
	entry = e.text_for(image).strip
	db_insert(entry,file_no)
	puts j.to_s+"COMPLETE\n\n\n\n\n\n\n"
	j=j+1
end
=end	
while i < len
	#Getting text from the files
	file  = arr[i].to_s
	filename = "./"+file 
	f = open (filename)
	content = "#{f.read}"
	splitc = content.split(" ")
	cstring = stringmake(splitc)
	#physical location
	#phy_path = "box"+box_no.to_s+"/file"+file_no.to_s
	#disk location
	path = "/home/user/Prabhav/rubytest/dbtext"
	FileUtils.cp filename, path
	#Entering the data into DB
	db_insert(cstring,file_no)
	i = i+1
end
=begin
im_no = 1;
im_txt = "/home/user/Documents/Project/imtext/img_"+im_no.to_s+".txt"
newfile = File.new(im_txt,"w+")
newfile.syswrite(ocr_ret);
=end

