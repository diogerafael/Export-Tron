object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 279
  Width = 396
  object SaveDialog1: TSaveDialog
    Filter = 'xml|.xml'
    Title = 'Salvar Arquivo'
    Left = 32
    Top = 16
  end
  object Conexao: TUniConnection
    ProviderName = 'SQL Server'
    Database = 'UAUPRODUCAOGUIDI'
    SpecificOptions.Strings = (
      'SQL Server.Authentication=auWindows')
    Server = 'DESKTOP-PQ00CJP'
    Left = 136
    Top = 24
  end
  object QueryTron: TUniQuery
    Connection = Conexao
    Constraints = <>
    Left = 184
    Top = 120
  end
  object SQLServerUniProvider1: TSQLServerUniProvider
    Left = 232
    Top = 24
  end
end
