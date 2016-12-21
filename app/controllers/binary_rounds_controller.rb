class BinaryRoundsController < ApplicationController
  before_action :set_binary_round, only: [:show]

  # GET /binary_rounds
  # GET /binary_rounds.json
  def index
    #@binary_rounds = BinaryRound.all
    @binary_rounds = BinaryRound.where.not(status: 3).all  # ignore cancelled rounds... maybe re-add later when AJAX working.
  end

  # GET /binary_rounds/1
  # GET /binary_rounds/1.json
  def show
  
    if @binary_round.roundtype == "btcusd60"
      @roundtype = "1 Minute"
    elsif @binary_round.roundtype == "btcusd5"
      @roundtype = "5 Minute"
    else 
      @roundtype = "1 Minute PLAY" 
    end    

    @ao = BinaryOrder.where(binary_round_id: @binary_round.id).count
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_binary_round
      @binary_round = BinaryRound.find(params[:id])
    end
end
