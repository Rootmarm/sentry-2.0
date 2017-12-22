object frmSettingsProxySettings: TfrmSettingsProxySettings
  Left = 0
  Top = 0
  Width = 574
  Height = 360
  TabOrder = 0
  DesignSize = (
    574
    360)
  object Label71: TLabel
    Left = 8
    Top = 52
    Width = 243
    Height = 13
    Caption = 'Reactivate All Proxies When Active Proxies Equals:'
  end
  object Label2: TLabel
    Left = 8
    Top = 16
    Width = 97
    Height = 19
    Caption = 'Proxy Settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 120
    Top = 26
    Width = 441
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object txtProxyActivate: TEdit
    Left = 256
    Top = 48
    Width = 49
    Height = 21
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    Text = '10'
  end
end
