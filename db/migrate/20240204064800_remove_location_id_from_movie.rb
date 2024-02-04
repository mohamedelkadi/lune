class RemoveLocationIdFromMovie < ActiveRecord::Migration[7.0]
  def change
    remove_column :movies, :location_id, :integer
  end
end
