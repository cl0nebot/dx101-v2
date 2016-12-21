class AffCode < ActiveRecord::Base
  belongs_to :user
  validates :code, presence: true, uniqueness: true
  
end
