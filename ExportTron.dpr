program ExportTron;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {Form1},
  UDM in 'UDM.pas' {DataModule1: TDataModule},
  UConfigDB in 'UConfigDB.pas' {FrmConfigDb};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFrmConfigDb, FrmConfigDb);
  Application.Run;
end.
