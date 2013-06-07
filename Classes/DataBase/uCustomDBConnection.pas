unit uCustomDBConnection;

interface

type

  TDBConnetions = (
    dbcPostgres
  );

  TCustomDBConnection = class
  private
  protected
    procedure ConnectDataBase; virtual; abstract;
  protected
    FHostName: string;
    FDataBaseName: string;
    FDriverName: string;
    FUser: string;
    FPassWord: string;

    FInUse: Boolean;
  public
    constructor Create; virtual;
    property DataBaseName: string read FDataBaseName write FDataBaseName;
    property DriverName: string read FDriverName write FDriverName;    
    property User: string read FUser write FUser;
    property PassWord: string read FPassWord write FPassWord;
    property HostName: string read FHostName write FHostName;

    property InUse: Boolean read FInUse write FInUse;
  end;
implementation

uses IniFiles, SysUtils;
{ TCustomDBConnection }

constructor TCustomDBConnection.Create;
var
  LArquivoIni: TIniFile;
begin
  LArquivoIni := TIniFile.Create(ExtractFilepath(ParamStr(0)) + 'ConfigSSG.ini');
  try
    FHostName := LArquivoIni.ReadString('DATABASE', 'SERVER_NAME', '');
    FDataBaseName := LArquivoIni.ReadString('DATABASE', 'DATABASE_NAME', '');
    FDriverName := LArquivoIni.ReadString('DATABASE', 'DRIVER_NAME', '');
    FUser := LArquivoIni.ReadString('DATABASE', 'USER_NAME', '');
    FPassWord := LArquivoIni.ReadString('DATABASE', 'PASSWORD', '');
  finally
    FreeAndNil(LArquivoIni);
  end;

  FInUse := True;
end;

end.

