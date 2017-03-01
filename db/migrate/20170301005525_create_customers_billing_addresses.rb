class CreateCustomersBillingAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :customers_billing_addresses do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :address,  null: false, foreign_key: true

      t.timestamps
    end
  end
end
