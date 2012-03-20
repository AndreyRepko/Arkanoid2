unit circles;

interface

uses System.Types,Vcl.Graphics, base_classes;

type
TCircle = class (TTimedFigure)
  private
    Fradius: UInt16;
    Fcenter: TPoint;
    procedure Setcenter(const Value: TPoint);
    procedure Setradius(const Value: UInt16);
  protected
    procedure InternalDraw; override;
  public
     procedure DoNextStep;override;
     property center:TPoint read Fcenter write Setcenter;
     property radius:UInt16 read Fradius write Setradius;
     constructor Create(canv:TCanvas;BackClr:TColor;center:TPoint;radius:UInt16; color:TColor);
     function IsOutOfRange(max_position:TPoint):boolean;override;
 end;

implementation

{ TCircle }

constructor TCircle.Create(canv:TCanvas;BackClr:TColor;center: TPoint; radius: UInt16; color:TColor);
begin
  inherited Create(canv,BackClr);
  Self.Fradius:=radius;
  self.Fcenter:=center;
  self.Color:=color;
end;


procedure TCircle.DoNextStep;
begin
  fcenter:=self.fcenter.Add(self.speed);
end;

procedure TCircle.InternalDraw;
begin
   canvas.Ellipse(self.center.X-self.radius,Self.center.Y-self.radius,
                  self.center.X+self.radius,Self.center.Y+self.radius);
end;

function TCircle.IsOutOfRange(max_position: TPoint): boolean;
begin
  if (Self.center.X+self.radius<0) or (self.center.Y+self.radius<0) or
     (self.center.X-self.radius>max_position.X) or (self.center.Y-self.radius>max_position.Y) then
      result:=True else
      result:=False;
end;

procedure TCircle.Setcenter(const Value: TPoint);
begin
  Fcenter := Value;
end;

procedure TCircle.Setradius(const Value: UInt16);
begin
  Fradius := Value;
end;



{ TTimedCircle }

end.
