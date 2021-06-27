{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.DataBase.Utils;

interface

uses
  DataStorage.Intf,
  System.Generics.Collections;

type
  TDataStorageDataBaseUtils = class(TInterfacedObject, IDataStorageDataBaseUtils)
  private
    [Weak]
    FDataBase: IDataStorageDataBase;
    FDictDataBase: TDataStorageDictDataBase;
  public
    function Count: Integer;
    function IsExist(const ADataBase: string): Boolean;
    function ListKey: TArray<string>;
    function ListDictionary: TDataStorageDictDataBase;
    function Clear: IDataStorageDataBaseUtils;
    function Remove(const ADataBase: string): IDataStorageDataBaseUtils;
    function &End: IDataStorageDataBase;

    constructor Create(const ADataBase: IDataStorageDataBase; const ADictDataBase: TDataStorageDictDataBase);
    destructor Destroy; override;
  end;

implementation

{ TDataStorageDataBaseUtils }

constructor TDataStorageDataBaseUtils.Create(const ADataBase: IDataStorageDataBase; const ADictDataBase: TDataStorageDictDataBase);
begin
  FDataBase := ADataBase;
  FDictDataBase := ADictDataBase;
end;

destructor TDataStorageDataBaseUtils.Destroy;
begin
  inherited;
end;

function TDataStorageDataBaseUtils.Count: Integer;
begin
  Result := FDictDataBase.Count;
end;

function TDataStorageDataBaseUtils.ListKey: TArray<string>;
begin
  Result := FDictDataBase.Keys.ToArray;
end;

function TDataStorageDataBaseUtils.ListDictionary: TDataStorageDictDataBase;
begin
  Result := FDictDataBase;
end;

function TDataStorageDataBaseUtils.IsExist(const ADataBase: string): Boolean;
begin
  Result := FDictDataBase.ContainsKey(ADataBase);
end;

function TDataStorageDataBaseUtils.Clear: IDataStorageDataBaseUtils;
var
  LPairDataBase: TPair<string, IDataStorageTable>;
begin
  Result := Self;

  for LPairDataBase in FDictDataBase do
    LPairDataBase.Value.Table.Clear;

  FDictDataBase.Clear;
end;

function TDataStorageDataBaseUtils.Remove(const ADataBase: string): IDataStorageDataBaseUtils;
begin
  Result := Self;

  FDictDataBase.Remove(ADataBase);
end;

function TDataStorageDataBaseUtils.&End: IDataStorageDataBase;
begin
  Result := FDataBase;
end;

end.
