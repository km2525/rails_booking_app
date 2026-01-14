class AddDetailsToReservations < ActiveRecord::Migration[7.0]
  def change
    # guests カラムが既に存在する場合はスキップ
    add_column :reservations, :guests, :integer, default: 1, null: false unless column_exists?(:reservations, :guests)
    add_column :reservations, :total_price, :integer unless column_exists?(:reservations, :total_price)
  end
end