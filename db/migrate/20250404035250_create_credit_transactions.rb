class CreateCreditTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :credits, :integer, default: 0, null: false
    create_credit_transactions
  end

  private

  def create_credit_transactions
    create_table :credit_transactions do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: true

      t.integer :transaction_type, null: false
      t.integer :amount, null: false
      t.datetime :expires_at

      t.timestamps
    end

    add_index :credit_transactions, [ :user_id, :transaction_type, :expires_at ]
  end
end
