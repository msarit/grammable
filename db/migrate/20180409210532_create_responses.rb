class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.text :message
      t.integer :user_id
      t.integer :comment_id
      t.timestamps
    end
    add_index :responses, :user_id
    add_index :responses, :comment_id
  end
end
