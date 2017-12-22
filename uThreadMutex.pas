unit uThreadMutex;

interface

uses Windows, Classes;

type
  TMutexThread = class(TThread)
  private
    FOutput: string;
  public
    procedure Execute; override;

    property OutputFile: string read FOutput write FOutput;
  end;

implementation

// ---------------- TMutexThread ------------------- \\

procedure TMutexThread.Execute;
var Mutex: THandle;

begin
  // Mutex Code to let Charon complete and return access back to Sentry
  Mutex := 0;
  repeat
   Sleep (200);
   if Mutex <> 0 then
    CloseHandle (Mutex);
   Mutex := OpenMutex (MUTEX_ALL_ACCESS, False, 'CharonForm');
  until (Mutex = 0) and (GetLastError <> 0);

  inherited;
end;

end.
