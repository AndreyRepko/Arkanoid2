unit squares;

interface

uses System.Types,Vcl.Graphics, base_classes;

type
 TSquare = class (TTimedFigure)
  private
    fVertex: TPoint;
    FWidth: UInt16;
    FHeight: UInt16;
    procedure SetHeight(const Value: UInt16);
    procedure SetVertex(const Value: TPoint);
    procedure SetWidth(const Value: UInt16);
   protected
    procedure InternalDraw; override;
   public
      procedure DoNextStep;override;
     property Vertex:TPoint read FVertex write SetVertex;
     property Width:UInt16 read FWidth write SetWidth;
     property Height:UInt16 read FHeight write SetHeight;
     constructor Create(canv:TCanvas;BackClr:TColor;Vertex:TPoint;  width, heigth:UInt16; color:TColor);
     function IsOutOfRange(max_position: TPoint): boolean;override;
 end;


implementation


{ TSquare }


constructor TSquare.Create(canv:TCanvas;BackClr:TColor;Vertex: TPoint; width, heigth: UInt16;
  color: TColor);
begin
  inherited Create(canv,BackClr);
  Self.fVertex:=Vertex;
  Self.Width:=width;
  self.Height:=heigth;
  self.Color:=color;
end;

procedure TSquare.DoNextStep;
begin
  fVertex:=self.fVertex.Add(self.speed);
end;

procedure TSquare.InternalDraw;
begin
   canvas.FrameRect(Bounds(self.fVertex.X,fVertex.Y,self.Width,self.Height));
end;

function TSquare.IsOutOfRange(max_position: TPoint): boolean;
begin
  if (self.Vertex.X+self.Width<0) or (self.Vertex.Y+self.Height<0) or
     (self.Vertex.X>max_position.X) or (self.Vertex.Y>max_position.Y) then
   begin
     result:=true;
   end else
   begin
     result:=false;
   end;
end;

procedure TSquare.SetHeight(const Value: UInt16);
begin
  FHeight := Value;
end;

procedure TSquare.SetVertex(const Value: TPoint);
begin
  FVertex := Value;
end;


procedure TSquare.SetWidth(const Value: UInt16);
begin
  FWidth := Value;
end;



end.
