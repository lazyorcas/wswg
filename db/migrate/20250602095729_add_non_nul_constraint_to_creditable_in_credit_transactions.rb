class AddNonNulConstraintToCreditableInCreditTransactions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :credit_transactions, :creditable_id, false
    change_column_null :credit_transactions, :creditable_type, false
  end
end
