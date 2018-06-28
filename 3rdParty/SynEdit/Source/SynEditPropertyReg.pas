{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: SynEditPropertyReg.pas, released 2000-04-07.
The Original Code is based on mwEditPropertyReg.pas, part of the
mwEdit component suite.
Unicode translation by Maël Hörz.
All Rights Reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: SynEditPropertyReg.pas,v 1.17.2.6 2008/09/14 16:24:59 maelh Exp $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

Known Issues:
-------------------------------------------------------------------------------}

unit SynEditPropertyReg;

{$I SynEdit.inc}

interface

uses
  DesignIntf,
  DesignEditors,
  VCLEditors,
  StrEdit,
  SynUnicode,
  Classes;

type
  TSynEditFontProperty = class(TFontProperty)
  public
    procedure Edit; override;
  end;

  TSynEditCommandProperty = class(TIntegerProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TSynEditKeystrokesProperty = class(TClassProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;

implementation

uses
  Dialogs,
  Forms,
  Graphics,
  Controls,
  SynEdit,
  SysUtils;

{ TSynEditFontProperty }

procedure TSynEditFontProperty.Edit;
const
  { context ids for the Font editor }
  hcDFontEditor = 25000;
var
  FontDialog: TFontDialog;
begin
  FontDialog := TFontDialog.Create(Application);
  try
    FontDialog.Font := TFont(GetOrdValue);
    FontDialog.HelpContext := hcDFontEditor;
    FontDialog.Options := FontDialog.Options + [fdShowHelp, fdForceFontExist,
       fdFixedPitchOnly];
    if FontDialog.Execute then
      SetOrdValue(NativeInt(FontDialog.Font));
  finally
    FontDialog.Free;
  end;
end;

{ TSynEditCommandProperty }

procedure TSynEditCommandProperty.Edit;
begin
  ShowMessage('I''m thinking that this will show a dialog that has a list'#13#10+
     'of all editor commands and a description of them to choose from.');
end;

function TSynEditCommandProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paDialog, paValueList, paRevertable];
end;

function TSynEditKeystrokesProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

{ Register }

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(WideChar), nil,
     '', TCharProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), nil,
     '', TStringListProperty);
  RegisterPropertyEditor(TypeInfo(TFont), TCustomSynEdit,
     'Font', TSynEditFontProperty);
end;

end.

