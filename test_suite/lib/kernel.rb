module Kernel    # add this to the Kernal to get mathod_name
	private  
	def this_method_name  
		caller[0] =~ /`([^']*)'/ and $1  
	end  

	def bat_puts str
		puts "* from bat_puts: " + str
	end
end 



