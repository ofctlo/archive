class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.string :title
      t.boolean :completed
      t.integer :checklist_id
      
      t.timestamps
    end
  end
end
