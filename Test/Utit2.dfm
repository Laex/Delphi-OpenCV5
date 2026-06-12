object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 393
  ClientWidth = 606
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object cvwvcl1: TcvViewVcl
    Left = 160
    Top = 40
    Width = 433
    Height = 337
    Source = cvpln1
    EmptyText = 'No Signal'
  end
  object btn1: TButton
    Left = 48
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Camera'
    TabOrder = 1
    OnClick = btn1Click
  end
  object chkUseInputB: TCheckBox
    Left = 48
    Top = 224
    Width = 97
    Height = 17
    Caption = 'Input B (blur)'
    TabOrder = 2
  end
  object chkStrictMode: TCheckBox
    Left = 48
    Top = 248
    Width = 97
    Height = 17
    Caption = 'Strict mode'
    TabOrder = 3
  end
  object cvcmr1: TcvCamera
    Left = 80
    Top = 56
  end
  object cvpln1: TcvPipeline
    Enabled = True
    Source = cvcmr1
    Preset = ppContours
    Stages = <
      item
      end
      item
        StageType = stContours
      end>
    Left = 56
    Top = 304
  end
end
