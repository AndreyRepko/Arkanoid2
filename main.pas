unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, Vcl.Menus, timeline,
  Vcl.ExtCtrls, Vcl.ComCtrls, base_classes, Winapi.OpenGL;

type
  TForm2 = class(TForm)
    mm1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    alMain: TActionList;
    actGameState: TAction;
    actTriangle: TAction;
    actSquare: TAction;
    actRound: TAction;
    actExit: TAction;
    imgFull: TImage;
    tmrMain: TTimer;
    statMain: TStatusBar;
    procedure actGameStateExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrMainTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    faults,miss,hit:Integer;
    hrc : HGLRC ;{ ссылка на контекст воспроизведения}
    procedure OnFault(obj:TFigure);
    procedure OnMiss(obj:TFigure);
    procedure OnHit(obj:TFigure);
  public
    { Public declarations }
    mainLine:TTimeline;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

{+++ Формат пикселя +++}
procedure SetDCPixelFormat ( hdc : HDC );
var
pfd : TPixelFormatDescriptor;
nPixelFormat : Integer;
begin
  FillChar (pfd, SizeOf (pfd), 0);
  nPixelFormat := ChoosePixelFormat (hdc, @pfd);
  SetPixelFormat (hdc, nPixelFormat, @pfd);
end;
{--- Формат пикселя ---}

procedure TForm2.actGameStateExecute(Sender: TObject);
begin
  if mainLine=nil then
   begin
     faults:=0;
     miss:=0;
     hit:=0;
     imgFull.Canvas.Brush.Color:=clBtnFace;
     imgFull.Canvas.FillRect(Bounds(0,0,imgFull.Width,imgFull.Height));
     mainLine:=TTimeline.Create(imgFull.Canvas,imgFull.Width,imgFull.Height,clBtnFace);
     mainLine.OnTargetDestroy:=self.OnHit;
     mainLine.OnMiss:=self.OnMiss;
     mainLine.OnFault:=Self.OnFault;
     tmrMain.Enabled:=True;
     actGameState.Caption:='Start';
   end else
   begin
     tmrMain.Enabled:=false;
     FreeAndNil(mainLine);
     actGameState.Caption:='Stop';
   end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if mainLine<>nil then
   begin
     tmrMain.Enabled:=false;
     FreeAndNil(mainLine);
   end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
SetDCPixelFormat( imgFull.Canvas.Handle );
hrc := wglCreateContext ( imgFull.Canvas.Handle );
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  wglDeleteContext(hrc);
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if mainLine<>nil then
    begin
      mainLine.Proceed(Key);
    end;

end;

procedure TForm2.FormPaint(Sender: TObject);
var
 err:cardinal;
begin
  if not wglMakeCurrent ( imgFull.Canvas.Handle , hrc ) then
   begin
     err:=GetLastError;
     raise Exception.Create('WTF?'+IntToStr(err));
   end;
  glClearColor ( 1 , 1 , 1 , 1.0 ); { цвет фона }
  glClear ( GL_COLOR_BUFFER_BIT ); { очистка буфера цвета }
  wglMakeCurrent ( 0 , 0 );
end;

procedure TForm2.OnFault(obj: TFigure);
begin
  Inc(self.faults);
  self.statMain.Panels[2].Text:='Faults:'+IntToStr(faults);
end;

procedure TForm2.OnHit(obj: TFigure);
begin
  Inc(self.hit);
  self.statMain.Panels[0].Text:='Hit:'+IntToStr(hit);
end;

procedure TForm2.OnMiss(obj: TFigure);
begin
  Inc(self.miss);
  self.statMain.Panels[1].Text:='Miss:'+IntToStr(miss);

end;

procedure TForm2.tmrMainTimer(Sender: TObject);
begin
  if mainLine<>nil then
   begin
     mainLine.DoNextStep;
   end;
end;

end.
