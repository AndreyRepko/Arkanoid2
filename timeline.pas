unit timeline;

interface

uses
 base_classes, System.Generics.Collections, gun, System.Types,Vcl.Graphics,
 System.SysUtils, circles, squares, triangles;

const
 cColorsOfFigures: array[0..2] of TColor =
  (clRed, clGreen, clBlue);



 type

 TOnFigureEvent = procedure (obj:TFigure) of object;

 TTimeline = class
  private
    fCanvas:TCanvas;
    FWidth: Integer;
    FHeigth: Integer;
    FBackColor: TColor;
    //
    procedure AddNewFigures;
    procedure ClearAllFigures;
    procedure DoNextMove;
    procedure DrawAll;
    procedure CleanOutRange;
    procedure CheckAndDeleteIntersect;
    //
    procedure SetWidth(const Value: Integer);
    procedure SetHeigth(const Value: Integer);
    procedure SetBackColor(const Value: TColor);
  public
   figure:TList<TTimedFigure>;
   bullet:TList<TCircle>;
   gun:TGun;
   OnTargetDestroy:TOnFigureEvent;
   OnMiss:TOnFigureEvent;
   OnFault:TOnFigureEvent;
   procedure DoNextStep;
   procedure Proceed(key:word);
   property Width:Integer read FWidth write SetWidth;
   property Heigth:Integer read FHeigth write SetHeigth;
   property BackColor:TColor read FBackColor write SetBackColor;
   //
   constructor Create(canvas:TCanvas; Width, Heigth:integer;BackClr:TColor);
   destructor Destroy; override;
 end;



implementation

{ TTimeline }

uses intersectchecker;

procedure TTimeline.AddNewFigures;
const
 cmax_speed = 5;
 cMaxSize = 20;
var
 rand_result:Integer;
 Triangle:TSimpleTriangle;
 Square: TSquare;
 Circle: TCircle;
begin
 //TODO: extract contstant to some store
  rand_result:=Random(10);
  case rand_result of
    0:
     begin
       Triangle:=TSimpleTriangle.Create( Self.fCanvas,
                                         self.BackColor,
                                         Point(Random(width),0),
                                         Point(Random(width),Random(cMaxSize)),
                                         cColorsOfFigures[Random(High(cColorsOfFigures))]
                                       );
       Triangle.Speed:=Point(0,1+Random(cmax_speed));
       Self.figure.Add(Triangle);
     end;
    1:
     begin
       Square:=TSquare.Create( Self.fCanvas,
                               self.BackColor,
                               Point(Random(width),0),
                               Random(cMaxSize)+1,
                               Random(cMaxSize)+1,
                               cColorsOfFigures[Random(High(cColorsOfFigures))]
                             );
       Square.Speed:=Point(0,1+Random(cmax_speed));
       Self.figure.Add(Square);
     end;
    2:
     begin
       Circle:=TCircle.Create(
                              Self.fCanvas,
                              self.BackColor,
                              Point(Random(width),0),
                              Random(cMaxSize),
                              cColorsOfFigures[Random(High(cColorsOfFigures))]
                             );
       Circle.Speed:=Point(0,1+Random(cmax_speed));
       Self.figure.Add(Circle);
   end;

  end;

end;

procedure TTimeline.CheckAndDeleteIntersect;
var
 i,j:Integer;
begin
  i:=0;
  while (i<self.bullet.Count) do
   begin
     j:=0;
     while (j<self.figure.Count) do
      begin
        if TIntersectCheker.IsIntersect(
                                        self.bullet.Items[i],
                                        self.figure.Items[j])
                               then
           begin
             if Assigned(OnTargetDestroy) then
                OnTargetDestroy(self.figure.Items[j]);
             Self.bullet.Items[i].Free;
             Self.bullet.Delete(i);
             Dec(i);
             self.figure.Items[j].Free;
             self.figure.Delete(j);
             break;
           end else
            Inc(j);
      end;
      inc(i);
   end;


end;

procedure TTimeline.CleanOutRange;
var
i:integer;
begin
  //Clear old drawing
  i:=0;
  while(i<Self.figure.Count) do
    begin
     if Self.figure.Items[i].IsOutOfRange(Point(Self.Width,self.Heigth)) then
        begin
          if Assigned(Self.OnFault) then
             Self.OnFault(Self.figure.Items[i]);
          Self.figure.Items[i].Free;
          Self.figure.Delete(i);
         end  else
        Inc(i);
    end;
  //Clear old bullets
  i:=0;
  while(i<Self.bullet.Count) do
    begin
     if Self.bullet.Items[i].IsOutOfRange(Point(Self.Width,self.Heigth)) then
       begin
         if Assigned(Self.OnMiss) then
             Self.OnMiss(self.bullet.Items[i]);
         self.bullet.Items[i].Free;
         Self.bullet.Delete(i);
       end  else
        Inc(i);
    end;
end;

procedure TTimeline.ClearAllFigures;
var
i:integer;
begin
  //Clear old drawing
  for I := 0 to Self.figure.Count-1 do
   begin
     Self.figure.Items[i].Clear;
   end;

  //Clear old bullets
  for I := 0 to Self.bullet.Count-1 do
   begin
     Self.bullet.Items[i].Clear;
   end;

  self.gun.Clear;
end;

constructor TTimeline.Create(canvas: TCanvas; Width, Heigth:integer;BackClr:TColor);
begin
  fCanvas:=canvas;
  figure:=TList<TTimedFigure>.Create;
  bullet:=TList<TCircle>.Create;
  self.Width:=Width;
  self.Heigth:=Heigth;
  Self.BackColor:=BackClr;
  gun:=TGun.Create(Self.fCanvas,self.BackColor, Point(Trunc(self.Width/2-20),Self.Heigth-25),40,20, clBlack);
  gun.Step:=Point(2,0);
  gun.AngleStep:=1;
  Randomize;
end;

destructor TTimeline.Destroy;
var
 i:Integer;
begin
  if (figure<>nil) then
    begin
      for i := 0 to figure.Count-1 do
         figure.Items[i].Free;   // TInterfacedObject
      FreeAndNil(figure);
    end;
  if (bullet<>nil) then
    begin
      for i := 0 to bullet.Count-1 do
         bullet.Items[i].Free;
      FreeAndNil(bullet);
    end;
  if Self.gun<>nil then
     FreeAndNil(gun);
  inherited;
end;

procedure TTimeline.DoNextMove;
var
  i:integer;
begin
  for I := 0 to Self.figure.Count-1 do
   begin
     Self.figure.Items[i].DoNextStep;
   end;

  for I := 0 to Self.bullet.Count-1 do
   begin
     Self.bullet.Items[i].DoNextStep;
   end;
end;

procedure TTimeline.DoNextStep;
begin
  Self.AddNewFigures;
  self.gun.Draw;
  self.ClearAllFigures;
  self.DoNextMove;
  Self.CleanOutRange;
  self.CheckAndDeleteIntersect;
  self.DrawAll;
end;

procedure TTimeline.DrawAll;
var
i:integer;
begin
  //Clear old drawing
  for I := 0 to Self.figure.Count-1 do
   begin
     Self.figure.Items[i].Draw;
   end;

  //Clear old bullets
  for I := 0 to Self.bullet.Count-1 do
   begin
     Self.bullet.Items[i].Draw;
   end;

  self.gun.Draw;
end;

procedure TTimeline.Proceed(key: word);
begin
  if key=32 then
    self.bullet.Add(Self.gun.Fire) else
  if key=37 then
    self.gun.MoveLeft else
  if key=39 then
    self.gun.MoveRigth else
  if key=40 then
    Self.gun.TurnLeft else
  if key=38 then
    Self.gun.TurnRight else
  if key=13 then
    self.bullet.Add(Self.gun.Fire);
end;

procedure TTimeline.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
end;

procedure TTimeline.SetHeigth(const Value: Integer);
begin
  FHeigth := Value;
end;

procedure TTimeline.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

end.
