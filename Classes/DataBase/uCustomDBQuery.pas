unit uCustomDBQuery;

interface

uses uCustomDBConnection;

type
  ICustomDBQuery = interface
  ['{F605C86B-711B-433F-81E4-B5787CC17227}']
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

  TCustomDBQuery = class;

  TFactoryDBQuery = class
    class function FactoryDBQuery(ADBConnection: TDBConnetions): TCustomDBQuery;
  end;

  TCustomDBQuery = class(TInterfacedObject, ICustomDBQuery)
  protected
  FCustomDBConnection: TCustomDBConnection;
  public
    procedure BeginTransaction; virtual;abstract;
    procedure EndTransaction; virtual;abstract;

    destructor Destroy; override;

    procedure Open; virtual;abstract;
    procedure Execute; virtual;abstract;

    procedure SetSQL(ASQL: string); virtual;abstract;
    procedure SetParam(AFieldName: string; AValue: Integer); overload; virtual;abstract;
    procedure SetParam(AFieldName: string; AValue: Extended); overload; virtual;abstract;
    procedure SetParam(AFieldName: string; AValue: Int64); overload; virtual;abstract;
    procedure SetParam(AFieldName: string; AValue: string); overload; virtual;abstract;
    procedure SetParamDateTime(AFieldName: string; AValue: TDateTime);overload; virtual; abstract;

    function Field(AFieldName: string): Variant; virtual;abstract;
    function FieldDateTime(AFieldName: string): TDateTime; virtual;abstract;

    procedure Next; virtual;abstract;

    function Eof: Boolean; virtual;abstract;
    function RecordCount: Integer; virtual;abstract;
  end;
  
implementation

uses uPostgreDBQuery, SysUtils;

{ TFactoryDBQuery }

class function TFactoryDBQuery.FactoryDBQuery(
  ADBConnection: TDBConnetions): TCustomDBQuery;
begin
  Result := nil;
  case ADBConnection of
    dbcPostgres: Result := TPostgreDBQuery.Create;
  end;
end;

{ TCustomDBQuery }

destructor TCustomDBQuery.Destroy;
begin
  FCustomDBConnection.InUse := False;
end;

end.

