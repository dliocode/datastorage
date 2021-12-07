{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.DataBase;

interface

uses
  DataStorage.Intf, DataStorage.DataBase.Utils, DataStorage.Table;

type
  TDataStorageDataBase = class(TInterfacedObject, IDataStorageDataBase)
  private
    [Weak]
    FDataStorage: IDataStorage;
    FDict: TDataStorageDictDataBase;
    FUtils: IDataStorageDataBaseUtils;
  public
    function DataBase(const ADataBase: string): IDataStorageTable; overload;
    function DataBase: IDataStorageDataBaseUtils; overload;
    function &End: IDataStorage;

    constructor Create(const ADataStorage: IDataStorage);
    destructor Destroy; override;
  end;

implementation

{ TDataStorageDataBase }

constructor TDataStorageDataBase.Create(const ADataStorage: IDataStorage);
begin
  FDataStorage := ADataStorage;
  FDict := TDataStorageDictDataBase.Create;
  FUtils := TDataStorageDataBaseUtils.Create(Self, FDict);
end;

destructor TDataStorageDataBase.Destroy;
begin
  FDict.Free;
  inherited;
end;

function TDataStorageDataBase.DataBase(const ADataBase: string): IDataStorageTable;
var
  LTable: IDataStorageTable;
begin
  if not FDict.TryGetValue(ADataBase, LTable) then
  begin
    LTable := TDataStorageTable.Create(Self, ADataBase);
    FDict.AddOrSetValue(ADataBase, LTable);
  end;

  Result := LTable;
end;

function TDataStorageDataBase.DataBase: IDataStorageDataBaseUtils;
begin
  Result := FUtils;
end;

function TDataStorageDataBase.&End: IDataStorage;
begin
  Result := FDataStorage
end;

end.
