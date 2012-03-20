object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Arkanoid 2'
  ClientHeight = 389
  ClientWidth = 599
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = mm1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object imgFull: TImage
    Left = 0
    Top = 0
    Width = 599
    Height = 370
    Align = alClient
    ExplicitLeft = 272
    ExplicitTop = 128
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object statMain: TStatusBar
    Left = 0
    Top = 370
    Width = 599
    Height = 19
    Panels = <
      item
        Text = 'Hit:'
        Width = 100
      end
      item
        Text = 'Miss:'
        Width = 100
      end
      item
        Text = 'Faults:'
        Width = 100
      end>
  end
  object mm1: TMainMenu
    Left = 536
    object N6: TMenuItem
      Action = actGameState
    end
    object N1: TMenuItem
      Caption = 'Select'
      object N3: TMenuItem
        Action = actRound
      end
      object N4: TMenuItem
        Action = actSquare
      end
      object N5: TMenuItem
        Action = actTriangle
      end
    end
    object N2: TMenuItem
      Action = actExit
    end
  end
  object alMain: TActionList
    Left = 568
    object actGameState: TAction
      Caption = 'Start'
      OnExecute = actGameStateExecute
    end
    object actTriangle: TAction
      Caption = 'Triangle'
    end
    object actSquare: TAction
      Caption = 'Square'
    end
    object actRound: TAction
      Caption = 'Round'
    end
    object actExit: TAction
      Caption = 'Exit'
    end
  end
  object tmrMain: TTimer
    Interval = 300
    OnTimer = tmrMainTimer
    Left = 504
    Top = 8
  end
end
