class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string    :street,    null: false
      t.string     :city,     null: false
      t.string     :zipcode,  null: false
      t.references :state,    null: false, foreign_key: true

      t.timestamps
    end
  end
end
