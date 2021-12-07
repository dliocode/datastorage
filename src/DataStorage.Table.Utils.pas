{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.Table.Utils;

interface

uses
  DataStorage.Intf,
  System.Generics.Collections;

type
  TDataStorageTableUtils = class(TInterfacedObject, IDataStorageTableUtils)
  private
    [Weak]
    FTable: IDataStorageTable;
    FDictTable: TDataStorageDictTable;
  public
    function Count: Integer;
    function IsExist(const ATable: string): Boolean;
    function ListKey: TArray<string>;
    function ListDictionary: TDataStorageDictTable;
    function Clear: IDataStorageTableUtils;
    function Remove(const ATable: string): IDataStorageTableUtils;
    function &End: IDataStorageTable;

    constructor Create(const ATable: IDataStorageTable; const ADictTable: TDataStorageDictTable);
    destructor Destroy; override;
  end;

implementation

{ TDataStorageTableUtils }

constructor TDataStorageTableUtils.Create(const ATable: IDataStorageTable; const ADictTable: TDataStorageDictTable);
begin
  FTable := ATable;
  FDictTable := ADictTable;
end;

destructor TDataStorageTableUtils.Destroy;
begin
  inherited;
end;

function TDataStorageTableUtils.Count: Integer;
begin
  Result := FDictTable.Count;
end;

function TDataStorageTableUtils.ListKey: TArray<string>;
begin
  Result := FDictTable.Keys.ToArray;
end;

function TDataStorageTableUtils.ListDictionary: TDataStorageDictTable;
begin
  Result := FDictTable;
end;

function TDataStorageTableUtils.IsExist(const ATable: string): Boolean;
begin
  Result := FDictTable.ContainsKey(ATable);
end;

function TDataStorageTableUtils.Clear: IDataStorageTableUtils;
var
  LPairItem: TPair<string, IDataStorageItem>;
begin
  Result := Self;

  for LPairItem in FDictTable do
    LPairItem.Value.Item.Clear;

  FDictTable.Clear;
end;

function TDataStorageTableUtils.Remove(const ATable: string): IDataStorageTableUtils;
begin
  Result := Self;
  FDictTable.Remove(ATable);
end;

function TDataStorageTableUtils.&End: IDataStorageTable;
begin
  Result := FTable;
end;

end.
