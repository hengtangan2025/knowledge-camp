namespace :import_data do
  desc "导入csv中的用户数据"
  task :user_csv_file => [:environment] do
    file_path = ARGV[1]

    if !File.exists?(file_path)
      puts "#{file_path} 文件不存在，请指定正确的文件路径"
      next
    end
    require "csv"
    begin
      arr = CSV.read(file_path, :encoding => "gbk")
    rescue
      begin
        arr = CSV.read(file_path, :encoding => "utf-8")
      rescue
        "csv 格式出现未知错误，请把 #{file_path} 文件发给开发人员确定原因"
      end
    end

    has_error = false

    puts "检查数据是否有错误..."
    arr.each_with_index do |user_info_arr, index|
      name     = user_info_arr[0]
      login    = user_info_arr[1]
      password = user_info_arr[2]
      user = User.new(
        :name     => name,
        :login    => login,
        :password => password
      )
      if !user.valid?
        has_error = true
        user.errors.messages.each do |key, value|
          case key
          when :login
            p "第 #{index+1} 行数据登录名格式不对，原因是 #{value.join(",")}"
          when :name
            p "第 #{index+1} 行数据用户昵称格式不对，原因是 #{value.join(",")}"
          when :password
            p "第 #{index+1} 行数据用户密码格式不对，原因是 #{value.join(",")}"
          end
        end
        
      end
    end

    next if has_error

    puts "检查完毕，数据正确."
    puts "开始导入..."
    count = arr.count
    arr.each_with_index do |user_info_arr, index|
      p "#{index+1}/#{count}"
      name     = user_info_arr[0]
      login    = user_info_arr[1]
      password = user_info_arr[2]
      user = User.create!(
        :name     => name,
        :login    => login,
        :password => password
      )
    end
    puts "====: 导入完毕."
  end
end
