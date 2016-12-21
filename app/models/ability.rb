class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
       can :manage, :all
    else
# TODO: fix abilities

      can :show, :all  #:read includes index, :show is show only.

      can :read, BinaryOrder

      can :read, BuyBitcoin
      can :show, User, :id => user.id
      #can :read, Dashboard::CryptoAddress, :id => user.id

    end
    

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
