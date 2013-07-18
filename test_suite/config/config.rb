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
require 'mysql'
require 'win32ole'

$HOME_DIR = File.dirname(__FILE__).split("/")[0, File.dirname(__FILE__).split("/").index("test_suite")+1].join("\\")
$START_URL = "http://www.baidu.com" # Warning: last char should NOT be "/"!
$USER_ID = "test_auto"
$USER_PASSWORD = "Y1RGM01tVXpjalE9Cg==\n"
$RUNNER = "Hexogen"
$MAIL_FROM = "wangpc.mobile@gmail.com"
$MAIL_TO = "wangpc.mobile@gmail.com" # if multi reciver, split with "," just like: "222@baidu.com,33@baidu.com"
$MAIL_SERVER = "smtp.google.com"
%MAIL_SERVER_DOMAIN = "google.com"
$SCREEN_IMG_FOLDER = $HOME_DIR + '\test_img'
$TEST_LOG_FOLDER = $HOME_DIR + '\test_log'  # d:\\test_log\\'
$ERROR_LOG_FOLDER = $HOME_DIR + '\test_error_log'
$SUCCESS_CASE = 0
$FAIL_CASE = 0
$FAIL_LIST = [] # araay
$SEND_FILE = false # bool
$SEND_MAIL = false
# str
$ERROR_LOG_HEADER = <<EOS
**********************************************************
* Error log created by WATIR
* Date: #{Time.now}
* Author: wangpc
**********************************************************

EOS
# str
$TEST_ID = 0 # int
$DB_NAME = "MCO_AUTOTEST.DB" # str
$DB_MGR = nil # dbMgr object
$CASE_ID_NAME = nil # hash
$START_TIME = ""
$FINISH_TIME = ""
$TOTAL_CASE = ""





