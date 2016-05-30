class CreateCardLabels < ActiveRecord::Migration
  def change
    create_table :card_labels do |t|
      t.integer :card_id
      t.integer :label_id
      
      t.timestamps
    end
  end
end
