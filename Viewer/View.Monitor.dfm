object fMonitor: TfMonitor
  Left = 488
  Top = 0
  Caption = 'DB1 Log Viewer - 1.0'
  ClientHeight = 567
  ClientWidth = 1344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 1344
    Height = 567
    ActivePage = TabSheetLog
    Align = alClient
    TabOrder = 0
    TabWidth = 110
    object TabSheetLog: TTabSheet
      Caption = 'Log'
      object Splitter: TSplitter
        Left = 0
        Top = 381
        Width = 1336
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 91
        ExplicitWidth = 338
      end
      object PanelOptions: TPanel
        Left = 0
        Top = 0
        Width = 1336
        Height = 64
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          1336
          64)
        object LabelRecordInfoValue: TLabel
          Left = 613
          Top = 37
          Width = 345
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 200
        end
        object LabelFileName: TLabel
          Left = 558
          Top = 18
          Width = 50
          Height = 13
          Caption = 'Arquivo :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
        object LabelRecordInfo: TLabel
          Left = 550
          Top = 37
          Width = 58
          Height = 13
          Caption = 'Contador :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
        object LabelFileNameValue: TLabel
          Left = 614
          Top = 18
          Width = 645
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 500
        end
        object ActionToolBar: TActionToolBar
          Left = 0
          Top = 0
          Width = 545
          Height = 59
          ActionManager = ActionManager
          Align = alCustom
          Color = clMenuBar
          ColorMap.DisabledFontColor = 7171437
          ColorMap.HighlightColor = clWhite
          ColorMap.BtnSelectedFont = clBlack
          ColorMap.UnusedColor = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBackground = True
          ParentFont = False
          Spacing = 0
        end
        object GroupBoxAutoUpdate: TGroupBox
          Left = 349
          Top = 3
          Width = 185
          Height = 54
          Caption = 'Atualiza'#231#227'o autom'#225'tica       '
          TabOrder = 1
          object LabelInterval: TLabel
            Left = 9
            Top = 26
            Width = 81
            Height = 13
            Caption = 'Intervalo (segs):'
          end
          object CheckBoxAutoUpdate: TCheckBox
            Left = 124
            Top = -1
            Width = 16
            Height = 17
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = CheckBoxAutoUpdateClick
          end
          object SpinEditInterval: TSpinEdit
            Left = 96
            Top = 22
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
        Top = 64
        Width = 1336
        Height = 317
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object DBGrid: TDBGrid
          Left = 0
          Top = 39
          Width = 1336
          Height = 278
          Align = alClient
          DataSource = DataSource
          Options = [dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          PopupMenu = PopupMenu
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDblClick = DBGridDblClick
          OnKeyPress = DBGridKeyPress
          Columns = <
            item
              Expanded = False
              FieldName = 'Type'
              Title.Caption = 'Tipo'
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Database'
              Title.Caption = 'Base'
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'User'
              Title.Caption = 'Usu'#225'rio'
              Width = 140
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
              FieldName = 'DateTime'
              Title.Caption = 'Data/Hora'
              Width = 130
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Class'
              Width = 180
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Method'
              Title.Caption = 'M'#233'todo'
              Width = 420
              Visible = True
            end>
        end
        object DBGridFilter: TDBGrid
          Left = 0
          Top = 0
          Width = 1336
          Height = 39
          TabStop = False
          Align = alTop
          DataSource = DataSourceFilter
          Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          PopupMenu = PopupMenu
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnColEnter = DBGridFilterColEnter
          OnKeyPress = DBGridFilterKeyPress
          Columns = <
            item
              Expanded = False
              FieldName = 'Type'
              Title.Caption = 'Tipo'
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Database'
              Title.Caption = 'Base'
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'User'
              Title.Caption = 'Usu'#225'rio'
              Width = 140
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
              FieldName = 'DateTime'
              Title.Caption = 'Data/Hora'
              Width = 130
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Class'
              Title.Caption = 'Classe'
              Width = 180
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Method'
              Title.Caption = 'M'#233'todo'
              Width = 420
              Visible = True
            end>
        end
      end
      object PanelSQL: TPanel
        Left = 0
        Top = 384
        Width = 1336
        Height = 155
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object SynMemoSQL: TSynMemo
          Left = 0
          Top = 29
          Width = 1336
          Height = 126
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          TabOrder = 0
          CodeFolding.GutterShapeSize = 11
          CodeFolding.CollapsedLineColor = clGrayText
          CodeFolding.FolderBarLinesColor = clGrayText
          CodeFolding.IndentGuidesColor = clGray
          CodeFolding.IndentGuides = True
          CodeFolding.ShowCollapsedLine = False
          CodeFolding.ShowHintMark = True
          UseCodeFolding = False
          Gutter.BorderStyle = gbsNone
          Gutter.DigitCount = 3
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Gutter.LeftOffset = 10
          Gutter.ShowLineNumbers = True
          Highlighter = SynSQLSyn
          ReadOnly = True
          RightEdge = 0
          ScrollBars = ssVertical
          WordWrap = True
          FontSmoothing = fsmNone
        end
        object PanelFilterSQL: TPanel
          Left = 0
          Top = 0
          Width = 1336
          Height = 29
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            1336
            29)
          object LabelFilterSQL: TLabel
            Left = 4
            Top = 7
            Width = 28
            Height = 13
            Caption = 'Filtro:'
          end
          object EditSQLFilter: TEdit
            Left = 36
            Top = 4
            Width = 1299
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            MaxLength = 200
            TabOrder = 0
            OnKeyPress = EditSQLFilterKeyPress
          end
        end
      end
    end
    object TabSheetSQL: TTabSheet
      Caption = 'SQL'
      ImageIndex = 2
      OnEnter = TabSheetSQLEnter
      object SynMemoTab: TSynMemo
        Left = 0
        Top = 45
        Width = 1336
        Height = 494
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        CodeFolding.GutterShapeSize = 11
        CodeFolding.CollapsedLineColor = clGrayText
        CodeFolding.FolderBarLinesColor = clGrayText
        CodeFolding.IndentGuidesColor = clGray
        CodeFolding.IndentGuides = True
        CodeFolding.ShowCollapsedLine = False
        CodeFolding.ShowHintMark = True
        UseCodeFolding = False
        Gutter.BorderStyle = gbsNone
        Gutter.DigitCount = 3
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.LeftOffset = 10
        Gutter.ShowLineNumbers = True
        Highlighter = SynSQLSyn
        ReadOnly = True
        RightEdge = 0
        FontSmoothing = fsmNone
      end
      object PanelSQLTab: TPanel
        Left = 0
        Top = 0
        Width = 1336
        Height = 45
        Align = alTop
        TabOrder = 1
        object DBNavigator: TDBNavigator
          Left = 1215
          Top = 1
          Width = 120
          Height = 43
          DataSource = DataSource
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
          Align = alRight
          TabOrder = 0
        end
        object LabeledEditDatabase: TLabeledEdit
          Left = 3
          Top = 17
          Width = 95
          Height = 21
          EditLabel.Width = 27
          EditLabel.Height = 13
          EditLabel.Caption = 'Base:'
          LabelSpacing = 2
          ReadOnly = True
          TabOrder = 1
        end
        object LabeledEditUser: TLabeledEdit
          Left = 103
          Top = 17
          Width = 160
          Height = 21
          EditLabel.Width = 40
          EditLabel.Height = 13
          EditLabel.Caption = 'Usu'#225'rio:'
          LabelSpacing = 2
          ReadOnly = True
          TabOrder = 2
        end
        object LabeledEditIP: TLabeledEdit
          Left = 268
          Top = 17
          Width = 110
          Height = 21
          EditLabel.Width = 14
          EditLabel.Height = 13
          EditLabel.Caption = 'IP:'
          LabelSpacing = 2
          ReadOnly = True
          TabOrder = 3
        end
        object LabeledEditDateTime: TLabeledEdit
          Left = 383
          Top = 17
          Width = 121
          Height = 21
          EditLabel.Width = 54
          EditLabel.Height = 13
          EditLabel.Caption = 'Data/Hora:'
          LabelSpacing = 2
          ReadOnly = True
          TabOrder = 4
        end
        object LabeledEditClass: TLabeledEdit
          Left = 509
          Top = 17
          Width = 200
          Height = 21
          EditLabel.Width = 35
          EditLabel.Height = 13
          EditLabel.Caption = 'Classe:'
          LabelSpacing = 2
          ReadOnly = True
          TabOrder = 5
        end
        object LabeledEditMethod: TLabeledEdit
          Left = 714
          Top = 17
          Width = 442
          Height = 21
          EditLabel.Width = 40
          EditLabel.Height = 13
          EditLabel.Caption = 'M'#233'todo:'
          LabelSpacing = 2
          ReadOnly = True
          TabOrder = 6
        end
      end
    end
    object TabSheetOptions: TTabSheet
      Caption = 'Op'#231#245'es'
      object GroupBoxLog: TGroupBox
        Left = 18
        Top = 16
        Width = 327
        Height = 130
        Caption = 'Log: '
        TabOrder = 0
        object LabelIgnoreBasicLogInfo: TLabel
          Left = 256
          Top = 78
          Width = 19
          Height = 13
          Cursor = crHandPoint
          Caption = '[ ? ]'
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          StyleElements = [seClient, seBorder]
          OnClick = LabelIgnoreBasicLogInfoClick
        end
        object LabelRowSelectInfo: TLabel
          Left = 176
          Top = 104
          Width = 19
          Height = 13
          Cursor = crHandPoint
          Caption = '[ ? ]'
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          StyleElements = [seClient, seBorder]
          OnClick = LabelRowSelectInfoClick
        end
        object ToggleSwitchShowOnlySQL: TToggleSwitch
          Left = 8
          Top = 23
          Width = 214
          Height = 20
          StateCaptions.CaptionOn = 'Exibir somente logs do tipo "SQL"'
          StateCaptions.CaptionOff = 'Exibir somente logs do tipo "SQL"'
          TabOrder = 0
          OnClick = ToggleSwitchShowOnlySQLClick
        end
        object ToggleSwitchHighlightErrors: TToggleSwitch
          Left = 8
          Top = 49
          Width = 172
          Height = 20
          StateCaptions.CaptionOn = 'Destacar linhas de erros'
          StateCaptions.CaptionOff = 'Destacar linhas de erros'
          TabOrder = 1
          OnClick = ToggleSwitchHighlightErrorsClick
        end
        object ToggleSwitchIgnoreBasicLog: TToggleSwitch
          Left = 8
          Top = 75
          Width = 241
          Height = 20
          StateCaptions.CaptionOn = 'Ignorar logs da classe TfpgServidorDM'
          StateCaptions.CaptionOff = 'Ignorar logs da classe TfpgServidorDM'
          TabOrder = 2
          OnClick = ToggleSwitchIgnoreBasicLogClick
        end
        object ToggleSwitchRowSelect: TToggleSwitch
          Left = 8
          Top = 101
          Width = 163
          Height = 20
          StateCaptions.CaptionOn = 'Selecionar linha inteira'
          StateCaptions.CaptionOff = 'Selecionar linha inteira'
          TabOrder = 3
          OnClick = ToggleSwitchRowSelectClick
        end
      end
      object GroupBoxVisual: TGroupBox
        Left = 18
        Top = 279
        Width = 327
        Height = 143
        Caption = 'Visual: '
        TabOrder = 1
        object LabelStyle: TLabel
          Left = 8
          Top = 88
          Width = 30
          Height = 13
          Caption = 'Tema:'
        end
        object ComboBoxStyles: TComboBox
          Left = 8
          Top = 104
          Width = 189
          Height = 21
          Style = csDropDownList
          DropDownCount = 20
          TabOrder = 2
          OnSelect = ComboBoxStylesSelect
        end
        object ToggleSwitchStayOnTop: TToggleSwitch
          Left = 8
          Top = 53
          Width = 224
          Height = 20
          StateCaptions.CaptionOn = 'Manter na frente de outras janelas'
          StateCaptions.CaptionOff = 'Manter na frente de outras janelas'
          TabOrder = 1
          OnClick = ToggleSwitchStayOnTopClick
        end
        object ToggleSwitchShowBottomPanel: TToggleSwitch
          Left = 8
          Top = 27
          Width = 203
          Height = 20
          StateCaptions.CaptionOn = 'Exibir painel inferior com a SQL'
          StateCaptions.CaptionOff = 'Exibir painel inferior com a SQL'
          TabOrder = 0
          OnClick = ToggleSwitchShowBottomPanelClick
        end
      end
      object GroupBoxShortCuts: TGroupBox
        Left = 367
        Top = 16
        Width = 217
        Height = 201
        Caption = 'Atalhos: '
        TabOrder = 2
        object LabelCtrlO: TLabel
          Left = 23
          Top = 24
          Width = 43
          Height = 13
          Caption = 'Ctrl + O'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelCtrlL: TLabel
          Left = 25
          Top = 43
          Width = 41
          Height = 13
          Caption = 'Ctrl + L'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelF5: TLabel
          Left = 53
          Top = 62
          Width = 13
          Height = 13
          Caption = 'F5'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelCtrlC: TLabel
          Left = 24
          Top = 89
          Width = 42
          Height = 13
          Caption = 'Ctrl + C'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelCtrlQ: TLabel
          Left = 23
          Top = 108
          Width = 43
          Height = 13
          Caption = 'Ctrl + Q'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelAlt1: TLabel
          Left = 28
          Top = 135
          Width = 38
          Height = 13
          Caption = 'Alt + 1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelAlt2: TLabel
          Left = 28
          Top = 154
          Width = 38
          Height = 13
          Caption = 'Alt + 2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelAlt3: TLabel
          Left = 28
          Top = 173
          Width = 38
          Height = 13
          Caption = 'Alt + 3'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelOpenFile: TLabel
          Left = 72
          Top = 24
          Width = 70
          Height = 13
          Caption = ': Abrir Arquivo'
        end
        object LabelClearLog: TLabel
          Left = 72
          Top = 43
          Width = 58
          Height = 13
          Caption = ': Limpar Log'
        end
        object LabelReloadLog: TLabel
          Left = 72
          Top = 62
          Width = 69
          Height = 13
          Caption = ': Atualizar Log'
        end
        object LabelCopyColumnValue: TLabel
          Left = 72
          Top = 89
          Width = 60
          Height = 13
          Caption = ': Copiar SQL'
        end
        object LabelCopySQL: TLabel
          Left = 72
          Top = 108
          Width = 116
          Height = 13
          Caption = ': Copiar Valor da Coluna'
        end
        object LabelShowLogTab: TLabel
          Left = 72
          Top = 135
          Width = 83
          Height = 13
          Caption = ': Exibir Aba "Log"'
        end
        object LabelShowSQLTab: TLabel
          Left = 72
          Top = 154
          Width = 85
          Height = 13
          Caption = ': Exibir Aba "SQL"'
        end
        object LabelShowOptionsTab: TLabel
          Left = 72
          Top = 173
          Width = 102
          Height = 13
          Caption = ': Exibir Aba "Op'#231#245'es"'
        end
        object BevelSeparator1: TBevel
          Left = 13
          Top = 81
          Width = 191
          Height = 10
          Shape = bsTopLine
        end
        object BevelSeparator2: TBevel
          Left = 13
          Top = 127
          Width = 191
          Height = 10
          Shape = bsTopLine
        end
      end
      object GroupBoxSQL: TGroupBox
        Left = 18
        Top = 159
        Width = 327
        Height = 109
        Caption = 'SQL: '
        TabOrder = 3
        object LabelAutoFormatInfo: TLabel
          Left = 295
          Top = 52
          Width = 19
          Height = 13
          Cursor = crHandPoint
          Caption = '[ ? ]'
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          StyleElements = [seClient, seBorder]
          OnClick = LabelAutoFormatInfoClick
        end
        object ToggleSwitchAutoFormatSQL: TToggleSwitch
          Left = 8
          Top = 49
          Width = 283
          Height = 20
          StateCaptions.CaptionOn = 'Identar SQL automaticamente no painel inferior'
          StateCaptions.CaptionOff = 'Identar SQL automaticamente no painel inferior'
          TabOrder = 0
          OnClick = ToggleSwitchAutoFormatSQLClick
        end
        object ToggleSwitchShowLineNumbers: TToggleSwitch
          Left = 8
          Top = 23
          Width = 208
          Height = 20
          StateCaptions.CaptionOn = 'Exibir n'#250'mero das linhas na SQL'
          StateCaptions.CaptionOff = 'Exibir n'#250'mero das linhas na SQL'
          TabOrder = 1
          OnClick = ToggleSwitchShowLineNumbersClick
        end
        object ToggleSwitchUseToDateFunction: TToggleSwitch
          Left = 8
          Top = 75
          Width = 283
          Height = 20
          StateCaptions.CaptionOn = 'Identar SQL automaticamente no painel inferior'
          StateCaptions.CaptionOff = 'Usar fun'#231#227'o "to_date" para as datas'
          TabOrder = 2
          OnClick = ToggleSwitchAutoFormatSQLClick
        end
      end
    end
  end
  object DataSource: TDataSource
    DataSet = LogViewer
    Left = 979
    Top = 371
  end
  object TimerAutoUpdate: TTimer
    Enabled = False
    OnTimer = TimerAutoUpdateTimer
    Left = 1035
    Top = 371
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 1063
    Top = 371
    object MenuItemCopySQL: TMenuItem
      Caption = 'Copiar SQL'
      ShortCut = 16451
      OnClick = MenuItemCopySQLClick
    end
    object MenuItemCopyColumnValue: TMenuItem
      Caption = 'Copiar Coluna'
      ShortCut = 16465
      OnClick = MenuItemCopyColumnValueClick
    end
  end
  object ImageList: TImageList
    ColorDepth = cd32Bit
    Height = 32
    Width = 32
    Left = 1091
    Top = 371
    Bitmap = {
      494C010103000500040020002000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000800000002000000001002000000000000040
      000000000000000000000000000000000000000000000000000000060809000F
      1517000F1517000F1517000F1517000F1517000F1517000F1517000F1517000F
      1517000F1517000F1517000F1517000F1517000F1517000F1517000F1517000F
      1517000F1517000F1517000F1517000F1517000F1517000F151700090D0E0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000085C7D8C0DA8E1FB0DAB
      E5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DAB
      E5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DAB
      E5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DABE5FF0DA9E3FD0757
      7582000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000002020203050505060909090A0B0B
      0B0C0D0D0D0E0E0E0E0F0F0F0F1010101011101010110F0F0F100F0F0F100D0D
      0D0E0C0C0C0D0909090A06060607030303040000000100000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101020606
      06070B0B0B0C0E0E0E0F10101011131313141414141515151516151515161515
      151613131314111111120F0F0F100C0C0C0D0909090A04040405000000010000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000D9CD3ED0EABE5FF0EAB
      E5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EAB
      E5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EAB
      E5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EABE5FF0EA9
      E3FD01161E210000000000000000000000000000000000000000000000000000
      000000000001040404050909090A0D0D0D0E1111111215151516181818191B1B
      1B1C1D1D1D1E1F1F1F2020202021212121222121212221212122202020211E1E
      1E1F1C1C1C1D1919191A16161617121212130F0F0F100A0A0A0B060606070101
      0102000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000030303040909090A0F0F0F10141414151919
      191A1E1E1E1F2121212225252526262626282828282A2929292B2929292B2929
      292B2727272926262627232323241F1F1F201B1B1B1C17171718121212130C0C
      0C0D060606070000000100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000001010D92D3FB13ADE6FF13AD
      E6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13AD
      E6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13AD
      E6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13ADE6FF13AD
      E6FF07475F6A0000000000000000000000000000000000000000000000000505
      05060A0A0A0B10101011151515161A1A1A1B1E1E1E1F22222223262626282929
      292B2C2C2C2E2F2F2F31303030333030303331313134303030332F2F2F312D2D
      2D2F2A2A2A2C27272729242424251F1F1F201B1B1B1C16161617111111120C0C
      0C0D070707080101010200000000000000000000000000000000000000000000
      000000000000020202030A0A0A0B10101011171717181E1E1E1F242424252929
      292B2E2E2E304345454A5293A0C0558F9ABB62787D924B4D4D553C3C3C413C3C
      3C403A3A3A3E3737373B34343437303030322B2B2B2D26262628212121221A1A
      1A1B141414150D0D0D0E06060607000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000070C100D7CC8FF18AEE7FF18AE
      E7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AE
      E7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AE
      E7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AEE7FF18AE
      E7FF10749BAC0000000000000000000000000000000000000001060606070C0C
      0C0D12121213181818191E1E1E1F23232324272727292D2D2D2F313131343636
      36393939393D3C3C3C413F3E3E44615E5C70736C678A85776CA68E7B6BB58E7B
      6BB482756D9D65615E724A4948502929292B252525261F1F1F201A1A1A1B1414
      14150E0E0E0F0808080902020203000000000000000000000000000000000000
      0000030303040B0B0B0C131313141A1A1A1B222222232828282A2F2F2F313535
      35384141424732A8BDEB67D5E6FF46C5DBFF5CCBDCFC31AAC0F03B9AAFDD6170
      748B4C4C4C564646464E424242483D3D3D423737373B323232352C2C2C2E2525
      25261E1E1E1F171717180F0F0F10070707080000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000010F1C250E73C1FF4CBEE9FF1DB0
      E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0
      E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0
      E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0E8FF1DB0
      E8FF1BA3D5EC00010202000000000000000000000000040404050A0A0A0B2424
      24257B726A8D1D1D1D1E232323242828282A2E2E2E30333333363838383C3D3D
      3D425E5B5A6C8D7A6CB5A47A57E7B3865EF2C18B58FFC38D5AFFC48E5AFFC48F
      59FFC08650FFB77A49FDA97F59E4957D6ABE4746454C252525261F1F1F201818
      1819121212130C0C0C0D06060607000000000000000000000000000000000000
      000008080809101010111818181920202021262626282E2E2E30353535383C3C
      3C404897A6CC66D7E7FF0AB1CEFF36CEE1FF4AD1E3FF12B4D2FF6BDAE8FF5AC8
      D9FB1BA0BCF361787C994A4A4A544545454C3E3E3E443838383C313131342A2A
      2A2C242424251C1C1C1D141414150C0C0C0D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000001172A38056EC0FF99D1E9FF22B1
      E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1
      E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1
      E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1E8FF22B1
      E8FF22B1E8FF06222C31000000000000000000000000040404050A0A0A0B2626
      2627A77E5BE187796F9F242424252929292B2F2F2F31343434375A585665997F
      69CBB38660F2C9996AFFCD9C69FFCC9864FFCA955FFFC9925BFFC89159FFC890
      58FFC78F57FFC78F56FFC68E55FFC1864DFFAC7A51ED6F69647D1F1F1F201919
      191A121212130C0C0C0D06060607000000000000000000000000000000000000
      000008080809101010111818181920202021272727292F2F2F31363636396172
      76883ABFD4FA3EC9DEFF04BDD6FF47D3E4FF07B0CEFF15C7DDFF4FD5E6FF29C0
      D7FF4DCFE1FF5DCBDCFC2D9DB4E7617C819C3F3F3F453939393D323232352B2B
      2B2D242424251C1C1C1D141414150C0C0C0D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000220394C056EC0FFC2D7E6FF3EB9
      EAFF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3
      E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3
      E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3E9FF27B3
      E9FF27B3E9FF114F697300000000000000000000000001010102080808092323
      2324B08F71E0CAAB8CF6736C6782252525262B2B2B2D8C7C6FAAB48D68F0D2A5
      79FFCE9E6DFFCB9662FFCA9560FFCA945FFFCA945DFFC9935CFFC9925BFFC891
      59FFC89058FFC78F56FFC78E55FFC68D53FFC68C52FFB27B48F87B726A8D1515
      15160F0F0F100909090A03030304000000000000000000000000000000000000
      0000040404050C0C0C0D141414151B1B1B1C232323242929292B303030323CA4
      B9E44BD3E5FF06B5D2FF1AC8DEFF23C0D9FF08C3DBFF39D3E6FF41CFE2FF03B2
      D0FF4AD4E5FF28C3DAFF2BBFD8FF33B5C6F25E8890AB333333362F2F2F312626
      26281F1F1F20171717180F0F0F10080808090000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000012A4860056EC0FFABCAE1FF95D3
      EBFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4
      EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4
      EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4EAFF2CB4
      EAFF2CB4EAFF1F7FA6B500000000000000000000000000000000010101021C1C
      1C1DB08F74DEE3C8AEFFBE9D81EC6E68637BA78261E2D1A883FFD1A272FFCC99
      66FFCC9864FFCB9763FFCB9662FFCA9560FFCA945FFFC9935DFFCA9560FFCA95
      60FFCA945FFFCA935CFFC89059FFC78E55FFC68C53FFC68B51FFB17D50F24E4C
      4A520909090A0202020300000000000000000000000000000000000000000000
      000000000000030303040B0B0B0C121212131919191A1F1F1F2053595B623EBE
      D5F935CADFFF01BBD6FF2CCFE3FF09B7D4FF15CFE7FF56DCEDFF13B7D3FF27C8
      DEFF30C7DEFF00B4D1FF03C3DAFF62DAE9FF61D1E0FD3D9FB2DA4F54555B1C1C
      1C1D151515160E0E0E0F07070708000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000033257740670C2FF92BDDDFFE2EA
      EDFF3AB8EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6
      EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6
      EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6EBFF31B6
      EBFF31B6EBFF2FACDFF201030404000000000000000000000000000000001515
      1516B09075DDE1C2A6FFE1C3A6FFCBA582FCE0C2A5FFDAB693FFCF9F6EFFCD9A
      67FFCC9966FFCC9864FFCC9865FFCE9D6BFFCC9C6BFFC18F64FEB48866EAB27D
      4EF6AE7349F7AF784CF6AF7D51F1B48355F2BF864FFFC68C53FFC68B51FFA082
      69CB0C0C0C0D0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000050505060B0B0B0C1111111259929DB44CD1
      E3FF11C0D9FF0DC8E1FF1FC7E0FF15C7E2FF2DD8EDFF3CCEE4FF0CBCD8FF3CCF
      E2FF01B0CEFF00C2DAFF31CEE1FF4CD4E5FF2FC3DBFF39C1D8FF49AEC2E52525
      2526080808090101010200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000043D69870975C8FF78B0DBFFEEEE
      EEFF86CEECFF42BDEDFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7
      ECFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7
      ECFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7ECFF36B7
      ECFF36B7ECFF36B7ECFF0C2A353A000000000000000000000000000000001515
      1516B09075DDE1C3A6FFDCB998FFDFBEA0FFDBB796FFDBB695FFD9B491FFD2A3
      75FFCC9967FFD0A070FFCC9E70FFAF8C6CE199826FBD6C6661774C4A49505653
      515B6C656074A48A75BDD3B59EF2C9A282F8B28A62E7AF8257EAC68C53FFB37C
      4DF6403F3E420000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001515151651ABBAD632CE
      E1FF0BC0DCFF1BD3EAFF14C1DEFF27DAF3FF3DDCF1FF0EB5D4FF31D4E8FF0EB5
      D2FF00C0D8FF21CADFFF45D3E4FF0FB6D2FF2DC5DBFF64DAE8FF68D4E3FD5199
      A8C2000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000007497D9B0C7ACDFF60A6D9FFEEEE
      EEFFD6E6EDFF4FC2EFFF59C7F1FF3BB9EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9
      EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9
      EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9EDFF3BB9
      EDFF3BB9EDFF3BB9EDFF1D59727C000000000000000000000000000000001414
      1415B19076DDE1C3A7FFDCB998FFDCB998FFDCB897FFDBB795FFDBB695FFDBB8
      96FFDAB492FFAF9170DF84786E96323232340202020301010102010101020000
      000100000000000000009D8876AFBEB4ABCAA49E98AAA49385B6AC8159E7BF84
      4AFF7F756C8F0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003233343541B9CDF221CD
      E2FF17CCE6FF22D4EDFF21CEE8FF30E1F8FF1FC9E3FF1DCDE7FF26C7E0FF02BC
      D6FF12C6DDFF3DCEE2FF07B2CFFF35CBDFFF6FDDEAFF66BECBE661868D9A0C0C
      0C0D000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A5690AF1080D3FF4A9CDAFFEEEE
      EEFFEDEDEDFF94D1EAFF5AC6F1FF74D3F6FF73D3F6FF73D3F6FF73D3F6FF73D3
      F6FF73D3F6FF73D3F6FF73D3F6FF75D4F6FF64CBF3FF41BAEEFF40BAEEFF40BA
      EEFF40BAEEFF40BAEEFF40BAEEFF40BAEEFF40BAEEFF40BAEEFF40BAEEFF40BA
      EEFF40BAEEFF40BAEEFF2F8BB1BE000000000000000000000000000000001414
      1415B19074DDE1C4A8FFDCB998FFDCB998FFDCB998FFDBB896FFDFBFA1FFCDAB
      90F49A8473BA2424242500000000000000000000000000000000000000000000
      000000000000000000001D1D1D1E9D9187A87D7B78815F5E5D61837A738FB085
      5BE899826EB90000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000051595B5E41CADFFF24D2
      E8FF25D9F1FF29D7F1FF32DCF5FF30DCF5FF1AC6E3FF2DD8F0FF0BBEDBFF08C4
      DBFF31CBE0FF03B7D4FF3CD1E3FF79D7E4FE5DACB9D3484D4E51000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000F65A5C31284D8FF3394DBFFEEEE
      EEFFEDEDEDFFEAE3D4FFAB9F65FFB1C4B9FFB4CBD1FF9EB9BDFFAFC7CDFFBAD5
      DEFFC0DEEAFFADC2C6FF95B3B8FF8BC2D6FF63C6EEFF73D2F5FF46BCEEFF45BC
      EEFF45BCEEFF45BCEEFF45BCEEFF45BCEEFF45BCEEFF45BCEEFF45BCEEFF45BC
      EEFF45BCEEFF45BCEEFF43B6E6F7020607080000000000000000000000001414
      1415B19075DDE2C4A9FFDCB998FFDCB998FFDCB998FFDEBC9CFFDCBA9CFF8F7E
      70A7000000000000000000000000000000000000000000000000000000000000
      000000000000000000000D0D0D0E76716E7A5555545737373738181818199F83
      6DC2A07F62CE0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000617C828B51D4E7FF27DB
      F0FF34E3FBFF34D7F0FF46E6FCFF27CCE7FF2EDFF6FF19CBE5FF0FC6DFFF23C8
      DDFF01BAD5FF3BD0E3FF69D1E0FB649198A81616161700000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001173B8D61589DDFF1E8DDDFFEEEE
      EEFFEDEDEDFFEBE8E3FFD8C49CFFE1DACAFFD9D0C8FFC2BFB5FFD1CBC3FFDDD7
      D0FFEAEAEAFFD4C9BEFFB5B1A5FFD5CABFFFC6CAC8FF78C7E8FF6CCEF4FF4ABD
      EFFF4ABDEFFF4ABDEFFF4ABDEFFF4ABDEFFF4ABDEFFF4ABDEFFF4ABDEFFF4ABD
      EFFF4ABDEFFF4ABDEFFF4ABDEFFF12303E420000000000000000000000001414
      1415B19076DDE2C5A9FFDCB998FFDCB998FFDCB998FFDCB998FFE0C0A3FFC7A4
      86F05D5956620000000000000000000000000000000000000000000000000000
      00000000000000000000070707084C4B4A4D2D2D2D2E0E0E0E0F00000000766E
      6783A37F60D40000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006188909D56DAEDFF30E1
      F8FF43E6FCFF45DDF3FF47DEF4FF38D9F2FF2DDDF4FF19CCE7FF1BCAE1FF00BD
      D6FF35CFE1FF68CDDDF662848A97000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001C83CBE61C90E2FF188EE2FFE0E8
      EEFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFD9D0C8FFDCDBD7FFDCD8D2FFD3C7
      BBFFDCD5CFFFCCBCAEFFD7CEC6FFD0C3B7FFD5CCC4FFCECBC5FF76CCF0FF65CA
      F3FF4FBEF0FF4FBEF0FF4FBEF0FF4FBEF0FF4FBEF0FF4FBEF0FF4FBEF0FF4FBE
      F0FF4FBEF0FF4FBEF0FF4FBEF0FF29637C840000000000000000000000001414
      1415B19076DDE3C8AEFFDEBD9DFFDEBC9DFFDEBC9CFFDDBC9CFFDDBB9CFFE1C5
      A9FFBA9B7BE73C3B3B3E00000000000000000000000000000000000000000000
      00000000000000000000010100011C1C1C1D050404050000000000000000605C
      59679A7F69C00000000000000000000000000000000000000000000000000000
      00000000000000000000000000000909090A5E5E6C7E5D8596AE63DFF0FF3EE6
      FDFF51E5FAFF56E1F5FF52E4F8FF45E7FDFF26D6EEFF19D0E8FF06C1DCFF2ECD
      E0FF5EC6D4F15F74787F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000013639CAD42A2E9FF2E9AE7FFCCE0
      EEFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFE2DDD8FFDAD1C8FFDDD6D0FFE2DE
      D9FFE7E5E3FFE9E9E9FFE8E8E8FFE7E6E6FFE0DEDBFFD9D3CDFFC3D0D3FF74CF
      F4FF65C9F3FF55C0F1FF55C0F1FF55C0F1FF55C0F1FF55C0F1FF55C0F1FF55C0
      F1FF55C0F1FF55C0F1FF55C0F1FF4D9CBCC60000000000000000000000001414
      1415A98160E0D8B699FFD8B598FFD7B698FFD8B698FFD8B698FFD7B598FFD8B6
      98FFD5B190FFA9825EE423232324000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003535
      3437726A657D0000000000000000000000000000000000000000000000000000
      000000000000000000000000000061617B9B0404A0FC06118EFB14429AFF65DB
      F2FF65EAFCFF69E9FAFF5AEAFDFF3CE4FAFF26D9F0FF14CEE6FF2FCDE1FF4EBB
      CCEC5864666B0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000002090F101354818D2E75A7B6A8BE
      CEDFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFE3DFDAFFE8E7
      E5FFDBD3CCFFD5CAC0FFD8CFC6FFD6CDC3FFDDD7D1FFE4E3E2FFD1D2D2EB7A9F
      B0C074CFF5FE81D7F8FF6FCDF5FF69CAF4FF69CAF4FF69CAF4FF69CAF4FF69CA
      F4FF69CAF4FF6BCBF4FF81D7F8FF54ADD6E10000000000000000000000000000
      00003434333653504E57545250595754525C5855535D5B5755605C5956625E5A
      5764605C5966615D5A68161616170000000000000000101010117F746C8D9582
      71B2998475B5998475B5998473B5998473B5998473B5998474B6998474B69782
      71B65D5956620000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424284D20000B8FF0000C3FF0E0FBCFF0C1C
      8AFE4D7BBAFF7AEAFAFF53E9FDFF37E6FDFF26D9F0FF4DD7EAFF3EB1C3E7454A
      4B4D000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000A0B
      0B0D252525284646464BEEEEEEFFEDEDEDFFEDEDEDFFEDEDEDFFE6E2DFFFDED7
      D0FFE7E5E3FFE3E3E3F7B5B5B5C68383838F515151591F1F1F23000000000000
      00002040505456ADD8E370CDF5FF75D0F6FF75D0F6FF75D0F6FF75D0F6FF75D0
      F6FF75D0F6FF73CFF6FF62C4F2FE2751656B0000000000000000000000000808
      08099E7D61CF0606060700000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005E5B5864B995
      74EED9B696FFD8B290FFD7B18FFFD7B18FFFD7B28FFFD7B390FFD8B492FFD7B2
      92FF958271B30000000000000000000000000000000000000000000000000000
      000000000000000000000F0F0F10568A9CB90D2E8BFC05109BFF1D1DD4FF3636
      E7FF3338C2FE13268AFE4BA5D2FF56E6F9FF4FD0E4FD44A3B7D7202020210000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000B0B0B0CEBEBEBFCEDEDEDFFEBEBEBFDC6C6C6D69393939F6161
      61692F2F2F33050505050000000000000000050A080E00000000000000000000
      00000000000002030404162E393D204252572042525720425257204252572042
      5257204252572042525710222B2D000000000000000000000000000000001C1C
      1C1DA77752E95A58555E3E3D3C3F2F2F2F302D2D2C2E1B1B1B1C000000000000
      0000000000000000000000000000000000000000000000000000000000006A65
      6172C6A283F2D6AC86FFD1A375FFD0A172FFCF9F70FFCF9F6FFFCF9F6FFFD8B3
      92FF988475B40000000000000000000000000000000000000000000000000000
      0000000000003C3F3F4135A5BBDF2BCBDFFF26D0E6FF339CCCFF12258EFF2C30
      C2FF5757FCFF3B3BE4FF111A9BFE224492ED5F73777E00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000444444493E3E3E430E0E0E0F00000000000000000000
      00000000000000000000000000000000000025A05FD81C7444A0041209180000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002020
      2021AA7650F2958577AB78726C7F6C67647179726B8332313133000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F746D8DCCA786F8D3A980FFD0A273FFD0A071FFCF9F6FFFCF9F6FFFD8B2
      91FF998474B60000000000000000000000000000000000000000000000000000
      000000000000343536374A9FAFCC36BED4F64FDEF0FF64EAFBFF6BE8FAFF3F7B
      BCFF1B2794FF2829C8FF1A1ACAFF363683DD0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000197B4BA129C175FF29B26BF11354
      3273000401050000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002C2C
      2B2DB38764F0AA7C59EBA7907EC09C8B7DB19F8777BD5855525D000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003C3B3B3EAE8D70DBD9B392FFD1A475FFD0A172FFCF9F6FFFCF9F6FFFD7B3
      90FF998474B60000000000000000000000000000000000000000000000000000
      00000000000000000000000000006073788121A8C6FD68DFF2FF80EFFDFF79EE
      FDFF79DDF1FF294996F1262982EA535359620000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000D4C316024C97EFF26C57AFF29C1
      75FF24A05FD70C331E4600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002323
      2324B2937ADCB68C6BF1B87B4FFFBB8C66F1B08765E8756D6880000000000000
      00000000000000000000000000000000000000000000000000000F0F0F108478
      7094B89B81E4D9B390FFD2A579FFD1A375FFD0A273FFCFA070FFCF9F6FFFD7B1
      8EFF9A8473B80000000000000000000000000000000000000000000000000000
      000000000000000000001E1E1E1F3D779ADD0F6FAAFF0E8FBAFF39BAD6FF85E9
      F7FF8EF0FDFF5CA4B1C800000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000010A070B0D2A1F2F0000000000000000000000000000
      000000000000000000000000000004211729148A5AA720D086FF22CD83FF24C9
      7EFF26C57AFF28C176FF208350AE0107040B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A78971D2E6CEB9FFAD7D57F4AE6F40FFB6794DFFA2836BCF524F4D560000
      0000000000000000000000000000000000002E2D2D2F7D736B8BAC8F78D5CDAB
      8AFDD6AD87FFD3A87CFFD2A679FFD2A477FFD1A274FFD0A071FFCF9F6FFFD7B1
      8EFF9A8572B90000000000000000000000000000000000000000000000000000
      00000000000000000000557C93C0217BB7FF0B6DADFF106EABFF387C9EDD6099
      A4B960C3D3EE59A0B0C700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000D6C4A7E0A52375F0324182A042D1F350740
      2C4B0A5D3F6C1082589915B77BD61AD991FF1BD78FFF1CD58DFF1ED28AFF20D0
      87FF22CD83FF24CA7EFF3ACE88FF113A264A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F766E8CDDBFA6FFE8D2BDFFBC9679F0A7734FF2A7643AFDA27454E49D7C
      62CD83766C956E6762787B736C899F8B7BBDBC9D87E4DCBEA3FFE3C8ADFFDEBF
      A0FFDAB492FFD4A981FFD3A77AFFD2A578FFD6AD86FFD5AB83FFCF9F70FFD7B0
      8DFF9A8473BA0000000000000000000000000000000000000000000000000000
      0000000000005E686E7B3584B9F81379BBFF0C72B4FF1D77B1FF617887A30000
      0000464A4B4D5761636700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000020E091016BE81DE19DB94FF19DB94FF19DB
      94FF19DB94FF19DB94FF19DB94FF19DA93FF19DA93FF1AD991FF1BD78FFF1CD5
      8DFF1ED38AFF20D087FF3EBC83DD0308060A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002F2E2E30BBA08AE2EAD4C0FFE9D2BEFFE4C9B2FFD2B294FCC3A287F3BF9E
      7DF5C6A183F6CFB093F9DDC0A5FFE2C8AFFFE4C9AFFFE2C5ABFFE2C4A8FFE1C3
      A6FFE0C1A5FFDEBD9FFFD7B08BFFD9B48FFFC39871F9BD9E79E9D6AC86FFD6B0
      8CFF9C8473BB0000000000000000000000000000000000000000000000000000
      0000343535374685AEE6258AC7FF0D79C0FF1B82C0FF3A7DA7E8343535370000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000523182820C387E219DB94FF19DB
      94FF19DB94FF19DB94FF19DB94FF19DB94FF19DB94FF19DA93FF19DA93FF1AD9
      91FF1BD78FFF37DB98FE103C2A46000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006B666272D2B398FBE9D3BEFFE8D2BDFFE8D0BBFFE7D0B9FFE6CF
      B8FFE7CDB6FFE5CBB3FFE5C9B1FFE4C9AFFFE3C7ADFFE2C6ABFFE2C4A9FFE1C3
      A7FFE0C2A6FFE1C4A8FFE0C4A9FFB79674EA69646071605C5966C09D79EED9B5
      94FF9D8471BB0000000000000000000000000000000000000000000000000000
      0101497D9ED84099CEFF0D7AC1FF0D7AC1FF3390C8FF577E95C0000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000003120D161E8E63A42ADB
      98FC19DB94FF19DB94FF19DB94FF19DB94FF19DB94FF24DD98FF19DB94FF19DA
      93FF1FDB95FF2B8F67A200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000847B7393D0B197FBE8D2BEFFE8D1BCFFE8CFB9FFE7CF
      B8FFE6CDB6FFE5CCB3FFE5CAB2FFE4C9B0FFE3C8AEFFE2C7ACFFE2C5AAFFE4C7
      ADFFE3C7AFFFC9A88AF49C8573BA1F1F1F200000000000000000706A657ABE94
      6EF39A8371BB0000000000000000000000000000000000000000000000005F6B
      727F4293C2FD0F78BCFF0D7AC1FF1E86C5FF3F89B7F4484B4D51000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000051A
      121E185A416721805C92248C639F24845F951F684B740E38273F15BA7DD819DB
      94FF3ACF95EA03120C1400000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006F696577BC997EEAE0C6ADFFE8D1BBFFE7CF
      B9FFE6CEB7FFE6CDB6FFE5CCB3FFE5CBB3FFE5CBB2FFE5CBB3FFDBBCA0FFC1A0
      81F0A18770CA504D4C5300000000000000000000000000000000000000008679
      6F989D8069C7000000000000000000000000000000000000000000000000597D
      92B84093C2FF5895BBFF3B8CBCFF3F98CDFF497D9ED800000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000F8258972EDF
      9CFF15523B5D0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001919191A877B7297AE8F74DCBF9E
      82EECFAA8EFAD8B79AFFD2AF91FFC6A284F6B79A7EE4AA8A6FD67F756D8D2F2E
      2E30000000000000000000000000000000000000000000000000000000000100
      000117171718020202030000000000000000000000000000000000000000617A
      89A44B97C4FF468AB2FF408EBDFF2F84B6FB4F53565B00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000D432F4E2CA1
      74B6000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000050505062424
      24254442414654514F5845434247343333352222222300000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001313
      13143677A0E23C90C2FF488DB6EF62747F920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000131313144E52555A3B3C3D3F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000200000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00C000001FFFFFFFFFFFFFFFFF00000000
      8000000FFF00007FFFC0001F0000000080000007F000000FFE00000300000000
      00000007E0000003F8000001000000000000000780000001F000000000000000
      0000000380000001F0000000000000000000000380000001F000000000000000
      0000000380000001F00000000000000000000003C0000003F800000100000000
      00000001E0000007FE0000030000000000000001E0000007FF80000F00000000
      00000001E0000C07FF80000F0000000000000001E003FC07FF80003F00000000
      00000000E00FFC07FF80007F0000000000000000E007FC27FF8001FF00000000
      00000000E003FC67FE0003FF0000000000000000E001FFE7FE0007FF00000000
      00000000F0018007FE000FFF00000000E0003000E3FFC007FC001FFF00000000
      F8037801E03FE007F8007FFF00000000FC7F1FFFE03FF007F800FFFF00000000
      FFFF07FFE03FF007FE00FFFF00000000FFFF03FFE03FC007FC03FFFF00000000
      FCFE00FFF01F0007FC03FFFF00000000FE0000FFF0000007F813FFFF00000000
      FE0000FFF0000007F01FFFFF00000000FF0001FFF8000007E03FFFFF00000000
      FF8003FFFC0000C7E03FFFFF00000000FFE003FFFE0003E7E07FFFFF00000000
      FFFFC7FFFF000FE3E07FFFFF00000000FFFFCFFFFFC07FFFE0FFFFFF00000000
      FFFFFFFFFFFFFFFFF1FFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = ActionOpenFile
            Caption = '&Abrir Arquivo'
            ImageIndex = 0
            ShortCut = 16463
          end
          item
            Caption = '-'
          end
          item
            Action = ActionReloadLog
            Caption = 'A&tualizar Log'
            ImageIndex = 1
            ShortCut = 16500
          end
          item
            Caption = '-'
          end
          item
            Action = ActionClearLog
            Caption = '&Limpar Log'
            ImageIndex = 2
            ShortCut = 16460
          end>
        ActionBar = ActionToolBar
        GlyphLayout = blGlyphTop
      end>
    Images = ImageList
    Left = 1119
    Top = 371
    StyleName = 'Platform Default'
    object ActionOpenFile: TAction
      Caption = 'Abrir Arquivo'
      ImageIndex = 0
      ShortCut = 16463
      OnExecute = ActionOpenFileExecute
    end
    object ActionReloadLog: TAction
      Caption = 'Atualizar Log'
      ImageIndex = 1
      ShortCut = 16500
      OnExecute = ActionReloadLogExecute
    end
    object ActionClearLog: TAction
      Caption = 'Limpar Log'
      ImageIndex = 2
      ShortCut = 16460
      OnExecute = ActionClearLogExecute
    end
  end
  object BindingsList: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 1063
    Top = 344
    object LinkControlToPropertyLabel: TLinkControlToProperty
      Category = 'Quick Bindings'
      Control = CheckBoxAutoUpdate
      Track = True
      Component = LabelInterval
      ComponentProperty = 'Enabled'
    end
    object LinkControlToPropertySpinEdit: TLinkControlToProperty
      Category = 'Quick Bindings'
      Control = CheckBoxAutoUpdate
      Track = True
      Component = SpinEditInterval
      ComponentProperty = 'Enabled'
      InitializeControlValue = False
    end
  end
  object LogViewer: TFDLogViewer
    Active = True
    AfterScroll = LogViewerAfterScroll
    Filtered = True
    FilterOptions = [foCaseInsensitive]
    Filter = '1 = 1'
    FieldDefs = <
      item
        Name = 'Type'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'Database'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'User'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'IP'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Class'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Method'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SQL'
        DataType = ftString
        Size = 15000
      end
      item
        Name = 'DateTime'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Error'
        DataType = ftString
        Size = 1
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 1007
    Top = 371
  end
  object DataSourceFilter: TDataSource
    DataSet = FDMemTableFilter
    Left = 979
    Top = 344
  end
  object FDMemTableFilter: TFDMemTable
    Active = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1007
    Top = 344
    Content = {
      414442530F00BE1610030000FF00010001FF02FF03040020000000460044004D
      0065006D005400610062006C006500460069006C0074006500720005000A0000
      005400610062006C006500060000000000070000080032000000090000FF0AFF
      0B040008000000540079007000650005000800000054007900700065000C0001
      0000000E000D000F000A00000010000111000112000113000114000115000116
      0008000000540079007000650017000A000000FEFF0B04001000000044006100
      7400610062006100730065000500100000004400610074006100620061007300
      65000C00020000000E000D000F00140000001000011100011200011300011400
      0115000116001000000044006100740061006200610073006500170014000000
      FEFF0B040008000000550073006500720005000800000055007300650072000C
      00030000000E000D000F00320000001000011100011200011300011400011500
      011600080000005500730065007200170032000000FEFF0B0400040000004900
      5000050004000000490050000C00040000000E000D000F001400000010000111
      000112000113000114000115000116000400000049005000170014000000FEFF
      0B04000A00000043006C0061007300730005000A00000043006C006100730073
      000C00050000000E000D000F0064000000100001110001120001130001140001
      15000116000A00000043006C00610073007300170064000000FEFF0B04000C00
      00004D006500740068006F00640005000C0000004D006500740068006F006400
      0C00060000000E000D000F006400000010000111000112000113000114000115
      000116000C0000004D006500740068006F006400170064000000FEFF0B040010
      0000004400610074006500540069006D00650005001000000044006100740065
      00540069006D0065000C00070000000E000D000F001400000010000111000112
      00011300011400011500011600100000004400610074006500540069006D0065
      00170014000000FEFEFF18FEFF19FEFF1AFF1B1C0000000000FF1DFEFEFEFEFE
      FF1EFEFF1F200002000000FF21FEFEFE0E004D0061006E006100670065007200
      1E00550070006400610074006500730052006500670069007300740072007900
      12005400610062006C0065004C006900730074000A005400610062006C006500
      08004E0061006D006500140053006F0075007200630065004E0061006D006500
      0A0054006100620049004400240045006E0066006F0072006300650043006F00
      6E00730074007200610069006E00740073001E004D0069006E0069006D007500
      6D0043006100700061006300690074007900180043006800650063006B004E00
      6F0074004E0075006C006C00140043006F006C0075006D006E004C0069007300
      74000C0043006F006C0075006D006E00100053006F0075007200630065004900
      440018006400740041006E007300690053007400720069006E00670010004400
      61007400610054007900700065000800530069007A0065001400530065006100
      720063006800610062006C006500120041006C006C006F0077004E0075006C00
      6C000800420061007300650014004F0041006C006C006F0077004E0075006C00
      6C0012004F0049006E0055007000640061007400650010004F0049006E005700
      68006500720065001A004F0072006900670069006E0043006F006C004E006100
      6D006500140053006F007500720063006500530069007A0065001C0043006F00
      6E00730074007200610069006E0074004C006900730074001000560069006500
      77004C006900730074000E0052006F0077004C00690073007400060052006F00
      77000A0052006F0077004900440010004F0072006900670069006E0061006C00
      1800520065006C006100740069006F006E004C006900730074001C0055007000
      640061007400650073004A006F00750072006E0061006C001200530061007600
      650050006F0069006E0074000E004300680061006E00670065007300}
    object FDMemTableFilterType: TStringField
      FieldName = 'Type'
      Size = 10
    end
    object FDMemTableFilterDatabase: TStringField
      FieldName = 'Database'
    end
    object FDMemTableFilterUser: TStringField
      FieldName = 'User'
      Size = 50
    end
    object FDMemTableFilterIP: TStringField
      FieldName = 'IP'
    end
    object FDMemTableFilterClass: TStringField
      FieldName = 'Class'
      Size = 100
    end
    object FDMemTableFilterMethod: TStringField
      FieldName = 'Method'
      Size = 100
    end
    object FDMemTableFilterDateTime: TStringField
      FieldName = 'DateTime'
    end
  end
  object SynSQLSyn: TSynSQLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    CommentAttri.Foreground = clGray
    KeyAttri.Foreground = clNavy
    NumberAttri.Foreground = clBlue
    StringAttri.Foreground = 42496
    Left = 1035
    Top = 344
  end
end
