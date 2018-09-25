unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Gauges,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus,
  cxLabel, cxButtons, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxGroupBox, Vcl.ExtCtrls, dxGDIPlusClasses, cxImage;

type
  TForm1 = class(TForm)
    Gauge1: TGauge;
    cxGroupBox1: TcxGroupBox;
    edtIni: TcxDateEdit;
    edtFim: TcxDateEdit;
    btnGerarArquivo: TcxButton;
    cxLabel1: TcxLabel;
    status: TcxLabel;
    cxLabel2: TcxLabel;
    cxImage1: TcxImage;
    lblConexao: TcxLabel;
    cxLabel3: TcxLabel;
    procedure btnGerarArquivoClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    procedure Limpar;
    procedure Conexao;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses UDM, UConfigDB, System.IniFiles;

procedure TForm1.btnGerarArquivoClick(Sender: TObject);
begin
  //validar data
  if DataModule1.Obrigatorio(Self, edtini,'Verficar Data Inicial!') then Exit;
  if DataModule1.Obrigatorio(Self, edtfim,'Verficar Data Final!') then Exit;
  if DataModule1.SaveDialog1.Execute() then
  begin
    Gauge1.Progress := 0;
    DataModule1.GerarXml(DataModule1.SaveDialog1.FileName,edtini.date,edtfim.date);
  end;
  Limpar();
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then selectnext(activecontrol,true,true);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  //conexao
  Conexao();
end;

procedure TForm1.Conexao();
begin
  try
    if not FileExists(ExtractFilePath(Application.ExeName)+'db.ini') then
    begin
      ArquivoINI.WriteString('BANCO','Servidor',_Servidor);
      ArquivoINI.WriteString('BANCO','NomeBanco',_NomeBanco);
      ArquivoINI.WriteString('BANCO','Porta',_PortaServidor);
      ArquivoINI.WriteString('BANCO','UsuarioBD','');
      ArquivoINI.WriteString('BANCO','SenhaBD','');
    end;

    with TIniFile.Create(ExtractFilePath(Application.ExeName)+'db.ini') do
    begin
        _Servidor          := ArquivoINI.ReadString('BANCO','Servidor','servidor');
        _NomeBanco         := ArquivoINI.ReadString('BANCO','NomeBanco','quantum');
        _PortaServidor     := ArquivoINI.ReadString('BANCO','Porta','3390');
        _Login             := ArquivoINI.ReadString('BANCO','UsuarioBD','');
        _Senha             := ArquivoINI.ReadString('BANCO','SenhaBD','');
    end;



    DataModule1.Conexao.ProviderName := 'SQL Server';
    DataModule1.Conexao.Username := _Login;
    DataModule1.Conexao.Password := _Senha;
    DataModule1.Conexao.Port     := StrToIntdef(_PortaServidor,0);
    DataModule1.Conexao.Server := _Servidor;
    DataModule1.Conexao.database:=_NomeBanco;

    DataModule1.Conexao.Connected := True;
    cxLabel3.Caption := 'Conectado';
    cxLabel3.Style.Font.Color := clBlue;
  except on E: Exception do
  begin
    cxLabel3.Style.Font.Color := clRed;
    lblConexao.Caption := 'Erro ao Cone';
    FrmConfigDb := TFrmConfigDb.Create(Self);
    FrmConfigDb.ShowModal;
  end
  end;
end;

procedure TForm1.Limpar();
begin
  edtIni.Clear;
  edtFim.Clear;
end;

end.
