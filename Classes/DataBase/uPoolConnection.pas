unit uPoolConnection;

interface

uses
  uCustomDBConnection, uPostgreDBConection, Contnrs, DateUtils, Classes;

type
  TItemPoolCon = class
  private
    FConnection: TCustomDBConnection;
    FThreadId: Int64;
    FStartConnection: TDateTime;
    FInUso: Boolean;
  public
    constructor Create(AThreadId: Int64; AConnection: TCustomDBConnection);

    destructor Destroy; override;
    property Connection: TCustomDBConnection read FConnection;
    property ThreadId: Int64 read FThreadId;
    property StartConnection: TDateTime read FStartConnection;
  end;

  TListPoolConection = class
  private
  FOwnerList: TObjectList;
  public
    constructor Create;
    destructor Destroy;

    function Count: Integer;
    procedure CreateNewConnectionOnThePool(AThreadId: Int64; ADBConnector: TDBConnetions;out AItemPool: TItemPoolCon);
    procedure GetDBPoolByThreadId(AThreadId: Int64; out AItemPool: TItemPoolCon);

    procedure RemoveConnectionPendents;
  end;

  TThreadConnections = class(TThread)
  protected
    procedure Execute; override;

  end;

var
  ListaPool: TListPoolConection;
  
implementation

uses SysUtils;
{ TItemPoolCon }

constructor TItemPoolCon.Create(AThreadId: Int64;
  AConnection: TCustomDBConnection);
begin
  FConnection := AConnection;
  FThreadId := AThreadId;
  FStartConnection := Now;
  FInUso := True;
end;

function TListPoolConection.Count: Integer;
begin
  Result := FOwnerList.Count;
end;

constructor TListPoolConection.Create;
begin
  FOwnerList := TObjectList.Create;
end;

procedure TListPoolConection.CreateNewConnectionOnThePool(AThreadId: Int64; ADBConnector: TDBConnetions;
  out AItemPool: TItemPoolCon);
var
  LCustomConnection: TCustomDBConnection;
  LITemList: TItemPoolCon;
begin
  case ADBConnector of
    dbcPostgres: LCustomConnection := TPostgreDBConection.Create;
  end;

  AItemPool := TItemPoolCon.Create(AThreadId, LCustomConnection);
//  LITemList := TItemPoolCon.Create(AThreadId, LCustomConnection);
//  FOwnerList.Add(LITemList);
  FOwnerList.Add(AItemPool);
end;

destructor TListPoolConection.Destroy;
begin
  FreeAndNil(FOwnerList);
end;

procedure TListPoolConection.GetDBPoolByThreadId(AThreadId: Int64;
  out AItemPool: TItemPoolCon);
var
  i: Integer;
  LItemPool: TItemPoolCon;
begin
  for i := 0 to FOwnerList.Count -1 do
  begin
    LItemPool := TItemPoolCon(FOwnerList.Items[i]);
    if LItemPool.ThreadId = AThreadId then
    begin
      AItemPool := LItemPool;
      Exit;
    end;
  end;
end;

procedure TListPoolConection.RemoveConnectionPendents;
var
  i: Integer;
  LItemPool: TItemPoolCon;
begin
  for i := FOwnerList.Count -1 downto 0 do
  begin
    LItemPool := TItemPoolCon(FOwnerList.Items[i]);
    if (SecondsBetween(Now, LItemPool.StartConnection) >= 5) and (not LItemPool.Connection.InUse) then
      FOwnerList.Delete(i);
  end;

  Writeln(Format('TListPoolConection.RemoveConnectionPendents: Quantidade de conexoes %d', [FOwnerList.Count]));
end;

destructor TItemPoolCon.Destroy;
begin
  FreeAndNil(FConnection);
  inherited;
end;

{ TThreadConnections }

procedure TThreadConnections.Execute;
begin
  while True do
  begin
    ListaPool.RemoveConnectionPendents;
    Sleep(5000);  
  end;
end;

end.

