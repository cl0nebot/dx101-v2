class Tx < ActiveRecord::Base
  belongs_to :user
  default_scope  { order(:created_at => :desc) }

  validates :txtype, presence: true
  validates :currency, presence: true
  validates :status, presence: true
  

  enum txtype: 		[ :deposit, :withdrawal, :buyoption, :selloption, :winpool, :afffee, :sysprofit]
  enum currency: 	[ :playbtc, :btc, :usd ]
  enum status: 		[ :pending, :processing, :complete, :cancelled, :unconfirmed ]
end
