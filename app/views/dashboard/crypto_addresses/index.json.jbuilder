json.array!(@crypto_addresses) do |crypto_address|
  json.extract! crypto_address, :id, :address, :currency, :active, :addrtype, :user_id
  json.url crypto_address_url(crypto_address, format: :json)
end
