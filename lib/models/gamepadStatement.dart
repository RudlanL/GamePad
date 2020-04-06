class GamePadStatement {
  bool gamePadButtonB;
  bool gamePadButtonX;
  bool gamePadButtonY;
  bool gamePadButtonA;
  double velocityNormal;
  double velocityAngular;

  GamePadStatement(){
    this.gamePadButtonA = this.gamePadButtonB = 
    this.gamePadButtonX = this.gamePadButtonY = false;
    this.velocityAngular = this.velocityNormal = 0;
  }

  Map<String, dynamic> toJson() => {
    'BUTTON_B': gamePadButtonB,
    'BUTTON_A': gamePadButtonA,
    'BUTTON_X': gamePadButtonX,
    'BUTTON_Y': gamePadButtonY,
    'VELOCITY_NORMAL': velocityNormal,
    'VELOCITY_ANGULAR': velocityAngular,
  };
}