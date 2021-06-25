program SampleTypes;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.IOUtils, System.SysUtils,
  DataStorage;

begin
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


    with TDataStorage.New do
    begin
      writeln;
      writeln('>> Simple');
      writeln;
      Writeln(Item('my_string').GetValue.AsVariant);
      Writeln(Item('my_integer').GetValue.AsVariant);
      Writeln(Item('my_float').GetValue.AsVariant);
      Writeln(Item('my_boolean').GetValue.AsVariant);
      Writeln(DateToStr(Item('my_date').GetValue.AsVariant));
      Writeln(TimeToStr(Item('my_time').GetValue.AsVariant));
      Writeln(DateTimeToStr(Item('my_datetime').GetValue.AsVariant));

      // Array
      writeln;
      writeln('>> Array');
      writeln;
      Writeln(Item('my_array_string').GetValue.AsType<TArray < string >>[1]);
      Writeln(Item('my_array_integer').GetValue.AsType<TArray < Integer >>[1]);
      Writeln(Item('my_array_float').GetValue.AsType<TArray < Double >>[1]);
      Writeln(Item('my_array_boolean').GetValue.AsType<TArray < Boolean >>[1]);
      Writeln(DateToStr(Item('my_array_date').GetValue.AsType<TArray < TDateTime >>[1]));
      Writeln(TimeToStr(Item('my_array_time').GetValue.AsType<TArray < TDateTime >>[1]));
      Writeln(DateTimeToStr(Item('my_array_datetime').GetValue.AsType<TArray < TDateTime >>[1]));
    end;

  TDataStorage.New
    .Data.SaveToFile(TPath.GetFileNameWithoutExtension(ParamStr(0)) + '.txt', False);

  Writeln;
  Writeln('Registro salvo com sucesso!');
  Writeln;

  Readln;

end.
