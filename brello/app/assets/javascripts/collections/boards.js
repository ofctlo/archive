Brello.Collections.Boards = Backbone.Collection.extend({
  model: Brello.Models.Board,
  url: function () {
    return '/boards';
  }
});
