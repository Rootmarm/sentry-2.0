unit uIPBot;

interface

uses
  Classes, uVTHttpWrapper, HttpProt;

type
  TIPBot = class(TVTHttpCli)
  protected
    FIP: string;

    procedure TriggerRequestDone; override;
  public
    constructor Create(Aowner: TComponent); override;

    property IP                : string         read FIP;
  end;

implementation

uses SysUtils, FastStrings, FastStringFuncs;

{ TIPBot }

{------------------------------------------------------------------------------}
 constructor TIPBot.Create(Aowner: TComponent);
  begin
   inherited;

   FURL := 'http://checkip.dyndns.org';
  end;
{------------------------------------------------------------------------------}
 procedure TIPBot.TriggerRequestDone;
  var strSource: string;
      I, J, K: integer;

  begin
   if FStatusCode = 200 then
    begin
     strSource := FSource;
     I := FastCharPos (strSource, '.', 1);
     J := I;
     for I := I - 1 downto 1 do
      begin
       if strSource[I] = ' ' then
        Break;
      end;
     K := I + 1;
     for I := J + 1 to Length (strSource) do
      begin
       if strSource[I] in ['0'..'9', '.'] = False then
        Break;
      end;
     FIP := CopyStr (strSource, K, I - K);
    end
   else
    FStatus := '( ' + IntToStr (FStatusCode) + ' ) ' + FReasonPhrase;

   inherited;
  end;
{------------------------------------------------------------------------------}
end.

