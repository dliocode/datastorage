{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.Item.Utils;

interface

uses
  DataStorage.Intf,
  System.Generics.Collections;

type
  TDataStorageItemUtils = class(TInterfacedObject, IDataStorageItemUtils)
  private
    [Weak]
    FItem: IDataStorageItem;
    FDictItem: TDataStorageDictItem;
  public
    function Count: Integer;
    function IsExist(const AItem: string): Boolean;
    function ListKey: TArray<string>;
    function ListDictionary: TDataStorageDictItem;
    function Clear: IDataStorageItemUtils;
    function Remove(const AItem: string): IDataStorageItemUtils;
    function &End: IDataStorageItem;

    constructor Create(const AItem: IDataStorageItem; const ADictItem: TDataStorageDictItem);
    destructor Destroy; override;
  end;

implementation

{ TDataStorageItemUtils }

constructor TDataStorageItemUtils.Create(const AItem: IDataStorageItem; const ADictItem: TDataStorageDictItem);
begin
  FItem := AItem;
  FDictItem := ADictItem;
end;

destructor TDataStorageItemUtils.Destroy;
begin
  inherited;
end;

function TDataStorageItemUtils.Count: Integer;
begin
  Result := FDictItem.Count;
end;

function TDataStorageItemUtils.ListKey: TArray<string>;
begin
  Result := FDictItem.Keys.ToArray;
end;

function TDataStorageItemUtils.ListDictionary: TDataStorageDictItem;
begin
  Result := FDictItem;
end;

function TDataStorageItemUtils.IsExist(const AItem: string): Boolean;
begin
  Result := FDictItem.ContainsKey(AItem);
end;

function TDataStorageItemUtils.Clear: IDataStorageItemUtils;
begin
  Result := Self;
  FDictItem.Clear;
end;

function TDataStorageItemUtils.Remove(const AItem: string): IDataStorageItemUtils;
begin
  Result := Self;
  FDictItem.Remove(AItem);
end;

function TDataStorageItemUtils.&End: IDataStorageItem;
begin
  Result := FItem;
end;

end.
