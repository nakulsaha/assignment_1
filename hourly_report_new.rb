
file=File.new("therap.log.ms-2.2013-10-21", "r")

get_counter=Hash.new(0)
post_counter=Hash.new(0)
get_timer=Hash.new(0)
post_timer=Hash.new(0)
num_user=Hash.new(0)
user_id=Hash.new(0)
user_counter=Hash.new(0)
hour=0

s_u_g_time=0
s_u_p_time=0

while line=file.gets
  
  sub_string=Array.new
  
  string_split_space=line.split(/[\s,]/)
  
  i=0
  string_split_space.each do |sss|
    sub_string[i]=sss
    i+=1
    
    pre_hour=hour
    if i>1
      hour=sub_string[1][0..1].to_i
    end
    
    if pre_hour!=hour
      user_id.clear 
    end
    
    if i>19 && sub_string[15]=="URI=[/ma/isp/singleForm]"
      if (sub_string[10][0..0]=="U" && user_id[sub_string[10]]==0 ) && (sub_string[12]=="[PROFILER:132]")
        user_id[sub_string[10]]=1
        user_counter[hour]+=1                    
      end
      
      if sub_string[17]=="G"
        get_counter[hour]+=1
        get_timer[hour]+=sub_string[19][5,sub_string[19].length-2].to_i
        
      elsif sub_string[17]=="P"
        post_counter[hour]+=1
        post_timer[hour]+=sub_string[19][5,sub_string[19].length-2].to_i
      end
      
    end
  
    if i>19 && sub_string[10]=="U:samanthaparks@LOI-OR"
      if sub_string[17]=="G"
        s_u_g_time += sub_string[19][5,sub_string[19].length-2].to_i
       
      
      elsif sub_string[17]=="P"
        s_u_p_time += sub_string[19][5,sub_string[19].length-2].to_i
      end
        
   end
    
  end
    
end

  out_file=File.new("output_hourly_report.txt","w")
  
  out_file.puts "TH HOUR---# USER---# GET---# POST---TOTAL_TIME_GET(ms)---TOTAL_TIME_POST(ms)---TOTAL_TIME(ms)"
  
  for m in 0..hour
    out_file.print m , "TH Hour " , user_counter[m] , " USER " , get_counter[m] , " GET REQs " , post_counter[m] , " POST REQs " , get_timer[m] , " ms in GET " , post_timer[m] , " ms in POST " , get_timer[m]+post_timer[m] , " ms in Total "
    out_file.puts
  end
  
  out_file.puts
  out_file.puts
  out_file.print "For User U:samanthaparks@LOI-OR Total Get time ", s_u_g_time,"ms Total Pots time ", s_u_p_time,"ms"
  
  out_file.close
  

file.close
