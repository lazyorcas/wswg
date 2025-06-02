class AddIndexToCreditTransactions < ActiveRecord::Migration[8.0]
  def change
    add_index :credit_transactions, [ :creditable_type, :creditable_id, :transaction_type, :expires_at ]
  end
end
