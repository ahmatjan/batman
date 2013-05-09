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


		def login_pan
			# 判断是否存在登陆控件
			if @browser.text_field(:id=>"TANGRAM__PSP_1__userName").exists?
				@browser.text_field(:id=>"TANGRAM__PSP_1__userName").set $USER_ID   # input the user name
				@browser.text_field(:id=>"TANGRAM__PSP_1__password").set Batman.decode_str($USER_PASSWORD)
				@browser.element(:id => "TANGRAM__PSP_1__submit").click
				sleep 0.5
				# depend if login success
				counter = 0.0
				find=false
				while true
					if @browser.element(:id => "signout").exists?
						find = true
						break
					else
						counter += 0.5
						if counter >= 5.0
							find = true
							break
						else
							sleep 0.5
						end
					end
				end # end of while

				if find
					puts "login successful from "+this_method_name.to_s
					puts "caller is: "+caller.to_s
				else
					puts "login fail from "+this_method_name.to_s
					puts "caller is: "+caller.to_s
					raise "login fail from login_pan 1"
				end
			else # 不存在登陆控件
				if @browser.element(:id=>"signout").exists? # 存在登出控件
					@browser.element(:id=>"signout").click # 登出
					sleep 0.5
					if @browser.text_field(:id=>"TANGRAM__PSP_1__userName").exists? # 登出后重新登录
						@browser.text_field(:id=>"TANGRAM__PSP_1__userName").set $USER_ID   # input the user name
						@browser.text_field(:id=>"TANGRAM__PSP_1__password").set Batman.decode_str($USER_PASSWORD)
						@browser.element(:id => "TANGRAM__PSP_1__submit").click
						sleep 1
						# depend if login success
						counter = 0.0
						find=false
						while true
							if @browser.element(:id => "signout").exists?
								find = true
								break
							else
								counter += 0.5
								if counter >= 5.0
									find = true
									break
								else
									sleep 0.5
								end
							end
						end

						if find
							puts "login successful from "+this_method_name.to_s
							puts "caller is: "+caller.to_s
						else
							puts "login fail from "+this_method_name.to_s
							puts "caller is: "+caller.to_s
							raise "login fail from login_pan 2"
						end
					else
						raise "login state unknowen 1"
					end
				else
					raise "login state unknowen 2"
				end
			end
		end

		def logout_pan

			@browser.element(:id=>"signout").click
			# @browser.document.parentWindow.execScript ("alert()")
			sleep 0.5
			# depend if the logout is ok
			# find the element on the infocenter
			#if @browser.has_element?("id","signout",5)
				#puts "login successful from "+this_method_name.to_s
				#puts "caller is: "+caller.to_s
			#else
				#puts "login fail from "+this_method_name.to_s
				#puts "caller is: "+caller.to_s
				#raise "login fail from login_pan"
			#end
		end

		def back
			@browser.back
		end

		def capture_screen filename
			cmd = 'snapit '+$SCREEN_IMG_FOLDER+filename+'.png'
			puts %x{#{cmd}}

		end

		def clear_cookie
			Watir::CookieManager::WatirHelper.deleteSpecialFolderContents(Watir::CookieManager::WatirHelper::COOKIES)
			p "clean cookie from test_browser"
			sleep 1
		end

		def clear_cache
			Watir::CookieManager::WatirHelper.deleteSpecialFolderContents(Watir::CookieManager::WatirHelper::INTERNET_CACHE)
			sleep 1
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
			file_path = $TEST_LOG_FOLDER+Time.now.to_s.split(/ \s?/)[0].to_s+'_test_log.txt'

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

	  def wait_for_loading # need to modify
	  		wait_count = 0.0
	  		if @browser.element(:id => "_disk_id_1").exists? then

		  		while @browser.element(:id => "_disk_id_1").visible?

		  			if wait_count >= 30.0
		  				raise "Timeout when waiting the loading toast finish (30 seconds)"
		  			else
		  				sleep 0.5
		  				wait_count += 0.5
		  			end
		  		end
		  	else
		  		sleep 0.5
		  	end

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

		def choose_a_file file_path

			# this method start after u click the "upload" button on the page
			# and this mathod will select the file u give and click the "Open" button
			# u need to check the upload if it start afer this method
			# eg: file_path sshould be like this: "c:\dir\abc.txt"

			# init a rautomation's window
			wupload = RAutomation::Window.new(:class=>"#32770")
			if wupload.exists?
				file_input = wupload.text_field(:class=>"Edit")
				open_button = wupload.button(:value=>/(&O)/i)
			else
				raise "can not initialize the upload choose file window"
			end

			# choose a file
			if file_input.exists?
				file_input.set file_path.to_s
			else
				wupload.text_fields.each do |tf|
					tf.set file_path.to_s
				end
			end
			sleep 0.5
			# click the open
			open_button.click
			# start upload
		end

		def upload_now?   # this method return bool
			# create a js
			js = <<-EOS
			$(document.body).append('<input type="text" id="ats_temp" value= />');
			$('#ats_temp').css('visibility', 'hidden');
			$('#ats_temp').attr('value', Page.obtain()._mUploadDialog._mFileUploader.inSessionProgress());
			EOS
			# run the js: add a element and write the result to the element
			@browser.execute_script js

			# get the result
			is_up = @browser.text_field(:id=>"ats_temp").value.to_s

			# delete the temp element
			js = "$(\'#ats_temp\').remove();"
			@browser.execute_script js
			# return
			if is_up == "true"
				true
			else
				false
			end
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

    def url_response_ok? url
      if url[0..6].downcase == "http://" then
        url_array = url.split("//")[1].split("/")
        prefix = url_array[0]
        and_then = ""
        (1..url_array.length.to_i-1).each do |index|
          and_then += "/"+url_array[index].to_s
        end
      else
        raise "Err in url_response_ok?: url not start with http://"
      end
      Net::HTTP.get(URI.parse("http://"+prefix))
      response = Net::HTTP.get_response(prefix, and_then)
      if response.message.to_s == "OK"
        return true
      else
        return false
      end
    end
  end




end


