unit klsUtils;

interface

function klsEncrypt(const S: string): string;
function klsDecrypt(const S: string): string;
function klsMD5(const S: string): string;

implementation

uses
  Spring.Cryptography;

const
  MySecretKey = 19750911;

function klsEncrypt(const S: string): string;
var des: IDES;
    key: TBuffer;
begin
     key.Create(MySecretKey);
     des := CreateDES;
     des.Key := key;
     Result := des.Encrypt(S).ToString;
end;

function klsDecrypt(const S: string): string;
var des: IDES;
    key: TBuffer;
begin
     key.Create(MySecretKey);
     des := CreateDES;
     des.Key := key;
     Result := des.Decrypt(S).ToString;
end;

function klsMD5(const S: string): string;
begin
     Result := CreateMD5.ComputeHash(S).ToString;
end;

end.
