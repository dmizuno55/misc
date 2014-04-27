#! ruby -Ku
# -*- coding: undecided -*-
require "tempfile"

SRC_PATH = "/Users/daisuke/Documents/cardgame/export_csv"
DEST_PATH = "/Users/daisuke/Documents/cardgame/fixed_csv"

Dir.chdir(SRC_PATH)
Dir.glob("*.csv") { |target|
  temp = Tempfile.new("resume", SRC_PATH)
  File.open(SRC_PATH + "/" + target, "r") { |file|
    row_num = 0
    while line = file.gets
p row_num
      if row_num === 0
        temp.puts("\"id\"," + line)
      else
        temp.puts("\"#{row_num}\"," + line)
      end
      row_num += 1
    end
  }
  temp.close
  temp.open
  origin = File.open(DEST_PATH + "/" + target, "w")
  FileUtils.copy_stream(temp, origin)
  temp.close(true)
}
