# class CreateSpaces < ActiveRecord::Migration[6.1]
#   def change
#     create_table :spaces do |t|
#       t.string :name
#       t.string :location
#       t.text :description
#       t.integer :price
#       t.references :user, null: false, foreign_key: true
#     end
#   end
# end
