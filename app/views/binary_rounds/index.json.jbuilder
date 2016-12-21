json.array!(@binary_rounds) do |binary_round|
  json.extract! binary_round, :id, :status, :open, :close, :itm
  json.url binary_round_url(binary_round, format: :json)
end
