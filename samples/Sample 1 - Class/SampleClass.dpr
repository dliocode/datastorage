program SampleClass;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.IOUtils,
  DataStorage;

type
  TUser = class
  private
    FId: string;
    FName: string;
    FLogin: string;
    FPassword: string;
  public
    property Id: string read FId write FId;
    property Name: string read FName write FName;
    property Login: string read FLogin write FLogin;
    property Password: string read FPassword write FPassword;
  end;

var
  LUser: TUser;
  LUser2: TUser;
begin
  LUser := TUser.Create;
  try
    LUser.Id := '1';
    LUser.Name := 'DLIO CODE';
    LUser.Login := 'dlio.developer@gmail.com';
    LUser.Password := 'password';

    TDataStorage.New
      .DataBase('configurations')
        .Table('users')
          .SetItem('1', LUser);

    LUser2 :=
    TDataStorage.New
      .DataBase('configurations')
        .Table('users')
          .Item('1').GetValue.AsType<TUser>;

    Writeln('Name: '+LUser2.Name);
    Writeln('Login: '+LUser2.Name);

    TDataStorage.New
      .Data.SaveToFile(TPath.GetFileNameWithoutExtension(ParamStr(0)) + '.txt', False);
  finally
    LUser.DisposeOf;
  end;

  Writeln;
  Writeln('Regisro salvo com sucesso!');
  Writeln;

  Readln;

end.
