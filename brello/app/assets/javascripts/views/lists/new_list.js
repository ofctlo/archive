Brello.Views.NewList = Backbone.View.extend({
  template: JST['lists/new'],
  
  render: function () {
    this.$el.html(this.template());
    return this;
  }
});