unit uDBQueryIons;

interface

uses uCustomDBQuery, uCustomDBConnection;

type
  TDBQueryIons = class
  private
    FCustomDBQuery: TCustomDBQuery;
  protected
  public
    constructor Create;

    destructor Destroy; override;
    procedure BeginTransaction;
    procedure EndTransaction;

    procedure Open;
    procedure Execute;

    procedure SetSQL(ASQL: string);
    procedure SetParam(AFieldName: string; AValue: Integer); overload;
    procedure SetParam(AFieldName: string; AValue: Extended); overload;
    procedure SetParam(AFieldName: string; AValue: Int64); overload;
    procedure SetParam(AFieldName: string; AValue: string); overload;
    procedure SetParamDateTime(AFieldName: string; AValue: TDateTime);

    function Field(AFieldName: string): Variant;
    function FieldDateTime(AFieldName: string): TDateTime;

    procedure Next;

    function Eof: Boolean;
    function RecordCount: Integer;
  end;

implementation

{ TDBQueryIons }

procedure TDBQueryIons.BeginTransaction;
begin
  FCustomDBQuery.BeginTransaction;
end;

constructor TDBQueryIons.Create;
begin
  FCustomDBQuery := TFactoryDBQuery.FactoryDBQuery(dbcPostgres);
end;

procedure TDBQueryIons.EndTransaction;
begin
  FCustomDBQuery.EndTransaction;
end;

procedure TDBQueryIons.SetParam(AFieldName: string; AValue: Integer);
begin
  FCustomDBQuery.SetParam(AFieldName, AValue);
end;

procedure TDBQueryIons.Open;
begin
  FCustomDBQuery.Open;
end;

procedure TDBQueryIons.SetParam(AFieldName, AValue: string);
begin
  FCustomDBQuery.SetParam(AFieldName, AValue);
end;

procedure TDBQueryIons.SetParam(AFieldName: string; AValue: Int64);
begin
  FCustomDBQuery.SetParam(AFieldName, AValue);
end;

procedure TDBQueryIons.SetParam(AFieldName: string; AValue: Extended);
begin
  FCustomDBQuery.SetParam(AFieldName, AValue);
end;

procedure TDBQueryIons.SetSQL(ASQL: string);
begin
  FCustomDBQuery.SetSQL(ASQL);
end;

destructor TDBQueryIons.Destroy;
begin
  FCustomDBQuery.Free;
end;

function TDBQueryIons.Eof: Boolean;
begin
  Result := FCustomDBQuery.Eof;
end;

procedure TDBQueryIons.Next;
begin
  FCustomDBQuery.Next;
end;

function TDBQueryIons.RecordCount: Integer;
begin
  result := FCustomDBQuery.RecordCount;
end;

procedure TDBQueryIons.SetParamDateTime(AFieldName: string;
  AValue: TDateTime);
begin
  FCustomDBQuery.SetParamDateTime(AFieldName, AValue);
end;

function TDBQueryIons.Field(AFieldName: string): Variant;
begin
  Result := FCustomDBQuery.Field(AFieldName);
end;

function TDBQueryIons.FieldDateTime(AFieldName: string): TDateTime;
begin
  Result := FCustomDBQuery.FieldDateTime(AFieldName);
end;

procedure TDBQueryIons.Execute;
begin
  FCustomDBQuery.Execute;
end;

end.

