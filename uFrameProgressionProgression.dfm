object frmProgressionProgression: TfrmProgressionProgression
  Left = 0
  Top = 0
  Width = 574
  Height = 360
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 0
    Top = 213
    Width = 574
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Panel6: TPanel
    Left = 0
    Top = 33
    Width = 574
    Height = 180
    Align = alClient
    TabOrder = 0
    object lstCProgression: TListView
      Left = 1
      Top = 1
      Width = 535
      Height = 178
      Align = alClient
      Columns = <
        item
          Caption = 'Bot #'
          MinWidth = 50
        end
        item
          Caption = 'Proxy'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Username'
          MinWidth = 80
          Width = 80
        end
        item
          Caption = 'Password'
          MinWidth = 80
          Width = 80
        end
        item
          AutoSize = True
          Caption = 'Reply'
          MinWidth = 170
        end>
      ColumnClick = False
      GridLines = True
      OwnerData = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnData = lstCProgressionData
      OnMouseMove = lstCProgressionMouseMove
    end
    object panProgression: TJvPanel
      Left = 536
      Top = 1
      Width = 37
      Height = 178
      MultiLine = False
      OnMouseLeave = panProgressionMouseLeave
      Align = alRight
      TabOrder = 1
      Visible = False
      object cmdOpenMemo: TPngSpeedButton
        Left = 8
        Top = 40
        Width = 23
        Height = 23
        Hint = 'Open Debug Memo'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = cmdOpenMemoClick
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000002594944415478DA
          9D93CB6B534114C6CF69420C269DD88DB81085524545456D4BA4546D958AA5A8
          68932C6D10856C2CD8568C5A09A8940AFE19A2AD200D554A4545EBC2850B1FF1
          15C1822214C485DE492DAD77E65ECF3C621204170E39F7CCE37EBFF9E6E60C36
          ADCFBEDFDADAD8B4E4FABE9000D2A7F04C566361C7C2B3F3764D621D7E2BCE7E
          C174FF78A9633015FD3C472F09805FD286A8C4920DD7AE2FBA00A108C0A7F17C
          090FA56F3A0DED5D8C7F5F844000C0A31D7CDA817E26E8E1F99539F5404A3F03
          61F8F0E031C73DBDD79DFEA103AC7353442FE8F6A7A3BA68519525441FA60A2E
          64B2F738B6256E38C3177A58F73606FF6A3E599364C5A31C0AF9907FEE42DFE9
          698EF1DE31E7E2F96ED6B3E36F804FBE95752925098D58458400132F3D383674
          9F6373E29693CBEE67079B6355427358255210298D500893EB15A04080738F38
          6E4FDC767267F7B1C32DB19A9D5533425F3B50FD72444312F2AF10D2C34F386E
          4E4E3897CE74B223ADB500298DE56AA172A0601AF0BA0E4EE49E72DC989C74AE
          0CEE6647E3312B562F992C8482082D765D23561005987C138093979F715C97BC
          E38C0CEC62899D312B2E7F2C737621ADD0953A2B9006BC0D4266E405C7C6D494
          7375A08D25E2B19A0FA66D532D0B020A2A51D577D598221A1470B7B80C32A305
          8E6B53D3CEB5532D2CD1BEC2148C6F0BDFA31DD599158C00428B0D2812F2E808
          61488FBEE3B8E1F84C696FC796E8EA7A49F58EC6BA72622F8E398A65EA620208
          A2071F7F84E1E14C711E1BBAC66697AF5CB5667E41D00950DF34CF860650F192
          99AACB016A922875080B5FE7B0FC9FFF6FFB0D068ABED5318427C60000000049
          454E44AE426082}
      end
      object cmdOpenDebug: TPngSpeedButton
        Left = 8
        Top = 8
        Width = 23
        Height = 23
        Hint = 'Open Debug.txt'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = cmdOpenDebugClick
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1300000B1301009A9C180000000467414D410000
          B18E7CFB5193000002AC4944415478DA65935F4853511CC7BF776E635BA57B48
          743ED48B84D053246691732CFF908341CE5E7C497C8B866F510FB2CD7CE82D90
          5EFAA36FF69483080CA9B5982865601A844E986489E9749BF3CEBB3F77BB5BE7
          77E0AE1B9ECBE1DCFB3BE7FB39BFDFF79C2B542A15506B6C6CBCD4DFDFEF3E62
          0D9572D964361B57764FD5AD2CACCE21B3B0D872FB25A2C17B6868B901491620
          FF7A8F825C84A0020606069ECECCCC78A169E2510A0F9E2DE3EDDA6918138BCF
          B7DEDD1FA9BFE094A59201C5DF1F21173500A7D339160E877DA5520935353510
          04019298C4CEE62A465FFDC4BAC183E60613C24F3AAE1750BBA8FC89A05852FE
          01EC76BB7F7E7E3E506454BD5ECF01A964029BD1EF588B6DE1EEEB3A9C3DDF8A
          66DB197C9A70DD4462698EB427008AA2F00CA81DECEF63EDC72AF6E27BF00745
          9CABCDA3EDA20D07A282178FEE5898365705747676062291885F0B482593D8D8
          884214D3505866F556236CB626ECEC1EA0DDDE738569BF9E00683DC8E572D867
          5914F279E8504185C52C160BD6A3517477F75C66DA6FDA1202AC043F89086034
          1A799C32225FB2590999E36308EC8932406F6F6F2BD32E6B0163A150C8470032
          D16C3643A7D3F139CA8AAEC7E1E121687D2C16435F5F5F3B7B5FFA0F303B3BEB
          533330994C7C2C97CB28140ACC079143E87B7B7B1B6EB7FB2AD37ED17A30160C
          067D994C8667603018F8A802289E4EA77906F1781C1E8FE71A7BFFAC058C4F4F
          4F8FD24E64200168240F64598624491C42EB09343838D8C14A5BA8021C0EC7F8
          E4E4E4A85A27EDAED64F2612209BCDF2188D4343430E068E54015D5D5D8FA7A6
          A61EA652292EA2DD698EC4D4C91BEA14A7928687877B18F44315E072B9260281
          C0482291E04215401EA86550A793A198D7EBBDC5B27D5305B08926ABD5DA96CF
          E78FE9F8D53F92049A35D4F5EC8ED4B18D422C9EFE0B4B43D9F0C22F6A480000
          000049454E44AE426082}
      end
      object cmdDebugEngine: TPngSpeedButton
        Left = 8
        Top = 72
        Width = 23
        Height = 22
        Hint = 'Debug Engine'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = cmdDebugEngineClick
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000003D74944415478DA
          5D936D4C935714C7CF6D9FBE522CD61690529262601BC81C28BA15CC2A3226F2
          6113D3210859299BCA4B101435E08802A5EA64505426A6AD19A026B63098666C
          66D34DD07E189B317E800A6C2D8C7441B05A68A5AFCFB35B3397652739373927
          F7FF3BE7DE732FCACECE0684E82095AE1B94CBB377B0584C626A6ADA69325D1B
          7EF060AC86A22807601389842093C9402814E18822BC5E7FE2E0E0D716949121
          E3391CCF5D515162634BCB294566E6C6D07E181B7B043535D5BF9ACD7773190C
          6271FDFA6458BB360662632539E9E95BDA6D36BB58AB3D5D8DCACBAB465C2E77
          F4D0D040AE244EDAA2D19CD993939385386C060C0C0CC3BE7D1F773B9D8ECABC
          BC5CD2ED7E014AA56A262F2F3FAEF6D051B2AFB7BB1AF5F5F57BE47239EBF8F1
          FA5993E9EAE6F875890683BE376FD3A614B0DAEC5054A8B04D4C3C4CC8CCCC08
          A4A4A45D4C4A4A3D30323A4AF69BAEFCB0BCECFC08E9F5D73C0505052CABD50A
          E7CF6B9FB039DC80AAB42C2636560C76FB3CA8547BE7F87CB6442EDFAE5FB52A
          B2ACAB4B3B373535710C9F7218FB73545656F1F848DD67891C2E03965D2B4006
          83C0603100E80C208082DEAFF49E65B77342248C7E53A7FBD26AB3FDFE01168E
          C33F860482D5C5B5B58D865DF90A2697C3C5198C7DFA14E6A71F437CDA5BE05E
          71C3FDD1FB70AEF32CAE6CD9C060321D7E9F0FFE058404C235C2FDEF66ED50A7
          A6BF236086F190DF320E1BDCF36829520CF4CD19909AFC3ADCB839ECEBEC6853
          7B7C2F5A161716008F178F1F0398B8DD0049020A90923482C89E07B4B540B6A5
          A84159C2FAA5AB1BEC8949B05BA7032E9B0D067D1FD9DA7AE2DCECACB5F665F5
          10A004AF411CAC606234C04ED91EC5E59CF7B6473DBBF51DDCBB731768DB7642
          E6E93610C7883084809EDEEB9446D3AC9BB14DEFF77A7D808E60B10B7B842042
          FBE1A1839569E91B09C7951ED0F70F52863081B5B0BA3E565958CC64B168C08F
          0883701E078CA61B54D3C986AB16CB78393A80C56B44427DB1A649F55A423C72
          5CEC84DB7746A1EE99D7F2672090251445E65756D6B517EF5532D96C1A389D4B
          10278983EB46231C3E5C7106350A563715AA4F34BE919C885C17DAC0FCB3198E
          2D914F1E7AFDBB6804CD4C0682C00B0FAFA839D8D05E5252CA22E87498B3FF85
          DFCCE7816F868CAD686477EED2D64F95E164CF25B8FDE33DA877920BBFF982A5
          F8C37C4B23E840D009F079BDC0E3F1545555472FC8B7BDCFE9E850FB6E7D7FF3
          146EBE197D91209E55488592914793D0BCE0F96332089F60F14FA15B7E0508F8
          7D40921444F0F94591D1E2FAE9C9890192A24EBE9C4438C0DB5280C61984169D
          14A5C6B9A9578FE4BF80908520FFB7BF011D0A8E9A4CEE70240000000049454E
          44AE426082}
      end
      object cmdReloadSettings: TPngSpeedButton
        Left = 8
        Top = 104
        Width = 23
        Height = 22
        Hint = 'Reload Engine Settings'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = cmdReloadSettingsClick
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000003914944415478DA
          55536D6C5445143DF3DECCEE7BBBCB52D895564A97AE6D4956301221353420A4
          1AD284D260AC1408585AB0D51F359254C5184CC5542C6D34ADB515AA981013B0
          3FCA0F6344602580A618B12A34B4556BEB9A8A7C6C53F77BF77D79776D4C9C99
          9B49E6CE3DF7CE3977189A0098804CD3D44C58CC426E64C80C32BBF072D93684
          64664C9FD3DA011E8258447E999C12D8FF00D20440939644003201E8607C49F1
          E2A28B2F6C3D1038153C3DF1DDF5E136383CA7A1090A64F300D9A41A54B2DAFC
          BC825AAF6B49A11D8A649A308D8C6916BB8B577D74A05F8DF130BA3E3E8EBECF
          8E754272BE0AC966303453700AABFDDE9281E72A9BD606020FC070C6A8283D97
          C1B44CD8988A049FC51FE2276CB4D52238348E43273ADE3134A395A111A50FE6
          AF0CF636BCEB1BCFFB1651EB1E8A841FCCE4C48799C500870D53915F311C3F8F
          467F0BE2DF78D0F076CB602A19AD67EE26F7A77D7BFAB75FF35E80D038CA139B
          F1E5F05791583C36CB652165D29AE55BE05B5A5F57276E4B215C0B4EA1FD64D7
          E7D164FC5908E5165BF77A45BCABA1D37121FA05D6A62AB0AF7BFFCDBFEEFEB9
          17764C2342BC24E15A5E5872A6FDF9CE15672F9D8B7D7271F02D62BD1B964840
          B8C00A5F5C1E7EA2F471C5C5175ADF4FFD285D1DBF7C1076B3078A331F69DC41
          C4719F627307858648341E26E2D875C4332E18B2809AA731EC918B1033E8C159
          31A53918A65F5DEC6A0394B2643C5589A8EB4EF60CD154080ADBF6D08A474E54
          061E93925A1AE746AEA6189EE1D4147A8E2C24B0AF7A4DCD9BBB37D7DF7F78A0
          6DF2E6C88D2A62F06F12244D4FF1B83D052787BA07D77BD644B00CABB1B7E5B0
          4E1510806138B925F7BC5C7DB071474D0D96CA3E740CF468A33363BF2BC221E9
          19CBC853162EA8AEACCA8FAD9A6011670881B127B1BBE595CB0CDB213389BFDF
          5BDFDBEC7BD48D63A1A378585D079F5A02CDD2735D9D2D4EE6126E59D350850D
          9B923BF0D26BEF85AF8C7C5DCDF03427BF74F4C853EDAD651505E89E3E827275
          3DFC4A29126632D7ACD414902C191EBD10D19F058E9F1A9CBA31F643339C8EF3
          0CBB9C806E4874BB63FF86E6D66D5BAA50A42E43E7077D99D199C90955B81833
          6549D780DBB37377674293677543FF1076E51E844CF03B1DFFFE850C7D8E7074
          5779D9A637EA36D695F69DE9FF6DF297D10DE02E52860B98B201E18C2391B260
          9B8FE1D23C000908DD0E44D2A484E91776EF2130E74A4DCF6C453246324A7487
          1270AA3696A0DDFE1FC03F4B9271F60C7FDA200000000049454E44AE426082}
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 216
    Width = 574
    Height = 144
    Align = alBottom
    BevelOuter = bvNone
    Constraints.MinHeight = 95
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 200
      Top = 0
      Height = 144
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 144
      Align = alLeft
      BevelInner = bvLowered
      Constraints.MinWidth = 200
      Ctl3D = True
      DragKind = dkDock
      DragMode = dmAutomatic
      ParentCtl3D = False
      TabOrder = 0
      DesignSize = (
        200
        144)
      object Label1: TLabel
        Left = 0
        Top = 1
        Width = 200
        Height = 15
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Statistics'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Panel2: TPanel
        Left = 0
        Top = 16
        Width = 200
        Height = 128
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelInner = bvLowered
        Color = clWhite
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentBackground = False
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          200
          128)
        object Label2: TLabel
          Left = 16
          Top = 8
          Width = 21
          Height = 14
          Caption = '200:'
        end
        object Label3: TLabel
          Left = 16
          Top = 22
          Width = 21
          Height = 14
          Caption = '3xx:'
        end
        object Label4: TLabel
          Left = 16
          Top = 51
          Width = 21
          Height = 14
          Caption = '403:'
        end
        object Label5: TLabel
          Left = 16
          Top = 65
          Width = 21
          Height = 14
          Caption = '404:'
        end
        object Label6: TLabel
          Left = 16
          Top = 80
          Width = 21
          Height = 14
          Caption = '5xx:'
        end
        object Label7: TLabel
          Left = 115
          Top = 8
          Width = 35
          Height = 14
          Anchors = [akTop, akRight]
          Caption = 'Retries:'
        end
        object Label8: TLabel
          Left = 103
          Top = 27
          Width = 47
          Height = 14
          Anchors = [akTop, akRight]
          Caption = 'Timeouts:'
        end
        object lbl200: TLabel
          Left = 40
          Top = 8
          Width = 40
          Height = 14
          AutoSize = False
          Caption = '0'
        end
        object lbl3xx: TLabel
          Left = 40
          Top = 22
          Width = 40
          Height = 14
          AutoSize = False
          Caption = '0'
        end
        object lbl403: TLabel
          Left = 40
          Top = 51
          Width = 40
          Height = 14
          AutoSize = False
          Caption = '0'
        end
        object lbl404: TLabel
          Left = 40
          Top = 65
          Width = 40
          Height = 14
          AutoSize = False
          Caption = '0'
        end
        object lbl5xx: TLabel
          Left = 40
          Top = 80
          Width = 40
          Height = 14
          AutoSize = False
          Caption = '0'
        end
        object lblRetries: TLabel
          Left = 153
          Top = 8
          Width = 40
          Height = 14
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
        end
        object lblTimeouts: TLabel
          Left = 153
          Top = 27
          Width = 40
          Height = 14
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
        end
        object Label9: TLabel
          Left = 98
          Top = 105
          Width = 52
          Height = 14
          Anchors = [akTop, akRight]
          Caption = 'Remaining:'
        end
        object lblPLeft: TLabel
          Left = 153
          Top = 105
          Width = 40
          Height = 14
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
        end
        object Label10: TLabel
          Left = 16
          Top = 36
          Width = 21
          Height = 14
          Caption = '401:'
        end
        object lbl401: TLabel
          Left = 40
          Top = 36
          Width = 40
          Height = 14
          AutoSize = False
          Caption = '0'
        end
        object lblPDisabled: TLabel
          Left = 152
          Top = 86
          Width = 40
          Height = 14
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
        end
        object Label12: TLabel
          Left = 109
          Top = 86
          Width = 41
          Height = 14
          Anchors = [akTop, akRight]
          Caption = 'Disabled:'
        end
        object lblPBanned: TLabel
          Left = 152
          Top = 67
          Width = 40
          Height = 14
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
        end
        object Label14: TLabel
          Left = 113
          Top = 67
          Width = 37
          Height = 14
          Anchors = [akTop, akRight]
          Caption = 'Banned:'
        end
        object Label11: TLabel
          Left = 8
          Top = 110
          Width = 29
          Height = 14
          Anchors = [akTop, akRight]
          Caption = 'Fakes:'
        end
        object lblFakes: TLabel
          Left = 40
          Top = 110
          Width = 40
          Height = 14
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
        end
        object Label15: TLabel
          Left = 15
          Top = 95
          Width = 22
          Height = 14
          Anchors = [akTop, akRight]
          Caption = 'Hits:'
        end
        object lblHits: TLabel
          Left = 40
          Top = 95
          Width = 40
          Height = 14
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Times New Roman'
          Font.Style = []
          ParentFont = False
        end
        object Label13: TLabel
          Left = 120
          Top = 48
          Width = 39
          Height = 13
          Caption = 'Proxies'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold, fsUnderline]
          ParentFont = False
        end
      end
    end
    object Panel5: TPanel
      Left = 203
      Top = 0
      Width = 371
      Height = 144
      Align = alClient
      TabOrder = 1
      object PageControl1: TPageControl
        Left = 1
        Top = 1
        Width = 369
        Height = 142
        ActivePage = TabSheet1
        Align = alClient
        Style = tsFlatButtons
        TabOrder = 0
        object TabSheet1: TTabSheet
          Caption = 'Hits'
          object lstHits: TListBox
            Left = 0
            Top = 0
            Width = 361
            Height = 111
            Align = alClient
            Color = clMoneyGreen
            Ctl3D = False
            ItemHeight = 13
            ParentCtl3D = False
            PopupMenu = mnuLists
            TabOrder = 0
            OnDblClick = LaunchInBrowser1Click
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'Redirects'
          ImageIndex = 1
          object lstRedirects: TListBox
            Left = 0
            Top = 0
            Width = 361
            Height = 111
            Align = alClient
            Color = 16637915
            Ctl3D = False
            ItemHeight = 13
            ParentCtl3D = False
            PopupMenu = mnuLists
            TabOrder = 0
            OnDblClick = LaunchInBrowser1Click
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'Fakes'
          ImageIndex = 2
          object lstFakes: TListBox
            Left = 0
            Top = 0
            Width = 361
            Height = 111
            Align = alClient
            Color = 12123900
            Ctl3D = False
            ItemHeight = 13
            ParentCtl3D = False
            PopupMenu = mnuLists
            TabOrder = 0
            OnDblClick = LaunchInBrowser1Click
          end
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 574
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      574
      33)
    object Label16: TLabel
      Left = 264
      Top = 8
      Width = 81
      Height = 13
      Caption = 'Wordlist Position:'
    end
    object Label17: TLabel
      Left = 8
      Top = 8
      Width = 24
      Height = 13
      Caption = 'Bots:'
    end
    object lblBots: TLabel
      Left = 232
      Top = 6
      Width = 8
      Height = 13
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblWordlist: TLabel
      Left = 522
      Top = 6
      Width = 8
      Height = 13
      Anchors = [akTop, akRight]
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sldBots: TTrackBar
      Left = 36
      Top = 6
      Width = 197
      Height = 19
      Ctl3D = True
      Max = 100
      Min = 1
      ParentCtl3D = False
      Position = 1
      TabOrder = 0
      ThumbLength = 12
      TickStyle = tsManual
      OnChange = sldBotsChange
    end
    object sldWordlist: TTrackBar
      Left = 348
      Top = 6
      Width = 173
      Height = 19
      Hint = 'Right Click to Reset Position'
      Anchors = [akLeft, akTop, akRight]
      Ctl3D = True
      Max = 100
      Min = 1
      ParentCtl3D = False
      ParentShowHint = False
      PopupMenu = mnuWordlist
      Position = 1
      ShowHint = True
      TabOrder = 1
      ThumbLength = 12
      TickStyle = tsManual
      OnChange = sldWordlistChange
    end
  end
  object mnuLists: TPopupMenu
    Images = frmSentry.ilMenus
    Left = 296
    Top = 272
    object LaunchInBrowser1: TMenuItem
      Caption = 'Launch In Browser'
      ImageIndex = 3
      OnClick = LaunchInBrowser1Click
    end
    object mnuProxy: TMenuItem
      Caption = 'Use Proxy In IE'
      OnClick = mnuProxyClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object CopyURLToClipboard1: TMenuItem
      Caption = 'Copy URL To Clipboard'
      ImageIndex = 6
      OnClick = CopyURLToClipboard1Click
    end
    object CopyComboToClipboad1: TMenuItem
      Caption = 'Copy Combo To Clipboad'
      ImageIndex = 6
      OnClick = CopyComboToClipboad1Click
    end
    object CopyProxyToClipboard1: TMenuItem
      Caption = 'Copy Proxy To Clipboard'
      ImageIndex = 6
      OnClick = CopyProxyToClipboard1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object BanProxy1: TMenuItem
      Caption = 'Ban Proxy'
      ImageIndex = 10
      OnClick = BanProxy1Click
    end
    object BanProxyAndAddToBlacklist1: TMenuItem
      Caption = 'Ban Proxy And Add To Blacklist'
      ImageIndex = 9
      OnClick = BanProxyAndAddToBlacklist1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object SendToHistory1: TMenuItem
      Caption = 'Send To History'
      ImageIndex = 15
      OnClick = SendToHistory1Click
    end
  end
  object mnuWordlist: TPopupMenu
    Images = frmSentry.ilMenus
    Left = 344
    Top = 272
    object ResetWordlistPosition1: TMenuItem
      Caption = 'Reset Wordlist Position'
      ImageIndex = 14
      OnClick = ResetWordlistPosition1Click
    end
  end
  object mnuDebugMemo: TPopupMenu
    Images = frmSentry.ilMenus
    Left = 256
    Top = 272
    object MinimizeMemo1: TMenuItem
      Caption = 'Minimize Memo'
      ImageIndex = 17
      OnClick = MinimizeMemo1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object ClearMemo1: TMenuItem
      Caption = 'Clear Memo'
      ImageIndex = 0
      OnClick = ClearMemo1Click
    end
  end
end
