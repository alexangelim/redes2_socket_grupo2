object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Servidor Socket  -> [ FormServer ]'
  ClientHeight = 165
  ClientWidth = 507
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Servir: TButton
    Left = 8
    Top = 8
    Width = 81
    Height = 33
    Caption = 'Iniciar Servidor'
    TabOrder = 0
    OnClick = ServirClick
  end
  object Status: TMemo
    Left = 0
    Top = 76
    Width = 507
    Height = 89
    Align = alBottom
    Color = clInactiveCaption
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = []
    Lines.Strings = (
      'Status')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Socket_Server: TServerSocket
    Active = False
    Port = 666
    ServerType = stNonBlocking
    OnListen = Socket_ServerListen
    OnClientConnect = Socket_ServerClientConnect
    OnClientDisconnect = Socket_ServerClientDisconnect
    OnClientRead = Socket_ServerClientRead
    Left = 232
    Top = 16
  end
end
