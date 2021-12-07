{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.Table;

interface

uses
  DataStorage.Intf, DataStorage.Table.Utils, DataStorage.Item;

type
  TDataStorageTable = class(TInterfacedObject, IDataStorageTable)
  private
    [Weak]
    FDataStorageDataBase: IDataStorageDataBase;
    FDataBase: string;
    FDict: TDataStorageDictTable;
    FUtils: IDataStorageTableUtils;
  public
    function Table(const ATable: string): IDataStorageItem; overload;
    function Table: IDataStorageTableUtils; overload;
    function &End: IDataStorageDataBase;

    constructor Create(const ADataStorageDataBase: IDataStorageDataBase; const ADataBase: string);
    destructor Destroy; override;
  end;

implementation

{ TDataStorageTable }

constructor TDataStorageTable.Create(const ADataStorageDataBase: IDataStorageDataBase; const ADataBase: string);
begin
  FDataStorageDataBase := ADataStorageDataBase;
  FDataBase := ADataBase;
  FDict := TDataStorageDictTable.Create;
  FUtils := TDataStorageTableUtils.Create(Self, FDict);
end;

destructor TDataStorageTable.Destroy;
begin
  FDict.Free;
  inherited;
end;

function TDataStorageTable.Table(const ATable: string): IDataStorageItem;
var
  LItem: IDataStorageItem;
begin
  if not FDict.TryGetValue(ATable, LItem) then
  begin
    LItem := TDataStorageItem.Create(Self, ATable);
    FDict.AddOrSetValue(ATable, LItem);
  end;

  Result := LItem;
end;

function TDataStorageTable.Table: IDataStorageTableUtils;
begin
  Result := FUtils;
end;

function TDataStorageTable.&End: IDataStorageDataBase;
begin
  Result := FDataStorageDataBase
end;

end.
