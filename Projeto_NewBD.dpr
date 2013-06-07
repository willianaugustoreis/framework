program Projeto_NewBD;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  uCustomDBConnection in 'Classes\DataBase\uCustomDBConnection.pas',
  uPostgreDBConection in 'Classes\DataBase\uPostgreDBConection.pas',
  uCustomDBQuery in 'Classes\DataBase\uCustomDBQuery.pas',
  uPostgreDBQuery in 'Classes\DataBase\uPostgreDBQuery.pas',
  uPoolConnection in 'Classes\DataBase\uPoolConnection.pas',
  uDBQueryIons in 'Classes\DataBase\uDBQueryIons.pas',
  pgeDriverUtils in '..\..\..\..\IONICS\Componentes\trunk\Midleware de Acesso à Banco de Dados\PostgreSQL\Vitavomm\4.50\pgeDriverUtils.pas';

var
  LBanco: TDBQueryIons;
  LThreadConnections: TThreadConnections;
begin
  ListaPool := TListPoolConection.Create;
  LThreadConnections := TThreadConnections.Create(False);
  LThreadConnections.Resume;

  Writeln('TESTANDO BANCO DE DADOS E SUAS CONEXOES...');
  try
    LBanco := TDBQueryIons.Create;
    LBanco.BeginTransaction;
    try
      LBanco.SetSQL('INSERT INTO public."TESTE"("TESTE1") VALUES (2)');
      LBanco.Execute;
      LBanco.SetSQL('UPDATE public."TESTE" SET "TESTE2" = ''2222'' WHERE "TESTE1" = 1');
      LBanco.Execute;
    finally
      LBanco.EndTransaction;
      LBanco.Free;
    end;

    LBanco := TDBQueryIons.Create;
    LBanco.Free;
  except
    on e: exception do
    Writeln(e.message);
  end;
  Readln;
end.
