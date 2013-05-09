# encoding: utf-8
require File.dirname(__FILE__)+"/../lib/batrunner.rb"
require File.dirname(__FILE__)+"/../lib/batman.rb"

# clear last log except db log
Batman.clear_all_log

# init dbMgr
dbMgr = Batman::TestDBMgr.new

# reg it as global 
Batman.reg_globle_dbMgr dbMgr

# init a runner
go = Batman::BatRunner.new

# reg case list as global
$CASE_ID_NAME = $DB_MGR.register_case_list go.get_case_list

# run all the case
go.run_all $DB_MGR

puts
$DB_MGR.update_test
# general report
reporter = Batman::BatReport.new $TEST_ID, $DB_MGR
reporter.generate_report

# send mail


