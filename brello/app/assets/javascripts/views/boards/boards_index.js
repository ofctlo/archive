Brello.Views.BoardsIndex = Backbone.View.extend({
  template: JST['boards/index'],
  
  className: 'board_index',
  
  events: {
    'click #new_board_link': 'displayNewBoardForm',
    'submit #new_board_form': 'processNewBoard',
    'click #dismiss_new_board_form': 'dismissNewBoardForm'
  },
  
  initialize: function () {
    this.listenTo(this.collection, "change add remove", this.render);
  },
  
  render: function () {
    var myBoards = this.myBoards();
    var sharedBoards = this.allSharedBoards();
    this.$el.html(this.template({
      myBoards: myBoards,
      sharedBoards: sharedBoards
    }));
    return this;
  },
  
  displayNewBoardForm: function (event) {
    event.preventDefault();
    this.$new_board_link = $('#new_board_link');
    $('#new_board').html(new Brello.Views.NewBoard().render().$el);
  },
  
  dismissNewBoardForm: function (event) {
    if (event) event.preventDefault();
    $('#new_board').html(this.$new_board_link);
  },
  
  processNewBoard: function (event) {
    var that = this;
    event.preventDefault();
    
    var boardData = $(event.target).serializeJSON();
    // TODO: same here...why the extra nesting.
    // or rather: why does it work correctly for cards??
    var board = new Brello.Models.Board(boardData.board);
    board.set('lists', new Brello.Collections.Lists());
    
    Brello.boards.add(board, { wait: true });
    
    board.save({}, {
      success: function (board) {
        that.dismissNewBoardForm();
      }
    });
  }
});
