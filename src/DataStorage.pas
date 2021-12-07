{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage;

interface

uses
  DataStorage.Intf, DataStorage.DataBase, DataStorage.Data;

type
  TValue = DataStorage.Intf.TValue;
  IDataStorage = DataStorage.Intf.IDataStorage;

  TDataStorage = class(TInterfacedObject, IDataStorage)
  private
    FDataStorageDataBase: IDataStorageDataBase;
    FDataStorageData: IDataStorageData;
    class var FInstance: IDataStorage;
  public
    function DataBase(const ADataBase: string): IDataStorageTable; overload;
    function DataBase: IDataStorageDataBaseUtils; overload;
    function Table(const ATable: string): IDataStorageItem; overload;
    function Table: IDataStorageTableUtils; overload;
    function Item(const AItem: string): IDataStorageValue; overload;
    function Item: IDataStorageItemUtils; overload;
    function Data: IDataStorageData;

    constructor Create;
    destructor Destroy; override;

    class function New: IDataStorage;
  end;

implementation

{ TDataStorage }

class function TDataStorage.New: IDataStorage;
begin
  if not Assigned(FInstance) then
    FInstance := TDataStorage.Create;

  Result := FInstance;
end;

constructor TDataStorage.Create;
begin
  FDataStorageDataBase := TDataStorageDataBase.Create(Self);
  FDataStorageData := TDataStorageData.Create(FDataStorageDataBase);
end;

destructor TDataStorage.Destroy;
begin
  inherited;
end;

function TDataStorage.DataBase(const ADataBase: string): IDataStorageTable;
begin
  Result := FDataStorageDataBase.DataBase(ADataBase);
end;

function TDataStorage.DataBase: IDataStorageDataBaseUtils;
begin
  Result := FDataStorageDataBase.DataBase;
end;

function TDataStorage.Table(const ATable: string): IDataStorageItem;
begin
  Result := DataBase('datastorage_default').Table(ATable);
end;

function TDataStorage.Table: IDataStorageTableUtils;
begin
  Result := DataBase('datastorage_default').Table;
end;

function TDataStorage.Item(const AItem: string): IDataStorageValue;
begin
  Result := Table('datastorage_default').Item(AItem);
end;

function TDataStorage.Item: IDataStorageItemUtils;
begin
  Result := Table('datastorage_default').Item;
end;

function TDataStorage.Data: IDataStorageData;
begin
  Result := FDataStorageData;
end;

end.
