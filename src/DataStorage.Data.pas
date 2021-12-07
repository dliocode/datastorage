{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.Data;

interface

uses
  DataStorage.Intf, DataStorage.Data.Utils, System.JSON,
  System.Generics.Collections, System.RTTI, System.TypInfo, System.SysUtils, System.Classes, System.IOUtils;

type
  TDataStorageData = class(TInterfacedObject, IDataStorageData)
  private
    [Weak]
    FDataBase: IDataStorageDataBase;
    FUtils: TDataStorageDataUtils;
  public
    function SetJSON(const AJSON: string): IDataStorageData;
    function ToJSON: string;
    function LoadFromFile(const AFileName: string; const AEncrypt: Boolean = True): IDataStorageData;
    function SaveToFile(const AFileName: string; const AEncrypt: Boolean = True): IDataStorageData;
    function &End: IDataStorage;

    constructor Create(const ADataBase: IDataStorageDataBase);
    destructor Destroy; override;
  end;

implementation

{ TDataStorageData }

constructor TDataStorageData.Create(const ADataBase: IDataStorageDataBase);
begin
  FDataBase := ADataBase;
  FUtils := TDataStorageDataUtils.Create;
end;

destructor TDataStorageData.Destroy;
begin
  FUtils.Free;
  inherited;
end;

function TDataStorageData.SetJSON(const AJSON: string): IDataStorageData;
var
  LJV: TJSONValue;
  LJO: TJSONObject;
begin
  Result := Self;

  try
    LJV := TJSONObject.ParseJSONValue(AJSON);
  except
    Exit
  end;

  if not Assigned(LJV) then
    Exit;

  if not(LJV is TJSONObject) then
  begin
    LJV.Free;
    Exit;
  end;

  LJO := LJV as TJSONObject;
  try
    FUtils.TJSONObjectToDataBase(FDataBase, LJO);
  finally
    LJO.Free;
  end;
end;

function TDataStorageData.ToJSON: string;
var
  LJO: TJSONObject;
  LDataBases: TDataStorageDictDataBase;
  LPairDataBase: TPair<string, IDataStorageTable>;
  LTables: TDataStorageDictTable;
  LPairTable: TPair<string, IDataStorageItem>;
  LItems: TDataStorageDictItem;
  LPairItem: TPair<string, IDataStorageValue>;
  LJOValue: TJSONObject;
  LValue: TValue;
begin
  LJO := TJSONObject.Create;
  try
    LDataBases := FDataBase.DataBase.ListDictionary;

    for LPairDataBase in LDataBases do
    begin
      LJO.AddPair(LPairDataBase.Key, TJSONObject.Create);

      LTables := LPairDataBase.Value.Table.ListDictionary;
      for LPairTable in LTables do
      begin
        LJOValue :=
          LJO.GetValue<TJSONObject>(LPairDataBase.Key)
          .AddPair(LPairTable.Key, TJSONObject.Create)
          .GetValue<TJSONObject>(LPairTable.Key);

        LItems := LPairTable.Value.Item.ListDictionary;
        for LPairItem in LItems do
        begin
          LValue := LPairItem.Value.GetValue;
          FUtils.TValueToJSONObject(LPairItem.Key, LValue, LJOValue);
        end;
      end;
    end;

    Result := LJO.ToString;
  finally
    LJO.Free;
  end;
end;

function TDataStorageData.LoadFromFile(const AFileName: string; const AEncrypt: Boolean = True): IDataStorageData;
var
  LText: string;
begin
  Result := Self;

  if Trim(AFileName).IsEmpty then
    raise EDataStorageException.Create('Filename is empty!');

  if not TFile.Exists(AFileName) then
    Exit;

  try
    LText := TFile.ReadAllText(AFileName);

    if AEncrypt then
      LText := FUtils.ZLibDecompress(LText);
  except
    Exit;
  end;

  SetJSON(LText);
end;

function TDataStorageData.SaveToFile(const AFileName: string; const AEncrypt: Boolean = True): IDataStorageData;
var
  LText: string;
  LStringStream: TStringStream;
begin
  Result := Self;

  if Trim(AFileName).IsEmpty then
    raise EDataStorageException.Create('Filename is empty!');

  if TFile.Exists(AFileName) then
    TFile.Delete(AFileName);

  LText := ToJSON;

  try
    if AEncrypt then
      LText := FUtils.ZLibCompress(LText);
  except
    Exit;
  end;

  LStringStream := TStringStream.Create(LText);
  try
    LStringStream.SaveToFile(AFileName);
  finally
    LStringStream.Free;
  end;
end;

function TDataStorageData.&End: IDataStorage;
begin
  Result := FDataBase.&End;
end;

end.
