program PresentationAutoRunner;

uses
  Vcl.Forms,
  USBDetection in 'USBDetection.pas' {USBDetectForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUSBDetectForm, USBDetectForm);
  Application.Run;
end.
