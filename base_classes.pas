unit base_classes;

interface

uses System.Types,Vcl.Graphics;
type

 TFigure = class(TObject)
  private
    FColor: TColor;
    fCanvas:TCanvas;
    fBackColor:TColor;
    procedure SetColor(const Value: TColor);
  protected
    procedure InternalDraw; virtual;abstract;
    property Canvas:TCanvas read fCanvas;
    property BackColor:TColor read fBackColor;
  public
    constructor Create(canvas:TCanvas;clrColor:TColor);
    procedure Draw; virtual;
    procedure Clear;virtual;
    property Color:TColor read FColor write SetColor;
    function IsOutOfRange(max_position:TPoint):boolean;virtual;abstract;
 end;

 TSpeedType = TPoint;

 TTimedFigure = class(TFigure)
      fSpeed:TSpeedType;
      procedure SetSpeed(const Value: TSpeedType);
    public
      procedure DoNextStep; virtual;abstract;
      property Speed:TSpeedType read fSpeed write SetSpeed;
 end;


 //Задачи:
 // 1. Класс должен себя нарисовать
 // 2. Класс должен определить пересечение с другим классом
 // 3. Клас должен \


 // TODO: Вынести процедуру пересечения в отдельный класс пересечений


implementation

{ TFigure }

procedure TFigure.Clear;
begin
  canvas.Pen.Color:=self.BackColor;
  Canvas.Brush.Color:=self.BackColor;
  Self.InternalDraw;
end;

constructor TFigure.Create(canvas: TCanvas; clrColor: TColor);
begin
  self.fCanvas:=canvas;
  self.fBackColor:=clrColor;
end;

procedure TFigure.Draw;
begin
  canvas.Pen.Color:=self.Color;
  Canvas.Brush.Color:=self.Color;
  Self.InternalDraw;
end;

procedure TFigure.SetColor(const Value: TColor);
begin
  FColor := Value;
end;



{ TTimedFigure }


procedure TTimedFigure.SetSpeed(const Value: TSpeedType);
begin
  Self.fSpeed:=Value;
end;

end.
