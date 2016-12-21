class ExtQuote < ActiveRecord::Base

enum pair: [:BTCUSD, :LTCUSD, :DGCUSD]
end
