unit UDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  FireDAC.Phys.ODBCBase, Data.DB, FireDAC.Comp.Client,XMLDoc, XMLIntf,
  Vcl.Dialogs, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet,UPrincipal, Vcl.Forms, DBAccess, Uni,
  MemDS, UniProvider, SQLServerUniProvider,System.IniFiles;

type
  TDataModule1 = class(TDataModule)
    SaveDialog1: TSaveDialog;
    Conexao: TUniConnection;
    QueryTron: TUniQuery;
    SQLServerUniProvider1: TSQLServerUniProvider;
    procedure DataModuleCreate(Sender: TObject);
  private

    { Private declarations }
    arqXML:TextFile;
    procedure escreveLancamento(ACodEmp,dataLan, natLan, comDescLan, codNorCnt:String; grpSeqLan:string; vlrLan:Currency);
    function SoNumero(fField: String): String;

  public
    { Public declarations }
    procedure GerarXml(ACaminho:string;AdataIni,AdataFim:TDate);
    function Obrigatorio(vrFormulario: TForm; vrComponente: TComponent;
      vrMensagem: string): Boolean;

  end;

var
  DataModule1:TDataModule1;

  ArquivoINI         : TIniFile;
  _Servidor          : string;
  _NomeBanco         : string;
  _PortaServidor     : string;
  _Login             : string;
  _Senha             : string;

implementation

uses
  Vcl.StdCtrls, Winapi.Windows, cxCalendar, cxTextEdit;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TDataModule1.GerarXml(ACaminho:string;AdataIni,AdataFim:Tdate);
var
  LSql:string;
  LEmpresa:string;
  LCount:Integer;
begin
  AssignFile(arqXML,ACaminho+'.xml');
  try
  {$I-}
    Reset(arqXML);
  {$I+}
    LCount := 1;
    if (IOResult <> 0)then Rewrite(arqXML); { arquivo não existe e será criado }
    //cabecalho
    write(Self.arqXML,'<?xml version="1.0" encoding="ISO-8859-1"?>');
    write(Self.arqXML,'<MOVIMENTACAO>');
    //abrir consulta
    Form1.status.Caption:='Iniciando exportação ';
    //gerar de recebimentos
//    LSql := 'select distinct(r.NumVend_Rec) AS [CONTRATO],'+
//    'r.Empresa_rec AS [EMPRESA],'+
//    'r.Obra_Rec [OBRA],'+
//    'r.Tipo_Rec AS [TIPO DE PARCELA],'+
//    'p.Descricao_par AS [DESCICAO PARCELA],'+
//    'r.Data_Rec AS [DATA RECEBIMENTO/LANCAMENTO],'+
//    'rpd.PercentValor_Rpd AS [RECEBIDO],'+
//    'rpd.PercentDesc_Rpd as [DESCONTO],'+
//    'rpd.PercentJurAtr_Rpd as	[JUROS],'+
//    'PE.nome_pes AS [NOME CLIENTE],'+
//    'r.NumParcGer_Rec AS [NUMERO DA PARCELA],'+
//    'CASE WHEN rpd.PercentDesc_Rpd > 0 THEN ''3.2.04.01.0005'''+
//    'ELSE ''0'''+
//    'END AS  ''DESCONTOS CONCEDIDOS'','+
//    '''1.1.01.01.0002 '' AS [BAIXA NA CARTEIRA],'+
//    '''2.2.02.01.0001 '' AS [RECEITA DIF. DAS VENDA],'+
//    '''4.1.01.01.0001 '' AS [VENDAS DO LOTEAMENTO],'+
//    'PE.InscrMunic_pes as CLIENTES,'+
//    'CASE WHEN rpd.PercentJurAtr_Rpd > 0 THEN ''4.1.03.01.0002'''+
//    'ELSE ''0'''+
//    'END AS  ''JUROS RECEBIDOS'','+
//    ''+
//    '''S'' as Concliado,'+
//    '''RECEB DE ''+ PE.nome_pes +'' REF CONTRATO ''+ CAST (r.NumVend_Rec AS VARCHAR) + '' PARCELA '' + CAST (r.NumParcGer_Rec AS VARCHAR) AS[COMLAN] ,'+
//    'PE.cod_peS+CONVERT( DECIMAL,r.Data_Rec,111)+r.NumParcGer_Rec AS [CODOPERACAO] '+
//    'from recebidas r JOIN RecebePgtoDiv rpd ON (R.Empresa_rec=RPD.Empresa_Rpd AND R.Obra_Rec=RPD.Obra_Rpd AND r.NumVend_Rec=RPD.NumVend_Rpd '+
//    'AND R.NumReceb_Rec=RPD.NumReceb_Rpd AND r.NumParcGer_Rec=rpd.NumParcGer_Rpd)'+
//    'INNER JOIN RecebePgto ON RecebePgto.Empresa_rpg = rpd.Empresa_Rpd AND RecebePgto.NumReceb_Rpg = rpd.NumReceb_Rpd AND '+
//    'RecebePgto.Tipo_Rpg = rpd.TipoRpg_Rpd AND RecebePgto.NumCont_Rpg = rpd.NumCont_Rpd '+
//    'JOIN Parcelas p ON p.Tipo_par = r.Tipo_Rec '+
//    'INNER JOIN Extrato ON RecebePgto.Empresa_rpg = Extrato.Empresa_doc '+
//    'AND RecebePgto.BancoDep_Rpg = Extrato.Banco_doc AND RecebePgto.ContaDep_Rpg = Extrato.Conta_doc '+
//    'AND RecebePgto.NumDep_Rpg = Extrato.Numero_doc '+
//    'JOIN Pessoas PE ON (R.Cliente_Rec=PE.cod_pes) '+
//    'WHERE (Extrato.Tipo_doc = 1) and r.Empresa_rec=1 and  r.Data_Rec between :dtIni and :dtFim '+
//    'GROUP BY r.NumVend_Rec,r.Empresa_rec, r.Obra_Rec, r.Tipo_Rec, p.Descricao_par,'+
//    'r.DataVenci_Rec,r.Data_Rec,rpd.PercentPrinc_Rpd,'+
//    'rpd.PercentValor_Rpd, rpd.PercentJurAtr_Rpd,PE.Nome_Pes,'+
//    'r.NumParcGer_Rec,r.Valor_Rec, r.ValorConf_Rec,rpd.PercentDesc_Rpd,PE.cod_peS, PE.InscrMunic_pes ';


    LSql :='select distinct(r.NumVend_Rec) AS [CONTRATO], '+
    'r.Empresa_rec AS [EMPRESA], '+
    'r.Obra_Rec [OBRA], '+
    'r.Tipo_Rec AS [TIPO DE PARCELA], '+
    'p.Descricao_par AS [DESCICAO PARCELA], '+
    'r.Data_Rec AS [DATA RECEBIMENTO/LANCAMENTO], '+
    'rpd.PercentValor_Rpd AS [RECEBIDO], '+
    'rpd.ValorPrincipalPrice_rpd [RECEBIDO PRINCIPAL], '+
    'rpd.PercentDesc_Rpd as [DESCONTO], '+
    ' rpd.PercentJurAtr_Rpd + rpd.PercentMultaAtr_Rpd as  [JUROS], '+
    'PE.nome_pes AS [NOME CLIENTE], '+
    'r.NumParc_Rec AS [NUMERO DA PARCELA], '+
    'CASE WHEN rpd.PercentDesc_Rpd > 0 THEN ''3204010005'' '+
    'ELSE ''0'' '+
    'END AS  ''DESCONTOS CONCEDIDOS'', '+
    '''1101010002 '' AS [BAIXA NA CARTEIRA], '+
    '''1.1.01.01.0002 '' AS [BAIXA NA CARTEIRA],'+
    '''2.2.02.01.0001 '' AS [RECEITA DIF. DAS VENDA],'+
    '''4.1.01.01.0001 '' AS [VENDAS DO LOTEAMENTO],'+
    'replace (PE.InscrMunic_pes,''.'','''') as CLIENTES, '+
    'CASE WHEN rpd.PercentJurAtr_Rpd > 0 THEN ''4103010002'' '+
    'ELSE ''0'' '+
    'END AS  ''JUROS RECEBIDOS'', '+
    ' '+
    '''S'' as Concliado, '+
    '''RECEB DE''+ PE.nome_pes +'' REF CONTRATO ''+ CAST (r.NumVend_Rec AS VARCHAR) + '' PARCELA '' + CAST (r.NumParc_Rec AS VARCHAR) AS[COMLAN]  '+
    //'PE.cod_peS+CONVERT( DECIMAL,r.Data_Rec,111)+r.NumParc_Rec AS [CODOPERACAO]'+
    //' concat (Pe.cod_pes,CONVERT(DECIMAL,V.DATA_VEN,111),V.Num_Ven) AS [CODOPERACAO] '+
    //' r.Num_Ven,concat (PE.cod_peS, CONVERT( DECIMAL,r.Data_Rec,111),r.Num_Ven,r.NumParc_Rec) AS [CODOPERACAO] '+
    'from recebidas r JOIN RecebePgtoDiv rpd ON (R.Empresa_rec=RPD.Empresa_Rpd AND R.Obra_Rec=RPD.Obra_Rpd AND r.NumVend_Rec=RPD.NumVend_Rpd '+
    'AND R.NumReceb_Rec=RPD.NumReceb_Rpd AND r.NumParcGer_Rec=rpd.NumParcGer_Rpd) '+
    'INNER JOIN RecebePgto ON RecebePgto.Empresa_rpg = rpd.Empresa_Rpd AND RecebePgto.NumReceb_Rpg = rpd.NumReceb_Rpd AND '+
    'RecebePgto.Tipo_Rpg = rpd.TipoRpg_Rpd AND RecebePgto.NumCont_Rpg = rpd.NumCont_Rpd '+
    'JOIN Parcelas p ON p.Tipo_par = r.Tipo_Rec '+
    'INNER JOIN Extrato ON RecebePgto.Empresa_rpg = Extrato.Empresa_doc '+
    'AND RecebePgto.BancoDep_Rpg = Extrato.Banco_doc AND RecebePgto.ContaDep_Rpg = Extrato.Conta_doc '+
    'AND RecebePgto.NumDep_Rpg = Extrato.Numero_doc '+
    'JOIN Pessoas PE ON (R.Cliente_Rec=PE.cod_pes) '+
//    'WHERE (Extrato.Tipo_doc = 1) and r.Empresa_rec=1 '+
    'WHERE (Extrato.Tipo_doc = 1) and r.Empresa_rec=1 and  r.Data_Rec between :dtIni and :dtFim '+
    'GROUP BY r.NumVend_Rec,r.Empresa_rec, r.Obra_Rec, r.Tipo_Rec, p.Descricao_par, '+
    'r.DataVenci_Rec,r.Data_Rec,rpd.PercentPrinc_Rpd, '+
    'rpd.PercentValor_Rpd, rpd.PercentJurAtr_Rpd,PE.Nome_Pes, '+
    'r.NumParc_Rec,r.Valor_Rec, r.ValorConf_Rec,rpd.PercentDesc_Rpd,PE.cod_peS, PE.InscrMunic_pes, rpd.ValorPrincipalPrice_rpd , rpd.PercentMultaAtr_Rpd';


    DataModule1.QueryTron.SQL.Text := LSql;

    DataModule1.QueryTron.Params.ParamByName('dtIni').AsDate := Adataini;
    DataModule1.QueryTron.Params.ParamByName('dtFim').AsDate := AdataFim;

    DataModule1.QueryTron.Open();
    DataModule1.QueryTron.First;
    Form1.gauge1.MaxValue := DataModule1.QueryTron.RecordCount;
    LEmpresa := DataModule1.QueryTron.FieldByName('empresa').AsString;
    while not DataModule1.QueryTron.eof do
    begin
      //BAIXA NA CARTEIRA
      escreveLancamento(DataModule1.QueryTron.FieldByName('empresa').AsString,DataModule1.QueryTron.FieldByName('DATA RECEBIMENTO/LANCAMENTO').AsString,'D',
        DataModule1.QueryTron.FieldByName('COMLAN').AsString,DataModule1.QueryTron.FieldByName('BAIXA NA CARTEIRA').AsString,
        LCount.ToString,DataModule1.QueryTron.FieldByName('RECEBIDO').ascurrency);

      //DB NA CONTA BANCO (VALOR TITULO+JUROS)
      escreveLancamento(DataModule1.QueryTron.FieldByName('empresa').AsString,DataModule1.QueryTron.FieldByName('DATA RECEBIMENTO/LANCAMENTO').AsString,'D',
        DataModule1.QueryTron.FieldByName('COMLAN').AsString,
        DataModule1.QueryTron.FieldByName('RECEITA DIF. DAS VENDA').AsString,
        LCount.ToString,DataModule1.QueryTron.FieldByName('RECEBIDO PRINCIPAL').ascurrency);

      //CLIENTE
      escreveLancamento(DataModule1.QueryTron.FieldByName('empresa').AsString,DataModule1.QueryTron.FieldByName('DATA RECEBIMENTO/LANCAMENTO').AsString,'C',
        DataModule1.QueryTron.FieldByName('COMLAN').AsString,
        DataModule1.QueryTron.FieldByName('CLIENTES').AsString,LCount.ToString,DataModule1.QueryTron.FieldByName('RECEBIDO PRINCIPAL').ascurrency);

      //VENDAS DO LOTEAMENTO ALTO DO PORTO
      escreveLancamento(DataModule1.QueryTron.FieldByName('empresa').AsString,DataModule1.QueryTron.FieldByName('DATA RECEBIMENTO/LANCAMENTO').AsString,'C',
        DataModule1.QueryTron.FieldByName('COMLAN').AsString,DataModule1.QueryTron.FieldByName('VENDAS DO LOTEAMENTO').AsString,
        LCount.ToString,DataModule1.QueryTron.FieldByName('RECEBIDO PRINCIPAL').ascurrency);

      //juros
      if DataModule1.QueryTron.FieldByName('JUROS').AsCurrency>0 then
        escreveLancamento(DataModule1.QueryTron.FieldByName('empresa').AsString,DataModule1.QueryTron.FieldByName('DATA RECEBIMENTO/LANCAMENTO').AsString,'C',
          DataModule1.QueryTron.FieldByName('COMLAN').AsString,
          DataModule1.QueryTron.FieldByName('JUROS RECEBIDOS').AsString,LCount.ToString,DataModule1.QueryTron.FieldByName('JUROS').ascurrency);

      //desconto
      if DataModule1.QueryTron.FieldByName('DESCONTO').AsCurrency>0 then
        escreveLancamento(DataModule1.QueryTron.FieldByName('empresa').AsString,DataModule1.QueryTron.FieldByName('DATA RECEBIMENTO/LANCAMENTO').AsString,'D',
          DataModule1.QueryTron.FieldByName('COMLAN').AsString,
          DataModule1.QueryTron.FieldByName('DESCONTOS CONCEDIDOS').AsString,LCount.ToString,DataModule1.QueryTron.FieldByName('DESCONTO').ascurrency);

      DataModule1.QueryTron.Next;
      Inc(LCount);
      Form1.gauge1.progress := Form1.gauge1.progress+1;
    end;

    //receita no ato da venda
    LSql := 'SELECT P.InscrMunic_pes as [CLIENTES],'+
    '''2.2.02.01.0001'' AS [CODNORCNT],'+
    '''1.1.02.01'' AS [CODNORCNT2],'+
    'V.Data_Ven AS [DATA DA VENDA],'+
    'V.ValorTot_Ven AS [RECEBIDO],'+
    '''RECEBIMENTO DE ''+UPPER(P.nome_pes )+'' VENDA - CONTRATO ''+ CAST (V.Num_Ven AS VARCHAR)  [COMLAN],'+
    //'P.cod_pes+CONVERT(DECIMAL,V.DATA_VEN,111)+V.Num_Ven AS [CODOPERACAO] '+
    ' concat (P.cod_pes,CONVERT(DECIMAL,V.DATA_VEN,111),V.Num_Ven) AS [CODOPERACAO] '+
    ''+
    ' FROM VENDAS V JOIN PESSOAS P ON V.CLIENTE_VEN=P.cod_pes where V.DATA_VEN between :dtIni and :dtFim ';

    DataModule1.QueryTron.SQL.clear;
    DataModule1.QueryTron.SQL.Text := LSql;

    DataModule1.QueryTron.Params.ParamByName('dtIni').AsDate := Adataini;
    DataModule1.QueryTron.Params.ParamByName('dtFim').AsDate := AdataFim;

    DataModule1.QueryTron.Open();
    DataModule1.QueryTron.First;
    Form1.gauge1.MaxValue := DataModule1.QueryTron.RecordCount;

    while not DataModule1.QueryTron.eof do
    begin
      //CR RECEITA DE VENDA
      escreveLancamento(LEmpresa,DataModule1.QueryTron.FieldByName('DATA DA VENDA').AsString,'C',
      DataModule1.QueryTron.FieldByName('COMLAN').AsString,DataModule1.QueryTron.FieldByName('CLIENTES').AsString,
      LCount.tostring,DataModule1.QueryTron.FieldByName('RECEBIDO').ascurrency);

      //DB CAIXA DA EMPRESA
      escreveLancamento(LEmpresa,DataModule1.QueryTron.FieldByName('DATA DA VENDA').AsString,'D',
      DataModule1.QueryTron.FieldByName('COMLAN').AsString,DataModule1.QueryTron.FieldByName('CLIENTES').AsString,
      LCount.tostring,
      DataModule1.QueryTron.FieldByName('RECEBIDO').ascurrency);

//      escreveLancamento(LEmpresa,DataModule1.QueryTron.FieldByName('DATA DA VENDA').AsString,'D',
//      DataModule1.QueryTron.FieldByName('COMLAN').AsString,DataModule1.QueryTron.FieldByName('CODNORCNT').AsString,DataModule1.QueryTron.FieldByName('CODOPERACAO').asinteger,DataModule1.QueryTron.FieldByName('RECEBIDO').ascurrency);

      DataModule1.QueryTron.Next;
      inc(LCount);
      Form1.gauge1.progress := Form1.gauge1.progress+1;
    end;

    //Cancelamentos
//    LSql :=' SELECT P.InscrMunic_pes as [CLIENTES], '+
//         ' ''2.2.02.01.0001'' AS [CODNORCNT],'+
//         '''1.1.02.01'' AS [CODNORCNT2],'+
//         ' VD.Empresa_vdd AS [ID EMPRESA], '+
//         ' ''CANCELAMENTO DE ''+ UPPER(P.nome_pes )+'' VENDA - CONTRATO ''+ CAST ( VD.NumVend_vdd AS VARCHAR)  [COMLAN], '+
//         ' VD.DataAprov_vdd AS [DATA OCORRENCIA], '+
//         ' VD.ValTotDistrato_vdd AS [VALOR DO DISTRATO],'+
//        ' P.cod_peS+CONVERT( DECIMAL,vd.DataAprov_vdd,111)+vd.NumVend_vdd AS [CODOPERACAO] '+
//        ' FROM VendaDistrato VD JOIN VendaHist VH ON (VD.NumVend_vdd=VH.NumVend_vhist AND '+
//        ' VD.Empresa_vdd=VH.Empresa_vhist AND VD.Obra_vdd=VH.Obra_vhist) '+
//        ' JOIN PESSOAS P ON (P.COD_PES = VH.Cliente_vhist) where VD.DataAprov_vdd between :dtIni and :dtFim ';

//    LSql :='SELECT distinct VD.NumVend_vdd as [NumVenda], '+
//    'P.InscrMunic_pes as [CLIENTES], '+
//    '''2202010001'' AS [RECEITA DIF. DAS VENDAS], '+
//    'VD.Empresa_vdd AS [ID EMPRESA], '+
//    '''CANCELAMENTO DE ''+UPPER(P.nome_pes )+'' VENDA - CONTRATO ''+ CAST ( VD.NumVend_vdd AS VARCHAR)  [COMLAN], '+
//    'VD.DataAprov_vdd AS [DATA OCORRENCIA], '+
//    'VD.ValTotDistrato_vdd AS [VALOR DO DISTRATO], '+
//    ' CASE WHEN VD.ValTotDistrato_vdd < 0 THEN VD.ValTotDistrato_vdd*-1 '+
//    ' ELSE VD.ValTotDistrato_vdd   '+
//    ' END AS [VALOR DO DISTRATO], '+
//    'CASE WHEN  VD.DataAprov_vdd  IS NOT NULL THEN 1 '+
//    'WHEN  VD.DataAprov_vdd  IS NULL THEN 0 '+
//    'END AS [STATUS DISTRATO], '+
//    'P.cod_peS+CONVERT( DECIMAL,vd.DataAprov_vdd,111)+vd.NumVend_vdd AS [CODOPERACAO] '+
//    'FROM VendaDistrato VD JOIN VendaHist VH ON (VD.NumVend_vdd=VH.NumVend_vhist AND VD.Empresa_vdd=VH.Empresa_vhist AND VD.Obra_vdd=VH.Obra_vhist) '+
//    'JOIN PESSOAS P ON (P.COD_PES = VH.Cliente_vhist) '+
//    'where vd.Empresa_vdd=1 and  VD.DataAprov_vdd between :dtIni and :dtFim';

    LSql :='SELECT distinct VD.NumVend_vdd as [NumVenda], '+
    'P.InscrMunic_pes as [CLIENTES], '+
    '''2202010001'' AS [RECEITA DIF. DAS VENDAS], '+
    'VD.Empresa_vdd AS [ID EMPRESA], '+
    '''CANCELAMENTO DE ''+UPPER(P.nome_pes )+'' VENDA - CONTRATO ''+ CAST ( VD.NumVend_vdd AS VARCHAR)  [COMLAN], '+
    'VD.DataAprov_vdd AS [DATA OCORRENCIA], '+
    'CASE WHEN VD.ValTotDistrato_vdd < 0 THEN VD.ValTotDistrato_vdd *-1 '+
    'WHEN VD.ValTotDistrato_vdd = 0 THEN 1 '+
    'ELSE VD.ValTotDistrato_vdd '+
    'END AS [VALOR DO DISTRATO], '+
    'CASE WHEN  VD.DataAprov_vdd  IS NOT NULL THEN 1 '+
    'WHEN  VD.DataAprov_vdd  IS NULL THEN 0 '+
    'END AS [STATUS DISTRATO], '+
    //'P.cod_peS+CONVERT( DECIMAL,vd.DataAprov_vdd,111)+vd.NumVend_vdd AS [CODOPERACAO] '+
    ' concat (P.cod_peS,CONVERT( DECIMAL,vd.DataAprov_vdd,111),vd.NumVend_vdd) AS [CODOPERACAO] '+
    'FROM VendaDistrato VD JOIN VendaHist VH ON (VD.NumVend_vdd=VH.NumVend_vhist AND VD.Empresa_vdd=VH.Empresa_vhist AND VD.Obra_vdd=VH.Obra_vhist) '+
    'JOIN PESSOAS P ON (P.COD_PES = VH.Cliente_vhist) '+
    'where vd.Empresa_vdd=1 and  VD.DataAprov_vdd between :dtIni and :dtFim ';


    DataModule1.QueryTron.SQL.clear;
    DataModule1.QueryTron.SQL.Text := LSql;

    DataModule1.QueryTron.Params.ParamByName('dtIni').AsDate := Adataini;
    DataModule1.QueryTron.Params.ParamByName('dtFim').AsDate := AdataFim;

    DataModule1.QueryTron.Open();
    DataModule1.QueryTron.First;
    Form1.gauge1.MaxValue := DataModule1.QueryTron.RecordCount;

    while not DataModule1.QueryTron.eof do
    begin
      if DataModule1.QueryTron.FieldByName('STATUS DISTRATO').Asinteger=1 then
        escreveLancamento(LEmpresa,DataModule1.QueryTron.FieldByName('DATA OCORRENCIA').AsString,'D',
        DataModule1.QueryTron.FieldByName('COMLAN').AsString,DataModule1.QueryTron.FieldByName('RECEITA DIF. DAS VENDAS').AsString,
        LCount.tostring,DataModule1.QueryTron.FieldByName('VALOR DO DISTRATO').ascurrency);

      if DataModule1.QueryTron.FieldByName('STATUS DISTRATO').Asinteger=1 then
        escreveLancamento(LEmpresa,DataModule1.QueryTron.FieldByName('DATA OCORRENCIA').AsString,'C',
        DataModule1.QueryTron.FieldByName('COMLAN').AsString,DataModule1.QueryTron.FieldByName('CLIENTES').AsString,
        LCount.tostring,DataModule1.QueryTron.FieldByName('VALOR DO DISTRATO').ascurrency);

//      escreveLancamento(LEmpresa,DataModule1.QueryTron.FieldByName('DATA OCORRENCIA').AsString,'D',
//      DataModule1.QueryTron.FieldByName('COMLAN').AsString,DataModule1.QueryTron.FieldByName('CODNORCNT').AsString,DataModule1.QueryTron.FieldByName('CODOPERACAO').asinteger,DataModule1.QueryTron.FieldByName('VALOR DO DISTRATO').ascurrency);

      DataModule1.QueryTron.Next;
      inc(LCount);
      Form1.gauge1.progress := Form1.gauge1.progress+1;
    end;

  finally
    write(Self.arqXML,'</MOVIMENTACAO>');
    CloseFile(Self.arqXML);
    ShowMessage('Gerado com Sucesso!');
    Form1.gauge1.progress :=0;
    Form1.status.Caption:='Iniciando exportação ';
  end;
end;


procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  ArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName)+'db.ini');
end;

procedure TDataModule1.escreveLancamento(ACodEmp,dataLan, natLan, comDescLan, codNorCnt:String; grpSeqLan:string; vlrLan:Currency);
//COD_EMPRESA, *DTLAN, *COMLAN(COMPLEMENTO/DESC), *VALOR, *NATLAN(D/C), *CODNORCNT (PLANO CONTA)
var
  sql, ContratoQdLt, temp:string;
  qtdParcelasPagas, qtdParcelasAbertas, qtdSkip, i:Integer;
  vlRecebMes, vlVenda, vlParcelasPagasComJuros, vlParcelasPagasSemJuros, vlParcelasAbertas:Currency;
begin
  //TRON-layout 0
    write(Self.arqXML,'<LANCAMENTO>');
    //write(Self.arqXML,'<CODEMP>'+Trim(ACodEmp)+'</CODEMP>'); //data pagamento boleto
    write(Self.arqXML,'<DTALAN>'+dataLan+'</DTALAN>'); //data pagamento boleto
    write(Self.arqXML,'<DOCLAN></DOCLAN>'); //numero do documento
    write(Self.arqXML,'<CODHIS></CODHIS>');  //Ex.55 Recebimento de duplicata
    write(Self.arqXML,'<NATLAN>'+natLan+'</NATLAN>'); //Credito ou Debito
    write(Self.arqXML,'<VLRLAN>'+Trim(FormatFloat('#####0.00',vlrLan))+'</VLRLAN>'); //2 lançamentos um pro valor original e outro pro valor do juros
    write(Self.arqXML,'<CODLOT>0</CODLOT>'); //numero da quadra mais o numero do lote emendado
    write(Self.arqXML,'<CONLAN>N</CONLAN>'); //o padrão sera não conciliado
    write(Self.arqXML,'<COMLAN>'+comDescLan+'</COMLAN>'); //
    write(Self.arqXML,'<GRPSEQLAN>'+Trim((grpSeqLan))+'</GRPSEQLAN>'); // sem juro coloca ZERO com juro coloca 1,2,3
    write(Self.arqXML,'<CODNORCNT>'+Trim(SoNumero(codNorCnt))+'</CODNORCNT>'); //codigo da conta maior
    write(Self.arqXML,'<VLRLOT>0</VLRLOT>'); //total do pacote de exportação (soma dos lançamentos)
//    write(Self.arqXML,'<CENTROS>');
//    write(Self.arqXML,'  <CENTRO>');
//    write(Self.arqXML,'    <CODNIV>0</CODNIV>'); //deixa em branco
//    write(Self.arqXML,'    <CODCENNEG>0</CODCENNEG>'); //deixa em branco
//    write(Self.arqXML,'    <VLRLAN>0</VLRLAN>'); //deixa em branco
//    write(Self.arqXML,'  </CENTRO>');
//    write(Self.arqXML,'</CENTROS>');
    write(Self.arqXML,'</LANCAMENTO>');
end;

function TDataModule1.Obrigatorio(vrFormulario : TForm; vrComponente : TComponent; vrMensagem : string) : Boolean;
begin
  Result := False;

  with vrFormulario do
  begin
    if vrComponente is TEdit then
    begin
      if Trim(TEdit(vrComponente).Text) = '' then
      begin
        TEdit(vrComponente).SetFocus;
        Application.MessageBox(PWideChar(vrMensagem),'ATENÇÃO',MB_OK + MB_ICONINFORMATION);
        Result := True;
      end;
    end
    else
    if vrComponente is TcxDateEdit then
    begin
      if (TcxDateEdit(vrComponente).Text = '') then
      begin
        TcxDateEdit(vrComponente).SetFocus;
        Application.MessageBox(PWideChar(vrMensagem),'ATENÇÃO',MB_OK + MB_ICONINFORMATION);
        Result := True;
      end;

      if (TcxDateEdit(vrComponente).Text = '  /  /    ') then
      begin
        TcxDateEdit(vrComponente).SetFocus;
        Application.MessageBox(PWideChar(vrMensagem),'ATENÇÃO',MB_OK + MB_ICONINFORMATION);
        Result := True;
      end;
    end
    else
    if vrComponente is TcxTextEdit then
    begin
      if Trim(TcxTextEdit(vrComponente).Text) = '' then
      begin
        TcxTextEdit(vrComponente).SetFocus;
        Application.MessageBox(PWideChar(vrMensagem),'ATENÇÃO',MB_OK + MB_ICONINFORMATION);
        Result := True;
      end;
    end;
  end;
end;

function TDataModule1.SoNumero(fField : String): String;
var
  I : Byte;
begin
  Result := '';
  for I := 1 To Length(fField) do
     if fField [I] In ['0'..'9'] Then
       Result := Result + fField [I];
end;


end.
