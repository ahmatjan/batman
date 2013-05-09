# encoding: utf-8

# require File.dirname(__FILE__) + "/batman.rb"
require File.dirname(__FILE__) + "/test_browser.rb"

module Batman
	class BatCase

		def initialize
			# regist case
			puts "initialize the case from batcase"
			@case_result = true

		end

		def log_case_result
			# init db
			# write into result
		end

		def case_register

		end

		def before_case
			$DB_MGR.set_current_case_name self.class.name.to_s
			
		end

		def after_case
			# puts self.class.name
		end

		# user control zone start ****************************
		def setup
			puts "before case before batcase"
		end

		def tear_down
			puts "after case from batcase"
		end

		def test
			puts "run case from batcase"
		end
		# user control zone end ******************************
		def run_test
			begin
				# user zone start ********************** 	
				self.before_case
				self.setup
				self.test
				self.tear_down
				self.after_case
				# user zone end ************************
			rescue => e
				puts "#{e}, caller is: #{caller}"
				@case_result = false
			ensure
				# log_case_result
				puts "reg case result from ensure"
				$DB_MGR.reg_current_case_result @case_result

			end


		end
	end
end