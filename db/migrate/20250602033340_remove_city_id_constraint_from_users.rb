class RemoveCityIdConstraintFromUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :city_id, true
  end
end
