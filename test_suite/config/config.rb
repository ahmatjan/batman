# encoding: utf-8
# config file

require File.dirname(__FILE__) + "/../lib/kernel.rb"
require 'mailfactory'
require 'zip/zipfilesystem'
require 'base64' 
require 'net/smtp'
require 'net/http'
require 'watir'
require 'watir/CookieManager'
require 'rautomation'
require 'sqlite3'
require 'markaby'
require 'uri'

$START_URL = "http://pan.baidu.com" 
$USER_ID = "test_auto"
$USER_PASSWORD = "Y1RGM01tVXpjalE9Cg==\n"
$RUNNER = "WANG Pengcheng"
$MAIL_FROM = "wangpengcheng03@baidu.com"
$MAIL_TO = "netdisk-qa@baidu.com"
$SCREEN_IMG_FOLDER = File.join(__FILE__, '../../test_img/')
$TEST_LOG_FOLDER = File.join(__FILE__, '../../test_log/')  # d:\\test_log\\'
$ERROR_LOG_FOLDER = File.join(__FILE__, '../../test_error_log/')
$SUCCESS_CASE = 0
$FAIL_CASE = 0
$FAIL_LIST = [] # araay
$SEND_FILE = false # bool
# str
$ERROR_LOG_HEADER = <<EOS
**********************************************************
* Error log created by WATIR
* Date: #{Time.now}
* Author: Wang Pengcheng
**********************************************************

EOS

# str
$MAIL_TEMPLATE = <<EOS

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

$DEBUG_LEVEL = 1

$TEST_ID = 0 # int
$DB_NAME = "MCO_AUTOTEST.DB" # str

$DB_MGR = nil # dbMgr object
$CASE_ID_NAME = nil # hash
$CLIENT_URL_PREFIX = "http://bcscdn.baidu.com"




