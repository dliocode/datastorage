program SampleSimple;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.IOUtils, System.SysUtils,
  DataStorage;

var
  LName: TValue;

begin
  TDataStorage.New
    .DataBase('configurations')
      .Table('users')
        .SetItem('id', '1')
        .SetItem('name', 'DLIO Code')
        .SetItem('login', 'developer.dlio@gmail.com')
        .SetItem('password', 'my_passowrd');

  TDataStorage.New
    .DataBase('configurations')
      .Table('users')
        .GetItem('name', LName);

//        or
//
//  LName :=
//  TDataStorage.New
//    .DataBase('configurations')
//      .Table('users')
//        .Item('name').GetValue.AsString;

  Writeln(LName.AsString);

  TDataStorage.New
    .Data.SaveToFile(TPath.GetFileNameWithoutExtension(ParamStr(0)) + '.txt', False);

  Writeln;
  Writeln('Registro salvo com sucesso!');
  Writeln;

  Readln;

end.
