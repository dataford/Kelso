unit klsUtils;

interface

function klsEncrypt(const S: string): string;
function klsDecrypt(const S: string): string;
function klsMD5(const S: string): string;

implementation

uses
  Spring.Cryptography, System.SysUtils;

const
  MySecretKey = '0123456789abcdef';
  MySecretIV = '1234567890abcdef';

function klsEncrypt(const S: string): string;
var des: IDES;
    inBuf: TBuffer;
begin
     inBuf := TBuffer.Create(S);
     des := CreateDES;
     des.CipherMode := TCipherMode.ECB;
     des.PaddingMode := TPaddingMode.PKCS7;
     des.Key := TBuffer.FromHexString(MySecretKey);
     des.IV := TBuffer.FromHexString(MySecretIV);
     Result := des.Encrypt(inBuf).ToString;
end;

function klsDecrypt(const S: string): string;
var des: IDES;
    inBuf: TBuffer;
begin
     inBuf := TBuffer.FromHexString(S);
     des := CreateDES;
     des.CipherMode := TCipherMode.ECB;
     des.PaddingMode := TPaddingMode.PKCS7;
     des.Key := TBuffer.FromHexString(MySecretKey);
     des.IV := TBuffer.FromHexString(MySecretIV);
     Result := WideStringOf(des.Decrypt(inBuf).ToBytes);
end;

function klsMD5(const S: string): string;
begin
     Result := CreateMD5.ComputeHash(S).ToString;
end;

end.
