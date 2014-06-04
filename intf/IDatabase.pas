unit IDatabase;

interface

uses
  System.Classes, Data.DB;

type
  TID = type Int64;
  TdfCursorType = (ctReadOnly, ctWriteOnly, ctReadWrite);

  IdfUser = interface;
  IdfUserList = interface;
  IdfCursor = interface;

  IdfDatabase = interface
    ['{F5EC35B3-9660-430C-AF70-7839985FBFEC}']
  // private
    function GetName: string;
    procedure SetName(const AValue: string);
    function GetDBInfo: TStrings;
  // public
    function EditProp: Boolean;
    function Connected: Boolean;
    function Reconnect: Boolean;
    procedure Disconnect;
    function Users: IdfUserList;
    function CursorCreate(const SQLStmt: string; const Args: array of variant; AType: TdfCursorType = ctReadOnly): IdfCursor;
    function CursorAttach(ACursor: IdfCursor; const SQLStmt: string; const Args: array of variant): IdfCursor;
  // public
    function QueryValueStr(const AStmt: string; const Args: array of variant): string;
    function QueryValueInt(const AStmt: string; const Args: array of variant; ADef: Int64 = 0): Int64;
    function QueryValueBool(const AStmt: string; const Args: array of variant; ADef: Boolean = false): Boolean;
  // public
    property Name: string read GetName write SetName;
    property DBInfo: TStrings read GetDBInfo;
  end;

  IdfUser = interface
    ['{5CC9B854-EE45-4DCE-B0E7-022B52AB3F36}']
    function ID: TID;
    function Name: string;
    procedure LoadFromCursor(ACursor: IdfCursor);
  end;

  IdfUserList = interface
    ['{1C46389D-E297-4313-8127-51E808510354}']
  // private
    procedure SetDatabase(const Value: IdfDatabase);
    function GetDatabase: IdfDatabase;
  // public
    function LoadFromDatabase: Boolean;
    function ActiveUser: IdfUser;
    procedure SetActiveUser(UserID: TID);
    function Count: Integer;
    function User(AIndex: Integer): IdfUser;
  // public
    property Database: IdfDatabase read GetDatabase write SetDatabase;
  end;

  IdfField = record
    Name: string;
    FieldType: TFieldType;
    FieldValue: Variant;
    function GetAsString: string;
    function GetAsInteger(ADef: Integer = 0): Integer;
    function GetAsInt64(ADef: Int64 = 0): Int64;
  end;

  IdfCursor = interface
    ['{7ECCA895-EB08-42E9-BE2C-55309ADE2944}']
  // private
  // public
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
  // public
  end;

implementation

uses
  System.SysUtils, System.Variants;

{ IdfField }

function IdfField.GetAsInteger(ADef: Integer): Integer;
begin
     Result := StrToIntDef(GetAsString, ADef);
end;

function IdfField.GetAsInt64(ADef: Int64): Int64;
begin
     Result := StrToInt64Def(GetAsString, ADef);
end;

function IdfField.GetAsString: string;
begin
     Result := VarToStr(FieldValue);
end;

end.
