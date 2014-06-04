unit uDBObj;

interface

uses
  IDatabase, System.Classes;

type
  TdfDatabase = class(TInterfacedObject, IdfDatabase)
  private
    FDBInfo: TStrings;
    FUserList: IdfUserList;
    function GetName: string;
    procedure SetName(const AValue: string);
    function GetDBInfo: TStrings;
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function EditProp: Boolean; virtual; abstract;
    function Connected: Boolean; virtual; abstract;
    function Reconnect: Boolean; virtual; abstract;
    procedure Disconnect; virtual;
    function Users: IdfUserList;
    function CursorCreate(const SQLStmt: string; const Args: array of variant; AType: TdfCursorType = ctReadOnly): IdfCursor;
    function CursorAttach(ACursor: IdfCursor; const SQLStmt: string; const Args: array of variant): IdfCursor;
   public
    function QueryValueStr(const AStmt: string; const Args: array of variant): string;
    function QueryValueInt(const AStmt: string; const Args: array of variant; ADef: Int64 = 0): Int64;
    function QueryValueBool(const AStmt: string; const Args: array of variant; ADef: Boolean = false): Boolean;
  public
    property Name: string read GetName write SetName;
    property DBInfo: TStrings read GetDBInfo;
  end;

implementation

uses
  Spring.Container, Spring.Services, klsConsts, System.SysUtils, Vcl.Dialogs;

{ TdfDatabase }

constructor TdfDatabase.Create;
begin
     FDBInfo := TStringList.Create;
     FUserList := ServiceLocator.GetService<IdfUserList>('UserListDefault');
     FUserList.Database := Self;
end;

function TdfDatabase.GetDBInfo: TStrings;
begin
     Result := FDBInfo;
end;

function TdfDatabase.GetName: string;
begin
     Result := DBInfo.Values['Name'];
end;

function TdfDatabase.QueryValueBool(const AStmt: string; const Args: array of variant; ADef: Boolean): Boolean;
var s: string;
begin
     s := QueryValueStr(AStmt, Args);
     if s = '' then
      Result := ADef else
      Result := (s = '1');
end;

function TdfDatabase.QueryValueInt(const AStmt: string; const Args: array of variant; ADef: Int64): Int64;
begin
     Result := StrToInt64Def(QueryValueStr(AStmt, Args), ADef);
end;

function TdfDatabase.QueryValueStr(const AStmt: string; const Args: array of variant): string;
var c: IdfCursor;
begin
     Result := '';
     c := CursorCreate(AStmt, Args, ctReadWrite);
     try
       if (c.FieldCount > 0) then
        Result := c.Field(0).GetAsString;
     finally
       c.Close(true, true);
     end;
end;

function TdfDatabase.CursorAttach(ACursor: IdfCursor; const SQLStmt: string; const Args: array of variant): IdfCursor;
begin
     Result := CursorCreate(SQLStmt, Args);
     ACursor.AttachCursor(Result);
end;

function TdfDatabase.CursorCreate(const SQLStmt: string; const Args: array of variant; AType: TdfCursorType = ctReadOnly): IdfCursor;
begin
     Result := ServiceLocator.GetService<IdfCursor>(implCursor);
     Result.SetDatabase(Self);
     Result.SetCursorType(AType);
     Result.SetSQLStmt(SQLStmt);
     Result.Open(Args);
end;

destructor TdfDatabase.Destroy;
begin
     ShowMessage('TdfDatabase.Destroy');
     FDBInfo.Free;
     FUserList := nil;
     inherited;
end;

procedure TdfDatabase.Disconnect;
begin
     Users.SetActiveUser(iUndefinedActiveUser);
end;

procedure TdfDatabase.SetName(const AValue: string);
begin
     DBInfo.Values['Name'] := AValue;
end;

function TdfDatabase.Users: IdfUserList;
begin
     Result := FUserList;
end;

end.
