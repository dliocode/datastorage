{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.Item;

interface

uses
  DataStorage.Intf, DataStorage.Item.Utils, DataStorage.Value;

type
  TDataStorageItem = class(TInterfacedObject, IDataStorageItem)
  private
    [Weak]
    FDataStorageTable: IDataStorageTable;
    FTable: string;
    FDict: TDataStorageDictItem;
    FUtils: IDataStorageItemUtils;
  public
    function Item(const AItem: string): IDataStorageValue; overload;
    function Item: IDataStorageItemUtils; overload;
    function SetItem(const AItem: string; const AValue: TValue): IDataStorageItem;
    function GetItem(const AItem: string; out AValue: TValue): IDataStorageItem;
    function &End: IDataStorageTable;

    constructor Create(const ADataStorageTable: IDataStorageTable; const ATable: string);
    destructor Destroy; override;
  end;

implementation

{ TDataStorageItem }

constructor TDataStorageItem.Create(const ADataStorageTable: IDataStorageTable; const ATable: string);
begin
  FDataStorageTable := ADataStorageTable;
  FTable := ATable;
  FDict := TDataStorageDictItem.Create;
  FUtils := TDataStorageItemUtils.Create(Self, FDict);
end;

destructor TDataStorageItem.Destroy;
begin
  FDict.Free;
  inherited;
end;

function TDataStorageItem.Item(const AItem: string): IDataStorageValue;
var
  LValue: IDataStorageValue;
begin
  if not FDict.TryGetValue(AItem, LValue) then
  begin
    LValue := TDataStorageValue.Create(Self, AItem);
    FDict.AddOrSetValue(AItem, LValue);
  end;

  Result := LValue;
end;

function TDataStorageItem.Item: IDataStorageItemUtils;
begin
  Result := FUtils;
end;

function TDataStorageItem.SetItem(const AItem: string; const AValue: TValue): IDataStorageItem;
begin
  Result := Item(AItem).SetValue(AValue);
end;

function TDataStorageItem.GetItem(const AItem: string; out AValue: TValue): IDataStorageItem;
begin
  Result := Self;
  AValue := Item(AItem).GetValue;
end;

function TDataStorageItem.&End: IDataStorageTable;
begin
  Result := FDataStorageTable;
end;

end.
