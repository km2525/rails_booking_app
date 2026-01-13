class AddGuestsToReservations < ActiveRecord::Migration[7.2]
  def change
    add_column :reservations, :guests, :integer
  end
end
