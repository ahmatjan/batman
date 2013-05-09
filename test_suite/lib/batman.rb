# encoding: utf-8

require File.join(__FILE__,'../batreport.rb' )



module Batman

	def self.clear_all_screen  # delete all the screen shots in the $SCREEN_IMG_FOLDER
		cmd = "del ..\\test_img\\*.png"
		puts %x{#{cmd}}

	end

	def self.clear_all_log
		cmd = "del /Q ..\\test_log\\*.*"
		puts %x{#{cmd}}
	end

	def self.clear_all_error
		cmd = "del ..\\test_error_log\\*.*"
		puts %x{#{cmd}}
	end

	def self.clear_all_attachment
		cmd = "del ..\\attachment\\*.zip"
		puts %x{#{cmd}}
	end

	def self.clear_folder
		clear_all_screen
		clear_all_log
		clear_all_error
		clear_all_attachment
	end

	def self.error_log(case_name, error_message)   # wait for finish
		if case_name == nil or case_name == "" then case_name = "TestSuite" end

		file_path = $ERROR_LOG_FOLDER+Time.now.to_s.split(/ \s?/)[0].to_s+'_ERROR_MESSAGE.txt'
		# take a screen shot
		cmd = 'snapit '+$ERROR_LOG_FOLDER+case_name+'_error.png'
		puts %x{#{cmd}}
		# log error
		if File.exists? file_path then
				File.open(file_path, 'a'){
					|file|
					file.puts "* case_name: "+case_name+"\n"
					file.puts "* error message: "+error_message+"\n"
					file.puts "* screen shot name: "+case_name+'_error.png'
					file.puts "\n"

				}
			else
				File.open(file_path, 'a'){
					|file|
					file.puts $ERROR_LOG_HEADER
					file.puts "* case_name: "+case_name+'\n'
					file.puts "* error message: "+error_message+"\n"
					file.puts "* screen shot name: "+case_name+'_error.png'
					file.puts "\n"
				}
			end
	end


	def self.code_str(str)
		Base64.encode64(Base64.encode64(str)) 
	end

	def self.decode_str(str)
		Base64.decode64(Base64.decode64(str))
	end

	def self.add_file_to_zip(file_path, zip)
		if File.directory?(file_path)  then
	    		Dir.foreach(file_path) do |sub_file_name|  
	    			# puts "#{file_path}/#{sub_file_name}"
	      			add_file_to_zip("#{file_path}/#{sub_file_name}", zip) unless sub_file_name == '.' or sub_file_name == '..'  
	    		end  
	  	else  
	    		zip.add(file_path.split("/")[-1], file_path)  
	  	end
	  end

	def self.compress zip_name, file_path
		Zip::ZipFile.open zip_name, Zip::ZipFile::CREATE do |zip|  
	  		# puts $file_path
	    		add_file_to_zip file_path, zip   
	  	end  
	end 

	def self.generate_attachment
		file_path_log = File.join(__FILE__, "../../test_log")
		file_path_img = File.join(__FILE__, "../../test_img")
		file_path_error = File.join(__FILE__, "../../test_error_log")

		zip_path = File.join(__FILE__,  "../../attachment/test_attachment.zip")

		 
	  
		

	  	compress zip_path, file_path_log
	  	compress zip_path, file_path_img
	  	compress zip_path, file_path_error

	  	return  zip_path

		
	end

	def self.send_mail
		puts "Start Sending mail"
		# get test data
		
		# generate mail

		mail_content = <<-EOS

		大家好!

		以下是网盘前端自动化测试的执行报告摘要:

		****************************************************************************
		测试地址: #{$START_URL}
		开始时间: #{$START_TIME}
		结束时间: #{$FINISH_TIME}
		总计执行用例: #{$TOTAL_CASE}
		成功: #{$SUCCESS_CASE}
		失败: #{$FAIL_CASE}
		运行者: 王鹏程
		****************************************************************************

		失败用例列表:

		#{$FAIL_LIST}

		用例的测试详情请参考附件中每个用例的执行日志和失败日志.

		说明: 
		测试失败信息为: ***_ERROR_MESSAGE.txt
		测试用例日志为: ***_test_log.txt 
		测试截屏文件为: ***_img.png



		本邮件由测试框架自动生成, 可以直接回复, 欢迎大家多指教! 
		
		祝顺利!

		EOS


		attachement = generate_attachment # generate attachement

		mail = MailFactory.new 
		mail.to = ['wangpengcheng03@baidu.com','netdisk-qa@baidu.com'].join(',')
		mail.from = "#{$RUNNER}" 
		mail.subject = "网盘Web前端自动化测试报告@#{Time.now.to_s}"
		# mail.html='</font color="red">htmlconternt</font>'
		mail.text = mail_content
		mail.attach(attachement)
		to = ["#{$MAIL_TO}"]


		# msg = [ mail_from, subject, "\n", "#{mail_content}\n" ]  
		Net::SMTP.start("mail2-in.baidu.com", 25, "baidu.com") do |smtp|  
	  		# smtp.sendmail(msg, "#{$MAIL_FROM}", "#{$MAIL_TO}")  
	  		smtp.send_message(mail.to_s, "#{$MAIL_FROM}", to)
		end

		puts "finished sending mail"
	end


	def self.case_static case_name, result
		if result == true then 
			$SUCCESS_CASE += 1
		else 
			$FAIL_CASE += 1
			$FAIL_LIST.insert(-1, case_name)
		end
	end


	def self.clean_cookie
		puts "start clean_cookie in p_m"
		Watir::CookieManager::WatirHelper.deleteSpecialFolderContents(Watir::CookieManager::WatirHelper::COOKIES)
		p "clean cookie from public_mathods"
		sleep 1
		puts "finished clean_cookie in p_m"
	end

	def self.clean_cache
		Watir::CookieManager::WatirHelper.deleteSpecialFolderContents(Watir::CookieManager::WatirHelper::INTERNET_CACHE)
		p "clean cache from public_mathods"
		sleep 1
	end

	def self.reg_globle_dbMgr mgr
		$DB_MGR = mgr
	end


end