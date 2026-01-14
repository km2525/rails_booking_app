class AddTotalPriceToReservations < ActiveRecord::Migration[7.2]
  def change
    add_column :reservations, :total_price, :integer
  end
end
