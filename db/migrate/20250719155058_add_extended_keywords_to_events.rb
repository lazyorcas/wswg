class AddExtendedKeywordsToEvents < ActiveRecord::Migration[8.0]
  def up
    add_column :events, :extended_keywords, :virtual,
      type: :tsvector,
      as: "to_tsvector('english', coalesce(title || ' ' || description, ''))",
      stored: true

    add_index :events, :extended_keywords, using: :gin
  end

  def down
    remove_column :events, :extended_keywords
  end
end
