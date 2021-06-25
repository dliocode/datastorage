program SampleRecord;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.IOUtils,
  DataStorage;

type
  TUser = record
    Id: string;
    Name: string;
    Login: string;
    Password: string;
  end;

var
  LUser: TUser;
begin
  LUser.Id := '1';
  LUser.Name := 'DLIO CODE';
  LUser.Login := 'dlio.developer@gmail.com';
  LUser.Password := 'password';

  TDataStorage.New
    .DataBase('configurations')
    .Table('users')
    .SetItem('1', TValue.From<TUser>(LUser));

  LUser := Default(TUser); // Limpando a variavel;

  Writeln('Test nome: '+LUser.Name);

  LUser :=
    TDataStorage.New
      .DataBase('configurations')
        .Table('users').Item('1').GetValue.AsType<TUser>;

  Writeln('Test nome: '+LUser.Name);

  TDataStorage.New
    .Data.SaveToFile(TPath.GetFileNameWithoutExtension(ParamStr(0)) + '.txt', False);

  Writeln;
  Writeln('Registro salvo com sucesso!');
  Writeln;

  Readln;

end.
