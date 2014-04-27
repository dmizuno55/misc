#! ruby -Ku
require "string_util"
require "csv"
require "json"

class CSVData
  CSV_PATH = "/Users/daisuke/Documents/cardgame/fixed_csv";
  CONF_PATH = "/Users/daisuke/Documents/cardgame/fixed_csv";
  NAME_FORMAT = :none
  
  def initialize(target)
    @conf = load_conf(target)
    @data = load_data(target)
  end
  
  attr_reader :data
  
  def validate_file(path)
    if !File.exists?(path)
      raise "#{path} is not found"
    end
  end
  private :validate_file
  
  def load_data(target)
    path = CSV_PATH + "/" + target + ".csv"
    validate_file(path)
    header = nil
    result = Array.new
    CSV.open(path, "r") {|row|
      if header === nil
        header = row.map{|col| StringUtil.format(NAME_FORMAT, col)}
        next
      end
      result.push(parse(header, row))
    }
    return result
  end
  private :load_data
  
  def parse(header, source)
    result = Hash.new
    header.each_index {|i|
      type = @conf["attributes"][header[i]]
      result[header[i]] = StringUtil.convert_type(type, source[i])
    }
    return result
  end
  private :parse
  
  def load_conf(target)
    path = CONF_PATH + "/" + target + ".json"
    begin
      validate_file(path)
    rescue
      return CSVData.create_default_conf(target, false)
    else
      return JSON.load(File.open(path))
    end
  end
  private :load_conf
  
  def get_options
    result = Hash.new
    result["hash_key"] = {
      "name" => @conf["hash_key"],
      "type" => @conf["attributes"][@conf["hash_key"]]
    }
    if @conf["range_key"] != nil
      result["range_key"] = {
        "name" => @conf["range_key"],
        "type" => @conf["attributes"][@conf["range_key"]]
      }
    end
    ["read_capacity_units", "write_capacity_units"].each {|prop|
      if @conf[prop] != nil
        result[prop] = @conf[prop]
      end
    }
    return result
  end
  
  def CSVData.create_default_conf(target, persist = true)
    conf_path = CONF_PATH + "/" + target + ".json"
    csv_path = CSV_PATH + "/" + target + ".csv"
    if !File.exists?(csv_path)
      raise "#{csv_path} is not found"
    end
    if File.exists?(conf_path)
      puts "alreay eixsts #{conf_path}"
    end
    header = nil
    data = nil
    CSV.open(csv_path, "r") {|row|
      if header === nil
        header = row.map {|col| StringUtil.format(NAME_FORMAT, col)}
      else
        data = row.map{|col| StringUtil.check_type(col)}
        break
      end
    }
    conf = Hash.new
    conf["hash_key"] = header[0];
    ary = [header, data].transpose
    attributes = Hash[*ary.flatten]
    # attributes = Hash.new
    # header.each {|key|
      # attributes[key] = StringUtil::TYPE_STRING
    # }
    conf["attributes"] = attributes
    conf["read_capacity_units"] = 5
    conf["write_capacity_units"] = 5
    if persist
      conf_file = File.open(conf_path, "w")
      conf_file.write(JSON.pretty_generate(conf))
      conf_file.close
    end
    return conf
  end
  
end
