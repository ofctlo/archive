Snake.Game = (function() {
  function Game(width, height, snake) {
    this.width = width;
    this.height = height;
    this.snake = snake;
    this.apple = this.dropApple();
  }
  
  Game.prototype.advance = function() {
    this.snake.move();
    
    if (this.ateApple()) {
      this.snake.ate = true;
      this.apple = this.dropApple();
    }
  }
  
  Game.prototype.dropApple = function() {
    var x = -1;
    var y = -1;
    while (!this.openSpace([x, y])) {
      x = Math.floor(Math.random() * this.width);
      y = Math.floor(Math.random() * this.height);
    }
    
    return [x, y];
  }
  
  Game.prototype.openSpace = function(coords) {
    var offBoard = this.offBoard(coords);
    var onSnake = _.any(this.snake.body, function(bodypart) {
      bodypart[0] === coords[0] && bodypart[1] === coords[1];
    });
    
    return (!offBoard && !onSnake);
  }
  
  Game.prototype.ateApple = function() {
    var head = this.snake.body[0];
    return (head[0] === this.apple[0] && head[1] === this.apple[1]);
  }
  
  Game.prototype.offBoard = function(coords) {
    var offBoardX = (coords[0] < 0 || coords[0] >= this.width);
    var offBoardY = (coords[1] < 0 || coords[1] >= this.height);
    
    return offBoardX || offBoardY;
  }
  
  Game.prototype.detectCrash = function() {
    var that = this
    var offBoard = this.offBoard(this.snake.body[0]);

    var selfCollision = false;
    var test = {};
    _.each(_.range(0, that.snake.body.length - 1), function(i) {
      if (test.hasOwnProperty(that.snake.body[i].toString())) {
        selfCollision = true;
      }
      test[that.snake.body[i].toString()] = 1
    });
    return offBoard || selfCollision;
  }
  
  return Game;
})();