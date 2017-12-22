// This class is designed to centralize the routine of parsing a form in
// a class that is meant to be subclassed. It doesn't retrieve Form Data,
// just parses it if it is there.

unit uFormParserBot;

interface

uses
  Classes, uKeywordBot, uFormParser, HttpProt;

type
  TFormBotState = (stGetFormData, stReadyToPost);

  TFormParserBot = class(TKeywordBot)
  protected
    FFormURL: string;  // URL that points to the form
    FFormBotState: TFormBotState;

    FFormData: PFormData;
    FPOSTData: string;

    procedure DoRequestAsync(Rq : THttpRequest); override;
    procedure TriggerCookie(const Data : String; var bAccept : Boolean); override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor  Destroy; override;
    procedure   ParseForm; virtual;

    property FormData            : PFormData     read  FFormData;
    property FormURL             : string        read  FFormURL
                                                 write FFormURL;
    property POSTData            : string        read  FPOSTData
                                                 write FPOSTData;
  end;

implementation

uses SysUtils, FastStrings, FastStringFuncs;

{ TFormParserBot }

constructor TFormParserBot.Create(Aowner: TComponent);
begin
  inherited;

  New (FFormData);
end;

procedure TFormParserBot.DoRequestAsync(Rq : THttpRequest);
begin
  case FFormBotState of
   stReadyToPost: FURL := FFormData^.Action;
   stGetFormData: FURL := FFormURL;
  end;

  inherited;
end;

procedure TFormParserBot.ParseForm;
var I, J, iSourceLength: integer;
    strSource, strTmp, strFieldType: string;

begin
  iSourceLength := Length (FSource);
  // Find a Form in the source of a web page
  I := FastPosNoCase (FSource, '<FORM', iSourceLength, 5, 1);
  if I <> 0 then
   begin
    J := FastPosNoCase (FSource, '</FORM', iSourceLength, 6, I + 5);
    // strSource contains the entire Form
    strSource := CopyStr (FSource, I, J - I);
    iSourceLength := J - I;

    // Get Form's Action
    I := FastCharPos (strSource, '>', 6) + 1;
    strTmp := CopyStr (strSource, 1, I);
    // Use FLocation instead of FFormURL so Redirects work as well.
    FFormData^.Action := ParseFormAction (strTmp, FLocation);

    strSource := CopyStr (strSource, I, iSourceLength);
    Dec (iSourceLength, I - 1);

    // Loop through Input Fields
    I := FastPosNoCase (strSource, '<INPUT', iSourceLength, 6, 1);

    if I <> 0 then
     begin
      repeat
       J := FastCharPos (strSource, '>', I + 6) + 1;

       strTmp := CopyStr (strSource, I, J - I);
       strFieldType := ParseFieldType (strTmp);
       // http://onlyblowjob.com/login.php uses class=forminputtext, this is a way around it
       if SameText (strFieldType, 'text') or ((strFieldType = '') and (FFormData^.Username = '')) then
        FFormData^.Username := ParseFormField (strTmp)
       else if SameText (strFieldType, 'password') then
        FFormData^.Password := ParseFormField (strTmp)
       else if (SameText (strFieldType, 'hidden')) or (SameText (strFieldType, 'submit')) then
        begin
         strTmp := ParseFormField (strTmp);
         if strTmp <> '' then
          begin
           if Trim (FFormData^.AddData) = '' then
            FFormData^.AddData := strTmp
           else
            FFormData^.AddData := FFormData^.AddData + '&' + strTmp;
          end;
        end;
       I := FastPosNoCase (strSource, '<INPUT', iSourceLength, 6, J);
      until I = 0;
     end;

     // Remove value from Username and Password Fields
     with FFormData^ do
      begin
       Username := RemoveValueFromField (Username);
       Password := RemoveValueFromField (Password);
      end;
   end;

  FPOSTData := BuildPOSTData (FFormData);
end;

procedure TFormParserBot.TriggerCookie(const Data : String; var bAccept : Boolean);
begin
  FFormData^.Cookie := Data;

  inherited;
end;

destructor TFormParserBot.Destroy;
begin
  Dispose (FFormData);

  inherited;
end;


end.

