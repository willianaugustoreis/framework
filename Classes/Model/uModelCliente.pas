unit uModelCliente;

interface

type
  TModelCliente = class
  private
    FId: Integer;
    FNome: string;

    function IsNewObject: Boolean;
  public
    procedure Salvar;
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
  end;

implementation

uses uDAOCliente, SysUtils;

{ TModelCliente }

function TModelCliente.IsNewObject: Boolean;
begin
  Result := True;
end;

procedure TModelCliente.Salvar;
var
  LDAOCliente: TDAOCliente;
begin
  LDAOCliente := TDAOCliente.Create;
  try
    if IsNewObject then
      LDAOCliente.Insert(Self)
    else
      LDAOCliente.Update(Self)
  finally
    FreeAndNil(LDAOCliente);
  end;
end;

end.
