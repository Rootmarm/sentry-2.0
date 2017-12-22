// Unit which contains useful functions for parsing form data.

unit uFormParser;

interface

type
  PFormData = ^TFormData;
  TFormData = record
    Action,
    Username,
    Password,
    AddData,
    Cookie: string
  end;

function RemoveValueFromField(const strField: string): string;
function BuildPOSTData(const FFormData: PFormData): string;
function ParseFormField(const S: string): string;
function ParseFormAction(const S, strURL: string): string;
function ParseFormMethod(const S: string): string;
function ParseFieldType(const S: string): string;

implementation

uses SysUtils, FastStrings, FastStringFuncs, uFunctions;

{------------------------------------------------------------------------------}
// Removes Value from field if one exists.
function RemoveValueFromField(const strField: string): string;
var I: integer;

begin
  Result := strField;

  if strField <> '' then
   begin
    I := FastCharPos (strField, '=', 1);
    if I <> 0 then
     Result := Copy (strField, 1, I - 1);
   end;
end;
{------------------------------------------------------------------------------}
function BuildPOSTData(const FFormData: PFormData): string;
begin
  Result := '';

  with FFormData^ do
   begin
    if Username <> '' then
     Result := Username + '=<USER>';
    if Password <> '' then
     begin
      if Result = '' then
       Result := Password + '=<PASS>'
      else
       Result := Result  + '&' + Password + '=<PASS>';
     end;
    if AddData <> '' then
     Result := Result + '&' + AddData;
   end;
end;
{------------------------------------------------------------------------------}
 function ParseFormField(const S: string): string;
  var I, J, K, L: integer;
      strValue: string;

  begin
   Result := '';
   I := FastPosNoCase (S, 'name=', Length (S), 5, 1) + 6;
   if I <> 6 then
    begin
     if S[I - 7] in ['<', ' '] = False then
      I := 6;
    end;

   // Check for name field, if not returned it must be
   // of type submit
   if I <> 6 then
    begin
     J := FastCharPos (S, '"', I);
     K := FastCharPos (S, ' ', I);

     // No quotes are used
     if ((K < J) and (K <> 0)) or (J = 0) then
      begin
       J := K;
       Dec (I);
      end;

     // If name field is last, as in <INPUT class=in1 maxLength=20 size=10 name=username>
     if (K = 0) and (J = K) then
      J := Length (S);

     Result := CopyStr (S, I, J - I);
    end
   else
    Exit;

   // Check for value, if found then append it
   I := FastPosNoCase (S, 'value=', Length (S), 6, 1) + 7;

   if I <> 7 then
    begin
     J := FastCharPos (S, '"', I);
     K := FastCharPos (S, '>', I);
     L := FastCharPos (S, ' ', I);

     // No quotes are used
     if ((K < J) and (K <> 0)) or (J = 0) then
      begin
       J := K;
       Dec (I);
      end;

     // Check for space after value, might not be last field
     if (L < J) and (L <> 0) then
      J := L;
      
     strValue := CopyStr (S, I, J - I);

     Result := Result + '=' + strValue;
    end;
  end;
{------------------------------------------------------------------------------}
 function ParseFormAction(const S, strURL: string): string;
  var I, J: integer;
      strTmp: string;

  begin
   I := FastPosNoCase (S, 'Action=', Length (S), 7, 1) + 8;
   if I = 8 then
    begin
     Result := strURL;
     Exit;
    end;

   J := FastCharPos (S, '"', I);
   if J = 0 then
    begin
     J := FastCharPos (S, ' ', I);
     Dec (I);
    end;

   strTmp := CopyStr (S, I, J - I);

   // Attach Base URL if not present
   Result := AttachBaseURL (strTmp, strURL);
  end;
{------------------------------------------------------------------------------}
 function ParseFormMethod(const S: string): string;
  var I, J: integer;

  begin
   I := FastPosNoCase (S, 'Method=', Length (S), 7, 1) + 8;
   J := FastCharPos (S, '"', I);
   if J = 0 then
    begin
     J := FastCharPos (S, ' ', I);
     Dec (I);
    end;

   Result := CopyStr (S, I, J - I);
  end;
{------------------------------------------------------------------------------}
 function ParseFieldType(const S: string): string;
  var I, J, K: integer;

  begin
   J := 0;
   K := 0;
   I := FastPosNoCase (S, 'type=', Length (S), 5, 1) + 6;

   if I <> 6 then
    begin
     J := FastCharPos (S, '"', I);
     K := FastCharPos (S, ' ', I);
    end;

   // We are using a space instead of a "
   // happens when type=somevalue value="somevalue"
   if ((K < J) and (K <> 0)) or (J = 0) then
    begin
     J := K;
     Dec (I);
    end;

   if J <> 0 then
    Result := LowerCase (CopyStr (S, I, J - I))
   else
    Result := '';
  end;
{------------------------------------------------------------------------------}
end.
