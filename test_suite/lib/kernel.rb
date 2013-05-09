module Kernel    # add this to the Kernal to get mathod_name
	private  
	def this_method_name  
		caller[0] =~ /`([^']*)'/ and $1  
	end  
end 



