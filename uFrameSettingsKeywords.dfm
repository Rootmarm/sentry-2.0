object frmSettingsKeywords: TfrmSettingsKeywords
  Left = 0
  Top = 0
  Width = 574
  Height = 360
  TabOrder = 0
  DesignSize = (
    574
    360)
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 139
    Height = 19
    Caption = 'Header Key Phrases'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 160
    Top = 18
    Width = 400
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Label1: TLabel
    Left = 8
    Top = 136
    Width = 135
    Height = 19
    Caption = 'Source Key Phrases'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 160
    Top = 146
    Width = 400
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Label3: TLabel
    Left = 8
    Top = 264
    Width = 183
    Height = 19
    Anchors = [akLeft, akBottom]
    Caption = 'Global Source Key Phrases'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel3: TBevel
    Left = 200
    Top = 274
    Width = 360
    Height = 2
    Anchors = [akLeft, akBottom]
  end
  object Label4: TLabel
    Left = 8
    Top = 312
    Width = 145
    Height = 41
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Global Key Phrases apply to all sites if enabled.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = cl3DDkShadow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object chkHeaderFailure: TCheckBox
    Left = 8
    Top = 36
    Width = 145
    Height = 17
    Caption = 'Define Failure Key Phrase'
    TabOrder = 0
  end
  object lstHeaderFailure: TListBox
    Left = 8
    Top = 56
    Width = 177
    Height = 73
    Anchors = [akLeft, akTop, akRight]
    Color = 12566527
    Ctl3D = False
    ItemHeight = 13
    MultiSelect = True
    ParentCtl3D = False
    PopupMenu = mnuKeywords
    TabOrder = 1
    OnKeyDown = lstHeaderFailureKeyDown
  end
  object chkHeaderSuccess: TCheckBox
    Left = 194
    Top = 36
    Width = 153
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Define Success Key Phrase'
    TabOrder = 2
  end
  object lstHeaderSuccess: TListBox
    Left = 194
    Top = 56
    Width = 178
    Height = 73
    Anchors = [akTop, akRight]
    Color = clMoneyGreen
    Ctl3D = False
    ItemHeight = 13
    MultiSelect = True
    ParentCtl3D = False
    PopupMenu = mnuKeywords
    TabOrder = 3
    OnKeyDown = lstHeaderFailureKeyDown
  end
  object chkSourceFailure: TCheckBox
    Left = 8
    Top = 162
    Width = 145
    Height = 17
    Caption = 'Define Failure Key Phrase'
    TabOrder = 4
  end
  object lstSourceFailure: TListBox
    Left = 8
    Top = 182
    Width = 177
    Height = 73
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 12566527
    Ctl3D = False
    ItemHeight = 13
    MultiSelect = True
    ParentCtl3D = False
    PopupMenu = mnuKeywords
    TabOrder = 5
    OnKeyDown = lstHeaderFailureKeyDown
  end
  object lstSourceSuccess: TListBox
    Left = 194
    Top = 182
    Width = 178
    Height = 73
    Anchors = [akTop, akRight, akBottom]
    Color = clMoneyGreen
    Ctl3D = False
    ItemHeight = 13
    MultiSelect = True
    ParentCtl3D = False
    PopupMenu = mnuKeywords
    TabOrder = 6
    OnKeyDown = lstHeaderFailureKeyDown
  end
  object chkSourceSuccess: TCheckBox
    Left = 194
    Top = 162
    Width = 153
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Define Success Key Phrase'
    TabOrder = 7
  end
  object chkGlobalFailure: TCheckBox
    Left = 8
    Top = 290
    Width = 145
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Define Failure Key Phrase'
    TabOrder = 8
  end
  object lstGlobalFailure: TListBox
    Left = 160
    Top = 284
    Width = 401
    Height = 73
    Anchors = [akLeft, akRight, akBottom]
    Color = clSkyBlue
    Ctl3D = False
    ItemHeight = 13
    MultiSelect = True
    ParentCtl3D = False
    PopupMenu = mnuKeywords
    TabOrder = 9
    OnKeyDown = lstHeaderFailureKeyDown
  end
  object lstHeaderRetry: TListBox
    Left = 381
    Top = 56
    Width = 179
    Height = 73
    Anchors = [akTop, akRight]
    Color = 12123900
    Ctl3D = False
    ItemHeight = 13
    MultiSelect = True
    ParentCtl3D = False
    PopupMenu = mnuKeywords
    TabOrder = 10
    OnKeyDown = lstHeaderFailureKeyDown
  end
  object chkHeaderRetry: TCheckBox
    Left = 381
    Top = 36
    Width = 140
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Define Retry Key Phrase'
    TabOrder = 11
  end
  object lstSourceBan: TListBox
    Left = 381
    Top = 182
    Width = 179
    Height = 73
    Anchors = [akTop, akRight, akBottom]
    Color = 14464213
    Ctl3D = False
    ItemHeight = 13
    MultiSelect = True
    ParentCtl3D = False
    PopupMenu = mnuKeywords
    TabOrder = 12
    OnKeyDown = lstHeaderFailureKeyDown
  end
  object chkSourceBan: TCheckBox
    Left = 381
    Top = 162
    Width = 132
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Define Ban Key Phrase'
    TabOrder = 13
  end
  object mnuKeywords: TPopupMenu
    Images = frmSentry.ilMenus
    Left = 128
    Top = 88
    object Add1: TMenuItem
      Caption = 'Add'
      ImageIndex = 7
      OnClick = Add1Click
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      ImageIndex = 5
      OnClick = Edit1Click
    end
    object DeleteSelected1: TMenuItem
      Caption = 'Delete Selected'
      ImageIndex = 0
      OnClick = DeleteSelected1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object OpenListofKeyPhrases1: TMenuItem
      Caption = 'Open List of Key Phrases'
      ImageIndex = 1
      OnClick = OpenListofKeyPhrases1Click
    end
    object SaveListofKeyPhrases1: TMenuItem
      Caption = 'Save List of Key Phrases'
      ImageIndex = 2
      OnClick = SaveListofKeyPhrases1Click
    end
  end
end
