class AddKeywordsToEvents < ActiveRecord::Migration[8.0]
  def up
    add_column :events, :keywords, :virtual,
      type: :tsvector,
      as: "to_tsvector('english', coalesce(title, ''))",
      stored: true

    add_index :events, :keywords, using: :gin
  end

  def down
    remove_column :events, :keywords
  end
end
