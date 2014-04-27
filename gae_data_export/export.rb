#! ruby -Ku
require "./datastore_view_scraper"
require "csv"

HOST = "http://localhost:8080"
EXPORT_PATH = "/Users/daisuke/Documents/cardgame/export_csv"

def export_all
  scraper = DatastoreViewScraper.new(HOST)
  target = scraper.get_entity_names
  target.each {|t|
    data = scraper.get_entity(t)
    CSV.open(EXPORT_PATH + "/" + t + ".csv", "w", {:force_quotes => true}) {|f|
      data.each {|row|
        f << row
      }
    }
  }
end

def export(target)
  scraper = DatastoreViewScraper.new(HOST)
  target.each {|t|
    data = scraper.get_entity(t)
    CSV.open(EXPORT_PATH + "/" + t + ".csv", "w", {:force_quotes => true}) {|f|
      data.each {|row|
        f << row
      }
    }
  }
end


if ARGV.empty?
  puts "[Export table] Executes all tables [yes/no]"
  ans = STDIN.gets
  if ans =~ /^yes$/
    export_all
  end
else
  export(ARGV)
end
