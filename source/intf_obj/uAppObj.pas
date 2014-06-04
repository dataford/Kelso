unit uAppObj;

interface

implementation

uses
  IApp, System.Classes, Spring.Utils, Vcl.Forms, Spring.Container;

type
  TdfApplication = class(TInterfacedObject, IdfApplication)
  private
    FAppVer: Spring.Utils.TFileVersionInfo;
  public
    constructor Create;
    function GetAppName: string;
    function GetAppVersion: string;
  end;

{ TdfApplication }

constructor TdfApplication.Create;
begin
     FAppVer := TFileVersionInfo.GetVersionInfo(Application.ExeName);
end;

function TdfApplication.GetAppName: string;
begin
     Result := FAppVer.ProductName;
end;

function TdfApplication.GetAppVersion: string;
begin
     Result := FAppVer.ProductVersionNumber.ToString;
end;

initialization
  Spring.Container.GlobalContainer.RegisterType<TdfApplication>.Implements<IdfApplication>('ApplicationDefault').DelegateTo
   (
     function: TdfApplication
     begin
       Result := TdfApplication.Create;
     end
    );
end.
