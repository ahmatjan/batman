# enconding: utf-8

require File.join(__FILE__,'../batman.rb' )
# require 'watir'
# require 'watir/CookieManager'

module Batman
	class BatBrowser
		def initialize
			# init db file
			# self.init_db
			begin

				@browser = Watir::IE.new
				@browser.speed = :fast
				@browser.maximize
				@browser.bring_to_front
				@browser.goto $START_URL
				@db_mgr = $DB_MGR
				sleep 0.5
			rescue => e
				raise "init err occured in BatBrowser.initialize"
			end
		end



		def back
			@browser.back
		end

		

		def clear_cookie
			Watir::CookieManager::WatirHelper.deleteSpecialFolderContents(Watir::CookieManager::WatirHelper::COOKIES)
			puts  "* clean cookie from test_browser"
			sleep 0.1
		end

		def clear_cache
			Watir::CookieManager::WatirHelper.deleteSpecialFolderContents(Watir::CookieManager::WatirHelper::INTERNET_CACHE)
			sleep 0.1
		end

		def close
			@browser.close
		end

		def assert_title title_u_want
			if title_u_want.to_s == @browser.title.to_s
				true
			else
				false
			end
		end

		def log log_content
			$LOG_HEADER = <<-EOS
			**********************************************************
			* Test case log created by BATMAN MCO-Client-Test        *
			* Date: #{Time.now}                                      *
			* Author: Wang Pengcheng								 *
			**********************************************************

			EOS
			file_path = $TEST_LOG_FOLDER + "\\" + Time.now.to_s.split(/ \s?/)[0].to_s+'_test_log.txt'

			if File.exists? file_path then
				File.open(file_path, 'a'){
					|file|
					file.puts "* "+log_content

				}
			else
				File.open(file_path, 'a'){
					|file|
					file.puts $LOG_HEADER
					file.puts '* '+log_content
				}
			end

			# log into db
			# log_info: array = [log_id, case_id, test_id, log_text, remark]
			current_case_name = @db_mgr.get_current_case_name
			current_case_id = $CASE_ID_NAME.invert["#{current_case_name}"].to_i
			case_log_info = [0,current_case_id,$TEST_ID,log_content,Time.now.to_s]
			@db_mgr.add_case_log case_log_info
		end


		def goto url
			@browser.goto url
		end

		def assert_has_str sub_str
			@browser.text.include? sub_str
    	end

    	def get_text_field_text how, what
      		return @browser.text_field(:"#{how}"=>"#{what}").value.to_s
    	end


		def assert_url url_u_want
			if url_u_want.to_s == @browser.url.to_s
				true
			else
				false
			end
		end


		def get_title
			@browser.title
		end


		def get_url
			@browser.url
		end

		def click type, value
			@browser.element(:"#{type}", value).click
	  	end

		def get_element_class type, value
			@browser.element(:"#{type}", value).class_name.to_s
		end

		def get_element_text type,value
			@browser.element(:"#{type}", value).text.to_s
		end

		def run_js js
	    	@browser.execute_script js
	  	end


		def maximize
			@browser.maximize
			sleep 0.5
		end


		def has_element? (how, what, timeout)
			result = false
			wait_count = 0.0
			while wait_count<=timeout.to_f
				if @browser.element(:"#{how.to_s}"=> "#{what.to_s}").exists?
					puts "yes"
					result = true
					break
				else
					puts "no"
					sleep 0.5
					wait_count += 0.5
				end
			end
			return result
		end





    	def set_text_field (how, what, content)
      		@browser.text_field(:"#{how.to_s}" => what.to_s).set content.to_s
    	end

	    def attach_sub_browser_with_url url
	      return Watir::IE.attach(:url, url.to_s)
	    end

	    def click_with_index how, what, index
	      @browser.element(:"#{how.to_s}"=>what.to_s, :index=>"#{index.to_s}").click
	    end

	    def get_text_with_index how, what, index
	      return @browser.element(:"#{how.to_s}"=>what.to_s, :index=>"#{index.to_s}").text
	    end

	    def get_link_url how, what
	      return @browser.link(:"#{how.to_s}"=>what.to_s).href.to_s
	    end

	    def url_response_ok? url # 待优化
	      if url[0..6].downcase == "http://" then
	        url_array = url.split("//")[1].split("/")
	        prefix = url_array[0]
	        and_then = ""
	        (1..url_array.length.to_i-1).each do |index|
	          and_then += "/"+url_array[index].to_s
	        end
	      else
	        raise "* Err in url_response_ok?: url not start with http://"
	      end
	      Net::HTTP.get(URI.parse("http://"+prefix))
	      response = Net::HTTP.get_response(prefix, and_then)
	      if response.message.to_s == "OK"
	        return true
	      else
	        return false
	      end
	    end

	    def send_keys key_str
	    	@browser.send_keys key_str
	    	
	    end


  end




end


