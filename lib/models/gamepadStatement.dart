class GamePadStatement {
  bool gamePadButtonB;
  bool gamePadButtonX;
  bool gamePadButtonY;
  bool gamePadButtonA;
  bool gamePadButtonStart;
  bool gamePadButtonSelect;

  GamePadStatement(){
    this.gamePadButtonA = this.gamePadButtonB = 
    this.gamePadButtonX = this.gamePadButtonY= 
    this.gamePadButtonStart = this.gamePadButtonSelect = false;
  }
}