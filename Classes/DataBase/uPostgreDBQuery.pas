unit uPostgreDBQuery;

interface

uses uPoolConnection, Windows, uPostgreDBConection, uCustomDBConnection, uCustomDBQuery, SqlExpr, DBXpress;

type
  TPostgreDBQuery = class(TCustomDBQuery)
  private
  FQuery: TSQLQuery;
  public
    constructor Create;
    procedure BeginTransaction; override;
    procedure EndTransaction; override;

    destructor Destroy; override;

    procedure Open; override;
    procedure Execute; override;
    
    procedure SetSQL(ASQL: string); override;
    procedure SetParam(AFieldName: string; AValue: Integer); overload; override;
    procedure SetParam(AFieldName: string; AValue: Extended); overload; override;
    procedure SetParam(AFieldName: string; AValue: Int64); overload; override;
    procedure SetParam(AFieldName: string; AValue: string); overload; override;
    procedure SetParamDateTime(AFieldName: string; AValue: TDateTime);overload; override;

    function Field(AFieldName: string): Variant; overload; override;
    function FieldDateTime(AFieldName: string): TDateTime; overload; override;

    procedure Next; override;

    function Eof: Boolean; override;
    function RecordCount: Integer; override;
  end;
implementation

uses SysUtils, DB, DateUtils;

{ TAdoDBQuery }
procedure TPostgreDBQuery.BeginTransaction;
var
  Transacao: TTransactionDesc;
begin
//  FQuery.SQLConnection.StartTransaction(TPostgreDBConection(FCustomDBConnection).Transaction);
  Transacao.TransactionID := DateTimeToUnix(Now);
  Transacao.GlobalID := DateTimeToUnix(Now);
  Transacao.IsolationLevel := xilREADCOMMITTED;
  WriteLn('abertura transacao: ' + IntToStr(Transacao.TransactionID) );
  TPostgreDBConection(FCustomDBConnection).Transaction := Transacao;
  FQuery.SQLConnection.StartTransaction(Transacao);
end;

constructor TPostgreDBQuery.Create;
var
  LItem: TItemPoolCon;
begin
  LItem := nil;
  ListaPool.GetDBPoolByThreadId(Windows.GetCurrentThreadId(), LItem);
  if LItem = nil then
    ListaPool.CreateNewConnectionOnThePool(Windows.GetCurrentThreadId(), dbcPostgres, LItem);

  FCustomDBConnection := LItem.Connection;
  FQuery := TSQLQuery.Create(nil);
  FQuery.SQLConnection := TPostgreDBConection(FCustomDBConnection).Connection;
end;

procedure TPostgreDBQuery.EndTransaction;
begin
  try
    FQuery.SQLConnection.Commit(TPostgreDBConection(FCustomDBConnection).Transaction);
    WriteLn('Commi transacao: ' + IntToStr(TPostgreDBConection(FCustomDBConnection).Transaction.TransactionID));
  except
    FQuery.SQLConnection.Rollback(TPostgreDBConection(FCustomDBConnection).Transaction);
  end;
end;

procedure TPostgreDBQuery.SetParam(AFieldName: string; AValue: Integer);
begin
  FQuery.ParamByName(AFieldName).Value := AValue;
end;

procedure TPostgreDBQuery.Open;
begin
  FQuery.Open;
end;

procedure TPostgreDBQuery.SetParam(AFieldName, AValue: string);
begin
  FQuery.ParamByName(AFieldName).Value := AValue;
end;

procedure TPostgreDBQuery.SetParam(AFieldName: string; AValue: Int64);
begin
  FQuery.ParamByName(AFieldName).Value := AValue;
end;

procedure TPostgreDBQuery.SetParam(AFieldName: string; AValue: Extended);
begin
  FQuery.ParamByName(AFieldName).Value := AValue;
end;

procedure TPostgreDBQuery.SetSQL(ASQL: string);
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(ASQL);
  WriteLn('SQL: ' + ASQL);
end;

destructor TPostgreDBQuery.Destroy;
begin
  inherited;
end;

function TPostgreDBQuery.FieldDateTime(AFieldName: string): TDateTime;
begin
  Result := FQuery.FieldByName(AFieldName).AsDateTime;
end;

function TPostgreDBQuery.Eof: Boolean;
begin
  Result := FQuery.Eof;
end;

procedure TPostgreDBQuery.Next;
begin
  FQuery.Next;
end;

function TPostgreDBQuery.RecordCount: Integer;
begin
  Result := FQuery.RecordCount;
end;

function TPostgreDBQuery.Field(AFieldName: string): Variant;
begin
  Result := FQuery.FieldByName(AFieldName).Value;
end;

procedure TPostgreDBQuery.SetParamDateTime(AFieldName: string;
  AValue: TDateTime);
begin
  FQuery.ParamByName(AFieldName).Value := AValue;
end;

procedure TPostgreDBQuery.Execute;
begin
  WriteLn('TPostgreDBQuery.Execute ');
  FQuery.ExecSQL;
end;

end.

