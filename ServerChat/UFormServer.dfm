object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Servidor Socket  -> [ FormServer ]'
  ClientHeight = 175
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Status: TMemo
    Left = 0
    Top = 34
    Width = 375
    Height = 141
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ToggleSwitch1: TToggleSwitch
    Left = 4
    Top = 4
    Width = 161
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    FrameColor = clHotLight
    ParentFont = False
    StateCaptions.CaptionOn = 'Servidor ligado'
    StateCaptions.CaptionOff = 'Servidor desligado'
    TabOrder = 1
    ThumbColor = clHotLight
    OnClick = ToggleSwitch1Click
  end
  object cxListBox1: TcxListBox
    Left = 375
    Top = 34
    Width = 140
    Height = 139
    ItemHeight = 13
    TabOrder = 2
  end
  object Socket_Server: TServerSocket
    Active = False
    Port = 666
    ServerType = stNonBlocking
    OnListen = Socket_ServerListen
    OnClientConnect = Socket_ServerClientConnect
    OnClientDisconnect = Socket_ServerClientDisconnect
    OnClientRead = Socket_ServerClientRead
    Left = 392
    Top = 104
  end
end
