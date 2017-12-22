object frmSettingsFakeSettings: TfrmSettingsFakeSettings
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
    Top = 8
    Width = 141
    Height = 19
    Caption = 'Fake Pass Protection'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 160
    Top = 18
    Width = 401
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Label2: TLabel
    Left = 360
    Top = 64
    Width = 137
    Height = 13
    Caption = 'Abort Test When Hits Equals'
  end
  object Label3: TLabel
    Left = 360
    Top = 116
    Width = 96
    Height = 26
    Caption = 'Assume Fake When Content-Length <'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 512
    Top = 124
    Width = 25
    Height = 13
    Caption = 'bytes'
  end
  object chkConstrainHits: TCheckBox
    Left = 360
    Top = 40
    Width = 89
    Height = 17
    Hint = 'Enables you to stop a test after Sentry found X hits'
    Caption = 'Constrain Hits'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object txtConstrainHits: TEdit
    Left = 504
    Top = 60
    Width = 33
    Height = 21
    TabOrder = 1
    Text = '10'
  end
  object chkAfterFP: TCheckBox
    Left = 8
    Top = 40
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
    TabOrder = 2
  end
  object chkCheckHits: TCheckBox
    Left = 8
    Top = 81
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
    TabOrder = 3
  end
  object chkMetaRedirect: TCheckBox
    Left = 8
    Top = 120
    Width = 145
    Height = 17
    Hint = 
      'A Meta Redirect is a Meta Refresh tag in the Header part of the ' +
      'HTML'#13#10'source that tells a browser to redirect to a given locatio' +
      'n.'#13#10#13#10'This makes it appear like the page is a redirect but in ac' +
      'tuallity it is a 200 and'#13#10'your browser is redirecting you.'
    Caption = 'Check For Meta Redirects'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object chkFollowRedirects: TCheckBox
    Left = 8
    Top = 160
    Width = 97
    Height = 17
    Hint = 
      'Enables Sentry to Follow Redirects to the end.'#13#10#13#10'This option is' +
      ' only usable when the Engine cannot autodetect'#13#10'on when it shoul' +
      'd follow redirects based on the current options in it.'#13#10#13#10'This o' +
      'ption only takes effect with GET and no Key Phrases.'
    Caption = 'Follow Redirects'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object chkContentLength: TCheckBox
    Left = 360
    Top = 96
    Width = 177
    Height = 17
    Hint = 
      'Checks the length of the source returned to match a certain leng' +
      'th.'#13#10#13#10'If the length of the returned source is less than what is' +
      ' specified,'#13#10'the login is considered a fake.'
    Caption = 'Enable Content-Length Checker'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object txtContentLength: TEdit
    Left = 468
    Top = 120
    Width = 37
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 7
    Text = '200'
  end
end
