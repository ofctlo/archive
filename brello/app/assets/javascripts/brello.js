window.Brello = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  
  initialize: function() {
    Brello.boards = new Brello.Collections.Boards();
    Brello.users = new Brello.Collections.Users();
    Brello.currentUser = new Brello.Models.User(JSON.parse($('#current_user').html()));
    // This fetch only gets the ids and names (boards#index)
    Brello.boards.fetch({
      success: function () {
        new Brello.Routers.Boards();
        new Brello.Routers.Cards();
        new Brello.Routers.Users();
        Backbone.history.start(/*{ pushState: true }*/);
      }
    });
  }
};

function startBackbone () {
  Brello.initialize();
};

_.extend(Backbone.View.prototype, {
  myBoards: function () {
    return Brello.boards.select(function (board) {
      return (board.get('user_id') === Brello.currentUser.get('id'))
    });
  },
  
  allSharedBoards: function () {
    return Brello.boards.select(function (board) {
      return board.get('user_id') !== Brello.currentUser.get('id');
    });
  },
  
  sharedByUser: function (id) {
    return Brello.boards.select(function (board) {
      return (board.get('user_id') === id &&
              board.get('user_id') !== Brello.currentUser.get('id'));
    });
  }
});