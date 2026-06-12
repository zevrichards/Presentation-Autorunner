unit USBDetection;
{taken from an Experts Exchange solution:
 http://www.experts-exchange.com/Programming/Languages/Pascal/Delphi/
                             Q_21552015.html?sfQueryTermInfo=1+drive+letter+usb
 ginsonic:
 Here is a complete sample project. Use a form and a label.
}

interface

uses
  Windows, Messages, Classes, Forms, Controls, StdCtrls, Buttons, SysUtils, StrUtils, SHellAPI, registry,
  Vcl.ExtCtrls, Vcl.AppEvnts;

type
  TUSBDetectForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ApplicationEvents1: TApplicationEvents;
    TrayIcon1: TTrayIcon;
    procedure FormCreate(Sender: TObject);
    Procedure OpenPresentation(Drive: string);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure   WMDEVICECHANGE(var Msg: TMessage); message WM_DEVICECHANGE;
  public
    { Public declarations }
  end;

var
  USBDetectForm: TUSBDetectForm;

{----------------------------------------------------------------------------}
// Device constants
const
  DBT_DEVICEARRIVAL          =  $00008000;
  DBT_DEVICEREMOVECOMPLETE   =  $00008004;
  DBT_DEVTYP_VOLUME          =  $00000002;

// Device structs
type
  _DEV_BROADCAST_HDR         =  packed record
     dbch_size:              DWORD;
     dbch_devicetype:        DWORD;
     dbch_reserved:          DWORD;
  end;
  DEV_BROADCAST_HDR          =  _DEV_BROADCAST_HDR;
  TDevBroadcastHeader        =  DEV_BROADCAST_HDR;
  PDevBroadcastHeader        =  ^TDevBroadcastHeader;

type
  _DEV_BROADCAST_VOLUME      =  packed record
     dbch_size:              DWORD;
     dbch_devicetype:        DWORD;
     dbch_reserved:          DWORD;
     dbcv_unitmask:          DWORD;
     dbcv_flags:             WORD;
  end;
  DEV_BROADCAST_VOLUME       =  _DEV_BROADCAST_VOLUME;
  TDevBroadcastVolume        =  DEV_BROADCAST_VOLUME;
  PDevBroadcastVolume        =  ^TDevBroadcastVolume;

implementation
{$R *.dfm}

procedure TUSBDetectForm.WMDEVICECHANGE(var Msg: TMessage);
var  lpdbhHeader:   PDevBroadcastHeader;
     lpdbvData:     PDevBroadcastVolume;
     dwIndex:       Integer;
     lpszDrive:      String;
begin

  // Perform inherited
  inherited;

  // Get the device notification header
  lpdbhHeader:=PDevBroadcastHeader(Msg.lParam);

  // Handle the message
  lpszDrive:='';
  case Msg.WParam of
     DBT_DEVICEARRIVAL       :    {a USB drive was connected}
     begin
        if (lpdbhHeader^.dbch_devicetype = DBT_DEVTYP_VOLUME) then
        begin
           lpdbvData:=PDevBroadcastVolume(Msg.lParam);
           for dwIndex :=0 to 25 do
           begin
              if ((lpdbvData^.dbcv_unitmask shr dwIndex) = 1) then
              begin
                 lpszDrive:=Chr(65+dwIndex);
                 break;
              end;
           end;
           Label1.Caption:='Drive '+lpszDrive + ': connected.';
           Label2.Caption:= 'Searching for presentation to Autorun.';
           OpenPresentation(lpszDrive);

        end;
     end;
     DBT_DEVICEREMOVECOMPLETE:    {a USB drive was removed}
     begin
        if (lpdbhHeader^.dbch_devicetype = DBT_DEVTYP_VOLUME) then
        begin
           lpdbvData:=PDevBroadcastVolume(Msg.lParam);
           for dwIndex:=0 to 25 do
           begin
              if ((lpdbvData^.dbcv_unitmask shr dwIndex) = 1) then
              begin
                 lpszDrive:=lpszDrive+Chr(65+dwIndex)+':';
                 break;
              end;
           end;
           Label1.Caption:=lpszDrive + ' removed';
        end;
     end;
  end;
end;


Procedure TUSBDetectForm.OpenPresentation(Drive: string);
var
  SR: TSearchRec;
  FileName, SLideShowName: string;
begin

  //find any presentations

  If FindFirst(Drive+':\*.pptx', faAnyFile, SR) = 0 then
  begin
    FileName := SR.Name;
    Label2.Caption := FileName+' found. Renaming file and running slideshow.';
  end
  else
  begin
    if FindFirst(Drive+':\*.ppt', faAnyFile, SR) = 0 then
    begin
      FileName := SR.Name;
      Label2.Caption := FileName+' found. Renaming file and running slideshow.';
    end
    else
    begin
      if FindFirst(Drive+':\*.pps', faAnyFile, SR) = 0 then
      begin
        FileName := SR.Name;
        Label2.Caption := FileName+' found. Renaming file and running slideshow.';
      end
    else
      Label2.Caption := 'No presentations found';
    end;
  end;

  //rename the found presentation
  SlideShowName := LeftStr(SR.Name, Length(SR.Name)-Length(extractfileext(SR.Name)))+'.pps';
  RenameFile(Drive+':\'+SR.Name, Drive+':\'+SlideShowName);

  //run the slideshow
  Label3.Caption := 'Running '+SLideSHowName;
  ShellExecute(Handle, nil, PChar(Drive+':\'+SlideShowName), nil,  nil, SW_SHOWNORMAL);

  FindClose(SR);
end;

procedure TUSBDetectForm.TrayIcon1DblClick(Sender: TObject);
begin
  { Hide the tray icon and show the window,
  setting its state property to wsNormal. }
  TrayIcon1.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TUSBDetectForm.ApplicationEvents1Minimize(Sender: TObject);
begin
  { Hide the window and set its state variable to wsMinimized. }
  Hide();
  WindowState := wsMinimized;

  { Show the animated tray icon and also a hint balloon. }
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TUSBDetectForm.FormCreate(Sender: TObject);
var key: string;
     Reg: TRegIniFile;
begin
  key := '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run';
  Reg := TRegIniFile.Create;
  try
    Reg.RootKey:=HKEY_CURRENT_USER;
    Reg.CreateKey(Key);
    if Reg.OpenKey(Key,False) then
      Reg.WriteString(key, 'PresentationAutoRunner', Application.ExeName);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;

 Label1.Caption := '';
 Label2.Caption := '';
 Label3.Caption := '';

ApplicationEvents1Minimize(nil);
end;


end.
