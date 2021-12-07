{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.Data.Utils;

interface

uses
  DataStorage.Intf,
  System.RTTI, System.StrUtils, System.Json, System.SysUtils, System.TypInfo, System.Generics.Collections, System.DateUtils, System.ZLib, System.NetEncoding, System.Classes;

type
  EDataStorageException = class(Exception)
  end;

  TDataStorageDataUtils = class
  private
    function GetFormatSettings: TFormatSettings;
    function JsonToObject(const AClassName: string; AJSON: TJSONObject): TValue;
    function JsonToEnum(const AKeyEnum: string; const AValueEnum: string): TValue;
    function JsonToRecord(const AKeyRecord: string; const AJSON: TJSONObject): TValue;
    function JsonToArray(const AJSON: TJSONArray; const ARttiType: TRttiType): TValue;
    function JSONValueToTValue(const AJSON: TJSONValue; const ARttiType: TRttiType = nil): TValue;
  public
    procedure TValueToJSONObject(const AName: string; const AValue: TValue; out AJO: TJSONObject);
    function TJSONObjectToDataBase(const ADataBase: IDataStorageDataBase; const AJO: TJSONObject): IDataStorageDataBase;
    function ZLibCompress(const AText: string): string;
    function ZLibDecompress(const AText: string): string;
  end;

implementation

type
  TDataStorageRTTI = class
  private
  public
    class function FindAnyClassArray(const AName: string): TRttiType;
    class function FindAnyClass(const AName: string): TRttiType; overload;
    class function FindAnyClass(const AName: string; const ATypeKind: TTypeKind): TRttiType; overload;
  end;

  { TDataStorageDataUtils }

function TDataStorageDataUtils.TJSONObjectToDataBase(const ADataBase: IDataStorageDataBase; const AJO: TJSONObject): IDataStorageDataBase;
var
  I: Integer;
  LDataBase: string;
  J: Integer;
  LTable: string;
  K: Integer;
  LPair: TJsonPair;
  LKey: string;
  LJOValue: TJSONValue;
  LValue: TValue;
begin
  Result := ADataBase;
  Result.DataBase.Clear;

  for I := 0 to Pred(AJO.Count) do
  begin
    LDataBase := AJO.Pairs[I].JsonString.Value;

    for J := 0 to Pred((AJO.Pairs[I].JsonValue as TJSONObject).Count) do
    begin
      LTable := (AJO.Pairs[I].JsonValue as TJSONObject).Pairs[J].JsonString.Value;

      for K := 0 to Pred(((AJO.Pairs[I].JsonValue as TJSONObject).Pairs[J].JsonValue as TJSONObject).Count) do
      begin
        LPair := ((AJO.Pairs[I].JsonValue as TJSONObject).Pairs[J].JsonValue as TJSONObject).Pairs[K];

        LKey := LPair.JsonString.Value;
        LJOValue := LPair.JsonValue;
        LValue := JSONValueToTValue(LJOValue);

        Result.DataBase(LDataBase).Table(LTable).Item(LKey).SetValue(LValue);
      end;
    end;
  end;
end;

procedure TDataStorageDataUtils.TValueToJSONObject(const AName: string; const AValue: TValue; out AJO: TJSONObject);
type
  PPByte = ^PByte;

  function GetValue(Addr: Pointer; Typ: TRttiType): TValue;
  begin
    TValue.Make(Addr, Typ.Handle, Result);
  end;

var
  LJO: TJSONObject;
  LValue: string;
  LClass: TRttiInstanceType;
  LRecord: TRttiRecordType;
  LJOValue: TJSONObject;
  LField: TRttiField;
  LJA: TJSONArray;
  I: Integer;
  LValueArray: TValue;
  LJOArray: TJSONObject;
begin
  if not Assigned(AJO) then
    Exit;

  LJO := AJO;

  case AValue.Kind of
    tkInteger, tkInt64:
      LJO.AddPair(AName, TJSONNumber.Create(AValue.AsExtended));

    tkFloat:
      begin
        case IndexStr(string(AValue.TypeInfo.Name), ['TDateTime', 'TDate', 'TTime', 'TTimeStamp']) of
          0: LJO.AddPair(TJsonPair.Create(AName, DateToISO8601(AValue.AsExtended, False)));
          1: LJO.AddPair(TJsonPair.Create(AName, DateToStr(AValue.AsExtended, GetFormatSettings)));
          2: LJO.AddPair(TJsonPair.Create(AName, TimeToStr(AValue.AsExtended, GetFormatSettings)));
          3: LJO.AddPair(TJsonPair.Create(AName, DateToISO8601(AValue.AsExtended, False)));
        else
          LJO.AddPair(AName, TJSONNumber.Create(AValue.AsExtended));
        end;
      end;

    tkString, tkUString, tkLString, tkWString, tkWChar, tkChar, tkVariant:
      LJO.AddPair(AName, AValue.AsString);

    tkEnumeration:
      begin
        if AValue.TypeInfo = TypeInfo(Boolean) then
        begin
          LJO.AddPair(AName, TJSONBool.Create(AValue.AsBoolean));
        end
        else
        begin
          LValue := GetEnumName(AValue.TypeInfo, AValue.AsVariant);

          LJO
            .AddPair(AName, TJSONObject.Create).GetValue<TJSONObject>(AName)
            .AddPair('ds_data_enumerator', TJSONObject.Create).GetValue<TJSONObject>('ds_data_enumerator')
            .AddPair(string(AValue.TypeInfo.Name), LValue);
        end;
      end;

    tkClass:
      begin
        LClass := TRttiContext.Create.GetType(AValue.TypeInfo).AsInstance;

        LJOValue := TJSONObject.Create;

        for LField in LClass.GetFields do
          TValueToJSONObject(LField.Name, GetValue(PPByte(AValue.GetReferenceToRawData)^ + LField.Offset, LField.FieldType), LJOValue);

        LJO
          .AddPair(AName, TJSONObject.Create).GetValue<TJSONObject>(AName)
          .AddPair('ds_data_object', TJSONObject.Create).GetValue<TJSONObject>('ds_data_object')
          .AddPair(string(AValue.TypeInfo.Name), LJOValue);
      end;

    tkRecord:
      begin
        LRecord := TRttiContext.Create.GetType(AValue.TypeInfo).AsRecord;

        LJOValue := TJSONObject.Create;

        for LField in LRecord.GetFields do
          TValueToJSONObject(LField.Name, LField.GetValue(AValue.GetReferenceToRawData), LJOValue);

        LJO
          .AddPair(AName, TJSONObject.Create).GetValue<TJSONObject>(AName)
          .AddPair('ds_data_record', TJSONObject.Create).GetValue<TJSONObject>('ds_data_record')
          .AddPair(string(AValue.TypeInfo.Name), LJOValue);
      end;

    tkArray, tkDynArray:
      begin
        LJA := LJO.AddPair(AName, TJSONArray.Create).GetValue<TJSONArray>(AName);

        for I := 0 to Pred(AValue.GetArrayLength) do
        begin
          LValueArray := AValue.GetArrayElement(I);

          LJOArray := TJSONObject.Create;
          TValueToJSONObject(string(LValueArray.TypeInfo.Name), LValueArray, LJOArray);

          LJA.Add(LJOArray);
        end;
      end;
  end;
end;

function TDataStorageDataUtils.ZLibCompress(const AText: string): string;
var
  LText: TBytes;
  LSSInput, LSSOutput: TStringStream;
  LZStream: TZCompressionStream;
begin
  Result := '';

  LSSInput := TStringStream.Create(AText, TEncoding.UTF8);
  LSSOutput := TStringStream.Create;
  try
    LZStream := TZCompressionStream.Create(TCompressionLevel.clMax, LSSOutput);
    try
      LZStream.CopyFrom(LSSInput, LSSInput.Size);
    finally
      LZStream.Free;
    end;

    LText := TNetEncoding.Base64.Encode(LSSOutput.Bytes);

    Result := TEncoding.UTF8.GetString(LText);
  finally
    LSSInput.Free;
    LSSOutput.Free;
  end;
end;

function TDataStorageDataUtils.ZLibDecompress(const AText: string): string;
var
  LText: TBytes;
  LSSInput, LSSOutput: TStringStream;
  LZStream: TZDecompressionStream;
begin
  Result := '';

  try
    LText := TNetEncoding.Base64.Decode(TEncoding.UTF8.GetBytes(AText));

    LSSInput := TStringStream.Create(LText);
    LSSOutput := TStringStream.Create;
    try
      LZStream := TZDecompressionStream.Create(LSSInput);
      try
        LSSOutput.CopyFrom(LZStream, LZStream.Size);
      finally
        LZStream.Free;
      end;

      Result := LSSOutput.DataString;
    finally
      LSSInput.Free;
      LSSOutput.Free;
    end;
  except
  end;
end;

function TDataStorageDataUtils.JsonToObject(const AClassName: string; AJSON: TJSONObject): TValue;
var
  LClass: TRttiType;
  LClassInstance: TRttiInstanceType;
  LObject: TObject;
  LField: TRttiField;
  LValue: TValue;
begin
  LClass := TDataStorageRTTI.FindAnyClass(AClassName, tkClass);

  if not Assigned(LClass) then
    raise EDataStorageException.CreateFmt('Type (%s) not found!', [AClassName]);

  LClassInstance := TRttiContext.Create.GetType(LClass.Handle).AsInstance;
  LObject := LClassInstance.MetaclassType.Create;

  for LField in LClassInstance.GetFields do
  begin
    if not Assigned(AJSON.Values[LField.Name]) then
      Continue;

    LValue := JSONValueToTValue(AJSON.GetValue(LField.Name), LField.FieldType);
    LField.SetValue(LObject, LValue);
  end;

  Result := LObject;
end;

function TDataStorageDataUtils.JsonToEnum(const AKeyEnum: string; const AValueEnum: string): TValue;
var
  LClass: TRttiType;
  LEnumValueInt: Integer;
begin
  LClass := TDataStorageRTTI.FindAnyClass(AKeyEnum, tkEnumeration);

  if not Assigned(LClass) then
    raise EDataStorageException.CreateFmt('Type (%s) not found!', [AKeyEnum]);

  LEnumValueInt := GetEnumValue(LClass.Handle, AValueEnum);
  TValue.Make(LEnumValueInt, LClass.Handle, Result);
end;

function TDataStorageDataUtils.JsonToRecord(const AKeyRecord: string; const AJSON: TJSONObject): TValue;
var
  LClass: TRttiType;
  LClassInstance: TRttiRecordType;
  LRecord: TValue;
  LField: TRttiField;
  LValue: TValue;
begin
  LClass := TDataStorageRTTI.FindAnyClass(AKeyRecord, tkRecord);

  if not Assigned(LClass) then
    raise EDataStorageException.CreateFmt('Type (%s) not found!', [AKeyRecord]);

  LClassInstance := TRttiContext.Create.GetType(LClass.Handle).AsRecord;

  TValue.Make(nil, LClassInstance.Handle, LRecord);

  for LField in LClassInstance.GetFields do
  begin
    if not Assigned(AJSON.Values[LField.Name]) then
      Continue;

    LValue := JSONValueToTValue(AJSON.GetValue(LField.Name), LField.FieldType);

    LField.SetValue(LRecord.GetReferenceToRawData, LValue);
  end;

  Result := LRecord;
end;

function TDataStorageDataUtils.JsonToArray(const AJSON: TJSONArray; const ARttiType: TRttiType): TValue;
var
  I: Integer;
  LKeyTipo: string;
  LValue: TValue;
  LArrValue: TArray<TValue>;
  LRttiType: TRttiType;
  LPTypeInfo: PTypeInfo;
begin
  LPTypeInfo := ARttiType.Handle;
  LRttiType := nil;

  for I := 0 to Pred(AJSON.Count) do
  begin
    if I = 0 then
    begin
      LKeyTipo := (AJSON.Items[I] as TJSONObject).Pairs[0].JsonString.Value;
      LRttiType := TDataStorageRTTI.FindAnyClass(LKeyTipo);
    end;

    LValue := JSONValueToTValue((AJSON.Items[I] as TJSONObject).Pairs[0].JsonValue, LRttiType);
    LArrValue := Concat(LArrValue, [LValue]);
  end;

  Result := TValue.FromArray(LPTypeInfo, LArrValue);
end;

function TDataStorageDataUtils.JSONValueToTValue(const AJSON: TJSONValue; const ARttiType: TRttiType = nil): TValue;
  function ISOToDateTime(const ADateTime: string): TDateTime;
  begin
    if ADateTime.Contains('T') then
      Result := ISO8601ToDate(ADateTime, False)
    else
      Result := StrToDateTime(ADateTime);
  end;

var
  LKey: string;
  LClassValue: TJSONObject;
  LEnumValue: string;
  LRecordValue: TJSONObject;
  LValueInt: Integer;
  LArrName: string;
  LArrType: TRttiType;
begin
  if not Assigned(AJSON) then
    Exit(TValue.Empty);

  if AJSON is TJSONObject then
  begin
    LKey := ((AJSON as TJSONObject).Pairs[0].JsonValue as TJSONObject).Pairs[0].JsonString.Value;

    case IndexStr(AJSON.GetValue<TJSONObject>.Pairs[0].JsonString.Value, ['ds_data_object', 'ds_data_enumerator', 'ds_data_record']) of
      0:
        begin
          LClassValue := ((AJSON as TJSONObject).Pairs[0].JsonValue as TJSONObject).Pairs[0].JsonValue as TJSONObject;
          Result := JsonToObject(LKey, LClassValue);
        end;

      1:
        begin
          LEnumValue := ((AJSON as TJSONObject).Pairs[0].JsonValue as TJSONObject).Pairs[0].JsonValue.Value;
          Result := JsonToEnum(LKey, LEnumValue);
        end;

      2:
        begin
          LRecordValue := ((AJSON as TJSONObject).Pairs[0].JsonValue as TJSONObject).Pairs[0].JsonValue as TJSONObject;
          Result := JsonToRecord(LKey, LRecordValue);
        end;
    else
      Result := JSONValueToTValue(((AJSON as TJSONObject).Pairs[0].JsonValue as TJSONObject).Pairs[0].JsonValue, ARttiType);
    end
  end
  else
  begin
    if Assigned(ARttiType) then
    begin
      case ARttiType.TypeKind of
        tkInteger, tkInt64:
          Result := AJSON.AsType<Integer>;

        tkChar, tkWChar, tkLString, tkString, tkWString, tkUString, tkVariant:
          Result := AJSON.AsType<string>;

        tkEnumeration:
          begin
            if AJSON is TJSONBool then
              Result := AJSON.AsType<Boolean>
          end;

        tkFloat:
          begin
            case IndexStr(ARttiType.Name, ['TDateTime', 'TDate', 'TTime', 'TTimeStamp']) of
              0: Result := ISOToDateTime(AJSON.AsType<string>);
              1: Result := StrToDate(AJSON.AsType<string>, GetFormatSettings);
              2: Result := StrToTime(AJSON.AsType<string>, GetFormatSettings);
              3: Result := ISOToDateTime(AJSON.AsType<string>);
            else
              Result := AJSON.AsType<Double>;
            end;
          end;

        tkArray, tkDynArray:
          Result := JsonToArray(AJSON as TJSONArray, ARttiType);
      end;
    end
    else
    begin
      if AJSON is TJSONBool then
        Result := AJSON.AsType<Boolean>
      else
        if AJSON is TJSONNumber then
        begin
          if TryStrToInt(AJSON.ToString, LValueInt) then
            Result := AJSON.AsType<Integer>
          else
            Result := AJSON.AsType<Double>;
        end
        else
          if AJSON is TJSONString then
            Result := AJSON.AsType<string>
          else
            if AJSON is TJSONArray then
            begin
              LArrName := (AJSON as TJSONArray).Items[0].AsType<TJSONObject>.Pairs[0].JsonString.Value;
              LArrType := TDataStorageRTTI.FindAnyClassArray(LArrName);
              Result := JsonToArray(AJSON as TJSONArray, LArrType);
            end;
    end;
  end;
end;

function TDataStorageDataUtils.GetFormatSettings: TFormatSettings;
begin
  Result.DateSeparator := '-';
  Result.ShortDateFormat := 'yyyy-mm-dd';
  Result.TimeSeparator := ':';
  Result.LongTimeFormat := 'hh:nn:ss';
end;

{ TDataStorageRTTI }

class function TDataStorageRTTI.FindAnyClassArray(const AName: string): TRttiType;
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LARttiType: TArray<TRttiType>;
begin
  Result := nil;

  LRttiContext := TRttiContext.Create;
  LARttiType := LRttiContext.GetTypes;

  try
    for LRttiType in LARttiType do
    begin
      if StartsText('tarray<' + AName.ToLower, LRttiType.Name.ToLower) or EndsText(AName.ToLower + '>', LRttiType.Name.ToLower) then
      begin
        Result := LRttiType;
        Break;
      end;
    end;
  finally
    LRttiContext.Free;
  end;
end;

class function TDataStorageRTTI.FindAnyClass(const AName: string): TRttiType;
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LARttiType: TArray<TRttiType>;
begin
  Result := nil;

  LRttiContext := TRttiContext.Create;
  LARttiType := LRttiContext.GetTypes;

  try
    for LRttiType in LARttiType do
    begin
      if (SameStr(AName.ToLower, LRttiType.Name.ToLower)) then
      begin
        Result := LRttiType;
        Break;
      end;
    end;
  finally
    LRttiContext.Free;
  end;
end;

class function TDataStorageRTTI.FindAnyClass(const AName: string; const ATypeKind: TTypeKind): TRttiType;
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LARttiType: TArray<TRttiType>;
begin
  Result := nil;

  LRttiContext := TRttiContext.Create;
  LARttiType := LRttiContext.GetTypes;

  try
    for LRttiType in LARttiType do
      if (LRttiType.TypeKind = ATypeKind) and (EndsText(AName, LRttiType.Name)) then
      begin
        Result := LRttiType;
        Break;
      end;
  finally
    LRttiContext.Free;
  end;
end;

end.
