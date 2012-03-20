unit triangles;

interface

uses System.Types,Vcl.Graphics, base_classes;

type

 TTriangle = class (TTimedFigure)
  private
    fVertex1: TPoint;
    FVertex2: TPoint;
    FVertex3: TPoint;
    procedure SetVertex2(const Value: TPoint);
    procedure SetVertex3(const Value: TPoint);
    procedure SetVertex1(const Value: TPoint);
   protected
    procedure InternalDraw; override;
   public
     procedure DoNextStep; override;
     property Vertex1:TPoint read FVertex1 write SetVertex1;
     property Vertex2:TPoint read FVertex2 write SetVertex2;
     property Vertex3:TPoint read FVertex3 write SetVertex3;
     constructor Create(canv:TCanvas;BackClr:TColor;Vertex1,Vertex2,Vertex3:TPoint; color:TColor);
     function IsOutOfRange(max_position:TPoint):boolean;override;
 end;

 // for right triangles
 TSimpleTriangle = class(TTriangle)
    constructor Create(canv:TCanvas;BackClr:TColor;Vertex1,Vertex2:TPoint;color:TColor);
 end;


implementation
{ TTriangle }

constructor TTriangle.Create(canv:TCanvas;BackClr:TColor;Vertex1, Vertex2, Vertex3: TPoint; color:TColor);
begin
  inherited Create(canv,BackClr);
  self.Color:=color;
  self.fVertex1:=Vertex1;
  self.FVertex2:=Vertex2;
  self.FVertex3:=Vertex3;
end;

procedure TTriangle.DoNextStep;
begin
  fVertex1:=self.fVertex1.Add(self.fspeed);
  FVertex2:=self.FVertex2.Add(self.fspeed);
  FVertex3:=self.FVertex3.Add(Self.fspeed);
end;

procedure TTriangle.InternalDraw;
begin
  canvas.MoveTo(Vertex1.X,Vertex1.Y);
  canvas.LineTo(Vertex2.X,Vertex2.Y);
  canvas.LineTo(Vertex3.X,Vertex3.Y);
  canvas.LineTo(Vertex1.X,Vertex1.Y);
end;

function TTriangle.IsOutOfRange(max_position: TPoint): boolean;
begin
  if ((self.Vertex1.X<0) and (self.FVertex2.X<0) and (self.Vertex3.X<0)) or
     ((self.Vertex1.Y<0) and (self.FVertex2.Y<0) and (self.Vertex3.Y<0)) or
     ((self.Vertex1.X>max_position.X) and (self.FVertex2.X>max_position.X) and (self.Vertex3.X>max_position.X)) or
     ((self.Vertex1.y>max_position.y) and (self.FVertex2.y>max_position.y) and (self.Vertex3.y>max_position.y)) then
   begin
     result:=true;
   end else
   begin
     result:=false;
   end;
end;

procedure TTriangle.SetVertex1(const Value: TPoint);
begin
  FVertex1 := Value;
end;

procedure TTriangle.SetVertex2(const Value: TPoint);
begin
  FVertex2 := Value;
end;

procedure TTriangle.SetVertex3(const Value: TPoint);
begin
  FVertex3 := Value;
end;

{ TSimpleTriangle }

constructor TSimpleTriangle.Create(canv:TCanvas;BackClr:TColor;Vertex1, Vertex2: TPoint; color:TColor);
var
 thirdVertex:TPoint;
begin
 thirdVertex.X:=Vertex1.X;
 thirdVertex.Y:=Vertex2.Y;
 inherited Create(canv,BackClr,Vertex1,Vertex2,thirdVertex,color);
end;



end.
