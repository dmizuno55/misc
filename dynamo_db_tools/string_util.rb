#! ruby -Ku
require "parsedate"

class StringUtil
  BLANK_STRING = " "
  BLANK_NUMBER = 0
  TYPE_STRING = "string"
  TYPE_NUMBER = "number"
  TYPE_DATE = "date"
  
  def StringUtil.convert_type(type, value)
    result = value
    if type === "number"
      if value.index(".") == nil
        result = value === nil ? BLANK_NUMBER : value.to_i
      else
        result = value === nil ? BLANK_NUMBER : value.to_f
      end
    elsif type === "date"
      if value === nil
        result = BLANK_STRING
      else
        date = ParseDate::parsedate(value)
        result = sprintf("%4d/%02d/%02d %02d:%02d:%02d", date[0], date[1], date[2], date[3], date[4], date[5])
      end
    else
      result = value === nil || value.empty? ? BLANK_STRING : value
    end
    return result
  end
  
  def StringUtil.convert_type_auto(value)
    type = StringUtil.check_type(value)
    return StringUtil.convert_type(type, value)
  end
  
  def StringUtil.check_type(value)
    result = TYPE_STRING
    if value != nil
      date = ParseDate::parsedate(value)
      if date[0] != nil && date[1] != nil && date[2] != nil
        result = TYPE_DATE
      elsif value =~ /^[0-9\.\-]+$/
        result = TYPE_NUMBER
      end
    end
    return result
  end
  
  def StringUtil.to_camelcase(str)
    if str.include?("_")
      ary = Array.new
      str.split("_").each_with_index {|value, index|
        ary.push(index > 0 ? value.capitalize : value.downcase)
      }
      return ary.join("")
    else
      return str
    end
  end
  
  def StringUtil.to_underscore(str)
    return str.split(/(?![a-z])(?=[A-Z])/).map{|s| s.downcase}.join("_")
  end
  
  def StringUtil.format(format, value)
    if format === :camelcase
      return StringUtil.to_camelcase(value)
    elsif format === :underscore
      return StringUtil.to_underscore(value)
    else
      return value
    end
  end
end
