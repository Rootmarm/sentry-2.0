object frmSettingsHTTPHeader: TfrmSettingsHTTPHeader
  Left = 0
  Top = 0
  Width = 574
  Height = 360
  TabOrder = 0
  DesignSize = (
    574
    360)
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 558
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Request Header'
    TabOrder = 0
    DesignSize = (
      558
      249)
    object Label4: TLabel
      Left = 368
      Top = 20
      Width = 185
      Height = 17
      Alignment = taCenter
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'POST'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 10
      Top = 224
      Width = 58
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'POST Data:'
      Visible = False
    end
    object Label6: TLabel
      Left = 368
      Top = 40
      Width = 185
      Height = 41
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 
        'Use <USER> <PASS> in POST Data which will be substituted with th' +
        'e current combo.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object cmdWizard: TPngSpeedButton
      Left = 340
      Top = 220
      Width = 21
      Height = 21
      Hint = 'POST Request Wizard'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = cmdWizardClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000000467414D410000AFC837058AE90000001974455874536F6674776172
        650041646F626520496D616765526561647971C9653C000002A64944415478DA
        9DD25B4853711C07F0EFD94DA7421385958A56DA456C9310A2625D2095CAC097
        C420EBC1D0C52A23C7C08D4C7C58E8832FD9C3BC860662850449A1A03D9408A1
        58E024EF6DB3D9723B6E6EEEEC7ACEFACF1E2A66601DF871E0FCFFFFCFF9FF2E
        D44740C402F91B808701663D0028A038796F42AF7B233C1562C217296AEBDBB6
        0F3541510AC9D983EF0322A1F3CBB0514F03967D67B21FE53728768FDC7CB9B0
        69F21C0EF1298EE0E06D07BC03F2522FE58FE5181E4BD60607617B3B84BC160D
        FCDF27F1E25C6BA7CDCD5585C8463FB6BF05354482E3A14EDE71FF617A652322
        FE0950F12B307537A3BF7A72C0CEA2824FCE0BFF96C273C2321194CBCAE57D47
        7B3A7994C80C845E21EC9CC66C2F8DF11EFA9B65D1D7CC06229D64AB37067806
        144A4F65F71CEB6A48131F10038141F2BF19F2A6B06909C035E6C268EB2A1697
        D9C23860340618DE9FE438DE5D9612164BE0F93C86CC0B24E33030ACFE0A8677
        029FA667CC2B666BC30215FF9A6118071B0AFD090CA4C68D4452C559B4CD35EE
        629052DA945572E87C1AAE9EFE0041C96D5CBE52EA6D7AA0AB9E5E98EBF3F849
        29A3F13BD02FE6535E8EA3DC810847664194712471B5AC263DA5AE716DD960F7
        49D577EF24161615476A6A6B95F34663474C0AFD097CF84975EC5E16D1216245
        B89793C96B31BA7655BC499672B3A6A5A75AB55A7052A1E0944A65B5D56AED8A
        0148BD602680F767AFF964328B9C89920953661A3DE55CAF58B7D99EE8743A41
        41414184202A87C36188012CBF80AD89B32749309FB1074B3E063EAFB792A6E9
        76AD56CB97C964AC4AA5BAE5743ADB76042C13201820ED74B96EF8FD7E034104
        72B91C045112A47D474080549EB4301A952CCBB6D5D7D70B727373398D4653F5
        4F4080DC24180C5E23CBDD7ABD5EE076BBD9FF01A2A95F170A856D52A974EE07
        902B71C122C03F130000000049454E44AE426082}
    end
    object memHeader: TMemo
      Left = 10
      Top = 20
      Width = 351
      Height = 173
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
    object chkBasicAuth: TCheckBox
      Left = 10
      Top = 196
      Width = 191
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = 'URL Requires Basic Authentication'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = chkBasicAuthClick
    end
    object cmdBuildHeader: TButton
      Left = 372
      Top = 208
      Width = 177
      Height = 33
      Anchors = [akRight, akBottom]
      Caption = 'Build HTTP Header'
      TabOrder = 2
      OnClick = cmdBuildHeaderClick
    end
    object txtPOSTData: TEdit
      Left = 72
      Top = 220
      Width = 265
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 3
      Visible = False
    end
    object chkAutoBuild: TCheckBox
      Left = 372
      Top = 184
      Width = 177
      Height = 17
      Hint = 
        'This option will allow Sentry to auto-build your header for GET ' +
        'and HEAD requests.'
      Anchors = [akRight, akBottom]
      Caption = 'Auto-Build Header (HEAD/GET)'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 264
    Width = 361
    Height = 89
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'User Agents'
    TabOrder = 1
    DesignSize = (
      361
      89)
    object lstUserAgents: TListBox
      Left = 8
      Top = 16
      Width = 345
      Height = 65
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      MultiSelect = True
      PopupMenu = mnuUserAgents
      TabOrder = 0
    end
  end
  object rgRequestMethod: TRadioGroup
    Left = 376
    Top = 264
    Width = 190
    Height = 41
    Anchors = [akRight, akBottom]
    Caption = 'Request Method'
    Columns = 3
    ItemIndex = 1
    Items.Strings = (
      'HEAD'
      'GET'
      'POST')
    TabOrder = 2
    OnClick = rgRequestMethodClick
  end
  object rgReferer: TRadioGroup
    Left = 376
    Top = 312
    Width = 190
    Height = 41
    Hint = 'Referer to add to Request Header when Building HTTP Header'
    Anchors = [akRight, akBottom]
    Caption = 'Referer'
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'None'
      'Base'
      'Site')
    TabOrder = 3
  end
  object mnuUserAgents: TPopupMenu
    Images = frmSentry.ilMenus
    Left = 152
    Top = 296
    object AddUserAgent1: TMenuItem
      Caption = 'Add User Agent'
      ImageIndex = 7
      OnClick = AddUserAgent1Click
    end
    object EditUserAgent1: TMenuItem
      Caption = 'Edit Selected User Agent'
      ImageIndex = 5
      OnClick = EditUserAgent1Click
    end
    object RemoveUserAgent1: TMenuItem
      Caption = 'Remove Selected User Agents'
      ImageIndex = 0
      OnClick = RemoveUserAgent1Click
    end
  end
end
