unit intersectchecker;

interface
uses
 base_classes, System.SysUtils, System.Math;

type
 TIntersectCheker = class
   class function IsIntersect(firstFigure:TFigure;secondFigure:TFigure):Boolean;
 end;
implementation

{ TIntersectCheker }

uses circles, squares, triangles,System.Types;

//TODO: Create unit test for this fucntion for all possible situations
class function TIntersectCheker.IsIntersect(firstFigure: TFigure;
  secondFigure:TFigure): Boolean;
var
 first:TCircle;
 sci:TCircle;
 ssq:TSquare;
 str:TTriangle;
 ordered_x1, ordered_x2:TPoint;
begin
  //TODO: write code for intersect checking
  if not (firstFigure is TCircle)  then
    begin
      raise Exception.Create('not supported yet');
    end else
     first:=firstFigure as TCircle;

  if secondFigure is TCircle then
    begin
      sci:=secondFigure as TCircle;
      // distance between center of the circles biger or equal to radius sum
      result:=Sqrt(Sqr(first.center.x-sci.center.X)+sqr(first.center.Y-sci.center.Y))<=
             (first.radius+sci.radius);
    end else
  if secondFigure is TSquare then
    begin
      ssq:=secondFigure as TSquare;
      // Check if circle center in radius border on square
      // It's fast, but not always working algotithm
      if ((ssq.Vertex.X-first.radius)<=first.center.X) and
          ((ssq.Vertex.X+ssq.Width+first.radius)>=first.center.X) and
         ((ssq.Vertex.Y-first.radius)<=first.center.Y) and
         ((ssq.Vertex.Y+ssq.Height+first.radius)>=first.center.Y) then
         result:=True else
         result:=false;
    end else
  if secondFigure is TTriangle then
    begin
      str:=secondFigure as TTriangle;
      // It's fast, but not always working algotithm
      // here we assume, that if circle took square
      // we think, that they are intersect
      if str.Vertex1.X<str.Vertex2.X then
         begin
           ordered_x1:=str.Vertex1;
           ordered_x2:=str.Vertex2;
         end else
         begin
           ordered_x1.X:=str.Vertex2.X;
           ordered_x1.Y:=str.Vertex1.Y;
           ordered_x2.X:=str.Vertex1.X;
           ordered_x2.Y:=str.Vertex2.Y;

         end;

      if ((ordered_x1.X-first.radius)<=first.center.X) and
          ((ordered_x2.X+first.radius)>=first.center.X) and
         ((ordered_x1.Y-first.radius)<=first.center.Y) and
         ((ordered_x2.Y+first.radius)>=first.center.Y) then
          result:=True else
         result:=false;


    end else
      raise Exception.Create('not supported yet. Class: '+secondFigure.ClassName);
end;

end.
