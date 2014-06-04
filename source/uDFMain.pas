unit uDFMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IApp, IDatabase, klsConsts, Vcl.ComCtrls;

type
  TfmDFMain = class(TForm)
    sbStatus: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FApp: IdfApplication;
    FDBSystem: IdfDatabase;
    procedure WriteDBSystemInfo;
    procedure ReadDBSystemInfo;
    procedure klsMsgConnectHandle(var Msg: TMessage); message klsMsgConnect;
    procedure UpdateStatusBar;
  public
  end;

var
  fmDFMain: TfmDFMain;

implementation

uses
  Spring.Services, System.Win.Registry, uDFLogin, klsUtils;

{$R *.dfm}

procedure TfmDFMain.FormCreate(Sender: TObject);
begin
     WindowState := wsMaximized;
     FApp := ServiceLocator.GetService<IdfApplication>(implApplication);
     Caption := FApp.GetAppName;

     FDBSystem := ServiceLocator.GetService<IdfDatabase>(implDatabase);
     FDBSystem.DBInfo.Values['Name'] := 'System';
     ReadDBSystemInfo;
     PostMessage(Handle, klsMsgConnect, 0, 0);
end;

procedure TfmDFMain.FormDestroy(Sender: TObject);
begin
     if Assigned(FDBSystem) then
      FDBSystem.Disconnect;
     FDBSystem := nil;
end;

procedure TfmDFMain.klsMsgConnectHandle(var Msg: TMessage);
var uid: TID;
begin
     Msg.Result := 1;
     FDBSystem.Users.SetActiveUser(iUndefinedActiveUser);
     if not FDBSystem.Reconnect then
      if FDBSystem.EditProp and FDBSystem.Reconnect then
       WriteDBSystemInfo;
     if FDBSystem.Connected then
     begin
       if FDBSystem.Users.LoadFromDatabase and TfmDFLogin.Execute(FDBSystem, uid) then
       begin
         FDBSystem.Users.SetActiveUser(uid);
       end;
     end;
     UpdateStatusBar;
end;

procedure TfmDFMain.ReadDBSystemInfo;
var r: TRegistry;
begin
     r := TRegistry.Create;
     try
       r.RootKey := HKEY_LOCAL_MACHINE;
       if r.OpenKey(cSystemDatabaseRegistryPath, false) then
        with FDBSystem.DBInfo do
        begin
          Values['SrvType'] := r.ReadString('SrvType');
          Values['SrvName'] := r.ReadString('SrvName');
          Values['Port'] := r.ReadString('Port');
          Values['DBName'] := r.ReadString('DBName');
          Values['User'] := klsDecrypt(r.ReadString('User'));
          Values['Password'] := klsDecrypt(r.ReadString('Password'));
          Values['ClientLibrary'] := r.ReadString('ClientLibrary');
          r.CloseKey;
        end;
     finally
       r.Free;
     end;
end;

procedure TfmDFMain.UpdateStatusBar;
var u: IdfUser;
begin
     u := nil;
     if Assigned(FDBSystem) and Assigned(FDBSystem.Users) then
      u := FDBSystem.Users.ActiveUser;
     if Assigned(u) then
      sbStatus.Panels[0].Text := u.Name else
      sbStatus.Panels[0].Text := '<Гость>';
end;

procedure TfmDFMain.WriteDBSystemInfo;
var r: TRegistry;
    i: Integer;
begin
     r := TRegistry.Create;
     try
       r.RootKey := HKEY_LOCAL_MACHINE;
       r.DeleteKey(cSystemDatabaseRegistryPath);
       if not r.OpenKey(cSystemDatabaseRegistryPath, true) then
        raise Exception.CreateFmt('Ошибка при создании ключа реестра "%s"!', [cSystemDatabaseRegistryPath]);
       with FDBSystem.DBInfo do
        for i := 0 to Count-1 do
         if SameText('User', Names[i]) or SameText('Password', Names[i]) then
          r.WriteString(Names[i], klsEncrypt(Values[Names[i]])) else
          r.WriteString(Names[i], Values[Names[i]]);
       r.CloseKey;
     finally
       r.Free;
     end;
end;

end.
