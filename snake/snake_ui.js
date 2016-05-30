Snake.UI = (function() {
  function SnakeUI(game) {
    that = this;
    this.game = game;
    this.createField();
    this.draw();
  }
  
  SnakeUI.prototype.start = function() {
    var that = this;
    key('up', function() { that.game.snake.turn([-1, 0]); }); // west
    key('right', function() { that.game.snake.turn([0, 1]); }); // north
    key('down', function() { that.game.snake.turn([1, 0]); }); // east
    key('left', function() { that.game.snake.turn([0, -1]); }); // south

    this.timer = setInterval(function() { 
      // 60: very fast
      // 100: fast
      // 150: normal
      // 200: slow
      // 250: very slow
      that.step(); }, 150);
  };
  
  SnakeUI.prototype.step = function() {
    this.game.advance();
    this.draw();
    
    if (this.game.detectCrash()) {
      clearInterval(this.timer);
    }
  };
  
  SnakeUI.prototype.createField = function() {
    $field = $('<table>');
    
    _(that.game.width).times(function(i) {
      $row = $('<tr>');
      $field.append($row);
      
      _(that.game.height).times(function(j) {
        $row.append($('<td>').attr('id', i + '_' + j));
      });
    });
    $('body').append($field);    
  };
  
  SnakeUI.prototype.draw = function() {
    $('td').removeClass(); // clear field
    
    // draw snake.
    _.each(this.game.snake.body, function(coords) {
      $snakePart = $('#' + coords[0] + '_' + coords[1]);
      $snakePart.addClass('snake');
    });
    
    // draw apple.
    $apple = $('#' + this.game.apple[0] + '_' + this.game.apple[1]);
    $apple.addClass('apple');
  };
  
  return SnakeUI;
})();

$(function() {
  Snake.snake = new Snake.Snake(40, 40);
  Snake.game = new Snake.Game(40, 40, Snake.snake);
  Snake.ui = new Snake.UI(Snake.game);
  Snake.ui.start();
})