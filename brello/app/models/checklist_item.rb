class ChecklistItem < ActiveRecord::Base
  attr_accessible :title, :completed
  
  validates :title, :checklist_id, presence: true
  validates :completed, inclusion: { in: [true, false] }
end
