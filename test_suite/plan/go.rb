# encoding: utf-8
require File.dirname(__FILE__)+"/../lib/batrunner.rb"
require File.dirname(__FILE__)+"/../lib/batman.rb"

$START_TIME = Time.now
Batman.clear_folder
dbMgr = Batman::TestDBMgr.new
Batman.reg_globle_dbMgr dbMgr
go = Batman::BatRunner.new
$CASE_ID_NAME = $DB_MGR.register_case_list go.get_case_list
$TOTAL_CASE = $CASE_ID_NAME.size
go.run_all $DB_MGR
$DB_MGR.update_test
reporter = Batman::BatReport.new $TEST_ID, $DB_MGR
reporter.generate_report
$FINISH_TIME = Time.now
Batman.send_mail
Batman.close_all_ie




