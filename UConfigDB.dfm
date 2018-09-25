object FrmConfigDb: TFrmConfigDb
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FrmConfigDb'
  ClientHeight = 350
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 74
    Top = 0
    Width = 40
    Height = 13
    Caption = 'Servidor'
  end
  object Label2: TLabel
    Left = 74
    Top = 50
    Width = 71
    Height = 13
    Caption = 'Base de Dados'
  end
  object Label3: TLabel
    Left = 74
    Top = 100
    Width = 26
    Height = 13
    Caption = 'Porta'
  end
  object Label4: TLabel
    Left = 74
    Top = 150
    Width = 36
    Height = 13
    Caption = 'Usu'#225'rio'
  end
  object Label5: TLabel
    Left = 74
    Top = 200
    Width = 30
    Height = 13
    Caption = 'Senha'
  end
  object lblStatus: TLabel
    Left = 239
    Top = 317
    Width = 3
    Height = 13
  end
  object btnConectar: TcxButton
    Left = 239
    Top = 265
    Width = 150
    Height = 25
    Caption = 'Conectar'
    TabOrder = 0
    OnClick = btnConectarClick
  end
  object btnTestarConexao: TcxButton
    Left = 81
    Top = 265
    Width = 150
    Height = 25
    Caption = 'Testar Conex'#227'o'
    TabOrder = 1
    OnClick = btnTestarConexaoClick
  end
  object edtServidor: TcxTextEdit
    Left = 74
    Top = 21
    TabOrder = 2
    Width = 321
  end
  object edtBaseDados: TcxTextEdit
    Left = 74
    Top = 71
    TabOrder = 3
    Width = 321
  end
  object edtPorta: TcxTextEdit
    Left = 74
    Top = 121
    TabOrder = 4
    Width = 321
  end
  object edtUser: TcxTextEdit
    Left = 74
    Top = 171
    TabOrder = 5
    Width = 321
  end
  object edtSenha: TcxTextEdit
    Left = 74
    Top = 221
    TabOrder = 6
    Width = 321
  end
end
