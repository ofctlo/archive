Brello.Views.UserShow = Backbone.View.extend({
  template: JST['users/show'],
  
  initialize: function () {
    this.listenTo(this.model, "change", this.render);
  },
  
  render: function () {
    var that = this;
    
    var myBoards, sharedBoards;
    if (that.model.get('id') === Brello.currentUser.get('id')) {
      sharedBoards = that.allSharedBoards();
      myBoards = that.myBoards();
    } else {
      sharedBoards = that.sharedByUser(that.model.get('id'));
      myBoards = []
    }
    
    this.$el.html(this.template({
      user: this.model,
      myBoards: myBoards,
      sharedBoards: sharedBoards
    }));
    
    return this;
  }
});