class AddDueDateToCard < ActiveRecord::Migration
  def change
    add_column :cards, :due_date, :date
  end
end
