object frmPOSTWizard: TfrmPOSTWizard
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'POST Request Wizard'
  ClientHeight = 351
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 38
    Top = 14
    Width = 59
    Height = 13
    Caption = 'Form Action:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 21
    Top = 46
    Width = 76
    Height = 13
    Caption = 'Username Field:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 23
    Top = 78
    Width = 74
    Height = 13
    Caption = 'Password Field:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 22
    Top = 110
    Width = 75
    Height = 13
    Caption = 'Additional Data:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 61
    Top = 142
    Width = 36
    Height = 13
    Caption = 'Cookie:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 8
    Top = 170
    Width = 505
    Height = 2
  end
  object Label1: TLabel
    Left = 5
    Top = 238
    Width = 130
    Height = 13
    Caption = 'Cookie (To Get Form Data):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 6
    Top = 206
    Width = 132
    Height = 13
    Caption = 'Referer (To Get Form Data):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 178
    Width = 505
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'Optional Fields'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 8
    Top = 290
    Width = 505
    Height = 2
  end
  object cmdAnalyze: TButton
    Left = 8
    Top = 302
    Width = 89
    Height = 41
    Caption = 'Analyze'
    TabOrder = 8
    OnClick = cmdAnalyzeClick
  end
  object cmdClear: TButton
    Left = 424
    Top = 302
    Width = 89
    Height = 41
    Caption = 'Clear'
    TabOrder = 9
    OnClick = cmdClearClick
  end
  object cmdUse: TButton
    Left = 215
    Top = 302
    Width = 89
    Height = 41
    Caption = 'Use Data'
    ModalResult = 1
    TabOrder = 10
  end
  object txtAction: TEdit
    Left = 104
    Top = 8
    Width = 409
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object txtUsername: TEdit
    Left = 104
    Top = 40
    Width = 409
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object txtPassword: TEdit
    Left = 104
    Top = 72
    Width = 409
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object txtAddData: TEdit
    Left = 104
    Top = 104
    Width = 409
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object txtCookie: TEdit
    Left = 104
    Top = 136
    Width = 409
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object chkRefreshSession: TCheckBox
    Left = 144
    Top = 264
    Width = 129
    Height = 17
    Hint = 
      'Use this option to have Sentry retrieve the Form Login page on e' +
      'very attempt'#13#10'to gather fresh Form and Cookie Data.'
    Caption = 'Refresh Session Data'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
  end
  object txtFormCookie: TEdit
    Left = 144
    Top = 232
    Width = 368
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object txtFormReferer: TEdit
    Left = 144
    Top = 200
    Width = 368
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
end
