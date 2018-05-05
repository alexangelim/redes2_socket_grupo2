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
  TFormCliente = class(TForm)
    C_Comandos: TGroupBox;
    C_Texto: TEdit;
    Host: TEdit;
    Lbl_Servidor: TLabel;
    Conectar: TButton;
    Servir: TButton;
    S_Cliente: TClientSocket;
    Status: TMemo;
    Quadro: TMemo;
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
    procedure S_ServerListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure S_ServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure S_ServerClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCliente: TFormCliente;
implementation

{$R *.dfm}

{Procedimento de conex�o do cliente ao servidor }
procedure TFormCliente.S_ClienteConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Cliente  ::> Conectado a: ' + S_Cliente.Host);
  Conectar.Caption := 'Desconectar';
  Apelido.Enabled := False;
  S_Cliente.Socket.SendText('NICK::::' + Apelido.Text);
end;

{Procedimento de desconex�o do cliente com o servidor }
procedure TFormCliente.S_ClienteDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Cliente  ::> Desconectado ');
    Conectar.Caption := 'Conectar';
    Apelido.Enabled := True;
end;

{Procedimento de ERRO de conex�o }
procedure TFormCliente.S_ClienteError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Status.Lines.Add('Cliente  ::> ERRO ao tentar conectar a: ' + S_Cliente.Host);
end;

procedure TFormCliente.S_ClienteRead(Sender: TObject; Socket: TCustomWinSocket);
  var
    Mensagem : string;
begin
  Mensagem := Socket.ReceiveText;

  Quadro.Lines.Add(Mensagem);
  if Pos('entrou', Mensagem) > 0 then
    cxListBox1.Items.Add(Copy(Mensagem, 1,Pos('entrou', Mensagem)-1));
end;

{Ao clicar no bot�o "CONECTAR" o programa pega o IP digitado no campo
{ De servidor e tenta conectar ao servidor, caso de ERRO ele vai executar
{ o procedimento de ERRO de conex�o, caso ocorra sucesso de conex�o ele vai
{ executar o procedimento OnConnect}
procedure TFormCliente.ConectarClick(Sender: TObject);
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
procedure TFormCliente.C_TextoKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    S_Cliente.Socket.SendText(C_Texto.Text + '::::' + Apelido.Text);
    C_Texto.Text := '';
  end;
end;

{ Procedimento executado logo apos o server come�ar a escutar a porta Padr�o
{ Uma mensagem eh enviada para a tela de status}
procedure TFormCliente.S_ServerListen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Servidor ::> Servidor Ligado!');
end;

{ Procedimento do Servidor para quando um cliente se conecta}
procedure TFormCliente.S_ServerClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Servidor ::> Usu�rio Conectado => '+ Socket.RemoteAddress);
end;

{ Procedimento do Servidor para quando um cliente se desconecta}
procedure TFormCliente.S_ServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   Status.Lines.Add('Servidor ::> Usu�rio Desconectado => '+ Socket.RemoteAddress);
end;

{ Procedimento executado quando o servidor recebe dados dos clientes }
procedure TFormCliente.FormCreate(Sender: TObject); {Limpa o quadro}
begin
  Quadro.Text := '';
end;

end.
