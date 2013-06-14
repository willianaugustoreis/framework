unit uControllerCliente;

interface

uses uModelCliente;

type
  TControllerCliente = class
  private
  public
    procedure Salvar(ACliente: TModelCliente);
  end;

implementation

{ TControllerCliente }

procedure TControllerCliente.Salvar(ACliente: TModelCliente);
begin
  {REGRAS DE NEGOCIO}
  ACliente.Salvar;
end;

end.
