json.array!(@binary_orders) do |binary_order|
  json.extract! binary_order, :id, :user_id, :order, :premium, :prembalance, :pool, :sysbonus, :depbonus, :affpay, :itm, :itmpayout, :profit
  json.url binary_order_url(binary_order, format: :json)
end
