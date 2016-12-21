json.array!(@loans) do |loan|
  json.extract! loan, :id, :user_id, :amount
  json.url loan_url(loan, format: :json)
end
