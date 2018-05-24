object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Servidor Socket  -> [ FormServer ]'
  ClientHeight = 268
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 528
    Top = 10
    Width = 26
    Height = 13
    Caption = 'Porta'
  end
  object Status: TMemo
    Left = 0
    Top = 34
    Width = 377
    Height = 228
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = 4473924
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Switch: TToggleSwitch
    Left = 8
    Top = 8
    Width = 161
    Height = 20
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 170
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    FrameColor = 170
    ParentFont = False
    StateCaptions.CaptionOn = 'Servidor ligado'
    StateCaptions.CaptionOff = 'Servidor desligado'
    TabOrder = 1
    ThumbColor = 170
    OnClick = SwitchClick
  end
  object cxGrid1: TcxGrid
    Left = 383
    Top = 34
    Width = 233
    Height = 228
    TabOrder = 2
    object cxGrid1DBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DsServer
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
      object Grid1ColIP: TcxGridDBColumn
        DataBinding.FieldName = 'IP'
        Width = 101
      end
      object GridColNome: TcxGridDBColumn
        DataBinding.FieldName = 'Apelido'
        Width = 136
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
  object Porta: TEdit
    Left = 560
    Top = 7
    Width = 56
    Height = 21
    NumbersOnly = True
    TabOrder = 3
    Text = '666'
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
  object CDSServer: TClientDataSet
    PersistDataPacket.Data = {
      5B0000009619E0BD0100000018000000030000000000030000005B0005496E64
      6578040001000000000002495001004900000001000557494454480200020014
      00074170656C69646F01004900000001000557494454480200020014000000}
    Active = True
    Aggregates = <>
    Filter = 'where  = '
    FieldDefs = <
      item
        Name = 'Index'
        DataType = ftInteger
      end
      item
        Name = 'IP'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Apelido'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 224
    Top = 56
    object CDSServerIndex: TIntegerField
      FieldName = 'Index'
    end
    object CDSServerIP: TStringField
      FieldName = 'IP'
    end
    object CDSServerApelido: TStringField
      FieldName = 'Apelido'
    end
  end
  object DsServer: TDataSource
    DataSet = CDSServer
    Left = 224
    Top = 120
  end
end
