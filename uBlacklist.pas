unit uBlacklist;

interface

uses Classes;

type
  TBlacklist = class(TStringList)
  private

  public
    procedure AppendFromFile(const strFileName: string);
  end;

implementation

uses SysUtils, FastStrings, FastStringFuncs;

procedure TBlacklist.AppendFromFile(const strFileName: string);
var F: TextFile;
    strLine: string;
    I: integer;

begin
  AssignFile (F, strFileName);
  Reset (F);
  BeginUpdate;
  try
   while not Eof (F) do
    begin
     Readln (F, strLine);
     strLine := Trim (strLine);
     if strLine <> '' then
      begin
       I := FastCharPos (strLine, ':', 8);
       if I <> 0 then
        Add (CopyStr (strLine, 1, I - 1));
      end;
    end;
  finally
   CloseFile (F);
   EndUpdate;
  end;
end;

end.
