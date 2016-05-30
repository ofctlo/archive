var Asteroids = (function () {
  
	// MOVING OBJECT
	function MovingObject (pos, velocity, radius, game) {
		this.pos = [pos[0], pos[1]];
    this.radius = radius;
		this.game = game;
    this.dimensions = [this.game.canvas.width, this.game.canvas.height];
		this.velocity = velocity;
	}

	MovingObject.prototype.update = function () {
		this.pos[0] += this.velocity[0];
		this.pos[1] += this.velocity[1];
	};

	MovingObject.prototype.offScreen = function () {
		return (this.pos[0] < 0 || this.pos[0] > this.dimensions[0] || 
            this.pos[1] < 0 || this.pos[1] > this.dimensions[1])
	};
  
  MovingObject.prototype.wrap = function () {
		if (this.pos[0] < 0) {
			this.pos[0] = this.dimensions[0];
		} else if (this.pos[0] > this.dimensions[0]) {
			this.pos[0] = 0;
		}
		if (this.pos[1] < 0) {
			this.pos[1] = this.dimensions[1];
		} else if (this.pos[1] > this.dimensions[1]) {
			this.pos[1] = 0;
		}
  }
  
  Function.prototype.inherits = function(parent) {
    function Surrogate() {}
    
    Surrogate.prototype = parent.prototype;
    this.prototype = new Surrogate();
    this.prototype.constructor = this;
  }

	function Bullet (pos, direction, game) {
		var speed = 8;
		var dx = direction[0] * speed;
		var dy = direction[1] * speed;
		MovingObject.apply(this, [pos, [dx, dy], 2, game]);
		game.bullets[game.bullets.length] = this;
	}

	Bullet.inherits(MovingObject);

	Bullet.prototype.update = function() {
		if (this.offScreen()) {
			return false;
		} else {
			MovingObject.prototype.update.apply(this);
			return true;
		}
	};

	Bullet.prototype.draw = function() {
		context = this.game.context;

		context.beginPath();
		context.arc(this.pos[0], this.pos[1], this.radius, 0, (2 * Math.PI), false);
		context.fillStyle = "red";
		context.fill();
		context.closePath();
	};

	// SHIP
	function Ship (pos, game) {
		MovingObject.apply(this, [pos, [0, 0], 15, game]);
    this.angle = 0; // an angle representing forward
    this.acceleration = [0, 0];
    this.MAX_SPEED = 3;
	}

	Ship.inherits(MovingObject);

	Ship.prototype.fire = function() {
		var bulletDirection = directionFromAngle(this.angle)
    var bulletPosX = this.pos[0] + bulletDirection[0] * this.radius;
    var bulletPosY = this.pos[1] + bulletDirection[1] * this.radius;
		new Bullet([bulletPosX, bulletPosY], bulletDirection, this.game);
	};

	Ship.prototype.draw = function() {
    ctx = this.game.context;
    ctx.beginPath();
    ctx.arc(this.pos[0], this.pos[1], this.radius, 0, (2 * Math.PI), false);
    ctx.fillStyle = "gray";
    ctx.fill();
    // Show which direction the ship is facing:
    var direction = directionFromAngle(this.angle);
    ctx.moveTo(this.pos[0], this.pos[1]);
    ctx.lineTo(this.pos[0] + direction[0] * this.radius,
               this.pos[1] + direction[1] * this.radius);
    ctx.stroke();
    
    ctx.closePath();
	};

	Ship.prototype.update = function() {
    // apply acceleration.
    this.velocity[0] += this.acceleration[0];
    this.velocity[1] += this.acceleration[1];
    
    this.acceleration = [0, 0];
    
    // ship slows down by friction.
    for (var velComp = 0; velComp <= 1; velComp++) {
      if (this.velocity[velComp] >= 0) {
        this.velocity[velComp] -= Math.min(0.02, this.velocity[velComp]);
      } else {
        this.velocity[velComp] -= Math.max(-0.02, this.velocity[velComp]);
      }
    }
    
    // Constrain ship speed
		if (this.velocity[0] > this.MAX_SPEED) {
			this.velocity[0] = this.MAX_SPEED;
		} else if (this.velocity[0] < -this.MAX_SPEED) {
			this.velocity[0] = -this.MAX_SPEED;
		} else if (this.velocity[1] > this.MAX_SPEED) {
			this.velocity[1] = this.MAX_SPEED;
		} else if (this.velocity[1] < -this.MAX_SPEED) {
			this.velocity[1] = -this.MAX_SPEED;
		}
    
    this.wrap();
		MovingObject.prototype.update.apply(this);
	};

	Ship.prototype.isHit = function (asteroids) {
		for (var i = 0; i < asteroids.length; i++) {
			var distance = findDistance(this, asteroids[i]);

			if (distance < this.radius + asteroids[i].radius) {
				return true;
			}
		}

		return false;
	};

	Ship.prototype.power = function () {
    direction = directionFromAngle(this.angle);
    this.acceleration[0] += direction[0] * 2;
    this.acceleration[1] += direction[1] * 2;
    // this.velocity[0] += this.velocity[0] / 2 + 1 * direction[0];
    // this.velocity[1] += this.velocity[1] / 2 + 1 * direction[1];
	};
  
  Ship.prototype.turn = function (direction) {
    this.angle += direction;
  }


	// ASTEROID
	function Asteroid (pos, velocity, radius, game) {
		MovingObject.apply(this, [pos, velocity, radius, game]);
	}

	Asteroid.inherits(MovingObject);

	Asteroid.randomAsteroid = function (game) {
		var x = Math.random() * game.canvas.width;
		var y = Math.random() * game.canvas.height;

    // Asteroid doesn't exist yet but we need an object with a pos.
		var distance = findDistance({ pos: [x, y] }, game.ship);

		if (distance < 80) {
			x += 200;
			y += 200;
		}

		var xVel = Math.random() * 5 - 3;
		var yVel = Math.random() * 5 - 3;
		var velocity = [xVel, yVel];

		return (new Asteroid([x, y], velocity, (Math.random() * 30 + 5), game));
	};

	Asteroid.prototype.update = function () {
		this.wrap();
		MovingObject.prototype.update.apply(this);
	};

	Asteroid.prototype.draw = function () {
		var context = this.game.context;
		context.fillStyle = 'black';
		context.beginPath();
		context.arc(this.pos[0], this.pos[1], this.radius, 0, (2 * Math.PI), false);
		context.fill();
		context.closePath();
	};

	Asteroid.prototype.isHit = function(bullet) {
		var distance = findDistance(this, bullet);

		return (distance < (this.radius + bullet.radius))
	};


	// GAME
	function Game (canvas, numAsteroids) {
		this.canvas = canvas;
		this.context = canvas.getContext('2d');

		var x = canvas.width / 2;
		var y = canvas.height / 2;
		this.ship = new Ship([x, y], this);

		this.asteroids = this.generateAsteroids(numAsteroids);
		this.bullets = [];
	}

	Game.prototype.generateAsteroids = function (n) {
		var asteroids = [];

		for (var i = 0; i < n; i++) {
			asteroids[asteroids.length] = Asteroid.randomAsteroid(this);
		}

		return asteroids;
	};

	Game.prototype.draw = function() {
		var width = this.canvas.width;
		var height = this.canvas.height;

		this.context.clearRect(0, 0, width, height);
		this.context.fillStyle = "#5D478B";
		this.context.fillRect(0, 0, width, height);

		this.ship.draw();
		for (var i = 0; i < this.bullets.length; i++) {
			this.bullets[i].draw();
		}
		for (var i = 0; i < this.asteroids.length; i++) {
			this.asteroids[i].draw();
		}
	};
  
  Game.prototype.splitAsteroid = function (asteroid) {
    var newXVel = getRandomInt(-5, 5) / 2;
    var newYVel = getRandomInt(-5, 5) / 2;
		var newAsteroid1 = new Asteroid(asteroid.pos, 
                                    [newXVel, newYVel], 
                                    asteroid.radius / 2, 
                                    this);
    var newAsteroid2 = new Asteroid(asteroid.pos,
                                    [-newXVel, -newYVel],
                                    asteroid.radius / 2,
                                    this);
    this.asteroids = this.asteroids.concat([newAsteroid1, newAsteroid2]);
  }

	Game.prototype.update = function() {
		if (this.asteroids.length < 10) {
			this.asteroids[this.asteroids.length] = Asteroid.randomAsteroid(this);
		}

		if (this.ship.isHit(this.asteroids)) {
			console.log("MWAHAHA");
			clearInterval(this.timer);
		}

		this.ship.update()

		for (var i = 0; i < this.asteroids.length; i++) {
      this.asteroids[i].update();
			// alive refers to the asteroid.
      var alive = true;
			for (var j = 0; j < this.bullets.length; j++) {
				if (this.asteroids[i].isHit(this.bullets[j])) {
					var asteroid = this.asteroids.splice(i, 1)[0];
          var bullet = this.bullets.splice(j, 1)[0];
          
          if (asteroid.radius > 15) {
            this.splitAsteroid(asteroid);
          }
					alive = false;
					break;
				}
			}
		}

		for (var i = 0; i < this.bullets.length; i++) {
      this.bullets[i].update();
			if (this.bullets[i].offScreen()) {
				this.bullets.splice(i, 1);
			}
		}
	};

	Game.prototype.start = function () {
		var that = this;
		key('a', function () { that.ship.turn(-0.3); });
    key('d', function () { that.ship.turn(0.3); });
    key('w', function () { that.ship.power(); });
		key('space', function () { that.ship.fire(); });

		this.timer = setInterval(function () {
			that.draw();
			that.update();
		}, 32);
	};
  
  // HELPER FUNCTIONS
  function directionFromAngle(angle) {
    return [Math.cos(angle), Math.sin(angle)];
  }
  
  function directionFromVelocity(velocity) {
    var xSpeed = Math.pow(velocity[0], 2);
    var ySpeed = Math.pow(velocity[1], 2);
    var speed = Math.sqrt(xSpeed + ySpeed);
    
    var xDir = velocity[0] / speed;
    var yDir = velocity[1] / speed;
    
    return [xDir, yDir];
  }
  
  function findDistance(obj1, obj2) {
    var dx = Math.pow(obj1.pos[0] - obj2.pos[0], 2);
    var dy = Math.pow(obj1.pos[1] - obj2.pos[1], 2);
    return Math.sqrt(dx + dy);
  }
  
  function getRandomInt (min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  return {
    game: Game
  }
})();