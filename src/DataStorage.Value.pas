{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataStorage.Value;

interface

uses
  DataStorage.Intf, System.SysUtils, System.Rtti;

type
  TDataStorageValue = class(TInterfacedObject, IDataStorageValue)
  private
    [Weak]
    FItem: IDataStorageItem;
    FKey: string;
    FValue: TValue;

    procedure ObjectFinalize;
  public
    function GetKey: string;
    function GetValue: TValue;
    function SetValue(const AValue: TValue): IDataStorageItem;

    constructor Create(const AItem: IDataStorageItem; const AKey: string);
    destructor Destroy; override;
  end;

implementation

{ TDataStorageValue }

constructor TDataStorageValue.Create(const AItem: IDataStorageItem; const AKey: string);
begin
  FItem := AItem;
  FKey := AKey;
  FValue := '';
end;

destructor TDataStorageValue.Destroy;
begin
  ObjectFinalize;
  inherited;
end;

function TDataStorageValue.GetKey: string;
begin
  Result := FKey;
end;

function TDataStorageValue.GetValue: TValue;
begin
  Result := FValue;
end;

function TDataStorageValue.SetValue(const AValue: TValue): IDataStorageItem;
begin
  Result := FItem;

  ObjectFinalize;

  FValue := AValue;
end;

procedure TDataStorageValue.ObjectFinalize;
var
  LObject: TObject;
begin
  if FValue.IsObject then
  begin
    LObject := FValue.AsObject;
    try
      if Assigned(LObject) then
        LObject.Free;
    except
    end;
  end;
end;

end.
