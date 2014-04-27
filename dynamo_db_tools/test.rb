#! ruby -Ku
require "dao"

dao = DAO.new
dao.search_by_hashkey("mahoraba", "UserDeck|hogehoge|0|0")
