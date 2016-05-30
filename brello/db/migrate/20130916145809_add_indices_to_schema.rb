class AddIndicesToSchema < ActiveRecord::Migration
  def change
    add_index :lists, :board_id
    add_index :cards, :list_id
    add_index :checklists, :card_id
    add_index :checklist_items, :checklist_id
    add_index :memberships, :board_id
    add_index :users, [:fname, :lname]
    add_index :users, :email
  end
end
