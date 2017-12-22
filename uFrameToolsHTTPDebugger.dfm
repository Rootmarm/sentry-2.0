object frmToolsHTTPDebugger: TfrmToolsHTTPDebugger
  Left = 0
  Top = 0
  Width = 574
  Height = 360
  TabOrder = 0
  DesignSize = (
    574
    360)
  object Label52: TLabel
    Left = 44
    Top = 315
    Width = 38
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Referer:'
  end
  object Label47: TLabel
    Left = 8
    Top = 339
    Width = 74
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Data To POST:'
  end
  object Panel25: TPanel
    Left = 0
    Top = 0
    Width = 574
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      574
      41)
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
    object Label40: TLabel
      Left = 80
      Top = 14
      Width = 21
      Height = 13
      Caption = 'Site:'
    end
    object cboSite: TComboBox
      Left = 104
      Top = 10
      Width = 454
      Height = 21
      AutoComplete = False
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
    end
  end
  object PageControl7: TPageControl
    Left = 0
    Top = 41
    Width = 574
    Height = 264
    Cursor = crHandPoint
    ActivePage = TabSheet22
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Style = tsFlatButtons
    TabOrder = 1
    object TabSheet22: TTabSheet
      Caption = 'Main'
      DesignSize = (
        566
        233)
      object lblByteCount: TLabel
        Left = 0
        Top = 220
        Width = 113
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Received Byte Count: 0'
      end
      object memDebug: TRichEdit
        Left = 0
        Top = 0
        Width = 566
        Height = 215
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        PlainText = True
        PopupMenu = mnuDebug
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet25: TTabSheet
      Caption = 'Page Viewer'
      ImageIndex = 2
      object WebBrowser: TWebBrowser
        Left = 0
        Top = 0
        Width = 566
        Height = 233
        Align = alClient
        TabOrder = 0
        ControlData = {
          4C0000007F3A0000151800000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E12620B000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object TabSheet23: TTabSheet
      Caption = 'Options'
      ImageIndex = 1
      object rgRequestMethod: TRadioGroup
        Left = 0
        Top = 0
        Width = 129
        Height = 89
        Caption = 'Request Method'
        ItemIndex = 1
        Items.Strings = (
          'HEAD'
          'GET'
          'POST')
        TabOrder = 0
        OnClick = rgRequestMethodClick
      end
      object GroupBox24: TGroupBox
        Left = 0
        Top = 96
        Width = 561
        Height = 137
        Caption = 'Advanced Settings'
        TabOrder = 1
        object Label41: TLabel
          Left = 42
          Top = 44
          Width = 56
          Height = 13
          Caption = 'User Agent:'
        end
        object Label48: TLabel
          Left = 62
          Top = 69
          Width = 36
          Height = 13
          Caption = 'Cookie:'
        end
        object Label50: TLabel
          Left = 424
          Top = 44
          Width = 49
          Height = 13
          Caption = 'Timeout in'
        end
        object Label51: TLabel
          Left = 511
          Top = 44
          Width = 42
          Height = 13
          Caption = 'Seconds'
        end
        object Label81: TLabel
          Left = 10
          Top = 92
          Width = 88
          Height = 13
          Caption = 'Accept Language:'
        end
        object Label45: TLabel
          Left = 48
          Top = 16
          Width = 51
          Height = 13
          Caption = 'Username:'
        end
        object Label46: TLabel
          Left = 200
          Top = 16
          Width = 49
          Height = 13
          Caption = 'Password:'
        end
        object txtUserAgent: TEdit
          Left = 104
          Top = 40
          Width = 305
          Height = 21
          TabOrder = 0
          Text = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)'
        end
        object txtCookie: TEdit
          Left = 104
          Top = 64
          Width = 449
          Height = 21
          TabOrder = 1
        end
        object txtTimeout: TEdit
          Left = 480
          Top = 38
          Width = 25
          Height = 21
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 2
          Text = '30'
        end
        object txtAcceptLanguage: TEdit
          Left = 104
          Top = 88
          Width = 449
          Height = 21
          TabOrder = 3
        end
        object chkCustomHeader: TCheckBox
          Left = 8
          Top = 114
          Width = 129
          Height = 17
          Hint = 'Use Custom Header (Experts Only)'
          Caption = 'Use A Custom Header'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = chkCustomHeaderClick
        end
        object txtUsername: TEdit
          Left = 104
          Top = 12
          Width = 81
          Height = 21
          TabOrder = 5
        end
        object txtPassword: TEdit
          Left = 256
          Top = 12
          Width = 81
          Height = 21
          TabOrder = 6
        end
        object chkRandom: TCheckBox
          Left = 368
          Top = 114
          Width = 185
          Height = 17
          Caption = 'Use A Random Proxy From My List'
          TabOrder = 7
        end
        object chkDisablePageViewer: TCheckBox
          Left = 188
          Top = 114
          Width = 129
          Height = 17
          Caption = 'Disable Page Viewer'
          TabOrder = 8
          OnClick = chkDisablePageViewerClick
        end
      end
      object GroupBox25: TGroupBox
        Left = 136
        Top = 0
        Width = 425
        Height = 89
        Caption = 'Proxy'
        TabOrder = 2
        object Label42: TLabel
          Left = 8
          Top = 44
          Width = 29
          Height = 13
          Caption = 'Proxy:'
        end
        object Label43: TLabel
          Left = 192
          Top = 44
          Width = 29
          Height = 13
          Caption = 'Proxy:'
        end
        object Label44: TLabel
          Left = 192
          Top = 68
          Width = 29
          Height = 13
          Caption = 'Level:'
        end
        object txtProxy: TEdit
          Left = 48
          Top = 40
          Width = 113
          Height = 21
          TabOrder = 0
        end
        object chkProxy: TCheckBox
          Left = 8
          Top = 20
          Width = 73
          Height = 17
          Caption = 'Use Proxy'
          TabOrder = 1
        end
        object chkSOCKS: TCheckBox
          Left = 192
          Top = 16
          Width = 105
          Height = 17
          Caption = 'Use SOCKS Proxy'
          TabOrder = 2
        end
        object txtSOCKS: TEdit
          Left = 232
          Top = 40
          Width = 113
          Height = 21
          TabOrder = 3
        end
        object txtSOCKSLevel: TEdit
          Left = 232
          Top = 64
          Width = 25
          Height = 21
          TabOrder = 4
          Text = '5'
        end
        object cmdRetrieve: TButton
          Left = 48
          Top = 66
          Width = 113
          Height = 17
          Caption = 'Retrieve From '
          TabOrder = 5
          OnClick = cmdRetrieveClick
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Custom Header'
      ImageIndex = 4
      TabVisible = False
      DesignSize = (
        566
        233)
      object Label1: TLabel
        Left = 136
        Top = 207
        Width = 297
        Height = 26
        AutoSize = False
        Caption = 
          'When using POST, do not include POST Data or Content Length in t' +
          'he Header.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object memHeader: TMemo
        Left = 2
        Top = 0
        Width = 561
        Height = 201
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object cmdBuild: TButton
        Left = 2
        Top = 207
        Width = 121
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Build Header'
        TabOrder = 1
        OnClick = cmdBuildClick
      end
      object cmdClear: TButton
        Left = 442
        Top = 207
        Width = 121
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Clear Header'
        TabOrder = 2
        OnClick = cmdClearClick
      end
    end
  end
  object txtPOSTData: TEdit
    Left = 88
    Top = 334
    Width = 409
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    Enabled = False
    TabOrder = 2
  end
  object txtReferer: TEdit
    Left = 88
    Top = 310
    Width = 409
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
  end
  object cmdReferer: TButton
    Left = 504
    Top = 312
    Width = 65
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Ref = Site'
    TabOrder = 4
    OnClick = cmdRefererClick
  end
  object mnuDebug: TPopupMenu
    Images = frmSentry.ilMenus
    Left = 216
    Top = 200
    object Clear1: TMenuItem
      Caption = 'Clear'
      ImageIndex = 9
      OnClick = Clear1Click
    end
  end
end
