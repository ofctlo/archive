Brello.Collections.ChecklistItems = Backbone.Collection.extend({

  model: Brello.Models.ChecklistItem,
  
  url: function () {
    return '/checklists/' + this.checklist.get('id') + '/checklist_items'
  }

});
