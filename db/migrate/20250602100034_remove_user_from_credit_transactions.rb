class RemoveUserFromCreditTransactions < ActiveRecord::Migration[8.0]
  def change
    remove_reference :credit_transactions, :user, foreign_key: true
  end
end
