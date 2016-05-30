Brello.Routers.Boards = Backbone.Router.extend({
  routes: {
    "": "index",
    "boards/:id": "show",
  },
  
  index: function () {
    var indexView = new Brello.Views.BoardsIndex({ collection: Brello.boards });
    $('#content').html(indexView.render().$el);
  },
  
  show: function (id) {
    var board = Brello.boards.get(id);
    // fetch nested data.
    board.fetch({ 
      success: function (board) {
        var showView = new Brello.Views.BoardShow({
          model: board,
          collection: board.get('lists')
        });
        $('#content').html(showView.render().$el); 
      }
    });
  }
});