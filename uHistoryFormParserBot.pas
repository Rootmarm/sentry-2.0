unit uHistoryFormParserBot;

interface

uses
  Classes, uFormParserBot;

type
  THistoryFormParserBot = class(TFormParserBot)
  private
    FRetries: integer;
  protected
    procedure TriggerRequestDone; override;
  public
    constructor Create(Aowner: TComponent); override;
  end;

implementation

{ THistoryFormParserBot }

constructor THistoryFormParserBot.Create(Aowner: TComponent);
begin
  inherited;

  FVirtual := True;
  FRetries := 0;
end;

procedure THistoryFormParserBot.TriggerRequestDone;
const MAX_RETRIES: integer = 3;

begin
  case FStatusCode of
   200: ParseForm;
   else if FRetries < MAX_RETRIES then
    begin
     Inc (FRetries);
     TriggerBanProxy (Tag);
     TriggerSetProxy;
     GetAsync;
    end;
  end;

  inherited;
end;

end.

