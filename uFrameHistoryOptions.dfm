object frmHistoryOptions: TfrmHistoryOptions
  Left = 0
  Top = 0
  Width = 574
  Height = 360
  TabOrder = 0
  DesignSize = (
    574
    360)
  object Label1: TLabel
    Left = 8
    Top = 128
    Width = 52
    Height = 19
    Caption = 'Options'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 88
    Top = 26
    Width = 473
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Label2: TLabel
    Left = 8
    Top = 16
    Width = 73
    Height = 19
    Caption = 'Save Filter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cmdSaveHelp: TSpeedButton
    Left = 540
    Top = 48
    Width = 21
    Height = 21
    Hint = 'Displays List of Variables to use with the Save Filter'
    Anchors = [akTop, akRight]
    Flat = True
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000CE0E0000D80E00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
      0000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF00000000FFFF00FFFF000000000000FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
      FFFF00FFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
      FFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF00000000FFFF000000000000FF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
      FFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF00000000FFFF00FFFF000000000000FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FF00
      000000FFFF00FFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF00000000FFFF000000000000FF00FF00000000FFFF00FFFF0000000000
      00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000FFFF000000000000FF
      00FFFF00FF00000000FFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF00000000FFFF00FFFF00000000000000000000FFFF00FFFF0000000000
      00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000FFFF00FFFF00
      FFFF00FFFF00FFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF000000000000000000000000000000000000FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    ParentShowHint = False
    ShowHint = True
    OnClick = cmdSaveHelpClick
  end
  object Label98: TLabel
    Left = 8
    Top = 74
    Width = 330
    Height = 13
    Caption = 
      'Use the Save Filter to define how Sentry should save your Histor' +
      'y File.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = cl3DDkShadow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Bevel2: TBevel
    Left = 72
    Top = 138
    Width = 489
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Label97: TLabel
    Left = 8
    Top = 259
    Width = 280
    Height = 13
    Caption = 
      'If proxy field is empty, one will be assigned to it from My List' +
      '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = cl3DDkShadow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label36: TLabel
    Left = 8
    Top = 296
    Width = 73
    Height = 13
    Caption = 'Bots Timeout in'
  end
  object Label39: TLabel
    Left = 119
    Top = 296
    Width = 42
    Height = 13
    Caption = 'Seconds'
  end
  object Label4: TLabel
    Left = 320
    Top = 200
    Width = 241
    Height = 33
    AutoSize = False
    Caption = 
      'Default Request Method for sites loaded from a file or the clipb' +
      'oard.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = cl3DDkShadow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Bevel3: TBevel
    Left = 320
    Top = 272
    Width = 241
    Height = 2
  end
  object cboSaveFilter: TComboBox
    Left = 8
    Top = 48
    Width = 529
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    Text = '<PROTO><U>:<P>@<SITE>'
  end
  object chkSameProxy: TCheckBox
    Left = 8
    Top = 242
    Width = 249
    Height = 17
    Hint = 
      'Proxies behaviors are very sporadic, you can lose some valid log' +
      'ins when doing this'
    Caption = 'Check History Using The Proxy Which Found It'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object chkAppendHistory: TCheckBox
    Left = 320
    Top = 242
    Width = 233
    Height = 17
    Caption = 'Append Saved History To File When Saving'
    TabOrder = 2
  end
  object txtTimeout: TEdit
    Left = 88
    Top = 292
    Width = 25
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 3
    Text = '10'
  end
  object chkAfterFP: TCheckBox
    Left = 8
    Top = 160
    Width = 153
    Height = 17
    Hint = 
      'When a 200 is found, the combo is swapped out of the bot and a r' +
      'andomly'#13#10'generated combo is put in its place.  If this combo ret' +
      'urns a 200, then the proxy'#13#10'is banned and the login is considere' +
      'd a fake.'
    Caption = 'Enable After Fingerprinting'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 4
  end
  object chkCheckHits: TCheckBox
    Left = 8
    Top = 201
    Width = 177
    Height = 17
    Hint = 
      'If a 200 is found, the proxy is rotated out and another is used.' +
      '  If that second'#13#10'proxy gives a 200 response, the login is consi' +
      'dered a hit.  If a 401 results from'#13#10'the second try, then the fi' +
      'rst proxy is banned and the login is a fake.'
    Caption = 'Check Hits Using Another Proxy'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object rgRequestMethod: TRadioGroup
    Left = 320
    Top = 148
    Width = 241
    Height = 49
    Anchors = [akTop, akRight]
    Caption = 'Request Method For Loaded Sites'
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'HEAD'
      'GET'
      'POST')
    TabOrder = 6
  end
  object chkFloatDialog: TCheckBox
    Left = 320
    Top = 288
    Width = 161
    Height = 17
    Caption = 'Float History Statistics Dialog'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object chkSavePosition: TCheckBox
    Left = 320
    Top = 312
    Width = 137
    Height = 17
    Hint = 'Save Statistics Dialog Window Position'
    Caption = 'Save Window Position'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 8
  end
end
