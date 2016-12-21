json.array!(@trades) do |trade|
  json.extract! trade, :id, :user_id, :amount
  json.url trade_url(trade, format: :json)
end
