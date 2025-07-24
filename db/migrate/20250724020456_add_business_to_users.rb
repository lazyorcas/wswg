class AddBusinessToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :business, foreign_key: true, index: true
  end
end
