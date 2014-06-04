unit uDFLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IDatabase, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TfmDFLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    cmbName: TComboBox;
    edPwd: TEdit;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    Image1: TImage;
    Label3: TLabel;
    procedure bbOKClick(Sender: TObject);
  private
    FDatabase: IdfDatabase;
  public
    class function Execute(ADatabase: IdfDatabase; var UserID: TID): Boolean;
  end;

implementation

uses
  klsUtils;

{$R *.dfm}

{ TfmDFLogin }

procedure TfmDFLogin.bbOKClick(Sender: TObject);
var s: string;
    t: TID;
begin
     ModalResult := mrNone;
     if cmbName.ItemIndex < 0 then
     begin
       ShowMessage('Требуется выбрать пользователя!');
       exit;
     end;
     s := klsMD5(edPwd.Text + 'Шифрование данных средствами Delphi');
     t := FDatabase.QueryValueInt('select ID from DF$USERS where PWD=:PWD', [s]);
     if (t <> FDatabase.Users.User(cmbName.ItemIndex).ID) then
     begin
      ShowMessage('Неверный пароль!');
      exit;
     end;
     ModalResult := mrOk;
end;

class function TfmDFLogin.Execute(ADatabase: IdfDatabase; var UserID: TID): Boolean;
var i, ii: Integer;
begin
     with TfmDFLogin.Create(nil) do
     try
       FDatabase := ADatabase;
       ii := -1;
       for i := 0 to FDatabase.Users.Count-1 do
       begin
        cmbName.Items.Add(FDatabase.Users.User(i).Name);
        if FDatabase.Users.User(i).ID = UserID then
         ii := i;
       end;
       cmbName.ItemIndex := ii;
       Result := ShowModal = mrOk;
       if Result then
        UserID := FDatabase.Users.User(cmbName.ItemIndex).ID;
     finally
       Free;
     end;
end;

end.
