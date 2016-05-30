Brello.Views.NewCard = Backbone.View.extend({
  template: JST['cards/new'],
  
  render: function () {
    this.$el.html(this.template());
    return this;
  }
});