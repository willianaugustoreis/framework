unit uDAOCliente;

interface

uses uModelCliente, uDAOGenerico;

type
  TDAOCliente = class(TDAOGenerico)
  private
    function GetSQLInsert: string;
  public
    procedure Insert(AModelCliente: TModelCliente);
    procedure Update(AModelCliente: TModelCliente);    
  end;
implementation

{ TDAOCliente }

function TDAOCliente.GetSQLInsert: string;
begin
  Result := '';
end;

procedure TDAOCliente.Insert(AModelCliente: TModelCliente);
begin
  BeginTransaction;
  try
    FDBQueryIons.SetSQL(GetSQLInsert);
    FDBQueryIons.SetParam('ID', AModelCliente.Id);
    FDBQueryIons.SetParam('NOME', AModelCliente.Nome);
    FDBQueryIons.Execute;    
  finally
    EndTransaction;
  end;
end;

procedure TDAOCliente.Update(AModelCliente: TModelCliente);
begin

end;

end.
