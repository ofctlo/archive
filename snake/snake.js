Snake = {};

Snake.Snake = (function() {
  // needs the board dimensions only so it 
  // can position itself Front and Center!
  function Snake(boardWidth, boardHeight) {
    that = this;
    this.body = [];
    this.dir = [0, -1];
    this.ate = false;
    
    pos = [boardWidth / 2, boardHeight / 2];
    _.each(_.range(0, 5), function(i) {
      that.body[i] = [pos[0], pos[0] + i]; // each body segment
    });
  }
  
  Snake.prototype.move = function() {
    var newHead = [this.body[0][0] + this.dir[0], 
                   this.body[0][1] + this.dir[1]];
    this.body.unshift(newHead); // new head
    
    if (!this.ate) {
      this.body.pop(); // kill tail
    } else {
      this.ate = false; // next turn kill tail
    }
  };
  
  Snake.prototype.turn = function(direction) {
    // the snake is not allowed to double back on itself.
    if ((this.dir[0] === direction[0] && this.dir[1] === -direction[1]) ||
        (this.dir[1] === direction[1] && this.dir[0] === -direction[0])) {
      return;
    } else {
      this.dir = direction
    }
  };
  
  return Snake;
})();