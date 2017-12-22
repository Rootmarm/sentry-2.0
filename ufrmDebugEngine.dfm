object frmDebugEngine: TfrmDebugEngine
  Left = 192
  Top = 114
  Width = 448
  Height = 308
  Caption = 'Debug Engine'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    440
    274)
  PixelsPerInch = 96
  TextHeight = 13
  object memDebugEngine: TMemo
    Left = 0
    Top = 0
    Width = 440
    Height = 223
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object cmdRefresh: TButton
    Left = 8
    Top = 238
    Width = 89
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Refresh Data'
    TabOrder = 1
    OnClick = cmdRefreshClick
  end
  object cmdClose: TButton
    Left = 355
    Top = 238
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 2
    OnClick = cmdCloseClick
  end
end
