#! ruby -Ku
require "dao"
require "csv_data"

def setup(target, init = false)
  puts "setup table [#{target.join(",")}]"
  dao = DAO.new
  target.each {|t|
    if !DAO.valid_table_name?(t)
      puts "invalid table name #{t}"
      next
    end
    data = CSVData.new(t)
    if init
      dao.delete_table(t)
    end
#    dao.create_table(t, data.get_options())
#    dao.add_items(t, data.data)
  }
end

def generate_config(target)
  puts "generate config file [#{target.join(",")}]"
  target.each {|t|
    CSVData.create_default_conf(t)
  }
end

def get_target(from = nil)
  import_csv_path = CSVData::CSV_PATH
  Dir.chdir(import_csv_path)
  result = Dir.glob("*.csv").map {|dir|
    dir.sub(/\.(csv|CSV)$/, "")
  }.sort
  if from != nil
    index = result.index(from)
    if index != nil
      result = result[index..result.size]
    else
      result = nil
    end
  end
  return result
end

def ask_yes_no(message)
  result = false
  puts message 
  ans = STDIN.gets
  if /^yes$/ =~ ans
    result = true
  end
  return result
end

help = "usage: setup.rb [init | add | conf | init_resume | add_resume] [target..]"
if ARGV.empty?
  puts help
else
  case ARGV[0]
  when "init"
    if ARGV.size === 1
      if ask_yes_no("[Initialize table] Executes all files in following path [yes/no]: " + CSVData::CSV_PATH)
        setup(get_target, true)
      end
    else
      setup(ARGV.slice(1, ARGV.size), true)
    end
  when "init_resume"
    if ARGV.size === 2
      if ask_yes_no("[Initialize table] Executes from '#{ARGV[1]}' in following path [yes/no]: " + CSVData::CSV_PATH)
        setup(get_target(ARGV[1]), true)
      end
    end
  when "add"
    if ARGV.size === 1
      if ask_yes_no("[Add record] Excecutes all files in following path [yes/no]: " + CSVData::CSV_PATH) 
        setup(get_target)
      end
    else
      setup(ARGV.slice(1, ARGV.size))
    end
  when "add_resume"
    if ARGV.size === 2
      if ask_yes_no("[Add record] Excecutes from '#{ARGV[1]}' in following path [yes/no]: " + CSVData::CSV_PATH) 
        setup(get_target(ARGV[1]))
      end
    end
  when "conf"
    if ARGV.size === 1
      if ask_yes_no("[Generate config file] Excecutes all files in following path [yes/no]: " + CSVData::CSV_PATH) 
        generate_config(get_target)
      end
    else
      generate_config(ARGV.slice(1, ARGV.size))
    end
  else
    puts "Unknown command"
    puts help
  end
end
