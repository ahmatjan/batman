# encoding: utf-8

require File.join(__FILE__, '../../config/config.rb')

module Batman
	class TestDB
		def initialize
			# init the db obj/file
			self.init_db_file
			self.init_db_table
			
		end

		def init_db_file
			# init the db file
			begin
				@db = SQLite3::Database.new File.join(__FILE__, "../../db/#{$DB_NAME}")
			rescue Exception => e 
				puts e
				raise "Error when initialize test db, message: #{e}"
			end
		end

		def init_db_table
			begin
				# init the table
				sql_if_table_exists = <<-EOS
					select COUNT(*) from sqlite_master where type = 'table' and name in ('test_log','test_case','case_log'); 
				EOS
				sql_create_test_log = <<-EOS
					CREATE TABLE [test_log] (
						[test_id] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
						[test_timestamp] Timestamp NOT NULL DEFAULT (datetime('now','localtime')),
						[total_case] INTEGER NULL,
						[pass_case] INTEGER NULL,
						[fail_case] INTEGER NULL,
						[test_info] VARCHAR(255) NULL
					);
				EOS

				sql_create_test_case = <<-EOS
					CREATE TABLE [test_case] (
						[case_id] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
						[case_name] VARCHAR(255),
						[test_id] INTEGER NOT NULL,
						[case_result] TEXT
					);
				EOS

				sql_create_case_log = <<-EOS
					CREATE TABLE [case_log] (
						[log_id] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
						[case_id] INTEGER NOT NULL,
						[test_id] INTEGER NOT NULL,
						[log_text] TEXT NULL,
						[log_screenshot] BLOB NULL,
						[remark] VARCHAR(255)
					);
				EOS

				sql_init_test_id = "insert into test_log (test_id,total_case,pass_case,fail_case,test_info) values (10001,1,1,0,'this is the init record for table test_log');"
				sql_init_case_id = "insert into test_case (case_id,case_name,test_id,case_result) values (20001,'initCase',10001,1);"
				sql_init_case_log = "insert into case_log (log_id,case_id,test_id,log_text) values(30001,20001,10001,'this is a init case log.');"
				if (@db.execute sql_if_table_exists).to_s != "[[3]]" then
					@db.execute sql_create_test_log
					@db.execute sql_create_test_case
					@db.execute sql_create_case_log
					
					@db.execute sql_init_test_id
					@db.execute sql_init_case_id
					@db.execute sql_init_case_log
				else 
					puts "DB Table Exists" 
				end
			rescue => initDBTableErr
				puts initDBTableErr
				raise "Error when initialize test db table, message: #{initDBTableErr}"
			end
		end

		# def get_last_test_id
		# 	sql_get_last_test_id = "select test_id from test_log order by test_timestamp DESC limit 1;"
		# 	last_test_id = (@db.execute sql_get_last_test_id)[0][0].to_i
		# 	last_test_id
		# end

		# def get_last_case_id
		# 	sql_get_last_case_id = "select case_id from test_case order by case_id DESC limit 1;"
		# 	last_case_id = (@db.execute sql_get_last_case_id)[0][0].to_i
		# 	last_case_id
		# end

		# def get_last_log_id
		# 	sql_get_last_log_id = "select log_id from case_log order by log_id DESC limit 1;"
		# 	last_log_id = (@db.execute sql_get_last_log_id)[0][0].to_i
		# 	last_log_id
		# end

		# def write_test_log_table test_data
		# 	# test_data is a hash
			
		# 	# *** table info *** 
		# 	# [test_id] INT
		# 	# [test_timestamp] TIMESTAMP
		# 	# [total_case] INT
		# 	# [pass_case] INT
		# 	# [fail_case] INT
		# 	# [test_info] VAR
		# 	# ******************
		# 	sql_sub_key = ""
		# 	sql_sub_value = ""
		# 	test_data.each do |k, v|
		# 		if sql_sub == "" then
		# 			sql_sub_key += k.to_s
		# 			sql_sub_value += ("'" + v.to_s + "'")
		# 		else
		# 			sql_sub_key += ("," + k.to_s)
		# 			sql_sub_value += (",'" + v.to_s + "'")
		# 		end
		# 	end

		# 	sql_write_table = "insert into test_log ("+ sql_sub_key +") values ("+ sql_sub_value +");"
		# 	@db.execute sql_write_table
		# end

		# # def reg_test test_id, test_info
		# # 	# reg test into the test_log table without test static 
		# # 	# no return
		# # 	sql_reg_test = "insert into test_log (test_id, test_info) values (#{test_id}, '#{test_info}');"
		# # 	@db.execute sql_reg_test
		# # end

		# def reg_case case_name, test_id
		# 	# reg a case without result into test_case table
		# 	# this method return the id of the case
		# 	sql_reg_case = "insert into test_case (case_name, test_id) values ('#{case_name}',#{test_id});"
		# 	return (@db.execute "select case_id from test_case where case_name = '#{case_name}' and test_id = #{test_id};")[0][0]
		# end


		# # bug here !!!!!!!!!!!!!!!!!!!!!!!!!!
		# # update_test_log_table
		# def update_test_case_table test_data
		# 	sql_update_test_log = "update test_case set case_result = #{test_data["case_result"].to_i} where case_id = #{test_data["case_id"].to_i} and test_id = #{test_data["test_id"].to_i};"
		# 	@db.execute sql_update_test_log
		# end

		# def insert_new_log case_log_info
		# 	# case_log_info as :
		# 	# case_log_info["log_id"]=log_info[0]
		# 	# case_log_info["case_id"]=log_info[1]
		# 	# case_log_info["test_id"]=log_info[2]
		# 	# case_log_info["log_text"]=log_info[3]
		# 	# case_log_info["remark"]=log_info[4]
		# 	# sql like: insert into case_log (log_id, case_id, test_id, log_text, remark) values ();
		# 	sql_insert_case_log = "insert into case_log (case_id, test_id, log_text, remark) "
		# 	+"values (#{case_log_info["case_id"]},#{case_log_info["test_id"]},'#{case_log_info["log_text"]}','#{case_log_info["remark"]}'');"
			
		# 	@db.execute sql_insert_case_log
		# end

		# def update_test_case case_info
		# 	# ["case_id"] => int, p-key
		# 	# ["case_name"] => text
		# 	# ["test_id"] => int
		# 	# ["case_result"] => text, "0" for fail, "1" for pass

		# 	sql_update_test_case = "update test_case set case_id = "
		# end

		# def get_fail_case_count test_id
		# 	sql_count_fail_case = "select count(*) from test_case where test_id = '#{test_id}' "
		# 	+"and case_result = '0';"
		# 	fail_case_count = @db.execute sql_count_fail_case
		# 	return fail_case_count[0][0].to_i
		# end

		# def get_pass_case_count test_id
		# 	sql_count_pass_case = "select count(*) from test_case where test_id = '#{test_id}' "
		# 	+"and case_result = '1';"
		# 	pass_case_count = @db.execute sql_count_pass_case
		# 	return pass_case_count[0][0].to_i
		# end

		# def update_test_log_table test_info
		# 	# test_info like this :
		# 	# {
		# 	# 	"test_id"=>10001,
		# 	# 	"total_case"=>5,
		# 	# 	"pass_case"=>4,
		# 	# 	"fail_case"=>1,
		# 	# 	"test_info"=>"test test"
		# 	# }

		# 	sql_update_test_log
		# end





		# **********************重构**************************
		def update_test_log_table update_sql
			# input: update_sql(hash) like: {"test_id"=>10001}
			# output: no output
			# update_sql is a hash
			# like: {"pk"=>{"case_id"=>"10001",test_id=>"20001"},
			#        "keys"=>["total_case","pass_case","fail_case"],
			#        "values"=>[5,3,2]}
			# no output

			sql_update_test_log = "update test_log set "
			sub_sql = ""
			if update_sql["keys"].size == update_sql["values"].size
				for index in 0..(update_sql["keys"].size.to_i-1) do
					if sub_sql == "" then 
						sub_sql += "'#{update_sql["keys"][index].to_s}' = '#{update_sql["values"][index].to_s}'"
					else
						sub_sql += ",'#{update_sql["keys"][index].to_s}' = '#{update_sql["values"][index].to_s}'"
					end
				end
			else # two array not the same size
				raise "Exception Code: 10001"
			end
			sql_update_test_log += sub_sql
			sub_sql = ""
			update_sql["pk"].each do |p,k|
				if sub_sql == "" then 
					sub_sql += "#{p.to_s} = '#{k.to_s}'"
				else
					sub_sql += " and #{p.to_s} = '#{k.to_s}'"
				end
			end
			sql_update_test_log = sql_update_test_log + " where " + sub_sql + ";"
			@db.execute sql_update_test_log
		end

		def update_test_case_table update_sql
			# input: update_sql(hash) like: {"test_id"=>10001}
			# output: no output
			# update_sql is a hash
			# like: {"pk"=>{"case_id"=>"10001",test_id=>"20001"},
			#        "keys"=>["total_case","pass_case","fail_case"],
			#        "values"=>[5,3,2]}
			# no output

			sql_update_test_case = "update test_case set "
			sub_sql = ""
			if update_sql["keys"].size == update_sql["values"].size
				for index in 0..(update_sql["keys"].size.to_i-1) do
					if sub_sql == "" then 
						sub_sql += "'#{update_sql["keys"][index].to_s}' = '#{update_sql["values"][index].to_s}'"
					else
						sub_sql += ",'#{update_sql["keys"][index].to_s}' = '#{update_sql["values"][index].to_s}'"
					end
				end
			else # two array not the same size
				raise "Exception Code: 10002"
			end
			sql_update_test_case += sub_sql
			sub_sql = ""
			update_sql["pk"].each do |p,k|
				if sub_sql == "" then 
					sub_sql += "#{p.to_s} = '#{k.to_s}'"
				else
					sub_sql += " and #{p.to_s} = '#{k.to_s}'"
				end
			end
			sql_update_test_case = sql_update_test_case + " where " + sub_sql + ";"
      
			@db.execute sql_update_test_case
		end

		def update_case_log_table update_sql
			# input: update_sql(hash) like: {"test_id"=>10001}
			# output: no output
			# update_sql is a hash
			# like: {"pk"=>{"case_id"=>"10001",test_id=>"20001"},
			#        "keys"=>["total_case","pass_case","fail_case"],
			#        "values"=>[5,3,2]}
			# no output

			sql_update_case_log = "update case_log set "
			sub_sql = ""
			if update_sql["keys"].size == update_sql["values"].size
				for index in 0..(update_sql["keys"].size.to_i-1) do
					if sub_sql == "" then 
						sub_sql += "'#{update_sql["keys"][index].to_s}' = '#{update_sql["values"][index].to_s}'"
					else
						sub_sql += ",'#{update_sql["keys"][index].to_s}' = '#{update_sql["values"][index].to_s}'"
					end
				end
			else # two array not the same size
				raise "Exception Code: 10003"
			end
			sql_update_case_log += sub_sql
			sub_sql = ""
			update_sql["pk"].each do |p,k|
				if sub_sql == "" then 
					sub_sql += "#{p.to_s} = '#{k.to_s}'"
				else
					sub_sql += " and #{p.to_s} = '#{k.to_s}'"
				end
			end
			sql_update_case_log = sql_update_case_log + " where " + sub_sql + ";"
			@db.execute sql_update_case_log
		end

		def insert_test_log_table insert_sql
			# input: insert_sql(hash)
			# output: no output
			# insert_sql is a hash
			# like: {"keys"=>["total_case","pass_case","fail_case"],
			#        "values"=>[5,3,2]}
			# no output

			sql_insert_test_log = "insert into test_log "
			sub_sql_keys = ""
			sub_sql_values = ""
			if insert_sql["keys"].size == insert_sql["values"].size
				for index in 0..(insert_sql["keys"].size.to_i-1) do
					if sub_sql_keys == "" then 
						sub_sql_keys += "('#{insert_sql["keys"][index].to_s}'"
					else
						sub_sql_keys += ",'#{insert_sql["keys"][index].to_s}'"
					end

					if sub_sql_values == "" then 
						sub_sql_values += "values ('#{insert_sql["values"][index].to_s}'"
					else
						sub_sql_values += ",'#{insert_sql["values"][index].to_s}'"
					end
				end
			else # two array not the same size
				raise "Exception Code: 10004"
			end
			sub_sql_keys += ") "
			sub_sql_values += ");"
			sql_insert_test_log += sub_sql_keys
			sql_insert_test_log += sub_sql_values
			@db.execute sql_insert_test_log 
		end

		def insert_test_case_table insert_sql
			# input: insert_sql(hash)
			# output: no output
			# insert_sql is a hash
			# like: {"keys"=>["total_case","pass_case","fail_case"],
			#        "values"=>[5,3,2]}
			# no output

			sql_insert_test_log = "insert into test_case "
			sub_sql_keys = ""
			sub_sql_values = ""
			if insert_sql["keys"].size == insert_sql["values"].size
				for index in 0..(insert_sql["keys"].size.to_i-1) do
					if sub_sql_keys == "" then 
						sub_sql_keys += "('#{insert_sql["keys"][index].to_s}'"
					else
						sub_sql_keys += ",'#{insert_sql["keys"][index].to_s}'"
					end

					if sub_sql_values == "" then 
						sub_sql_values += "values ('#{insert_sql["values"][index].to_s}'"
					else
						sub_sql_values += ",'#{insert_sql["values"][index].to_s}'"
					end
				end
			else # two array not the same size
				raise "Exception Code: 10005"
			end
			sub_sql_keys += ") "
			sub_sql_values += ");"
			sql_insert_test_log += sub_sql_keys
			sql_insert_test_log += sub_sql_values
			begin
				@db.execute sql_insert_test_log
			rescue Exception => e
				puts e.to_s
				raise "Exception Code unknown, message: #{e.to_s}"
			end
		end

		def insert_case_log_table insert_sql
			# input: insert_sql(hash)
			# output: no output
			# insert_sql is a hash
			# like: {"keys"=>["total_case","pass_case","fail_case"],
			#        "values"=>[5,3,2]}
			# no output

			sql_insert_test_log = "insert into case_log "
			sub_sql_keys = ""
			sub_sql_values = ""
			if insert_sql["keys"].size == insert_sql["values"].size
				for index in 0..(insert_sql["keys"].size.to_i-1) do
					if sub_sql_keys == "" then 
						sub_sql_keys += "('#{insert_sql["keys"][index].to_s}'"
					else
						sub_sql_keys += ",'#{insert_sql["keys"][index].to_s}'"
					end

					if sub_sql_values == "" then 
						sub_sql_values += "values ('#{insert_sql["values"][index].to_s}'"
					else
						sub_sql_values += ",'#{insert_sql["values"][index].to_s}'"
					end
				end
			else # two array not the same size
				raise "Exception Code: 10006"
			end
			sub_sql_keys += ") "
			sub_sql_values += ");"
			sql_insert_test_log += sub_sql_keys
			sql_insert_test_log += sub_sql_values
			begin
				@db.execute sql_insert_test_log
			rescue Exception => e
				puts e.to_s
				raise "Exception Code unknown, message: #{e.to_s}"
			end
		end

		def select_from_test_log_table select_sql
			# select_sql is a hash
			# like: {"what"=>["case_id","test_id"], "where"=>{"case_id"=>"10001", "test_id"=>"20001"}}
			# return an array: [["1111","2222"],["2222","3333"]]
			if select_sql["what"] == "*" or select_sql["what"] == ["*"]
				sql_select_test_log = "select * from test_log where "
			else
				sql_select_test_log = "select "
				sub_sql = ""
				select_sql["what"].each do |select|
					if sub_sql == "" then 
						sub_sql += select.to_s
					else
						sub_sql += "," + select.to_s
					end
				end
				sql_select_test_log = "select #{sub_sql} from test_log where "
			end

			sub_sql = ""
			select_sql["where"].each do |k,v|
				if sub_sql == "" then 
					sub_sql += "#{k.to_s} = '#{v.to_s}'"
				else
					sub_sql += " and #{k.to_s} = '#{v.to_s}'"
				end
			end
			sub_sql += ";"
			sql_select_test_log += sub_sql
			return (@db.execute sql_select_test_log)

			
		end

		def select_from_test_case_table select_sql
			# select_sql is a hash
			# like: {"what"=>["case_id","test_id"], "where"=>{"case_id"=>"10001", "test_id"=>"20001"}}
			# return an array: [["1111","2222"],["2222","3333"]]
			if select_sql["what"] == "*" or select_sql["what"] == ["*"]
				sql_select_test_case = "select * from test_case where "
			else
				sql_select_test_case = "select "
				sub_sql = ""
				select_sql["what"].each do |select|
					if sub_sql == "" then 
						sub_sql += select.to_s
					else
						sub_sql += "," + select.to_s
					end
				end
				sql_select_test_case = "select #{sub_sql} from test_case where "
			end

			sub_sql = ""
			select_sql["where"].each do |k,v|
				if sub_sql == "" then 
					sub_sql += "#{k.to_s} = '#{v.to_s}'"
				else
					sub_sql += " and #{k.to_s} = '#{v.to_s}'"
				end
			end
			sub_sql += ";"
			sql_select_test_case += sub_sql
			return (@db.execute sql_select_test_case)
		end

		def select_from_case_log_table select_sql
			# select_sql is a hash
			# like: {"what"=>["case_id","test_id"], "where"=>{"case_id"=>"10001", "test_id"=>"20001"}}
			# return an array: [["1111","2222"],["2222","3333"]]
			if select_sql["what"] == "*" or select_sql["what"] == ["*"]
				sql_select_case_log = "select * from case_log where "
			else
				sub_sql = ""
				select_sql["what"].each do |select|
					if sub_sql == "" then 
						sub_sql += select.to_s
					else
						sub_sql += "," + select.to_s
					end
				end
				sql_select_case_log = "select #{sub_sql} from case_log where "
			end

			sub_sql = ""
			select_sql["where"].each do |k,v|
				if sub_sql == "" then 
					sub_sql += "#{k.to_s} = '#{v.to_s}'"
				else
					sub_sql += " and #{k.to_s} = '#{v.to_s}'"
				end
			end
			sub_sql += ";"
			sql_select_case_log += sub_sql
			return (@db.execute sql_select_case_log)
		end

		def get_last_test_id
			sql_get_last_test_id = "select test_id from test_log order by test_timestamp DESC limit 1;"
			last_test_id = (@db.execute sql_get_last_test_id)[0][0].to_i
			last_test_id
		end

		def get_last_case_id
			sql_get_last_case_id = "select case_id from test_case order by case_id DESC limit 1;"
			last_case_id = (@db.execute sql_get_last_case_id)[0][0].to_i
			last_case_id
		end

		def get_last_log_id
			sql_get_last_log_id = "select log_id from case_log order by log_id DESC limit 1;"
			last_log_id = (@db.execute sql_get_last_log_id)[0][0].to_i
			last_log_id
		end


		def get_fail_case_count test_id
			sql_count_fail_case = "select count(*) from test_case where test_id = '#{test_id}' and case_result = '0';"
			fail_case_count = @db.execute sql_count_fail_case
			return fail_case_count[0][0].to_i
		end

		def get_pass_case_count test_id
			sql_count_pass_case = "select count(*) from test_case where test_id = '#{test_id}' and case_result = '1';"
			pass_case_count = @db.execute sql_count_pass_case
			return pass_case_count[0][0].to_i
		end


	end



	# *************************************************************************
	# *************************************************************************
	# *************************************************************************



	class TestDBMgr
		def initialize
			@db = Batman::TestDB.new
			@test_id = (@db.get_last_test_id.to_i + 1)	
			$TEST_ID = @test_id
			@case_start_id = (@db.get_last_case_id.to_i + 1)
			@current_case_name = ""
			@case_id_name = ""
			self.register_test @test_id, "Test Start @ #{Time.now.to_s}"
		end # finish

		

		def set_current_case_name current_case_name
			@current_case_name = current_case_name
		end #finish

		def get_current_case_name
			return @current_case_name
		end #finish

		

		def register_test test_id, test_info
			# [test_id] INTEGER 
			# [test_timestamp] Timestamp
			# [total_case] INTEGER NULL,
			# [pass_case] INTEGER NULL,
			# [fail_case] INTEGER NULL,
			# [test_info] VARCHAR(255) 
			insert_sql = {"keys"=>["test_id", "test_info"],"values"=>[test_id.to_i, test_info.to_s]}

			# @db.reg_test test_id, test_info
			@db.insert_test_log_table insert_sql

		end

		def update_test
			# TODO: 
			# 1 Finish this method
			#
			# no input
			# static the result from data and update the result---after all the test
			# *********************** test_log table as : *****************************
			# [test_id] INTEGER 
			# [test_timestamp] Timestamp
			# [total_case] INTEGER NULL,
			# [pass_case] INTEGER NULL,
			# [fail_case] INTEGER NULL,
			# [test_info] VARCHAR(255) 
			# ***********************************************************************
			#  {"pk"=>{"case_id"=>"10001",test_id=>"20001"},
			#        "keys"=>["total_case","pass_case","fail_case"],
			#        "values"=>[5,3,2]}

			# step 1: get the result
			# select fail_case from the test_case
			# select count(*) from test_case where test_id = "***" and case_result = 0;
			# select count(*) from test_case where test_id = *** and case_reslit = 1;

			pass_case = @db.get_pass_case_count $TEST_ID
			fail_case = @db.get_fail_case_count $TEST_ID
			total_case = $CASE_ID_NAME.size

			update_sql = {
				"pk" => {"test_id" => $TEST_ID.to_i},
				"keys" => ["total_case", "pass_case", "fail_case"],
				"values" => [total_case.to_i, pass_case.to_i, fail_case.to_i]
			}

			@db.update_test_log_table update_sql
		end # fihish

		def register_case_list case_list
			# case_list is an array of case name
			# return a hash with case_id and case_name
			# e.g.: {10001=>"CaseA", 10002=>"CaseB"}
			@case_id_name = {}
			
			case_list.each do |case_name|
				# single_case_id = @db.reg_case case_name, @test_id
				# @case_id_name[single_case_id] = case_name
				# insert into test_case without the case_result
				@db.insert_test_case_table({"keys" => ["test_id","case_name"], "values" => [@test_id.to_i, case_name.to_s]})
				current_case_id = @db.select_from_test_case_table({"what" => ["case_id"], "where" =>{"test_id" => @test_id.to_i, "case_name" => case_name.to_s}})
				@case_id_name[current_case_id[0][0].to_i] = case_name
			end

			return @case_id_name
		end # finish



		def update_test_log test_log_info
			# test_log_info is a array
			# content is [test_id,total_case, pass_case, fail_case, test_info]
			# no one should be null !!
			# test_log = {}
				
			# test_log["test_id"] = test_log_info[0]
			# test_log["total_case"] = test_log_info[1]
			# test_log["pass_case"] = test_log_info[2]
			# test_log["fail_case"] = test_log_info[3]
			# test_log["test_info"] = test_log_info[4]

			update_sql = {
					"pk" => test_log_info[0].to_i, 
					"keys" => ["total_case", "pass_case", "fail_case", "test_info"], 
					"values" => [test_log_info[1].to_i, test_log_info[2].to_i,test_log_info[3].to_i,test_log_info[4].to_s]
				}

			# bug: @db.write_test_log_table test_log
			@db.update_test_log_table update_sql
		end # finish

		def update_test_case test_case_info
			# test_case_info is a array
			# content is [case_id,case_name,test_id,case_result]
			# no one should be null !!
			

			update_sql = {
				"pk" => {"case_id" => test_case_info["case_id"].to_i, "test_id" => test_case_info["test_id"].to_i},
				"keys" => ["case_id", "case_name", "test_id", "case_result"],
				"values" => [test_case_info["case_id"].to_i, test_case_info["case_name"].to_s, test_case_info["test_id"].to_i, test_case_info["case_result"].to_s]
			}

      
			@db.update_test_case_table update_sql


		end #finish


		

		def log_current_case_fail
			test_case = {}
			test_case["case_id"] = $CASE_ID_NAME.invert["#{@current_case_name}"].to_i
			test_case["case_name"] = @current_case_name.to_s
			test_case["test_id"] = $TEST_ID.to_i
			test_case["case_result"] = "0"
			self.update_test_case test_case
		end # finish

		def log_current_case_pass
			test_case = {}
			test_case["case_id"] = $CASE_ID_NAME.invert["#{@current_case_name}"].to_i
			test_case["case_name"] = @current_case_name.to_s
			test_case["test_id"] = $TEST_ID.to_i
			test_case["case_result"] = "1"
      
			self.update_test_case test_case
		end # finish

		def reg_current_case_result case_result
      
			if case_result then 
				self.log_current_case_pass
			else
				self.log_current_case_fail
			end
		end # finish


		def add_case_log log_info 
			# log_info: [log_id, case_id, test_id, log_text, remark]
			# case_log:
			# 	log_id int
			# 	case_id int
			# 	test_id int
			# 	log_text text
			# 	log_screenshot blob
			# 	remark var
			# insert into case_log (log_id, case_id, test_id, log_text, remark) values ();
			

			insert_sql = {
				"keys" => ["case_id", "test_id", "log_text", "remark"],
				"values" => [(@case_id_name.invert)["#{@current_case_name}"], log_info[2].to_i, log_info[3].to_s, log_info[4].to_s]
			}
			@db.insert_case_log_table insert_sql

		end # finish

		def get_fail_case_count
			# TODO: finish this method
			# return a int
			# get current fail case count from test_id

			return (@db.get_fail_case_count($TEST_ID)).to_i
		end # finish


		def get_pass_case_count
			# TODO: get pass case count
			return (@db.get_pass_case_count($TEST_ID)).to_i
		end # finish

		def check_data
			# TODO
			# check the data in db
			# include: total_case = pass_case + fail_case
			# data integrity
			# check_data run before generate the report

		end

		def get_case_result_by_id case_id
			# TODO
			# get the result from db by case_id AFTER the test
			# return a string
			# select case_result from test_case where case_id = "***";
			select_sql = {
				"what" => ["case_result"],
				"where" => {"case_id" => case_id.to_i}
			}

			res = @db.select_from_test_case_table select_sql
			return res[0][0].to_s
		end

		def get_step_by_case_id case_id
			# TODO
			# get all case step by case_id
			# return an array
			# case_steps << "add"....
			select_sql = {
				"what" => ["log_text"],
				"where" => {"case_id" => case_id.to_i}
			}

			res = @db.select_from_case_log_table select_sql
			resaa = []
			res.each do |aa|
				resaa << aa[0]
			end
			return resaa
		end

		def static_test
			# TODO
			# this method static the case from test_case table and update the test_log table
			# no input
			# no output
		end


	end

	
end

