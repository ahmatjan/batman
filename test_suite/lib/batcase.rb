# encoding: utf-8

# require File.dirname(__FILE__) + "/batman.rb"
require File.dirname(__FILE__) + "/test_browser.rb"

module Batman
	class BatCase

		def initialize
			# regist case
			puts "* case start, this case is: #{self.class.name.to_s}"
			@case_result = true
			@start_time = Time.now

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

		def after_case # this method may not be runned
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
		def run_test db_mgr
			begin
				# user zone start ********************** 	
				self.before_case
				self.setup
				self.test
				self.tear_down
				self.after_case
				# user zone end ************************
			rescue => e
				puts "* Exception: message: #{e}, from #{__FILE__}, @line: #{__LINE__}"
				Batman.snap_screen
				@case_result = false
			ensure
				# log_case_result
				@cost_time = Time.now - @start_time
				puts "* this case cost time: " + @cost_time.to_s + "seconds."
				puts "* debug info: case name: #{self.class.name.to_s}"
				puts "* debug info: time spend: #{@cost_time}s"
				puts "* reg case result and time from batcase.ensure....Done"
				$DB_MGR.reg_current_case_result @case_result, @cost_time

			end


		end
	end
end