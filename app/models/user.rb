class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable 
  # , :async
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  enum role: [:user, :admin, :disabled, :play, :seed]
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..20 }, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  

  has_many :aff_codes
  has_many :balances, autosave: true
  has_many :txes
  has_many :crypto_addresses
  has_many :binary_orders
  has_many :pars
  has_one :profile

  extend FriendlyId
   friendly_id :username

  def active_for_authentication?
    super unless self.disabled?
  end

  def after_confirmation
#    self.update(role: "play")
    NewaccountWorker.perform_async(self.id)   # create accounts for default currencies
    BitcoinWorker.perform_async(self.id)      # create bitcoin deposit address
  end


end
