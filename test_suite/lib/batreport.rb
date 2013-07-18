# encoding: utf-8

require File.join(__FILE__,'../batdb.rb' )

module Batman
	class BatReport
		def initialize test_id, db_mgr
			# init db_mgr
			@db_mgr = db_mgr

			# init the data
			@total_case = $CASE_ID_NAME.length.to_i
			@fail_case = @db_mgr.get_fail_case_count
			@pass_case = @db_mgr.get_pass_case_count
      		@case_summary = {}
			@case_summary = self.generate_case_summary_list
      		
			@case_detail = self.generate_case_detail_list
			# @report_path = 
			@case_list = []
			$CASE_ID_NAME.each do |k,v|
				@case_list << v.to_s
			end
			@css = <<-EOS
      		.title{
			        width:950px;
			        height:100px;               
			        background-color:rgb(188, 204, 183);
			        font: normal bold 25pt arial ; 
			        text-align:center;                              
			        margin:0 auto;                              
			}
			.report{                
			        line-height:80px;
			        vertical-align:middles;                              
			}
			.content{
			        width:950px;
			        margin:25px auto;
			}
			table {
			        width: 100%;
			        border-collapse: collapse;
			}       
			tr:nth-of-type(odd) {
			        background-color: rgb(242, 244, 245);
			}
			tr:hover {
			        background-color: #f3f3f3;
			}
			th {
			        background-color: #e8e8e8;
			        font-weight: bold;
			}
			td, th {
			        padding: 8px;
			        border: 1px solid #ccc;
			        /*text-align: center;*/
			}
			b{
			        color:blue;
			}
			.del{
			        color:red;
			}
			EOS
			
		end


		def generate_case_summary_list
			# generate hash like:
			# {"case 1: FormatCaseTest"=>"Pass", "case 2: ForTestCase"=>"Pass", "case 3: adasdasdCast"=>"Fail"}
			# case_name(string)=>result(Pass or Fail)
			# get name and result
			case_name_result = {}
			$CASE_ID_NAME.each do | case_id, case_name|
				case_res = @db_mgr.get_case_result_by_id case_id.to_i
        		
				if case_res.to_i == 1 then # pass
					case_name_result["#{case_name.to_s}"] = "Pass"
				else
					case_name_result["#{case_name.to_s}"] = "Fail"
				end # end if
			end # end each
      		
			return case_name_result
		end # end method

		def generate_case_detail_list
			# 2 get detail list
			# like: 
			# {"case 1: FormatCaseTest"=>
			#	{"pass"=>["aaa","bbb","ccc"]}, 
   			#  "case 2: TestCase"=>
   			#	{"pass"=>["aaa", "bbb", "ccc"]},
   			#  "case 3:PassCase"=>
   			#	{"fail"=>["aaa3","bbb3","ccc3"]}
   			# }

   			case_detail_list = {}
   			$CASE_ID_NAME.each do |case_id, case_name|
   				single_case_steps = @db_mgr.get_step_by_case_id case_id
   				case_res = @db_mgr.get_case_result_by_id case_id.to_i
   				if case_res.to_i == 1 then # pass
					case_detail_list["#{case_name.to_s}"] = {"Pass"=>single_case_steps}
				else # fail
					case_detail_list["#{case_name.to_s}"] = {"Fail"=>single_case_steps}
				end # end if
   			end # end each
   			case_detail_list
		end # end method

		def generate_report
			m = Markaby::Builder.new
      		css_local = @css
			m.html do
        		head do
                	title "Batman自动化测试报告"
                	style css_local, :type=>"text/css"
        		end

        		body do
                	div :class=>"title" do
                		p "Batman自动化测试报告", :class=>"report"
                	end # end of div title

                	div :class=>"content" do
                        div :class=>"first" do # first div
                        	h3 :class=>"detail ti" do
                            	a "摘要", :href=>"#"
                            end #end of the h3
                            table "TABLE_OF_SUMMARY" # placeholder
                        end # end of the div first

                        div :class=>"second" do # second div
                            h3 :class=>"detail ti" do
                                a "用例列表",:href=>"#"
                            end # end of the h3
                            table "TABLE_OF_CASE_LIST", :style=>"text-align: center;"
                        end # end of the div--second

                        div :class=>"third" do
                            h3 :class=>"detail ti" do
                                a "用例执行日志",:href=>"#"
                            end # end of the h3
                            table "TABLE_OF_CASE_DETAIL"
                        end # end of the third div
					end # end of div content
				end # end of body                
			end # end of html

			base_html = m.to_s
			m = Markaby::Builder.new

			# step 2: gen the summary table
			total_case_local = @total_case
			pass_case_local = @pass_case
			fail_case_local = @fail_case
			m.table do
        		tr do
                	td "总计执行用例："
                	td total_case_local
        		end
        		tr do
                	td "通过数："
                	td pass_case_local
        		end
        		tr do
                	td "失败数："
                	td fail_case_local
        		end
			end # end of table

			summary_table = m.to_s
			# puts summary_table
		  	begin
	        	m = Markaby::Builder.new
	        	case_summary_local = @case_summary

	        	#step 3: gen the case_list table
	        	# :style=>"text-align: center;"
	        	m.table :style=>"text-align: center;" do
	          		case_summary_local.each{
	            		|k,v|
	            		puts "* debug: k: #{k} => v: #{v}"
	            		tr do
	              			if v.to_s == "Pass" then
	                			td k.to_s+"---"+v.to_s
	              			else
	                			td k.to_s+"---"+v.to_s, :class=>"del"
	              			end # end of
	            		end # end tr do@170
          		}
        	end # end of table
      		rescue Exception => e
        		puts e
        		raise "shit"
      		end

			case_list_table = m.to_s
			# puts case_list_table
			m = Markaby::Builder.new

			# step 4 gen the case_datail_table
      		case_detail_local = @case_detail
			m.table do
	        	case_detail_local.each {
	              	|k,v|
	              # puts "k is #{k}, v is #{v}"
	              # puts v.keys[0].to_s
		        	tr do
		            	if (v.has_key? "Pass")
		                	td k.to_s+"---"+v.keys[0].to_s
		            	else
		                	td k.to_s+"---"+v.keys[0].to_s, :class=>"del"
		            	end
		        	end # end of the title tr

		         	tr do
		            	td do
		                	ol do
		                    	v.values[0].each do |log|
		                        	li log
		                    	end
		                	end # end of ol
		            	end # end of the td
		        	end # end of the tr
	         	}# end of each
			end # end of table

			case_detail_table = m.to_s
			# puts case_detail_table
			m = Markaby::Builder.new


			base_html = base_html.gsub("<table>TABLE_OF_SUMMARY</table>", summary_table)
			base_html = base_html.gsub("<table style=\"text-align: center;\">TABLE_OF_CASE_LIST</table>", case_list_table)
			base_html = base_html.gsub("<table>TABLE_OF_CASE_DETAIL</table>", case_detail_table)
			# puts base_html
			time_s = Time.now.to_s.split(" ")[0,2].join("_")
			time_s = time_s.delete(":")

			File.open("..\\test_log\\report_#{time_s}.html","a") do |file|
        		file.puts base_html
			end
		end # end of the method


	end # end of the class
end # end of module