class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.integer :role, null: false, default: 0
      t.boolean :block, null: false, default: false
      t.string :remember_digest
      t.integer :gender, null: false, default: 0
      t.string :phone
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.string :activation_digest
      t.boolean :activated, null: false, default: true
      t.datetime :activated_at

      t.timestamps
    end
  end
end
