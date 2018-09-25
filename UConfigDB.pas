unit UConfigDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer, cxEdit,
  cxTextEdit, Vcl.StdCtrls, cxButtons,UDM;

type
  TFrmConfigDb = class(TForm)
    btnConectar: TcxButton;
    btnTestarConexao: TcxButton;
    edtServidor: TcxTextEdit;
    edtBaseDados: TcxTextEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtPorta: TcxTextEdit;
    Label4: TLabel;
    edtUser: TcxTextEdit;
    Label5: TLabel;
    edtSenha: TcxTextEdit;
    lblStatus: TLabel;
    procedure btnTestarConexaoClick(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfigDb: TFrmConfigDb;

implementation

{$R *.dfm}

procedure TFrmConfigDb.btnConectarClick(Sender: TObject);
begin
  if  FileExists(ExtractFilePath(Application.ExeName)+'db.ini') then
  begin
    ArquivoINI.WriteString('BANCO','Servidor',edtServidor.Text);
    ArquivoINI.WriteString('BANCO','NomeBanco',edtBaseDados.Text);
    ArquivoINI.WriteString('BANCO','Porta',edtPorta.Text);
    ArquivoINI.WriteString('BANCO','UsuarioBD',edtUser.Text);
    ArquivoINI.WriteString('BANCO','SenhaBD',edtSenha.Text);
  end;

  try
    DataModule1.Conexao.ProviderName := 'SQL Server';
    DataModule1.Conexao.Username := edtUser.Text;
    DataModule1.Conexao.Password := edtSenha.Text;
    DataModule1.Conexao.Port     := strtointdef(edtPorta.Text,0);
    //DataModule1.Conexao.Server := 'DESKTOP-PQ00CJP';
    DataModule1.Conexao.database:=edtBaseDados.Text;
    //DataModule1.Conexao.SpecificOptions.Values['Schema'] := 'SCOTT';
    DataModule1.Conexao.Open;
    lblStatus.Caption := 'Conectado';
  except on E: Exception do
  begin
    lblStatus.Caption := 'Erro ao Conectar';
  end
  end;

end;

procedure TFrmConfigDb.btnTestarConexaoClick(Sender: TObject);
begin
  try
    DataModule1.Conexao.ProviderName := 'SQL Server';
    DataModule1.Conexao.Username := edtUser.Text;
    DataModule1.Conexao.Password := edtSenha.Text;
    DataModule1.Conexao.Port     := strtointdef(edtPorta.Text,0);
    //DataModule1.Conexao.Server := 'DESKTOP-PQ00CJP';
    DataModule1.Conexao.database:=edtBaseDados.Text;
    //DataModule1.Conexao.SpecificOptions.Values['Schema'] := 'SCOTT';
    DataModule1.Conexao.Open;
    lblStatus.Caption := 'Conectado';
  except on E: Exception do
  begin
    lblStatus.Caption := 'Erro ao Conectar';
  end
  end;
end;

end.
