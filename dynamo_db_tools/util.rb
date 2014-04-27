#! ruby -Ku
require "string_util"
require "dao"

def execute_all_target
  import_csv_path = CSVData::CSV_PATH
  Dir.chdir(import_csv_path)
  Dir.glob("*.csv") {|f|
    puts "process #{f}"
    target = f.sub(/\.(csv|CSV)$/, "")
    if !DAO.valid_table_name?(target)
      puts "invalid table name #{target}"
      next
    end
    yield(target)
  }
end

help = "usage: util.rb [select | test] [target..]"
if ARGV.empty?
  puts help
else
  case ARGV[0]
  when "select"
    dao = DAO.new
    ARGV.slice(1, ARGV.size).each {|target|
      dao.print_items(target)
    }
  when "test"
    
  else
    puts "Unknown command"
    puts help
  end
end
