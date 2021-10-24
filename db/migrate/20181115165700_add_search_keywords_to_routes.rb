class AddSearchKeywordsToRoutes < ActiveRecord::Migration[5.2]
  def change
    add_column :routes, :search_keywords, :string
    add_index :routes, :search_keywords, opclass: :gin_trgm_ops, using: :gin
  end
end
