Brello.Views.ChecklistShow = Backbone.View.extend({
  className: 'checklist',
  
  template: JST['checklists/show'],
  
  events: {
    'submit .new_checklist_item_form': 'submitChecklistItemForm',
    'keypress .new_checklist_item_form': 'submitChecklistItemForm',
    
    'click .checkbox': 'checkItem',
    'click .checklist-delete': 'deleteChecklist',
    'click .checklist-item-delete': 'deleteChecklistItem',
    'click': 'blurForm'
  },
  
  initialize: function () {
    this.listenTo(this.model, "change", this.render);
    this.listenTo(this.collection, "change add delete remove", this.render);
  },
  
  render: function () {
    this.$el.html(this.template({
      checklist: this.model
    }));
    
    if (this.formActive) {
      this.$el.find('textarea').focus();
      // this.formActive = false;
    }
    
    return this;
  },
  
  submitChecklistItemForm: function (event) {   
    var that = this;
    if (event.type === 'keypress' && event.keyCode !== 13) return;
    this.formActive = true;
    
    event.preventDefault();
    var checklistId = $(event.target).data('checklist_id');
    var checkItemData = $(event.target).serializeJSON().checklist_item;
    var checkItem = new Brello.Models.ChecklistItem(checkItemData);
    
    this.model.get('checklistItems').add(checkItem, { wait: true });
    
    checkItem.save();
  },
  
  checkItem: function (event) {    
    var id = $(event.target).data('id');
    var checklistId = $(event.target).data('checklist_id');
    var item = this.model.get('checklistItems').get(id);
    var completed = item.get('completed');
    item.set('completed', completed ? false : true);
    item.save();
  },
  
  deleteChecklist: function (event) {
    event.preventDefault();
    this.model.destroy();
  },
  
  deleteChecklistItem: function (event) {
    event.preventDefault();
    var id = $(event.target).data('id')
    var item = this.model.get('checklistItems').get(id)
    item.destroy();
    this.model.get('checklistItems').remove(item)
  },
  
  blurForm: function (event) {
    if ($(event.target).is('.new_checklist_item_form textarea')) return;
    this.formActive = false;
  }
});