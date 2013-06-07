unit uPostgreDBConection;

interface

uses
  uCustomDBConnection, SqlExpr, DBXpress, SysUtils;

type
  TPostgreDBConection = class(TCustomDBConnection)
    private
    FConnection: TSQLConnection;
    FTransaction: TTransactionDesc;
    protected
    function GetConnection: TSQLConnection;
    function GetTransaction: TTransactionDesc;
    procedure ConnectDataBase;override;
    public
      constructor Create; override;
      destructor Destroy; override;

      property Connection: TSQLConnection read GetConnection;
      property Transaction: TTransactionDesc read GetTransaction write FTransaction;
  end;
implementation

{ TAdoDBConnection }

procedure TPostgreDBConection.ConnectDataBase;
begin
  FConnection := TSQLConnection.Create(nil);
  try
    FConnection.ConnectionName := 'SSGPostgreSQL';
    FConnection.DriverName := 'PostgreSQL';
    FConnection.GetDriverFunc := 'getSQLDriverPOSTGRESQL';
    FConnection.LibraryName := 'dbexppge.dll';
    FConnection.LoginPrompt := False;
    FConnection.VendorLib := 'LIBPQ.DLL';

    FConnection.Close;
    FConnection.Params.Clear;
    FConnection.Params.Add('BlockingMode=True');
    FConnection.Params.Add('BlobSize=32');
    FConnection.Params.Add('ConnectionTimeout=60');
    FConnection.Params.Add('Database=' + FHostName + '/' +FDataBaseName);
    FConnection.Params.Add('DriverName=' + FDriverName);
    FConnection.Params.Add('User_Name=' + FUser);
    FConnection.Params.Add('Password=' + FPassWord);
    FConnection.Params.Add('AutoRecover=True               ');
    FConnection.Params.Add('Custom String = TextAsBlob = False, MapUnknownAsString = True');
    FConnection.KeepConnection := True;
    FConnection.Open;
  except
    on e: exception do
    Writeln(e.message);
  end;
end;

constructor TPostgreDBConection.Create;
begin
  inherited;
  ConnectDataBase;
end;

destructor TPostgreDBConection.Destroy;
begin
  FInUse := False;
  FreeAndNil(FConnection);
  inherited;
end;

function TPostgreDBConection.GetConnection: TSQLConnection;
begin
  Result := FConnection;
end;

function TPostgreDBConection.GetTransaction: TTransactionDesc;
begin
  Result := FTransaction;
end;

end.

