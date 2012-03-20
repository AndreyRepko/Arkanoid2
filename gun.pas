unit gun;

interface
  uses System.Types,Vcl.Graphics,base_classes, squares, circles, System.Math;

const
 cGunLengh = 15;
 cBulletRadius = 4;
 cBulletColor = clRed;
 cBulletSpeed = 20;

type
 TGun = class(TSquare)
  private
    // in radians
    fAngle:Extended;
    FStep: TPoint;
    FAngleStep: Integer;
    fGunPosition:TPoint;
    procedure SetStep(const Value: TPoint);
    procedure SetAngleStep(const Value: Integer);
  protected
    procedure InternalDraw; override;
  public
   procedure MoveLeft;
   procedure MoveRigth;
   procedure TurnLeft;
   procedure TurnRight;
   function Fire:TCircle;
   property Step:TPoint read FStep write SetStep;
   property AngleStep:Integer read FAngleStep write SetAngleStep;
   //
   constructor Create(canv:TCanvas;BackClr:TColor;Vertex:TPoint;  width, heigth:UInt16; color:TColor);
 end;

implementation

{ TGun }

constructor TGun.Create(canv: TCanvas; BackClr: TColor; Vertex: TPoint; width,
  heigth: UInt16; color: TColor);
begin
  inherited Create(canv,BackClr,Vertex,width,heigth,color);
  self.fGunPosition.X:=self.Vertex.X+(self.Width div 2)+Trunc(cGunLengh*sin(fAngle));
  self.fGunPosition.Y:=self.Vertex.Y-Trunc(cGunLengh*cos(fAngle));
end;

function TGun.Fire: TCircle;
var
 bullet:TCircle;
begin
  bullet:=TCircle.Create(Self.Canvas,Self.BackColor,
                              self.fGunPosition,cBulletRadius,cBulletColor);
  bullet.Speed:=Point(Trunc(cBulletSpeed*sin(self.fAngle)),
                     -Trunc(cBulletSpeed*cos(self.fAngle)));

  result:=bullet;
end;

procedure TGun.InternalDraw;
var
 pos:TPoint;
begin
   inherited;
   canvas.Rectangle(Bounds(self.Vertex.X,self.Vertex.Y,self.Width,self.Height));

   pos:=Point(self.Vertex.X+(self.Width div 2),Vertex.Y);
   canvas.MoveTo(pos.X,pos.Y);
   Self.fGunPosition.X:=pos.x+Trunc(cGunLengh*sin(fAngle));
   Self.fGunPosition.Y:=pos.Y-Trunc(cGunLengh*cos(fAngle));
   canvas.LineTo(Self.fGunPosition.X,Self.fGunPosition.y);

end;

procedure TGun.MoveLeft;
begin
  Self.Clear;
  Self.Vertex:=self.Vertex.Subtract(Step);
  self.Draw;
end;

procedure TGun.MoveRigth;
begin
  Self.Clear;
  Self.Vertex:=self.Vertex.Add(Step);
  self.Draw;
end;

procedure TGun.SetAngleStep(const Value: Integer);
begin
  FAngleStep := Value;
end;

procedure TGun.SetStep(const Value: TPoint);
begin
  self.FStep:=Value;
end;

procedure TGun.TurnLeft;
begin
  Self.Clear;
  self.fAngle:=self.fAngle+DegToRad(self.AngleStep);
  self.Draw;
end;

procedure TGun.TurnRight;
begin
  self.Clear;
  self.fAngle:=self.fAngle-DegToRad(self.AngleStep);
  Self.Draw;
end;

end.
