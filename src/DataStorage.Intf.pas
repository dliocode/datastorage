{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.Intf;

interface

uses
  System.Generics.Collections, System.Rtti;

type
  TValue = System.Rtti.TValue;

  IDataStorage = interface;
  IDataStorageValue = interface;
  IDataStorageItem = interface;
  IDataStorageTable = interface;
  IDataStorageDataBase = interface;

  TDataStorageDictItem = TDictionary<string, IDataStorageValue>;
  TDataStorageDictTable = TDictionary<string, IDataStorageItem>;
  TDataStorageDictDataBase = TDictionary<string, IDataStorageTable>;

  IDataStorageData = interface
    ['{A0E2B65D-44BC-4D5F-8CC8-CB9E1A24775D}']
    function SetJSON(const AJSON: string): IDataStorageData;
    function ToJSON: string;
    function LoadFromFile(const AFileName: string; const AEncrypt: Boolean = True): IDataStorageData;
    function SaveToFile(const AFileName: string; const AEncrypt: Boolean = True): IDataStorageData;
    function &End: IDataStorage;
  end;

  IDataStorageValue = interface
    ['{08466C0A-D354-43B0-8138-BF451BCBEB80}']
    function GetKey: string;
    function GetValue: TValue;
    function SetValue(const AValue: TValue): IDataStorageItem;
  end;

  IDataStorageItemUtils = interface
    ['{11A148C2-F357-4336-8DC7-3314CF63D82E}']
    function Count: Integer;
    function IsExist(const AItem: string): Boolean;
    function ListKey: TArray<string>;
    function ListDictionary: TDataStorageDictItem;
    function Clear: IDataStorageItemUtils;
    function Remove(const AItem: string): IDataStorageItemUtils;
    function &End: IDataStorageItem;
  end;

  IDataStorageItem = interface
    ['{642D3B0A-2947-442A-BA4B-E60D4E504CCF}']
    function Item(const AItem: string): IDataStorageValue; overload;
    function Item: IDataStorageItemUtils; overload;
    function SetItem(const AItem: string; const AValue: TValue): IDataStorageItem;
    function GetItem(const AItem: string; out AValue: TValue): IDataStorageItem;
    function &End: IDataStorageTable;
  end;

  IDataStorageTableUtils = interface
    ['{3AC38CB9-EDF6-483E-B6CB-2DF1363425C2}']
    function Count: Integer;
    function IsExist(const ATable: string): Boolean;
    function ListKey: TArray<string>;
    function ListDictionary: TDataStorageDictTable;
    function Clear: IDataStorageTableUtils;
    function Remove(const ATable: string): IDataStorageTableUtils;
    function &End: IDataStorageTable;
  end;

  IDataStorageTable = interface
    ['{2FF011E2-8D23-49DC-9B66-C9558E35F42E}']
    function Table(const ATable: string): IDataStorageItem; overload;
    function Table: IDataStorageTableUtils; overload;
    function &End: IDataStorageDataBase;
  end;

  IDataStorageDataBaseUtils = interface
    ['{E2D43D71-E1D5-4AB9-AE1B-F2DF25AAC34D}']
    function Count: Integer;
    function IsExist(const ADataBase: string): Boolean;
    function ListKey: TArray<string>;
    function ListDictionary: TDataStorageDictDataBase;
    function Clear: IDataStorageDataBaseUtils;
    function Remove(const ADataBase: string): IDataStorageDataBaseUtils;
    function &End: IDataStorageDataBase;
  end;

  IDataStorageDataBase = interface
    ['{E43BB56A-6DCD-478C-AAE8-6C8DEBFD6A3A}']
    function DataBase(const ADataBase: string): IDataStorageTable; overload;
    function DataBase: IDataStorageDataBaseUtils; overload;
    function &End: IDataStorage;
  end;

  IDataStorage = interface
    ['{CA89BF56-20E4-40DC-9835-8BB75D5F5EC5}']
    function DataBase(const ADataBase: string): IDataStorageTable; overload;
    function DataBase: IDataStorageDataBaseUtils; overload;
    function Table(const ATable: string): IDataStorageItem; overload;
    function Table: IDataStorageTableUtils; overload;
    function Item(const AItem: string): IDataStorageValue; overload;
    function Item: IDataStorageItemUtils; overload;
    function Data: IDataStorageData;
  end;

implementation

end.
