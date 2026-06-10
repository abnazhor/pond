class AddChangedAtToCollections < ActiveRecord::Migration[8.1]
  def change
    add_column :collections, :changed_at, :datetime
  end
end
