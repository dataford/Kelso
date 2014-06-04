program dfKelso;

uses
  Vcl.Forms,
  uDFMain in 'uDFMain.pas' {fmDFMain},
  IApp in '..\intf\IApp.pas',
  uAppObj in 'intf_obj\uAppObj.pas',
  Spring.Container,
  IDatabase in '..\intf\IDatabase.pas',
  uDBFirebirdObj in 'intf_obj\uDBFirebirdObj.pas',
  uFBConnEditor in 'intf_obj\uFBConnEditor.pas' {fmFBConnEditor},
  klsConsts in '..\intf\klsConsts.pas',
  uDBUsersObj in 'intf_obj\uDBUsersObj.pas',
  uDBObj in 'intf_obj\uDBObj.pas',
  uDFLogin in 'users\uDFLogin.pas' {fmDFLogin},
  klsUtils in 'klsUtils.pas';

{$R *.res}

begin
  GlobalContainer.Build;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmDFMain, fmDFMain);
  Application.Run;
end.
