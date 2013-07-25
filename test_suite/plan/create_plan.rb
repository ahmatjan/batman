require "./test_plan.rb"

def say_hello
	puts "*****************************************************"
	puts "* Welcome to use this tool to create test plan! "
	puts "* Author: wangpc | wangpc.mobile@gmail.com "
	puts "* Project: http://wangpc.tk/batman"
	puts "*****************************************************"
	puts "* Now fetching the case list..."
end

def get_all_case
	case_list = []
	Dir[File.dirname(__FILE__) + '/../case/*.rb'].each do |file|
		case_list.insert -1, file.to_s.split("/")[-1][0..-4]
	end
	return case_list
end

def ask_for_plan case_list
	plan_hash = {}
	case_hash = {}
	case_str = ""
	new_case_list = []
	case_no_array = []
	puts "* List case finished."
	puts "* Now case and number list is: "
	if case_list == [] then raise "case list is empty! plz check the case folder!" end
	(0..case_list.size-1).each do |index|
		puts "*		" + index.to_s + " => #{case_list[index]}"
		case_hash[index] = case_list[index].to_s
	end
	puts "* Please enter the sequence u want to run, only number and semicolon(;) is ok, just like 2;1;4;3 "
	case_str = gets
	case_str.strip!
	if case_str[-1] == ";" then case_str = case_str[0..-2] end
	case_no_array = case_str.split(";")
	case_no_array.each do |str|
		if str.to_i.to_s != str then raise "ur input is invalied, only number and semicolon(;) is ok!" end
	end
	
	
	case_no_array.each do |index|
		if index.to_i > case_list.size-1 then raise "the sequence u input is bigger than the total case amount! " end 
		new_case_list << case_hash[index.to_i]
	end
	puts new_case_list
	puts "* Plz input a plan_name, only number, char and _ is ok: "
	name = gets 
	name.strip!
	plan_hash[name.to_s] = new_case_list
	while $TEST_PLAN[name] != nil
		puts "* name #{name} already exists, plz choose another one!"
		name = gets 
		name.strip!
	end
	return plan_hash
end

def save_plan plan_hash
	plan_hash.each do |k,v|

		$TEST_PLAN[k.to_s] = v
	end
	new_plan = "$TEST_PLAN = #{$TEST_PLAN}"
	new_plan = new_plan.gsub("{","{\n\t").gsub("}","\n}").gsub("], ","],\n\t")


	File.open("./test_plan.rb","w+") do |file|
		file.puts new_plan	
	end
	puts "* Create test plan: #{plan_hash.keys[0]} successful! "
end

def say_bye
	puts "* Thanks for use this tool, bye~! "
end


say_hello
case_list = [] # ["case1","case2",]
case_list = get_all_case
plan_hash = ask_for_plan case_list
save_plan plan_hash
say_bye

