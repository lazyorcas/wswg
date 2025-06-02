class AddCreditableToCreditTransactions < ActiveRecord::Migration[8.0]
  def change
    add_reference :credit_transactions, :creditable, polymorphic: true
  end
end

# UPDATE credit_transactions SET creditable_type = 'User', creditable_id = user_id
