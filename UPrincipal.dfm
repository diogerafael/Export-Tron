object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Export Tron - Release 16/09/2018 10:10'
  ClientHeight = 295
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Gauge1: TGauge
    Left = 72
    Top = 209
    Width = 433
    Height = 12
    ForeColor = clNavy
    Progress = 0
  end
  object cxGroupBox1: TcxGroupBox
    Left = 72
    Top = 13
    Caption = 'Op'#231#245'es'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.LookAndFeel.NativeStyle = False
    Style.LookAndFeel.SkinName = 'sevenclassic'
    Style.IsFontAssigned = True
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleDisabled.LookAndFeel.SkinName = 'sevenclassic'
    TabOrder = 0
    Height = 161
    Width = 433
    object edtIni: TcxDateEdit
      Left = 88
      Top = 45
      TabOrder = 0
      Width = 121
    end
    object edtFim: TcxDateEdit
      Left = 224
      Top = 45
      TabOrder = 1
      Width = 121
    end
    object btnGerarArquivo: TcxButton
      Left = 136
      Top = 104
      Width = 161
      Height = 25
      Caption = 'Exportar Arquivo'
      OptionsImage.Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000020000
        00090000000E0000000F00000010000000100000001100000011000000110000
        001200000012000000110000000C000000030000000000000000000000087B50
        43C0AB705CFFAB6F5AFFAB705CFFAA6F5BFFAA6E59FFA96F5AFFAA6D59FFAA6C
        59FFAA6C59FFA96C58FF794D3FC30000000B00000000000000000000000CAD73
        5FFFFDFBF9FFFBF5F2FFFAF5F1FFFAF4F0FFFAF4EFFFFAF2EEFFFAF1EDFFF8F1
        ECFFF8F0EBFFF8F0EAFFD5B6ADFF0000001100000000000000000000000CB077
        62FFFDFBFAFFF7EDE6FF5B524CFF4E443EFF4C413AFF484038FF463D36FF443A
        33FF413731FF3F362FFF3E352DFF3C312BFF393129FF382F27FF0000000BB079
        66FFFDFBFBFFF8EEE8FF5D544DFFFAF8F7FF4D433DFFF9F6F5FF473E37FFF9F4
        F2FF433932FFF7F1EFFF3F362FFFF7F0EDFFF7EEECFF393029FF0000000AB37C
        69FFFEFCFBFFF8F0EAFF5F564FFFFAF8F7FF4E443EFFF9F6F5FF494038FFF8F5
        F3FF453A35FFF7F3F0FF403730FFF7F0EEFF3C322CFF3A312BFF00000009B67F
        6CFFFEFDFCFFF9F0EBFF625952FF88817BFFFAF8F7FF857E78FF4B4139FFF9F6
        F3FF463D36FFF8F2F0FF413831FFF7F1EEFF3E332CFF3C312BFF00000009B983
        71FFFEFDFCFFFAF3EEFF645B55FFFAF9F8FF514740FFFAF8F6FF4D433CFFF9F6
        F5FFF9F5F2FFF9F3F2FF433932FFF7F2EFFF3F352DFF3D322CFF00000008BC88
        77FFFEFEFDFFFBF4EFFF675C56FFFBF9F8FF524841FFFAF8F7FF4E443EFFF9F7
        F5FF493F38FFF9F5F3FF443A33FFF8F2EFFF403630FF3E352DFF00000007BF8C
        7AFFFEFEFDFFFBF6F1FF685E59FF665C55FF635853FF5F564FFF5D524CFF594F
        49FF564B44FF524941FF4E453EFF4B413AFF493F38FF463D35FF00000006C18F
        7FFFFEFEFEFFFAF6F3FFFAF5F3FFFBF6F2FFFBF5F1FFFBF5F0FFFBF5F0FFFAF4
        EFFFFAF4EEFFFDF9F8FFDEC3BAFF0000000B000000000000000000000006C493
        82FFFFFEFEFFFBF7F4FFFBF6F4FFFBF6F4FFFCF6F3FFFCF6F3FFFCF4F2FFFBF5
        F1FFFBF5F0FFFDFBF9FFBF8C7BFF0000000B000000000000000000000005C799
        85FFFFFEFEFFFCF8F7FFFCF8F6FFFCF7F5FFFCF7F5FFFBF6F4FFFBF6F4FFFCF6
        F3FFFCF6F2FFFDFCFAFFC28F7FFF0000000A000000000000000000000004C99A
        89FFFFFFFEFFFFFFFEFFFFFEFEFFFFFEFEFFFEFEFEFFFEFEFEFFFEFEFDFFFEFE
        FDFFFEFDFDFFFEFDFDFFC49382FF000000080000000000000000000000029775
        67C0CA9C8BFFCA9C8BFFC99C8AFFC99B89FFC99B8AFFCA9A88FFC89A88FFC999
        87FFC79887FFC89886FF927163C2000000050000000000000000000000010000
        0002000000030000000400000004000000050000000500000005000000060000
        0006000000060000000600000005000000010000000000000000}
      TabOrder = 2
      OnClick = btnGerarArquivoClick
    end
    object cxLabel1: TcxLabel
      Left = 88
      Top = 19
      Caption = 'Data Inicial'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
    object cxLabel2: TcxLabel
      Left = 224
      Top = 19
      Caption = 'Data Final'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
  end
  object status: TcxLabel
    Left = 307
    Top = 180
    Caption = 'status'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxImage1: TcxImage
    Left = 533
    Top = 264
    TabOrder = 2
    Height = 23
    Width = 36
  end
  object lblConexao: TcxLabel
    Left = 8
    Top = 267
    Caption = 'Status Conex'#227'o:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxLabel3: TcxLabel
    Left = 129
    Top = 267
    Caption = 'Conectado'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
end
