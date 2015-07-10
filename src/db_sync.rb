require 'rsync'

src = "/home/user/Documents/Impandey/*"
dest = "/home/user/Prabhav/rubytest/newdb/"
Rsync.run(src,dest) do |item|
	if item.success?
		item.changes.each do |new|
			puts "#{new.filename},(#{new.summary})"
		end
	end
	
end
#Rsync.run("/home/user/Prabhav/rubytest/dbtext/*","/home/user/Prabhav/rubytest/newdb/")