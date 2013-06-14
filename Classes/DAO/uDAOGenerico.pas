unit uDAOGenerico;

interface

uses uDBQueryIons;

type
  TDAOGenerico = class
  protected
    FDBQueryIons: TDBQueryIons;  
    procedure BeginTransaction(const ADBQueryIons: TDBQueryIons = nil);
    procedure EndTransaction;
  public
    constructor Create;
  end;
implementation

{ TDAOGenerico }

procedure TDAOGenerico.BeginTransaction(const ADBQueryIons: TDBQueryIons);
begin
  if ADBQueryIons <> nil then
  begin
    FDBQueryIons := ADBQueryIons;
  end else
    FDBQueryIons.BeginTransaction;
end;

constructor TDAOGenerico.Create;
begin
  FDBQueryIons := TDBQueryIons.Create;
end;

procedure TDAOGenerico.EndTransaction;
begin
  FDBQueryIons.EndTransaction;
end;

end.
