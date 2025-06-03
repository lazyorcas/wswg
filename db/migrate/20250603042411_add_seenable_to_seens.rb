class AddSeenableToSeens < ActiveRecord::Migration[8.0]
  def change
    add_reference :seens, :seenable, polymorphic: true
  end
end

# UPDATE seens
# SET seenable_type = 'User', seenable_id = user_id
# WHERE user_id IS NOT NULL
