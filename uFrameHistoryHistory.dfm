object frmHistoryHistory: TfrmHistoryHistory
  Left = 0
  Top = 0
  Width = 574
  Height = 360
  TabOrder = 0
  object Panel14: TPanel
    Left = 0
    Top = 0
    Width = 574
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      574
      41)
    object lblBot: TLabel
      Left = 558
      Top = 8
      Width = 12
      Height = 24
      Alignment = taRightJustify
      Anchors = [akRight]
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cmdStart: TSpeedButton
      Left = 8
      Top = 8
      Width = 25
      Height = 25
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000CE0E00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000FFFF000000FF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF00000000FFFF000000FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000FFFF00
        FFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF00000000FFFF00FFFF000000FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7F7F7F00000000
        000000FFFF00FFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF00000000FFFF00FFFF00FFFF000000000000FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
        FFFF00FFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF00000000FFFF00FFFF00FFFF000000FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
        000000FFFF00FFFF00FFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      OnClick = cmdStartClick
    end
    object cmdAbort: TSpeedButton
      Left = 40
      Top = 8
      Width = 25
      Height = 25
      Enabled = False
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF84828400000000000000
        0000000000000000848284FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF0000000000840000FF0000FF0000FF0000FF0000FF000084000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF000000FF00FFFF00FFFF00FFFF00FF000000
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF000000FF00FFFF00FF8482840000840000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF000084848284FF00FF0000000000FF
        0000FF0000FFFFFFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFF0000FF0000
        FF0000FF000000FF00FF0000000000FF0000FF0000FF0000FFFFFFFFFFFFFF00
        00FFFFFFFFFFFFFF0000FF0000FF0000FF0000FF000000FF00FF0000000000FF
        0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000
        FF0000FF000000FF00FF0000000000FF0000FF0000FF0000FF0000FFFFFFFFFF
        FFFFFFFFFF0000FF0000FF0000FF0000FF0000FF000000FF00FF0000000000FF
        0000FF0000FF0000FFFFFFFFFFFFFF0000FFFFFFFFFFFFFF0000FF0000FF0000
        FF0000FF000000FF00FF8482840000840000FF0000FFFFFFFFFFFFFF0000FF00
        00FF0000FFFFFFFFFFFFFF0000FF0000FF000084848284FF00FFFF00FF000000
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF000000FF00FFFF00FFFF00FFFF00FF0000000000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF0000000000840000FF0000FF0000FF0000FF0000FF000084000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF84828400000000000000
        0000000000000000848284FF00FFFF00FFFF00FFFF00FFFF00FF}
      OnClick = cmdAbortClick
    end
    object sldBot: TTrackBar
      Left = 72
      Top = 10
      Width = 462
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Ctl3D = True
      Max = 100
      Min = 1
      ParentCtl3D = False
      Position = 1
      TabOrder = 0
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = sldBotChange
    end
  end
  object Panel1: TPanel
    Left = 422
    Top = 41
    Width = 152
    Height = 319
    Align = alRight
    BevelOuter = bvNone
    DragKind = dkDock
    DragMode = dmAutomatic
    TabOrder = 1
    DesignSize = (
      152
      319)
    object Label2: TLabel
      Left = -4
      Top = 8
      Width = 156
      Height = 17
      Alignment = taCenter
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Statistics'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 176
      Width = 45
      Height = 13
      Caption = 'Search:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 8
      Top = 216
      Width = 105
      Height = 13
      Caption = 'Search by Site'#39's name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = cl3DDkShadow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cmdSearch: TSpeedButton
      Left = 126
      Top = 192
      Width = 21
      Height = 21
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000CE0E0000D80E00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000
        000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000
        00000000000000FF00FF000000FFFFFF000000000000000000FF00FFFF00FFFF
        00FFFF00FFFF00FF000000FFFFFF000000000000000000FF00FF000000FFFFFF
        000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFF0000
        00000000000000FF00FF000000000000000000000000000000000000000000FF
        00FF000000000000000000000000000000000000000000FF00FF000000000000
        FFFFFF000000000000000000000000000000000000FFFFFF0000000000000000
        00000000000000FF00FF000000000000FFFFFF000000000000000000C0C0C000
        0000000000FFFFFF000000000000000000000000000000FF00FF000000000000
        FFFFFF000000000000000000C0C0C0000000000000FFFFFF0000000000000000
        00000000000000FF00FFFF00FF00000000000000000000000000000000000000
        0000000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FF
        000000FFFFFF000000000000000000FF00FF000000FFFFFF0000000000000000
        00FF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000FF
        00FF000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF000000000000000000FF00FFFF00FFFF00FF000000000000000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFF000000FF00FFFF
        00FFFF00FF000000FFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF000000000000000000FF00FFFF00FFFF00FF000000000000000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      OnClick = cmdSearchClick
    end
    object Panel4: TPanel
      Left = 6
      Top = 24
      Width = 137
      Height = 145
      Anchors = [akTop, akRight]
      BevelInner = bvLowered
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Label3: TLabel
        Left = 29
        Top = 121
        Width = 31
        Height = 14
        Caption = 'Count:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 28
        Top = 33
        Width = 20
        Height = 14
        Caption = 'Bad:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 28
        Top = 9
        Width = 27
        Height = 14
        Caption = 'Good:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object Shape1: TShape
        Left = 8
        Top = 110
        Width = 121
        Height = 1
      end
      object Image1: TImage
        Left = 8
        Top = 8
        Width = 16
        Height = 16
        AutoSize = True
        Picture.Data = {
          07544269746D617036030000424D360300000000000036000000280000001000
          000010000000010018000000000000030000CE0E0000D80E0000000000000000
          0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FF008000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008000008000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF008000008000008000008000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF008000008000008000008000008000FF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0080000080
          00008000FF00FF008000008000008000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FF008000008000008000FF00FFFF00FF008000008000008000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FF008000008000008000FF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008000
          008000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF008000008000008000FF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          008000008000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008000008000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF008000008000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008000FF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF008000FF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
          8000}
        Transparent = True
      end
      object Image2: TImage
        Left = 8
        Top = 32
        Width = 16
        Height = 16
        AutoSize = True
        Picture.Data = {
          07544269746D617036030000424D360300000000000036000000280000001000
          000010000000010018000000000000030000CE0E0000D80E0000000000000000
          0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF808080FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF808080FF00FFFF
          00FFFF00FFFF00FF0000FF808080808080FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF0000FF808080FF00FFFF00FFFF00FFFF00FF0000FF0000FF8080
          80808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF0000FF0000FF808080808080FF00FFFF00FFFF00FF
          FF00FF0000FF808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF0000
          FF0000FF808080FF00FFFF00FFFF00FF0000FF0000FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF0000FF0000FF8080808080800000FF0000FF
          0000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF0000FF0000FF0000FF0000FF0000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF8080800000FF0000FF0000FF0000FF808080
          808080808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8080800000FF0000
          FF0000FF0000FF0000FF0000FF0000FF0000FF808080808080808080FF00FFFF
          00FFFF00FF0000FF0000FF0000FF0000FF0000FFFF00FFFF00FF0000FF0000FF
          0000FF0000FF0000FF808080FF00FFFF00FFFF00FF0000FF0000FF0000FF0000
          FFFF00FFFF00FFFF00FFFF00FF0000FF0000FF0000FF0000FFFF00FFFF00FFFF
          00FFFF00FFFF00FF0000FF0000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          0000FF0000FF0000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF}
        Transparent = True
      end
      object Image3: TImage
        Left = 7
        Top = 119
        Width = 18
        Height = 18
        AutoSize = True
        Picture.Data = {
          07544269746D61704E010000424D4E0100000000000076000000280000001200
          0000120000000100040000000000D80000000000000000000000100000000000
          000000000000000080000080000000808000800000008000800080800000C0C0
          C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00777777777777777777000000777777777777777777000000777FFFFFFFFF
          FFFF77000000778444444444444F77000000777844444444444F770000007777
          84447888884F77000000777778444F777777770000007777778444F777777700
          000077777778444F777777000000777777778444F7777700000077777778444F
          7777770000007777778444F7777777000000777778444F777777770000007777
          8444FFFFFF4F77000000777844444444444F77000000778444444444444F7700
          0000778888888888888777000000777777777777777777000000}
        Transparent = True
      end
      object lblGood: TLabel
        Left = 120
        Top = 9
        Width = 6
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object lblBad: TLabel
        Left = 120
        Top = 33
        Width = 6
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object lblCount: TLabel
        Left = 120
        Top = 121
        Width = 6
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object Image6: TImage
        Left = 8
        Top = 80
        Width = 16
        Height = 16
        AutoSize = True
        Picture.Data = {
          07544269746D617036030000424D360300000000000036000000280000001000
          000010000000010018000000000000030000C40E0000C40E0000000000000000
          0000FF00FFFF00FFFF00FFFF00FFFF00FF808080000000848284848284848284
          000000808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000
          00848284848284000000000000000000848284848284000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF000000848284000000000000FFFFFFFFFFFFFFFFFF
          000000000000848284000000FF00FFFF00FFFF00FFFF00FF000000C6C3C60000
          00FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF000000848284000000FF
          00FFFF00FFFF00FF000000C6C3C6000000FFFFFF000000FFFFFFFFFFFFFFFFFF
          000000FFFFFF000000848284000000FF00FFFF00FF000000C6C3C6000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000084828400
          0000FF00FF000000C6C3C6000000FFFFFF000000FFFFFFFFFFFF000000FFFFFF
          FFFFFF000000FFFFFF000000848284000000FF00FF000000C6C3C6000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF00000084828400
          0000FF00FFFF00FF000000C6C3C6000000FFFFFF000000FFFFFFFFFFFFFFFFFF
          000000FFFFFF000000848284000000FF00FFFF00FFFF00FF000000C6C3C60000
          00FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF000000848284000000FF
          00FFFF00FFFF00FFFF00FF000000C6C3C6000000000000FFFFFFFFFFFFFFFFFF
          000000000000848284000000FF00FFFF00FFFF00FFFF00FF0000000000000000
          00C6C3C6C6C3C6000000000000000000C6C3C6C6C3C6000000000000000000FF
          00FFFF00FFFF00FF000000C6C3C6000000000000000000C6C3C6C6C3C6C6C3C6
          000000000000000000C6C3C6000000FF00FFFF00FFFF00FFFF00FF0000000000
          00FF00FFFF00FF000000000000000000FF00FFFF00FF000000000000FF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000
          000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF000000C6C3C6000000C6C3C6000000848284000000FF00FFFF00FFFF00FFFF
          00FF}
        Transparent = True
      end
      object Label10: TLabel
        Left = 28
        Top = 81
        Width = 43
        Height = 14
        Caption = 'Timeout:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object lblTimeout: TLabel
        Left = 120
        Top = 81
        Width = 6
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object Image5: TImage
        Left = 8
        Top = 56
        Width = 16
        Height = 16
        Picture.Data = {
          07544269746D617042020000424D420200000000000042000000280000001000
          000010000000010010000300000000020000120B0000120B0000000000000000
          0000007C0000E00300001F000000100210021002100210021002100210021002
          1002100210021002100210021002100210021002100210021002100210021002
          1002100210021002100210021002100210021002100210021002100210021002
          1002100210001000100010021002100210021000100210021002100210021002
          1002100210001000100210021002100210001000100010021002100010001000
          1002100210001002100010021002100010001000100010001002100010001002
          1002100210021002100210001002100210021000100210021002100010021000
          1002100210021002100210001002100210021000100210021002100210021002
          1000100210021002100210001002100210021000100210021002100210021002
          1002100010021002100210001002100210021000100210021002100210021002
          1002100010021002100210001002100210021000100210021002100210001000
          1000104210021002100210021002100210021000100210021002100210021002
          1002100210021002100210021002100210021042100010021002100210021002
          1002100210021002100210021002100210021002104210001000100210021002
          1002100210021002100210021002100210021002100210021002100210021002
          1002100210021002100210021002100210021002100210021002100210021002
          1002100210021002100210021002}
        Transparent = True
      end
      object Label9: TLabel
        Left = 28
        Top = 57
        Width = 41
        Height = 14
        Caption = 'Redirect:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object lblRedirect: TLabel
        Left = 120
        Top = 57
        Width = 6
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
    end
    object txtSearch: TEdit
      Left = 8
      Top = 192
      Width = 115
      Height = 21
      TabOrder = 1
      OnKeyDown = txtSearchKeyDown
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 422
    Height = 319
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      422
      319)
    object cmdSort: TSpeedButton
      Left = 389
      Top = 168
      Width = 25
      Height = 25
      Hint = 'Extended Sorting Options'
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FF00FFFF00FF
        000084000084000084000084000084000084FF00FFFF00FFFF00FFFF00FFFF00
        FF000000FF00FFFF00FFFF00FFFF00FF000084000084FF00FFFF00FFFF00FF00
        0084FF00FFFF00FFFF00FFFF00FF848284000000848284FF00FFFF00FFFF00FF
        FF00FF000084000084FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000
        00000000000000FF00FFFF00FFFF00FFFF00FFFF00FF000084000084FF00FFFF
        00FFFF00FFFF00FFFF00FF848284000000000000000000848284FF00FFFF00FF
        FF00FFFF00FFFF00FF000084000084FF00FFFF00FFFF00FFFF00FF0000000000
        00000000000000000000FF00FFFF00FF000084FF00FFFF00FFFF00FF00008400
        0084FF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF
        000084000084000084000084000084000084FF00FFFF00FFFF00FFFF00FFFF00
        FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF
        840000840000840000FF00FF840000840000840000FF00FFFF00FFFF00FFFF00
        FF000000FF00FFFF00FFFF00FFFF00FF848284840000FF00FFFF00FFFF00FF84
        0000848284FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF
        FF00FF840000840000840000840000840000FF00FFFF00FFFF00FFFF00FFFF00
        FF000000FF00FFFF00FFFF00FFFF00FFFF00FF848284840000FF00FF84000084
        8284FF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF840000840000840000FF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF848284840000848284FF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF840000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentShowHint = False
      ShowHint = True
      OnClick = cmdSortClick
    end
    object cmdPaste: TSpeedButton
      Left = 389
      Top = 132
      Width = 25
      Height = 25
      Hint = 'Paste Sites from Clipboard'
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000CE0E0000D80E00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF80000080
        0000800000800000800000800000800000800000800000800000FF00FF000000
        000000000000000000000000800000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF800000000000808080008080808080008080808080800000FF
        FFFF800000800000800000800000800000800000FFFFFF800000000000008080
        808080008080808080008080800000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF800000000000808080008080808080008080808080800000FF
        FFFF800000800000800000FFFFFF800000800000800000800000000000008080
        808080008080808080008080800000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8000
        00FFFFFF800000FF00FF000000808080008080808080008080808080800000FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF800000800000FF00FFFF00FF000000008080
        8080800080808080800080808000008000008000008000008000008000008000
        00000000FF00FFFF00FF00000080808000808080808000808080808000808080
        8080008080808080008080808080008080000000FF00FFFF00FF000000008080
        8080800000000000000000000000000000000000000000000000008080808080
        80000000FF00FFFF00FF000000808080808080000000C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0000000808080008080000000FF00FFFF00FF000000008080
        80808000808000000000FFFF00000000000000FFFF0000008080800080808080
        80000000FF00FFFF00FFFF00FF00000000000000000000000000000000FFFF00
        FFFF000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF000000000000000000000000FF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentShowHint = False
      ShowHint = True
      OnClick = cmdPasteClick
    end
    object cmdClean: TSpeedButton
      Left = 389
      Top = 96
      Width = 25
      Height = 25
      Hint = 'Cleaning Options'
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E0000000000000000000000FFFFFFFFFF
        00FFFFFFFFFF00FFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00FFFFFFFFFFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFF00
        FFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF000000FFFFFF848284FFFFFF00FFFFFFFFFF000000FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFF848284FFFFFFC6
        C3C684828400FFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        000000FFFFFF848284FFFFFFC6C3C684828400FFFFFFFFFF00FFFF8482840000
        00FF00FFFF00FFFF00FFFF00FF000000FFFFFF848284FFFFFFC6C3C684828400
        FFFFFFFFFF00FFFF848284C6C3C6C6C3C6000000FF00FFFF00FF000000000000
        000000FFFFFFC6C3C684828400FFFFFFFFFF00FFFF848284C6C3C6C6C3C6C6C3
        C6000000FF00FFFF00FFFF00FFFF00FFFF00FF00000000000000FFFFFFFFFF00
        FFFF848284C6C3C6C6C3C6C6C3C6000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF00000000FFFF848284C6C3C6C6C3C6C6C3C68482848400
        00000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000C6
        C3C6C6C3C6C6C3C6000000840000840000840000000000FF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00FF0000008400
        00840000840000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FF000000840000840000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentShowHint = False
      ShowHint = True
      OnClick = cmdCleanClick
    end
    object cmdSave: TSpeedButton
      Left = 389
      Top = 60
      Width = 25
      Height = 25
      Hint = 
        'Save Selected Sites. All Saving of History uses the Save Filter ' +
        'in Options'
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000CE0E0000D80E00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000
        0000000000000000000000000000000000000000000000FF00FFFF00FF000000
        008080008080000000000000000000000000000000000000C0C0C0C0C0C00000
        00008080000000FF00FFFF00FF00000000808000808000000000000000000000
        0000000000000000C0C0C0C0C0C0000000008080000000FF00FFFF00FF000000
        008080008080000000000000000000000000000000000000C0C0C0C0C0C00000
        00008080000000FF00FFFF00FF00000000808000808000000000000000000000
        0000000000000000000000000000000000008080000000FF00FFFF00FF000000
        0080800080800080800080800080800080800080800080800080800080800080
        80008080000000FF00FFFF00FF00000000808000808000000000000000000000
        0000000000000000000000000000008080008080000000FF00FFFF00FF000000
        008080000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000
        00008080000000FF00FFFF00FF000000008080000000C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000008080000000FF00FFFF00FF000000
        008080000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000
        00008080000000FF00FFFF00FF000000008080000000C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000008080000000FF00FFFF00FF000000
        008080000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000
        00000000000000FF00FFFF00FF000000008080000000C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0C0000000FF00FFFF00FF000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentShowHint = False
      ShowHint = True
      OnClick = cmdSaveClick
    end
    object cmdOpen: TSpeedButton
      Left = 388
      Top = 24
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000CE0E0000D80E00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000
        000000000000000000000000000000000000000000000000000000FF00FFFF00
        FFFF00FFFF00FFFF00FF00000000000000808000808000808000808000808000
        8080008080008080008080000000FF00FFFF00FFFF00FFFF00FF00000000FFFF
        0000000080800080800080800080800080800080800080800080800080800000
        00FF00FFFF00FFFF00FF000000FFFFFF00FFFF00000000808000808000808000
        8080008080008080008080008080008080000000FF00FFFF00FF00000000FFFF
        FFFFFF00FFFF0000000080800080800080800080800080800080800080800080
        80008080000000FF00FF000000FFFFFF00FFFFFFFFFF00FFFF00000000000000
        000000000000000000000000000000000000000000000000000000000000FFFF
        FFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFF000000FF00FFFF00
        FFFF00FFFF00FFFF00FF000000FFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF
        FFFF00FFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FF00000000FFFF
        FFFFFF00FFFF000000000000000000000000000000000000000000FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FF000000FF00FFFF00FFFF00FF000000FF00FF000000FF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      OnClick = cmdOpenClick
    end
    object Label7: TLabel
      Left = 8
      Top = 8
      Width = 397
      Height = 17
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'History Verifier'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold, fsUnderline]
      ParentColor = False
      ParentFont = False
    end
    object lstCHistory: TListView
      Left = 8
      Top = 24
      Width = 373
      Height = 288
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Site'
          MinWidth = 275
          Width = 275
        end
        item
          Caption = 'Proxy Used'
          Width = 120
        end
        item
          Caption = 'Status'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Failure Keywords'
          Width = 120
        end
        item
          Caption = 'Success Keywords'
          Width = 120
        end
        item
          Caption = 'Form Action'
          Width = 120
        end
        item
          Caption = 'POST Data'
          Width = 120
        end
        item
          Caption = 'Rq Method'
          Width = 75
        end
        item
          Caption = 'Wordlist'
          Width = 100
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      GridLines = True
      HideSelection = False
      MultiSelect = True
      OwnerData = True
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      PopupMenu = mnulstHistory
      SmallImages = frmSentry.ilListViews
      TabOrder = 0
      ViewStyle = vsReport
      OnColumnClick = lstCHistoryColumnClick
      OnData = lstCHistoryData
      OnDblClick = lstCHistoryDblClick
      OnKeyDown = lstCHistoryKeyDown
    end
  end
  object mnuClean: TPopupMenu
    Left = 376
    Top = 328
    object DeleteBad1: TMenuItem
      Caption = 'Delete Bad'
      OnClick = DeleteBad1Click
    end
    object DeleteRedirects1: TMenuItem
      Caption = 'Delete Redirects'
      OnClick = DeleteRedirects1Click
    end
    object DeleteTimeouts1: TMenuItem
      Caption = 'Delete Timeouts'
      OnClick = DeleteTimeouts1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object RemoveDuplicates1: TMenuItem
      Caption = 'Remove Duplicates'
      OnClick = RemoveDuplicates1Click
    end
  end
  object mnuSort: TPopupMenu
    Left = 329
    Top = 328
    object SortUsingSiteName1: TMenuItem
      Caption = 'Sort By Site Name'
      OnClick = SortUsingSiteName1Click
    end
    object SortUsingLogin1: TMenuItem
      Caption = 'Sort By Username'
      OnClick = SortUsingLogin1Click
    end
    object SortByPassword1: TMenuItem
      Caption = 'Sort By Password'
      OnClick = SortByPassword1Click
    end
    object SortByImage1: TMenuItem
      Caption = 'Sort By Image'
      OnClick = SortByImage1Click
    end
  end
  object mnulstHistory: TPopupMenu
    Images = frmSentry.ilMenus
    Left = 240
    Top = 328
    object AddEntry1: TMenuItem
      Caption = 'Add Entry'
      ImageIndex = 7
      OnClick = AddEntry1Click
    end
    object DeleteSelected3: TMenuItem
      Caption = 'Delete Selected'
      ImageIndex = 0
      OnClick = DeleteSelected3Click
    end
    object ClearList1: TMenuItem
      Caption = 'Clear List'
      ImageIndex = 9
      OnClick = ClearList1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object EditURL1: TMenuItem
      Caption = 'Edit URL'
      ImageIndex = 5
      OnClick = EditURL1Click
    end
    object EditProxyUsed1: TMenuItem
      Caption = 'Edit Proxy Used'
      ImageIndex = 5
      OnClick = EditProxyUsed1Click
    end
    object EditFailureKeywords1: TMenuItem
      Caption = 'Edit Failure Keywords'
      ImageIndex = 5
      OnClick = EditFailureKeywords1Click
    end
    object EditSuccessKeywords1: TMenuItem
      Caption = 'Edit Success Keywords'
      ImageIndex = 5
      OnClick = EditSuccessKeywords1Click
    end
    object EditFormAction1: TMenuItem
      Caption = 'Edit Form Action'
      ImageIndex = 5
      OnClick = EditFormAction1Click
    end
    object EditPOSTData1: TMenuItem
      Caption = 'Edit POST Data'
      ImageIndex = 5
      OnClick = EditPOSTData1Click
    end
    object EditRequestMethod1: TMenuItem
      Caption = 'Edit Request Method'
      ImageIndex = 5
      OnClick = EditRequestMethod1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuProxy: TMenuItem
      Caption = 'Use Proxy in '
      ImageIndex = 4
      OnClick = mnuProxyClick
    end
    object N18: TMenuItem
      Caption = '-'
    end
    object CopySelectedURLsToClipboard1: TMenuItem
      Caption = 'Copy Selected URLs To Clipboard'
      ImageIndex = 6
      OnClick = CopySelectedURLsToClipboard1Click
    end
    object CopySelectedCombosToClipboard1: TMenuItem
      Caption = 'Copy Selected Combos To Clipboard'
      ImageIndex = 6
      OnClick = CopySelectedCombosToClipboard1Click
    end
    object CopySelectedProxiesToClipboard1: TMenuItem
      Caption = 'Copy Selected Proxies To Clipboard'
      ImageIndex = 6
      OnClick = CopySelectedProxiesToClipboard1Click
    end
    object LaunchinBrowser1: TMenuItem
      Caption = 'Launch In Browser'
      ImageIndex = 3
      OnClick = LaunchinBrowser1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object OpenList1: TMenuItem
      Caption = 'Open History List'
      ImageIndex = 1
      OnClick = OpenList1Click
    end
    object SaveHistory1: TMenuItem
      Caption = 'Save Selected Sites'
      ImageIndex = 2
      OnClick = SaveHistory1Click
    end
  end
end
