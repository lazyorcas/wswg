class UpdateInterestSetsToVersion2 < ActiveRecord::Migration[8.0]
  def change
    replace_view :interest_sets, version: 2, revert_to_version: 1
  end
end
