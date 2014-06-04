unit uFBConnEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, FIBDatabase, pFIBDatabase, Vcl.ImgList;

type
  {TFBServerType = (stLocal, stRemote);
  TFBConnInfo = record
    Name: string;
    SrvType: TFBServerType;
    SrvName: string;
    Port: string;
    DBName: string;
    User: string;
    Password: string;
    ClientLibrary: string;
    function MakeConnStr: string;
  end;   }

  TfmFBConnEditor = class(TForm)
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cmbSrvType: TComboBox;
    edSrvName: TEdit;
    edDBName: TButtonedEdit;
    edUser: TEdit;
    edPwd: TEdit;
    edLib: TButtonedEdit;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    bbTest: TBitBtn;
    Label8: TLabel;
    edPort: TEdit;
    pFIBDatabase1: TpFIBDatabase;
    pFIBTransaction1: TpFIBTransaction;
    ImageList1: TImageList;
    procedure bbTestClick(Sender: TObject);
    procedure edDBNameRightButtonClick(Sender: TObject);
    procedure edLibRightButtonClick(Sender: TObject);
    procedure cmbSrvTypeChange(Sender: TObject);
  private
    procedure ControlsToInfo(Info: TStrings);
  public
    class function Edit(Info: TStrings): Boolean;
    class function MakeConnStr(Info: TStrings): string;
  end;

implementation

{$R *.dfm}

{ TfmFBConnEditor }

procedure TfmFBConnEditor.bbTestClick(Sender: TObject);
var info: TStrings;
begin
     info := TStringList.Create;
     try
       ControlsToInfo(info);
       with pFIBDatabase1 do
       begin
         Connected := false;
         DatabaseName := MakeConnStr(info);
         ConnectParams.UserName := info.Values['User'];
         ConnectParams.Password := info.Values['Password'];
         LibraryName := info.Values['ClientLibrary'];
         try
           Connected := true;
           ShowMessage('Успешное соединение!');
         except
           on E: Exception do
             ShowMessage(E.Message);
         end;
       end;
     finally
       pFIBDatabase1.Connected := false;
       info.Free;
     end;
end;

procedure TfmFBConnEditor.cmbSrvTypeChange(Sender: TObject);
begin
     edSrvName.Enabled := cmbSrvType.ItemIndex = 1;
end;

procedure TfmFBConnEditor.ControlsToInfo(Info: TStrings);
begin
     Info.Values['Name'] := edName.Text;
     Info.Values['SrvType'] := IntToStr(cmbSrvType.ItemIndex);
     Info.Values['SrvName'] := edSrvName.Text;
     Info.Values['Port'] := edPort.Text;
     Info.Values['DBName'] := edDBName.Text;
     Info.Values['User'] := edUser.Text;
     Info.Values['Password'] := edPwd.Text;
     Info.Values['ClientLibrary'] := edLib.Text;
end;

procedure TfmFBConnEditor.edDBNameRightButtonClick(Sender: TObject);
var fn: string;
begin
     fn := edDBName.Text;
     if PromptForFileName(fn) then
      edDBName.Text := fn;
end;

class function TfmFBConnEditor.Edit(Info: TStrings): Boolean;
begin
     with TfmFBConnEditor.Create(nil) do
     try
       edName.Text := Info.Values['Name'];
       edName.Enabled := not SameText(edName.Text, 'System');
       cmbSrvType.ItemIndex := StrToIntDef(Info.Values['SrvType'], 0);
       cmbSrvTypeChange(nil);
       edSrvName.Text := Info.Values['SrvName'];
       edPort.Text := Info.Values['Port'];
       edDBName.Text := Info.Values['DBName'];
       edUser.Text := Info.Values['User'];
       edPwd.Text := Info.Values['Password'];
       edLib.Text := Info.Values['ClientLibrary'];
       Result := ShowModal = mrOk;
       if Result then
        ControlsToInfo(Info);
     finally
       Free;
     end;
end;

procedure TfmFBConnEditor.edLibRightButtonClick(Sender: TObject);
var fn: string;
begin
     fn := edLib.Text;
     if PromptForFileName(fn, 'DLL Windows|*.dll') then
      edLib.Text := fn;
end;

class function TfmFBConnEditor.MakeConnStr(Info: TStrings): string;
begin
     Result := '';
     if Info.Values['SrvType'] = '1' then
      Result := Info.Values['SrvName'];
     if (Result <> '') and (Info.Values['Port'] <> '') then
      Result := Result + '/' + Info.Values['Port'] + ':';
     Result := Result + Info.Values['DBName'];
end;

end.
