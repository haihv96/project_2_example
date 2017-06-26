class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.belongs_to :user, foreign_key: true, index: true, null: false
      t.belongs_to :post, foreign_key: true, index: true, null: false
      t.timestamps
    end
  end
end
