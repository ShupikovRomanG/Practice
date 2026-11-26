program TourCatalog;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.NetEncoding,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MSSQL,
  FireDAC.DApt,
  FireDAC.ConsoleUI.Wait,
  FireDAC.Comp.Client;

procedure SendResponse(const Status, Body: string; const ExtraHeaders: string = '');
var
  Bytes: TBytes;
  Written: DWORD;
begin
  Bytes := TEncoding.UTF8.GetBytes(
    'Status: ' + Status + #13#10 +
    'Content-Type: text/html; charset=utf-8' + #13#10 +
    'Cache-Control: no-store' + #13#10 + ExtraHeaders + #13#10 + Body);
  WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), Bytes[0], Length(Bytes), Written, nil);
end;

function Page(const Title, Body: string): string;
begin
  Result := '<!doctype html><html lang="ru"><head>' +
    '<meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">' +
    '<title>' + Title + '</title><style>' +
    'body{font:16px system-ui,sans-serif;color:#182333;margin:2rem auto;padding:0 1rem;max-width:54rem}' +
    'table{border-collapse:collapse;width:100%}th,td{padding:.6rem;text-align:left;border-bottom:1px solid #ccc}' +
    '</style></head><body><main><h1>' + Title + '</h1>' + Body + '</main></body></html>';
end;

function RenderCatalog: string;
var
  Connection: TFDConnection;
  Query: TFDQuery;
  Rows: TStringBuilder;
  Server: string;
begin
  Server := GetEnvironmentVariable('TOURISM_SQL_SERVER');
  if Server = '' then
    Server := 'localhost';

  Connection := TFDConnection.Create(nil);
  try
    Connection.LoginPrompt := False;
    Connection.ResourceOptions.SilentMode := True;
    Connection.Params.Values['DriverID'] := 'MSSQL';
    Connection.Params.Values['Server'] := Server;
    Connection.Params.Values['Database'] := 'TourismWeb';
    Connection.Params.Values['OSAuthent'] := 'Yes';
    Connection.Connected := True;

    Query := TFDQuery.Create(Connection);
    Query.Connection := Connection;
    Query.SQL.Text :=
      'SELECT Title, Destination, DurationDays, Price FROM dbo.PublishedTours ORDER BY TourId';
    Query.Open;
    if Query.Eof then
      Exit(Page('Каталог туров', '<p>Опубликованных туров пока нет.</p>'));

    Rows := TStringBuilder.Create;
    try
      while not Query.Eof do
      begin
        Rows.Append('<tr><td>' + TNetEncoding.HTML.Encode(Query.Fields[0].AsString) +
          '</td><td>' + TNetEncoding.HTML.Encode(Query.Fields[1].AsString) +
          '</td><td>' + IntToStr(Query.Fields[2].AsInteger) +
          '</td><td>' + FormatCurr('0.00', Query.Fields[3].AsCurrency) + '</td></tr>');
        Query.Next;
      end;
      Result := Page('Каталог туров', '<table><thead><tr><th>Тур</th>' +
        '<th>Направление</th><th>Дней</th><th>Цена, ₽</th></tr></thead><tbody>' +
        Rows.ToString + '</tbody></table>');
    finally
      Rows.Free;
    end;
  finally
    Connection.Free;
  end;
end;

begin
  if GetEnvironmentVariable('REQUEST_METHOD') <> 'GET' then
    SendResponse('405 Method Not Allowed', Page('Метод недоступен', '<p>Используйте GET.</p>'),
      'Allow: GET' + #13#10)
  else
    try
      SendResponse('200 OK', RenderCatalog);
    except
      on E: Exception do
        SendResponse('500 Internal Server Error',
          Page('Каталог временно недоступен', '<p>Повторите попытку позже.</p>'));
    end;
end.
