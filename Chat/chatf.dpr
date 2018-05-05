program chatf;

uses
  Forms,
  chat in 'chat.pas' {FormCliente};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormCliente, FormCliente);
  Application.Run;
end.
