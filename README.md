<p align="center">
  <a href="https://user-images.githubusercontent.com/54585337/123715769-5f6e1d00-d84f-11eb-9f24-d2a3279c09db.png">
    <img alt="DataStorage" src="https://user-images.githubusercontent.com/54585337/123715769-5f6e1d00-d84f-11eb-9f24-d2a3279c09db.png">
  </a>  
</p>
<br>
<p align="center"> 
  <img src="https://img.shields.io/github/v/release/dliocode/datastorage?style=flat-square">
  <img src="https://img.shields.io/github/stars/dliocode/datastorage?style=flat-square">
  <img src="https://img.shields.io/github/forks/dliocode/datastorage?style=flat-square">
  <img src="https://img.shields.io/github/contributors/dliocode/datastorage?color=orange&style=flat-square">
  <img src="https://tokei.rs/b1/github/dliocode/datastorage?color=red&category=lines">
  <img src="https://tokei.rs/b1/github/dliocode/datastorage?color=green&category=code">
  <img src="https://tokei.rs/b1/github/dliocode/datastorage?color=yellow&category=files">
</p>

# DataStorage

DataStorage foi projetado para ser uma biblioteca simples e com possibilidades de salvar quase todo o tipo de registro.

Support: developer.dlio@gmail.com

## Instalação

#### Para instalar em seu projeto usando [boss](https://github.com/HashLoad/boss):
```sh
$ boss install github.com/dliocode/datastorage
```

#### Instalação Manual

Adicione as seguintes pastas ao seu projeto, em *Project > Options > Delphi Compiler > Search path*

```
../datastorage/src
```

## Como usar

#### **Uses necessária**

```
uses DataStorage;
``` 

#### **Estrutura**

* DataBase 
* Table 
* Item 

#### **Como adicionar as informações**

##### Modo: Simples
```
    TDataStorage.New
    .DataBase('configurations')
      .Table('users')
        .SetItem('id', '1')
        .SetItem('name', 'DLIO Code')
        .SetItem('login', 'developer.dlio@gmail.com')
        .SetItem('password', 'my_passowrd')
```

##### Modo: Simples - Type: String / Integer / Float / Boolean / Date / Time / DateTime / Array
```
  TDataStorage.New
    .Item('my_string').SetValue('value_string')
    .Item('my_integer').SetValue(1000)
    .Item('my_float').SetValue(18.50)
    .Item('my_boolean').SetValue(True)
    .Item('my_date').SetValue(Date)
    .Item('my_time').SetValue(Time)
    .Item('my_datetime').SetValue(Now)

    .Item('my_array_string').SetValue(TValue.From < TArray < string >> (['value_string 1', 'value_string 2', 'value_string 3']))
    .Item('my_array_integer').SetValue(TValue.From < TArray < Integer >> ([1000, 1001, 1002]))
    .Item('my_array_float').SetValue(TValue.From < TArray < Double >> ([18.50, 25.90, 48.92]))
    .Item('my_array_boolean').SetValue(TValue.From < TArray < Boolean >> ([False, True, False]))
    .Item('my_array_date').SetValue(TValue.From < TArray < TDateTime >> ([Date, Date + 5, Date + 20]))
    .Item('my_array_time').SetValue(TValue.From < TArray < TDateTime >> ([Time, Time + 5, Time + 20]))
    .Item('my_array_datetime').SetValue(TValue.From < TArray < TDateTime >> ([Now, Now + 5, Now + 20]));
```

##### Modo: Record
```
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

  Readln;  
end.

```

##### Modo: Class
```
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

    Readln;      
  finally
    LUser.DisposeOf;
  end;  
end.
```

#### **Como recuperar o dados adicionados**

##### Modo: Simples
```
var
  LName: TValue;
begin
  TDataStorage.New
    .DataBase('configurations')
      .Table('users')
        .GetItem('name', LName);
        
//   or
//
//  LName :=
//  TDataStorage.New
//    .DataBase('configurations')
//      .Table('users')
//        .Item('name').GetValue;

  Writeln(LName.AsString);

  Readln;

end.
```

##### Modo: Simples - Type: String / Integer / Float / Boolean / Date / Time / DateTime / Array
```
    with TDataStorage.New do
    begin
      writeln;
      writeln('>> Simple');
      writeln;
      Writeln( Item('my_string').GetValue.AsVariant );
      Writeln( Item('my_integer').GetValue.AsVariant );
      Writeln( Item('my_float').GetValue.AsVariant );
      Writeln( Item('my_boolean').GetValue.AsVariant );
      Writeln( DateToStr(Item('my_date').GetValue.AsVariant) );
      Writeln( TimeToStr(Item('my_time').GetValue.AsVariant) );
      Writeln( DateTimeToStr(Item('my_datetime').GetValue.AsVariant) );

      // Array
      writeln;
      writeln('>> Array');
      writeln;
      Writeln( Item('my_array_string').GetValue.AsType<TArray < string >>[0]) ;
      Writeln( Item('my_array_integer').GetValue.AsType<TArray < Integer >>[1] );
      Writeln( Item('my_array_float').GetValue.AsType<TArray < Double >>[2] );
      Writeln( Item('my_array_boolean').GetValue.AsType<TArray < Boolean >>[0] );
      Writeln( DateToStr(Item('my_array_date').GetValue.AsType<TArray < TDateTime >>[1]) );
      Writeln( TimeToStr(Item('my_array_time').GetValue.AsType<TArray < TDateTime >>[2]) );
      Writeln( DateTimeToStr(Item('my_array_datetime').GetValue.AsType<TArray < TDateTime >>[0]) );
    end;
```

##### Modo: Record
```
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
  LUser :=
    TDataStorage.New
      .DataBase('configurations')
        .Table('users').Item('1').GetValue.AsType<TUser>;

  Writeln('Name: '+LUser.Name);
  Writeln('Login: '+LUser.Name);  

  Readln;  
end.

```

##### Modo: Class
```
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
  finally
    LUser.DisposeOf;
  end; 
end.
```

### **DataBase**

- **Como contar todos os DataBases**  
    ``` TDataStorage.New.DataBase.Count; ```  
  
- **Como verificar se um DataBase existe**  
    ``` TDataStorage.New.DataBase.IsExist('NAME'); ```  
  
- **Como remover um DataBase específico**  
    ``` TDataStorage.New.DataBase.Remove('Name'); ```  
  
- **Como remover todos os DataBase**  
    ``` TDataStorage.New.DataBase.Clear; ```  
  
### **Table**

- **Como contar todas as tabelas de um DataBase específico**  
    ``` TDataStorage.New.DataBase('NAME').Table.Count; ```  
  
- **Como verificar se uma tabela existe de um DataBase específico**  
    ``` TDataStorage.New.DataBase('NAME').Table.IsExist('TABLE NAME'); ```  
  
- **Como remove uma tabela de um DataBase específico**  
    ``` TDataStorage.New.DataBase('NAME').Table.Remove('TABLE NAME'); ```  
  
- **Como remover todas as tabelas de um DataBase específico**  
    ``` TDataStorage.New.DataBase('NAME').Table.Clear; ```  
  
### **Item**

- **Como contar todos os itens de uma tabela específica e um DataBase específico**  
    ``` TDataStorage.New.DataBase('NAME').Table('TABLE NAME').Item.Count; ```  
  
- **Como verificar se um item existe de uma tabela específica e um DataBase específico**  
    ``` TDataStorage.New.DataBase('NAME').Table('TABLE NAME').Item.IsExist('ITEM NAME'); ```  
  
- **Como remove um item de uma tabela específica e um DataBase específico**  
    ``` TDataStorage.New.DataBase('NAME').Table('TABLE NAME').Item.Remove('ITEM NAME'); ```  
  
- **Como remover todas os itens de uma tabela específica e um DataBase específico**  
    ``` TDataStorage.New.DataBase('NAME').Table('TABLE NAME').Item.Clear; ```  
  
###  **Data**

- **Como salvar os dados**  
    ``` TDataStorage.New.Data.SaveToFile('NAME_FILE.txt', True); // True = Salva Criptografado! ```  
  
- **Como carregar de um arquivo**  
    ```TDataStorage.New.Data.LoadFromFile('NAME_FILE.txt', True); // True = Ler o dados Criptografados! ``` 

- **Como obter os dados sem salvar**  
    ``` TDataStorage.New.Data.ToJSON; ```  
  
- **Como setar os dados**  
    ``` TDataStorage.New.Data.SetJSON(''); ``` 
