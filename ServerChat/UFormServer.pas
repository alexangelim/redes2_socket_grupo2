unit UFormServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls,
  Vcl.WinXCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxContainer, cxEdit, cxListBox;

type
  TForm1 = class(TForm)
    Socket_Server: TServerSocket;
    Status: TMemo;
    ToggleSwitch1: TToggleSwitch;
    cxListBox1: TcxListBox;
    procedure ServirClick(Sender: TObject);
    procedure Socket_ServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Socket_ServerClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Socket_ServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Socket_ServerListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure ToggleSwitch1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ServirClick(Sender: TObject);
begin
  if Socket_Server.Active = True then  // Se o Server estiver ativo...
  begin
    Socket_Server.Active := False;
    Status.Lines.Add('Servidor ::> Servidor Desligado!');
    //Servir.Caption := 'Iniciar Servidor';

  end
  else
  begin
    Socket_Server.Active := True;
    //Servir.Caption := 'Parar Servidor';
  end;
end;

procedure TForm1.Socket_ServerClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
  var
    index : Integer;
    texto : array[0..1] of string;
begin
  Status.Lines.Add('Servidor ::> Usu�rio Conectado => '+ Socket.RemoteAddress);
  with Socket_Server.Socket do
  begin
    for Index := 0 to ActiveConnections-1 do
    begin
      Connections[Index].SendText(texto[1] + ' entrou na sala: ');
    end;
  end;
  cxListBox1.Items.Add(Socket.RemoteAddress);

end;

procedure TForm1.Socket_ServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Servidor ::> Usu�rio Desconectado => '+ Socket.RemoteAddress);
end;

procedure TForm1.Socket_ServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
  var texto: array[0..1] of string;
      temptexto: string;
      Index: integer;
begin
  temptexto := Socket.ReceiveText;
  texto[0] := Copy(temptexto, 1,Pos('::::', temptexto) -1);
  texto[1] := Copy(temptexto, Pos('::::', temptexto) + Length('::::'),Length(temptexto));
  if texto[0] = 'NICK' then {Verifica se a mensagem eh de entrada}
  begin
    with Socket_Server.Socket do
    begin {Se a msg for de entrada avisa a todos os clientes quem entrou }
      for Index := 0 to ActiveConnections-1 do
      begin
        Connections[Index].SendText(texto[1] + ' entrou na sala: ');
      end;
      //cxListBox1.Items.Add(texto[1]);
    end;
  end
  else
  begin
    with Socket_Server.Socket do
    begin {Se nao for de entrada, ent�o eh msg normal, no caso passa para todos a msg}
      for Index := 0 to ActiveConnections-1 do
      begin
        Connections[Index].SendText('(' + texto[1] + ') escreveu: ' + texto[0]);
      end;
    end;
    //Status.Lines.Add('Servidor ::> ' + texto[1] + ' (' + Socket.RemoteAddress + ') escreveu: '+ texto[0]);
    Status.Lines.Add('Servidor ::> ' + texto[1] + ' (' + Socket.RemoteAddress + ') escreveu: '+ texto[0]);
  end;
end;

procedure TForm1.Socket_ServerListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Servidor ::> Servidor Ligado!');
end;

procedure TForm1.ToggleSwitch1Click(Sender: TObject);
begin
  if Socket_Server.Active = True then  // Se o Server estiver ativo...
  begin
    Socket_Server.Active := False;
    Status.Lines.Add('Servidor ::> Servidor Desligado!');
    //Servir.Caption := 'Iniciar Servidor';

  end
  else
  begin
    Socket_Server.Active := True;
    //Servir.Caption := 'Parar Servidor';
  end;
end;

end.
