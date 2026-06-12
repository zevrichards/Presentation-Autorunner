object USBDetectForm: TUSBDetectForm
  Left = 0
  Top = 0
  Caption = 'USBDetectForm'
  ClientHeight = 149
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    AlignWithMargins = True
    Left = 24
    Top = 32
    Width = 31
    Height = 13
    Alignment = taCenter
    Caption = 'Label1'
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 24
    Top = 64
    Width = 31
    Height = 13
    Alignment = taCenter
    Caption = 'Label2'
  end
  object Label3: TLabel
    AlignWithMargins = True
    Left = 24
    Top = 96
    Width = 31
    Height = 13
    Alignment = taCenter
    Caption = 'Label3'
  end
  object ApplicationEvents1: TApplicationEvents
    OnMinimize = ApplicationEvents1Minimize
    Left = 296
    Top = 16
  end
  object TrayIcon1: TTrayIcon
    OnDblClick = TrayIcon1DblClick
    Left = 288
    Top = 72
  end
end
