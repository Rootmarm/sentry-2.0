unit uProgressListView;

interface

uses
  Classes;

type
  TProgressItem = class
  private
    FBotNumber: integer;
    FProxy,
    FUsername,
    FPassword,
    FResponse: string;

  public
    property BotNumber: integer read FBotNumber write FBotNumber;
    property Proxy: string read FProxy write FProxy;
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property Response: string read FResponse write FResponse;
  end;

  { see TObjectList from unit Contnrs.pas  }

  TProgressList = class(TList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    function GetItem(Index: Integer): TProgressItem;
    procedure SetItem(Index: Integer; aItem: TProgressItem);
  public
    function Add(aItem: TProgressItem): Integer;
    function Remove(aItem: TProgressItem): Integer;

    property Items[Index: Integer]: TProgressItem read GetItem write SetItem; default;
  end;

implementation

{ TProgressList }

function TProgressList.Add(aItem: TProgressItem): Integer;
begin
  Result := inherited Add(aItem);
end;

function TProgressList.GetItem(Index: Integer): TProgressItem;
begin
  Result := inherited Items[Index];
end;

procedure TProgressList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
   TProgressItem(Ptr).Free;

  inherited Notify(Ptr, Action);
end;

function TProgressList.Remove(aItem: TProgressItem): Integer;
begin
  Result := inherited Remove(aItem);
end;

procedure TProgressList.SetItem(Index: Integer; aItem: TProgressItem);
begin
  inherited Items[Index] := aItem;
end;

end.

