unit chat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp, cxLookAndFeelPainters, cxGraphics, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  dxSkinXmas2008Blue, cxClasses, dxAlertWindow, cxControls, cxLookAndFeels,
  cxContainer, cxEdit, cxListBox;

type
  TChatFal = class(TForm)
    C_Comandos: TGroupBox;
    C_Texto: TEdit;
    Host: TEdit;
    Lbl_Servidor: TLabel;
    Conectar: TButton;
    Servir: TButton;
    S_Cliente: TClientSocket;
    Status: TMemo;
    Quadro: TMemo;
    S_Server: TServerSocket;
    Apelido: TEdit;
    Label1: TLabel;
    dxAlert: TdxAlertWindowManager;
    cxListBox1: TcxListBox;
    procedure S_ClienteConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure S_ClienteDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure S_ClienteError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure S_ClienteRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ConectarClick(Sender: TObject);
    procedure C_TextoKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure ServirClick(Sender: TObject);
    procedure S_ServerListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure S_ServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure S_ServerClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure S_ServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChatFal: TChatFal;
implementation

{$R *.dfm}

{Procedimento de conex�o do cliente ao servidor }
procedure TChatFal.S_ClienteConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Cliente  ::> Conectado a: ' + S_Cliente.Host);
  Conectar.Caption := 'Desconectar';
  Apelido.Enabled := False;
  S_Cliente.Socket.SendText('NICK::::' + Apelido.Text);
end;

{Procedimento de desconex�o do cliente com o servidor }
procedure TChatFal.S_ClienteDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Cliente  ::> Desconectado ');
    Conectar.Caption := 'Conectar';
    Apelido.Enabled := True;
end;

{Procedimento de ERRO de conex�o }
procedure TChatFal.S_ClienteError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Status.Lines.Add('Cliente  ::> ERRO ao tentar conectar a: ' + S_Cliente.Host);
end;

procedure TChatFal.S_ClienteRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  Quadro.Lines.Add(Socket.ReceiveText);
end;

{Ao clicar no bot�o "CONECTAR" o programa pega o IP digitado no campo
{ De servidor e tenta conectar ao servidor, caso de ERRO ele vai executar
{ o procedimento de ERRO de conex�o, caso ocorra sucesso de conex�o ele vai
{ executar o procedimento OnConnect}
procedure TChatFal.ConectarClick(Sender: TObject);
begin
  if S_Cliente.Active then
  begin
    S_Cliente.Active := False;
    Conectar.Caption := 'Conectar';
  end
  else
  begin
    S_Cliente.Host := Host.Text;
    S_Cliente.Active := True;
  end;
end;

{ Este Procedimento serve para quando for digitado a tecla [ENTER] envie
{ o texto do campo de MENSAGEM para  o servidor, facilitando o uso
{ do chat.}
procedure TChatFal.C_TextoKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    S_Cliente.Socket.SendText(C_Texto.Text + '::::' + Apelido.Text);
    C_Texto.Text := '';
  end;
end;

{Clicando no bot�o "Iniciar Servidor" O programa vira servidor de CHAT
{para que outros Clientes possam conectar nele. Para facilitar, automaticamente
{ o programa se conecta no proprio server, e desabilita os campos de conex�o
{ para evitar conflito.}
procedure TChatFal.ServirClick(Sender: TObject);
begin
  if S_Server.Active = True then
  begin
    S_Server.Active := False;
    Status.Lines.Add('Servidor ::> Servidor Desligado!');
    Servir.Caption := 'Iniciar Servidor';
    S_Cliente.Active := False;
    Host.Enabled := True;
    Conectar.Enabled := True;
  end
  else
  begin
    S_Server.Active := True;
    Servir.Caption := 'Parar Servidor';
    Host.Enabled := False;
    Conectar.Enabled := False;
    S_Cliente.Host := '127.0.0.1';
    S_Cliente.Active := True;
   end;
end;

{ Procedimento executado logo apos o server come�ar a escutar a porta Padr�o
{ Uma mensagem eh enviada para a tela de status}
procedure TChatFal.S_ServerListen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 Status.Lines.Add('Servidor ::> Servidor Ligado!');
end;

{ Procedimento do Servidor para quando um cliente se conecta}
procedure TChatFal.S_ServerClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   Status.Lines.Add('Servidor ::> Usu�rio Conectado => '+ Socket.RemoteAddress);
end;

{ Procedimento do Servidor para quando um cliente se desconecta}
procedure TChatFal.S_ServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   Status.Lines.Add('Servidor ::> Usu�rio Desconectado => '+ Socket.RemoteAddress);
end;

{ Procedimento executado quando o servidor recebe dados dos clientes }
procedure TChatFal.S_ServerClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var texto: array[0..1] of string;
    temptexto: string;
    Index: integer;
begin
   temptexto := Socket.ReceiveText;
   texto[0] := Copy(temptexto, 1,Pos('::::', temptexto) -1);
   texto[1] := Copy(temptexto, Pos('::::', temptexto) + Length('::::'),Length(temptexto));
   if texto[0] = 'NICK' then {Verifica se a mensagem eh de entrada}
   begin
    with S_Server.Socket do
    begin {Se a msg for de entrada avisa a todos os clientes quem entrou }
      for Index := 0 to ActiveConnections-1 do
      begin
        Connections[Index].SendText(texto[1] + ' entrou na sala: ');
      end;
    end;
    cxListBox1.Items.Add(texto[1]);
    if not(ChatFal.Active) then
     dxAlert.Show(texto[1]+' entrou','',0);
   end
   else
   begin
    with S_Server.Socket do
    begin {Se nao for de entrada, ent�o eh msg normal, no caso passa para todos a msg}
    for Index := 0 to ActiveConnections-1 do
    begin
      Connections[Index].SendText('(' + texto[1] + ') escreveu: ' + texto[0]);
    end;
    end;
   Status.Lines.Add('Servidor ::> ' + texto[1] + ' (' + Socket.RemoteAddress + ') escreveu: '+ texto[0]);
   if not(ChatFal.Active) then
     dxAlert.Show(texto[1]+' disse',texto[0],0);
   end;

end;
procedure TChatFal.FormCreate(Sender: TObject); {Limpa o quadro}
begin
  Quadro.Text := '';
end;

end.