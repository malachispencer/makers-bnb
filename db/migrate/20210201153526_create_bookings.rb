class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.references :spaces, null: false, foreign_key: { on_delete: :cascade }
      t.references :users, null: false, foreign_key: true
      t.date :check_in
      t.boolean :booked
    end
  end
end
