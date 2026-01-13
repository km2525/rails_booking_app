class AddPriceToRooms < ActiveRecord::Migration[7.2]
  def change
    add_column :rooms, :price, :integer
  end
end
