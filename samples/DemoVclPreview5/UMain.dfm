object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'OpenCV 5 VCL Preview'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Image1: TImage
    Left = 8
    Top = 48
    Width = 608
    Height = 385
    Proportional = True
    Stretch = True
  end
  object BtnLoad: TButton
    Left = 8
    Top = 8
    Width = 120
    Height = 33
    Caption = 'Load image...'
    TabOrder = 0
    OnClick = BtnLoadClick
  end
  object OpenDialog1: TOpenDialog
    Left = 560
    Top = 8
  end
end
