# encoding: utf-8
Dir[File.dirname(__FILE__) + '../../case/*.rb'].each{|file| require file } # include all case files

module Batman
	class BatRunner
		def initialize
			# if run all
			if true
				@case_list = []
				@total_code = ""
				Dir[File.dirname(__FILE__) + '/../case/*.rb'].each do |file|
					@case_list.insert -1, file.to_s.split("/")[-1][0..-4] # get the case name, need to be enhanced
				end
				@case_list.each do |case_name|
					@total_code += "#{case_name.downcase}_instance = #{case_name}.new.run_test mgr;\n"  # generate the method
				end
				run_code = <<-eval_end   
					def run_all mgr
						begin
							#{@total_code}
						rescue Exception => e
							puts "* EXCEPTION TYPE: " + e.class.to_s
							puts "* EXCEPTION: " + e.to_s + "@#{__FILE__}, line:#{__LINE__}"
						end
					end
				eval_end
				# puts run_code
				Batman::BatRunner.class_eval  run_code      # add
			else  # if run the test_plan
				@case_list = []
				@total_code = ""
				
			end


			
    	end

    	def get_case_list    # todo
    		@case_list
    	end

    	def generate_runtime_cache # todo

    	end


	end
end