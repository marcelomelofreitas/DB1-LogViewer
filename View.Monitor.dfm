object fMonitor: TfMonitor
  Left = 0
  Top = 0
  Caption = 'spMonitor4 - DB1 Global Software'
  ClientHeight = 498
  ClientWidth = 791
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 791
    Height = 498
    ActivePage = TabSheetLog
    Align = alClient
    TabOrder = 0
    object TabSheetLog: TTabSheet
      Caption = 'Log'
      object PanelOpcoes: TPanel
        Left = 0
        Top = 0
        Width = 783
        Height = 91
        Align = alTop
        TabOrder = 0
        object BitBtnAbrirLog: TBitBtn
          Left = 7
          Top = 4
          Width = 100
          Height = 50
          Caption = 'Abrir Log'
          TabOrder = 0
          OnClick = BitBtnAbrirLogClick
        end
        object BitBtnAtualizarLog: TBitBtn
          Left = 113
          Top = 4
          Width = 100
          Height = 50
          Caption = 'Atualizar Log'
          TabOrder = 1
          OnClick = BitBtnAtualizarLogClick
        end
        object BitBtnLimparLog: TBitBtn
          Left = 217
          Top = 4
          Width = 100
          Height = 50
          Caption = 'Limpar Log'
          TabOrder = 2
          OnClick = BitBtnLimparLogClick
        end
        object EditArquivo: TEdit
          Left = 8
          Top = 58
          Width = 469
          Height = 21
          ReadOnly = True
          TabOrder = 3
          Text = 'C:\Andre.Celestino\log2.txt'
        end
        object GroupBoxAtualizacaoAutomatica: TGroupBox
          Left = 492
          Top = 27
          Width = 185
          Height = 54
          Caption = 'Atualiza'#231#227'o autom'#225'tica       '
          TabOrder = 4
          object LabelIntervalo: TLabel
            Left = 9
            Top = 25
            Width = 81
            Height = 13
            Caption = 'Intervalo (segs):'
          end
          object CheckBoxAtualizacaoAutomatica: TCheckBox
            Left = 124
            Top = -1
            Width = 20
            Height = 17
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = CheckBoxAtualizacaoAutomaticaClick
          end
          object SpinEditIntervalo: TSpinEdit
            Left = 96
            Top = 21
            Width = 61
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 1
            Value = 1
          end
        end
      end
      object PanelGrid: TPanel
        Left = 0
        Top = 91
        Width = 783
        Height = 338
        Align = alClient
        TabOrder = 1
        ExplicitTop = 85
        ExplicitWidth = 722
        ExplicitHeight = 331
        object DBGrid: TDBGrid
          Left = 1
          Top = 1
          Width = 781
          Height = 336
          Align = alClient
          DataSource = DataSource
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'Tipo'
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Base'
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Usuario'
              Title.Caption = 'Usu'#225'rio'
              Width = 120
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'IP'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DataHora'
              Title.Caption = 'Data/Hora'
              Width = 130
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Classe'
              Width = 180
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Metodo'
              Width = 420
              Visible = True
            end>
        end
      end
      object PanelFiltro: TPanel
        Left = 0
        Top = 429
        Width = 783
        Height = 41
        Align = alBottom
        TabOrder = 2
        ExplicitTop = 416
        ExplicitWidth = 722
      end
    end
    object TabSheetOpcoes: TTabSheet
      Caption = 'Op'#231#245'es'
      object GroupBoxLog: TGroupBox
        Left = 18
        Top = 16
        Width = 213
        Height = 73
        Caption = 'Log: '
        TabOrder = 0
        object CheckBoxExibirSomenteSQL: TCheckBox
          Left = 8
          Top = 22
          Width = 189
          Height = 17
          Caption = 'Exibir somente logs do tipo "SQL"'
          TabOrder = 0
        end
        object CheckBoxDestacarLinhasErros: TCheckBox
          Left = 8
          Top = 42
          Width = 189
          Height = 17
          Caption = 'Destacar linhas de erros'
          TabOrder = 1
        end
      end
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 635
    Top = 359
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrAppWait
    Left = 666
    Top = 328
  end
  object TimerAtualizacaoAutomatica: TTimer
    Enabled = False
    OnTimer = TimerAtualizacaoAutomaticaTimer
    Left = 636
    Top = 328
  end
  object ClientDataSet: TClientDataSet
    PersistDataPacket.Data = {
      EA0000009619E0BD010000001800000008000000000003000000EA0004546970
      6F0100490000000100055749445448020002000A000442617365010049000000
      0100055749445448020002001400075573756172696F01004900000001000557
      4944544802000200320002495001004900000001000557494454480200020014
      0006436C617373650100490000000100055749445448020002006400064D6574
      6F646F01004900000001000557494454480200020064000353514C0200490000
      00010005574944544802000200983A0844617461486F72610100490000000100
      0557494454480200020014000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 666
    Top = 359
    object ClientDataSetTipo: TStringField
      FieldName = 'Tipo'
      Size = 10
    end
    object ClientDataSetBase: TStringField
      FieldName = 'Base'
    end
    object ClientDataSetUsuario: TStringField
      FieldName = 'Usuario'
      Size = 50
    end
    object ClientDataSetIP: TStringField
      FieldName = 'IP'
    end
    object ClientDataSetClasse: TStringField
      FieldName = 'Classe'
      Size = 100
    end
    object ClientDataSetMetodo: TStringField
      FieldName = 'Metodo'
      Size = 100
    end
    object ClientDataSetSQL: TStringField
      FieldName = 'SQL'
      Size = 15000
    end
    object ClientDataSetDataHora: TStringField
      FieldName = 'DataHora'
    end
  end
end
