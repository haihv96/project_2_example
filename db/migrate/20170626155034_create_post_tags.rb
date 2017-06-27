class CreatePostTags < ActiveRecord::Migration[5.1]
  def change
    create_table :post_tags do |t|
      t.bigint :post_id, null: false
      t.bigint :tag_id, null: false
      t.timestamps
    end
    add_index :post_tags, :post_id
    add_index :post_tags, :tag_id
    add_index :post_tags, [:post_id, :tag_id], unique: true

    add_foreign_key :post_tags, :posts, column: :post_id, index: true
    add_foreign_key :post_tags, :tags, column: :tag_id, index: true
  end
end
