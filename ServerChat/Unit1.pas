unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    S_Server: TServerSocket;
    Servir: TButton;
    Status: TMemo;
    procedure ServirClick(Sender: TObject);
    procedure S_ServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure S_ServerClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure S_ServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure S_ServerListen(Sender: TObject; Socket: TCustomWinSocket);
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
  if S_Server.Active = True then
  begin
    S_Server.Active := False;
    Status.Lines.Add('Servidor ::> Servidor Desligado!');
    Servir.Caption := 'Iniciar Servidor';
    //S_Cliente.Active := False;
    //Host.Enabled := True;
    //Conectar.Enabled := True;
  end
  else
  begin
    S_Server.Active := True;
    Servir.Caption := 'Parar Servidor';
    //Host.Enabled := False;
    //Conectar.Enabled := False;
    //S_Cliente.Host := '127.0.0.1';
    //S_Cliente.Active := True;
   end;
end;

procedure TForm1.S_ServerClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Servidor ::> Usuário Conectado => '+ Socket.RemoteAddress);
end;

procedure TForm1.S_ServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Servidor ::> Usuário Desconectado => '+ Socket.RemoteAddress);
end;

procedure TForm1.S_ServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
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
    //cxListBox1.Items.Add(texto[1]);
    //if not(ChatFal.Active) then
     //dxAlert.Show(texto[1]+' entrou','',0);
   end
   else
   begin
    with S_Server.Socket do
    begin {Se nao for de entrada, então eh msg normal, no caso passa para todos a msg}
    for Index := 0 to ActiveConnections-1 do
    begin
      Connections[Index].SendText('(' + texto[1] + ') escreveu: ' + texto[0]);
    end;
    end;
   Status.Lines.Add('Servidor ::> ' + texto[1] + ' (' + Socket.RemoteAddress + ') escreveu: '+ texto[0]);
   //if not(ChatFal.Active) then
     //dxAlert.Show(texto[1]+' disse',texto[0],0);
   end;
end;

procedure TForm1.S_ServerListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  Status.Lines.Add('Servidor ::> Servidor Ligado!');
end;

end.
