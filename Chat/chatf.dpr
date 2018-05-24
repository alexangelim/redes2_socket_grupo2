program chatf;

uses
  Forms,
  chat in 'chat.pas' {FormCliente},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(TFormCliente, FormCliente);
  Application.Run;
end.
