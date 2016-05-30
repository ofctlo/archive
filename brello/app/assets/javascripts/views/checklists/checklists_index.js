// Manages all the checklist views for a card view.
Brello.Views.ChecklistsIndex = Backbone.View.extend({

  template: JST['checklists/index'],
  
  initialize: function () {
    this.listenTo(this.collection, "change add remove", this.render);
  },
  
  render: function () {
    var that = this;
    this.$el.html(this.template());
    
    this.collection.each(function (checklist) {
      var showView = new Brello.Views.ChecklistShow({
        model: checklist,
        collection: checklist.get('checklistItems')
      });
      
      that.$el.find('#checklist_show_views').append(showView.render().$el);
    });
    
    return this;
  }
});