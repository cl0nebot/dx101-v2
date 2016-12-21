class Par < ActiveRecord::Base
  belongs_to :user
  belongs_to :bonus_pool

  enum period: [:day, :week, :month, :year]
end
