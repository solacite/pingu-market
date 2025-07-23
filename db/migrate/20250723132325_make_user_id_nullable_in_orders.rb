class MakeUserIdNullableInOrders < ActiveRecord::Migration[7.0] # Adjust version if needed
  def change
    change_column_null :orders, :user_id, true
  end
end