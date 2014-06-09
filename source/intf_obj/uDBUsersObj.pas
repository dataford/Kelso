unit uDBUsersObj;

interface

implementation

uses
  IDatabase, Spring.Container, System.SysUtils,
  klsConsts, Spring.Services, Vcl.Dialogs, Spring.Collections,
  Spring.Collections.Lists;

type
  TdfUser = class (TInterfacedObject, IdfUser)
  private
    FID: TID;
    FName: string;
  public
    function ID: TID;
    function Name: string;
    procedure LoadFromCursor(ACursor: IdfCursor);
    destructor Destroy; override;
  end;

  TdfUserList = class (TInterfacedObject, IdfUserList)
  private
    FList: TObjectList<TdfUser>;
    FDatabase: IdfDatabase;
    FActiveUserID: TID;
    procedure SetDatabase(const Value: IdfDatabase);
    function GetDatabase: IdfDatabase;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromDatabase: Boolean;
    function ActiveUser: IdfUser;
    procedure SetActiveUser(UserID: TID);
    function Count: Integer;
    function User(AIndex: Integer): IdfUser;
  public
    property Database: IdfDatabase read GetDatabase write SetDatabase;
  end;

////////////////////////////////////////////////////////////////////////////////

{ TfbUser }

destructor TdfUser.Destroy;
begin
     _Release;
     inherited;
end;

function TdfUser.ID: TID;
begin
     Result := FID;
end;

procedure TdfUser.LoadFromCursor(ACursor: IdfCursor);
begin
     FID := ACursor.Field('ID').GetAsInt64;
     FName := ACursor.Field('NAME').GetAsString;
end;

function TdfUser.Name: string;
begin
     Result := FName;
end;

{ TdfUserList }

function TdfUserList.ActiveUser: IdfUser;
var u: TdfUser;
begin
     for u in FList do
      if u.ID = FActiveUserID then
       exit(u);
     Result := nil;
end;

function TdfUserList.Count: Integer;
begin
     Result := FList.Count;
end;

constructor TdfUserList.Create;
begin
     FDatabase := nil;
     FList := TObjectList<TdfUser>.Create(false);
     FActiveUserID := iUndefinedActiveUser;
end;

destructor TdfUserList.Destroy;
begin
     ShowMessage('TdfUserList.Destroy');
     FreeAndNil(FList);
     FDatabase := nil;
     inherited;
end;

function TdfUserList.GetDatabase: IdfDatabase;
begin
     Result := FDatabase;
end;

function TdfUserList.LoadFromDatabase: Boolean;
var c: IdfCursor;
    u: TdfUser;
begin
     Result := true;
     FList.Clear;
     c := FDatabase.CursorCreate('select * from DF$USERS where EPV > current_date', []);
     try
       while not c.EOF do
       begin
         u := ServiceLocator.GetService<IdfUser>('UserDefault') as TdfUser;
         u.LoadFromCursor(c);
         FList.Add(u);
//         u._AddRef;
         c.Next;
       end;
     finally
       c.Close(true, true);
     end;
end;

procedure TdfUserList.SetActiveUser(UserID: TID);
begin
     FActiveUserID := UserID;
end;

procedure TdfUserList.SetDatabase(const Value: IdfDatabase);
begin
     FDatabase := Value;
end;

function TdfUserList.User(AIndex: Integer): IdfUser;
begin
     Result := FList[AIndex];
end;

initialization
  Spring.Container.GlobalContainer.RegisterType<TdfUser>.Implements<IdfUser>('UserDefault').DelegateTo
   (
     function: TdfUser
     begin
       Result := TdfUser.Create;
     end
    );

  Spring.Container.GlobalContainer.RegisterType<TdfUserList>.Implements<IdfUserList>('UserListDefault').DelegateTo
   (
     function: TdfUserList
     begin
       Result := TdfUserList.Create;
     end
    );
end.
