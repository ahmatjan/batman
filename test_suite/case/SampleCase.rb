# encoding: utf-8
require File.dirname(__FILE__) + "/../lib/batcase.rb"

class SampleCase < Batman::BatCase
	# do not write initialize method for this class

	def setup
		@baidu = Batman::BatBrowser.new
	end

	def test
		@baidu.set_text_field("id", "kw", "batman")
		@baidu.click "id", "su"
		if @baidu.assert_has_str "batman"
			@baidu.log "test case pass"
			bat_puts "test console output"
		else
			@baidu.log "test case fail"
			@baidu.close
			raise "test case fail"
		end
	end

	def tear_down
		@baidu.close
	end
end