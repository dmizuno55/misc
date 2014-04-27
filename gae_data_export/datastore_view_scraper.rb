#! ruby -Ku
require "rubygems"
require "mechanize"
require "kconv"

class DatastoreViewScraper
  COLUMN_OFFSET = 3
  COLUMN_NAME_CONVERSION_MAP = {
    "ID/NAME" => "id"
  }
  
  def initialize(url)
    @url = url
    @datastorePath = "/_ah/admin/datastore"
  end
  
  def get_entity(target)
    agent = Mechanize.new()
    agent.get(@url + @datastorePath + "?kind=" + target)
    header = agent.page.search("table#entities_table tr:first-child th").drop(COLUMN_OFFSET).map {|col|
      col.inner_text.strip
    }
    data = [header]
    begin
      has_more = false
      part = agent.page.search("table#entities_table tr.odd, tr.even").map {|row|
        row.search("td").drop(COLUMN_OFFSET).map {|col|
          convert_column_name(col.inner_text.strip.gsub("\n", ""))
        }
      }
      data.concat part
      if (agent.page.link_with(:dom_id => "next_link") != nil)
        agent.page.link_with(:dom_id => "next_link").click()
        has_more = true
      end
    end while has_more
    return data
  end
  
  def get_entity_names()
    agent = Mechanize.new()
    agent.get(@url + @datastorePath)
    entity_names = []
    entity_select = agent.page.forms.first.field_with(:id => "kind_input")
    entity_select.options.each {|opt|
      entity_names.push(opt.value)
    }
    return entity_names
  end

  
  def convert_column_name(col)
    if COLUMN_NAME_CONVERSION_MAP.has_key?(col)
      return COLUMN_NAME_CONVERSION_MAP[col]
    else
      return col
    end
  end
end

#scraper = DatastoreViewScraper.new("http://localhost:8080")
#list = scraper.get_entity_names()
#p list