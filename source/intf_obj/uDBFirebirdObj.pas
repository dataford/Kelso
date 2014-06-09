unit uDBFirebirdObj;

interface

implementation

uses
  System.Classes, Vcl.Forms, Spring.Container,
  uFBConnEditor, pFIBDatabase, Vcl.Dialogs, System.Generics.Collections,
  uDBObj, IDatabase, pFIBQuery, System.Variants, FIBQuery, pFIBProps, Data.DB,
  ibase;

type
  TdfFirebird = class(TdfDatabase)
  private
    FDatabase: TpFIBDatabase;
  public
    constructor Create; override;
    destructor Destroy; override;
    function EditProp: Boolean; override;
    function Connected: Boolean; override;
    function Reconnect: Boolean; override;
    procedure Disconnect; override;
    function GetDatabase: TpFIBDatabase;
  end;

  TdfFirebirdCursor = class(TInterfacedObject, IdfCursor)
  private
    FQuery: TpFIBQuery;
    FDatabase: IdfDatabase;
  public
    constructor Create;
    destructor Destroy; override;
  public
    procedure SetDatabase(const AValue: IdfDatabase);
    procedure SetSQLStmt(const SQLStmt: string);
    procedure SetCursorType(AType: TdfCursorType);
    procedure Open(const Args: array of variant);
    procedure AttachCursor(ACursor: IdfCursor);
    procedure Close(TransactionCommit, TransactionFree: Boolean);
    function EOF: Boolean;
    procedure Next;
    function FieldCount: Integer;
    function Field(const NameOrIndex: Variant): IdfField;
  public
  end;

{ TdfFirebird }

function TdfFirebird.Connected: Boolean;
begin
     Result := FDatabase.Connected;
end;

constructor TdfFirebird.Create;
begin
     inherited;
     FDatabase := TpFIBDatabase.Create(nil);
     FDatabase.DBParams.Values['lc_ctype'] := 'WIN1251';
     FDatabase.SQLDialect := 3;
     FDatabase.LibraryName := 'fbclient.dll';
end;

destructor TdfFirebird.Destroy;
begin
     ShowMessage('TdfFirebird.Destroy');
     FDatabase.Free;
     inherited;
end;

procedure TdfFirebird.Disconnect;
begin
     inherited;
     FDatabase.Connected := false;
end;

function TdfFirebird.EditProp: Boolean;
begin
     Result := TfmFBConnEditor.Edit(DBInfo);
end;

function TdfFirebird.GetDatabase: TpFIBDatabase;
begin
     Result := FDatabase;
end;

function TdfFirebird.Reconnect: Boolean;
begin
     Result := false;
     FDatabase.Connected := false;
     with FDatabase do
     begin
       DatabaseName := TfmFBConnEditor.MakeConnStr(DBInfo);
       ConnectParams.UserName := DBInfo.Values['User'];
       ConnectParams.Password := DBInfo.Values['Password'];
       LibraryName := DBInfo.Values['ClientLibrary'];
     end;
     try
       FDatabase.Connected := true;
       if FDatabase.Connected then
        Result := true;
     except
//       on e: exception do
//        ShowMessage(e.);
     end;
end;

{ TdfFirebirdCursor }

procedure TdfFirebirdCursor.AttachCursor(ACursor: IdfCursor);
var fc: TdfFirebirdCursor;
begin
     fc := ACursor as TdfFirebirdCursor;
     if Assigned(fc.FQuery.Transaction) then
      fc.FQuery.Transaction.Free;
     fc.FQuery.Transaction := FQuery.Transaction;
end;

procedure TdfFirebirdCursor.Close(TransactionCommit, TransactionFree: Boolean);
begin
     if Assigned(FQuery.Transaction) then
     begin
      if FQuery.Transaction.InTransaction then
       if TransactionCommit then
        FQuery.Transaction.Commit else
        FQuery.Transaction.Rollback;
      if TransactionFree then
      begin
        FQuery.Transaction.Free;
        FQuery.Transaction := nil;
      end;
     end;
     FQuery.Close;
end;

constructor TdfFirebirdCursor.Create;
begin
     FQuery := TpFIBQuery.Create(nil);
     FQuery.Options := [qoStartTransaction, qoTrimCharFields];
end;

destructor TdfFirebirdCursor.Destroy;
begin
     FQuery.Free;
     FDatabase := nil;
     inherited;
end;

function TdfFirebirdCursor.EOF: Boolean;
begin
     Result := FQuery.Eof;
end;

function TdfFirebirdCursor.Field(const NameOrIndex: Variant): IdfField;
 function mvbFBSQLTypeToFieldType(SQLType: integer): TFieldType;
 begin
      Result := ftUnknown;
      case SQLType of
        SQL_VARYING, SQL_TEXT: Result := ftString;
        SQL_DOUBLE, SQL_FLOAT, SQL_D_FLOAT: Result := ftFloat;
        SQL_LONG, SQL_SHORT, SQL_INT64: Result := ftInteger;
        SQL_TIMESTAMP, SQL_TYPE_TIME, SQL_TYPE_DATE{, SQL_DATE}: Result := ftDateTime;
        SQL_BOOLEAN: Result := ftBoolean;
      end;
 end;
var f: TFIBXSQLVAR;
begin
     if VarIsNumeric(NameOrIndex) then
      f := FQuery.Fields[NameOrIndex] else
      f := FQuery.FN(NameOrIndex);
     Result.Name := f.Name;
     Result.FieldValue := f.Value;
     Result.FieldType := mvbFBSQLTypeToFieldType(f.SQLType);
end;

function TdfFirebirdCursor.FieldCount: Integer;
begin
     Result := FQuery.FieldCount;
end;

procedure TdfFirebirdCursor.Next;
begin
     FQuery.Next;
end;

procedure TdfFirebirdCursor.Open(const Args: array of variant);
begin
     FQuery.ExecWP(Args);
end;

procedure TdfFirebirdCursor.SetCursorType(AType: TdfCursorType);
begin
     if FQuery.Transaction <> nil then
      FQuery.Transaction.Free;
     FQuery.Transaction := TpFIBTransaction.Create(nil);
     FQuery.Transaction.DefaultDatabase := FQuery.Database;
     with TpFIBTransaction(FQuery.Transaction) do
     begin
      TRParams.Clear;
      case AType of
        ctReadOnly: begin
                      TPBMode := tpbDefault;
                      TRParams.Add('read');
                      TRParams.Add('nowait');
                    end;
        ctWriteOnly: begin
                       TPBMode := tpbReadCommitted;
                       TRParams.Add('write');
                       TRParams.Add('nowait');
                     end;
        ctReadWrite: begin
                       TPBMode := tpbReadCommitted;
                       TRParams.Add('write');
                       TRParams.Add('nowait');
                     end;
      end;
      TRParams.Add('rec_version');
      TRParams.Add('read_committed');
     end;
end;

procedure TdfFirebirdCursor.SetDatabase(const AValue: IdfDatabase);
begin
     FDatabase := AValue;
     FQuery.Database := (AValue as TdfFirebird).GetDatabase;
end;

procedure TdfFirebirdCursor.SetSQLStmt(const SQLStmt: string);
begin
     FQuery.Close;
     FQuery.SQL.Text := SQLStmt;
     FQuery.Prepare;
end;

initialization
  Spring.Container.GlobalContainer.RegisterType<TdfFirebird>.Implements<IdfDatabase>('Firebird').DelegateTo
   (
     function: TdfFirebird
     begin
       Result := TdfFirebird.Create;
     end
    );

  Spring.Container.GlobalContainer.RegisterType<TdfFirebirdCursor>.Implements<IdfCursor>('FirebirdCursor').DelegateTo
   (
     function: TdfFirebirdCursor
     begin
       Result := TdfFirebirdCursor.Create;
     end
    );
end.
