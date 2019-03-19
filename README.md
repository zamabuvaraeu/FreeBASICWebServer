# Station922

Компактный вебсервер для Windows, написанный на фрибейсике. Умеет обрабатывать методы CONNECT, GET, HEAD, POST, PUT, DELETE, TRACE и OPTIONS. Также работает с CGI‐скриптами.

Сервер работает «из коробки», необходимо лишь прописать пути к сайтам в файле конфигурации.

![Снимок экрана консольного вебсервера](https://github.com/BatchedFiles/Station922/blob/master/Station922.png)


## Конфигурация сервера и сайтов

Настройки сервера и сайтов хранятся в обычных INI‐файлах. Для поддержки юникодных путей рекомендется сохранять такие файлы в кодировке UTF-16 LE (юникод 1200 с меткой BOM).


### Серверные настройки

Лежат в файле «WebServer.ini» в каталоге с программой. Пример:

```
[WebServer]
ListenAddress=0.0.0.0
Port=80
ConnectBindAddress=0.0.0.0
ConnectBindPort=0
```

Юникодные имена сайтов следует указывать в кодировке punicode.

#### Описание

<dl>
<dt>ListenAddress</dt>
<dd>Сетевой адрес, к которому будет привязан вебсервер. По умолчанию 0.0.0.0, то есть сервер будет ожидать соединений со всех сетевых интерфейсов.</dd>
</dl>

<dl>
<dt>Port</dt>
<dd>Порт для прослушивания. По умолчанию 80 (стандартный HTTP порт).</dd>
</dl>

<dl>
<dt>ConnectBindAddress</dt>
<dd>Адрес, к которому будет привязываться сервер для выполнения метода CONNECT. По умолчанию 0.0.0.0.</dd>
</dl>

<dl>
<dt>ConnectBindPort</dt>
<dd>Порт, к которому будет привязываться сервер для выполнения метода CONNECT. По умолчанию 0, это значит, что система будет сама выбирать порт для привязки.</dd>
</dl>


### Настройки сайтов

Лежат в файле «WebSites.ini» в каталоге с программой. Каждая секция в файле описывает отдельный сайт, определяемый HTTP‐заголовком «Host», для каждого сайта необходимо создавать отдельную секцию. Вебсервер считает, что example.org, example.org:80, www.example.org и www.example.org:80 — разные сайты, поэтому каждый такой сайт требует отдельной секции. Пример:

```
[localhost]
VirtualPath=/
PhisycalDir=c:\programming\сайты\localhost\
IsMoved=0
MovedUrl=http://localhost/

[localhost:80]
VirtualPath=/
PhisycalDir=c:\programming\сайты\localhost\
IsMoved=0
MovedUrl=http://localhost:80/
```


#### Описание

<dl>
<dt>VirtualPath</dt>
<dd>Виртуальное имя сайта. Используется в сообщениях об ошибках.</dd>
</dl>

<dl>
<dt>PhisycalDir</dt>
<dd>Физический каталог, где расположены файлы сайта, корневой каталог сайта.</dd>
</dl>

<dl>
<dt>IsMoved</dt>
<dd>Флаг перенаправления на другой сайт. Например, клиент делает запрос на example.org, а настоящий сайт находится на www.example.org. В таком случае необходимо установить 1 для перенаправления.</dd>
</dl>

<dl>
<dt>MovedUrl</dt>
<dd>Адрес сайта, куда сервер будет перенаправлять при установленном флаге перенаправления. Необходимо начинать с «http://» Также этот адрес используется сервером для установки заголовка «Location» в ответе на метод PUT.</dd>
</dl>

Таким образом при стандартных настройках, чтобы получить доступ к сайту, необходимо в браузере набрать http://localhost/

Максимальное количество сайтов, поддерживаемое вебсервером, определяется константой «MaxWebSitesCount» в файле «WebSite.bi» По умолчанию MaxWebSitesCount = 50.


## Поддерживаемые методы

Сервер обрабатывает методы CONNECT, DELETE, GET, HEAD, OPTIONS, POST, PUT и TRACE.

Если метод — GET, HEAD или POST и запрошенный файл лежит в папке «/cgi-bin/», то запрос отправляется на обработку скрипту. Если метод POST и файл не лежит в папке «/cgi-bin/», то сервер отвечает ошибкой «405 Method Not Allowed». В остальных случаях сервер обрабатывает запрос самостоятельно.

Для неподдерживаемых методов сервер отвечает ошибкой «501 Not Implemented».

Файлом скрипта может быть любая программа, исполняемый или пакетный файл, умеющая читать и записывать в стандартные потоки ввода‐вывода. Также такой файл должен находиться в папке «/cgi-bin/», лежащей в корневой директории сайта.


### Метод CONNECT

Для своей работы этот метод требуют имени пользователя и пароля в файле «users.config». Если имя пользователя и пароль не прописаны или файл не найден, то вебсервер будет отвечать на методы ошибкой «401 Unauthorized».

Создай в папке с программой файл «users.config» (текстовый INI‐файл) примерно следующего содержания:

```
[admins]
user=password
```


#### Описание

<dl>
<dt>user</dt>
<dd>Имя пользователя для авторизации</dd>
</dl>

<dl>
<dt>password</dt>
<dd>Пароль пользователя.</dd>
</dl>


### Метод PUT

Метод PUT также требует авторизации аналогично методу CONNECT. Файл «users.config» должен лежать в корневой директории сайта.


### Метод POST

Реализуется через CGI‐скрипты. Для этого файл должен лежать в папке /cgi-bin/ в каталоге с сайтом.


## Внутренняя кухня сервера


### Файлы по умолчанию

Если URL запрашиваемого ресурса не содержит полный путь к файлу, например, клиент запрашивает http://localhost/, то сервер ищет в каталоге сайта файлы в порядке очерёдности:

* default.xml
* default.xhtml
* default.htm
* default.html
* index.xml
* index.xhtml
* index.htm
* index.html

Если ни один из этих файлов не найден, то сервер отправляет ошибку «404 Not Found» в общем случае или «410 Gone» если найдёт файл default.xml.410.


### MIME и расширения файлов

MIME меняются довольно редко, нет нужны каждый раз считывать информацию о них из файлов конфигурации или реестра, поэтому в сервере жёстко прописаны стандартные MIME типы содержимого и расширения файлов.

Константы с расширениями файлов, функции обработки MIME располагаются в модуле `Mime.bas`.

В структуру типов документа также встроен флаг, отвечающий за текстовое содержимое. Если функции из модуля `Mime.bas` определят, что запрашиваемый клиентом документ является текстом (например: `text/plain`, `text/html`, `application/xml`, `application/xhtml`), то для такого файла сервер попытается найти метку порядка следования байт (BOM) и на основании ё определить кодировку документа. Возможные варианты:

* метка BOM найдена и соответствует таковой при UTF-8, в этом случае к заголовку Content-Type добавляется указатель на кодировку `charset=utf-8`, а клиенту отправляется содержимое файла без первых трёх байт;

* метка BOM найдена и соответствует таковой при UTF-16 LE, в этом случае к заголовку Content-Type добавляется указатель на кодировку `charset=utf-16`, а клиенту отправляется содержимое файла целиком как есть;

* метка BOM найдена и соответствует таковой при UTF-16 BE, в этом случае к заголовку Content-Type добавляется указатель на кодировку `charset=utf-16`, а клиенту отправляется содержимое файла без первых двух байт;

* метка BOM не найдена, то сервер считает, что файл в кодировке ASCII и не указывает кодировку в ответе клиенту, клиенту отправляется содержимое файла целиком как есть.

Когда клиент запрашивает файл с незарегистрированным расширением, то сервер не может найти для него MIME тип. В таком случае сервер ответит ошибкой «403 Forbidden». Таким образом клиенту не будут отправлены файлы конфигурации `*.config`.


### Файл с дополнительными заголовками ответа

Сервер отправляет клиенту минимальное количество заголовков для правильного отображения файла в браузере. Однако иногда их бывает недостаточно или требуется переопределить некоторые их них. Для такого случая применяются файлы типа `*.headers`.

Файл с дополнительными заголовками следует создавать как текстовый файл в кодировке ASCII, где перечисляются заголовки ответов, каждый на новой строке. Например, для файла `default.htm` файл с заголовками `default.htm.headers` может иметь вид:

```
Content-Language: ru
Content-Type: application/xml
```

При чтении такого файла сервер добавляет значения заголовков в коллекцию перед тем как сформировать ответ. С помощью файла с дополнительными заголовками можно переопределить тип документа, указать используемый язык документа, необходимое время кеширования и так далее. Сервер не будет добавлять нераспознанные заголовки в коллекцию.

```
Age
Allow
Cache-Control
Content-Encoding
Content-Language
Content-Location
Content-MD5
Content-Range
Content-Type
ETag
Expires
Last-Modified
Location
Pragma
Proxy-Authenticate
Retry-After
Set-Cookie
Trailer
Upgrade
Via
Warning
WWW-Authenticate
```

Однако таким файлом нельзя переопределить следующие заголовки:

```
Accept-Ranges
Connection
Content-Length
Date
Keep-Alive
Server
Transfer-Encoding
Vary
```


### Ошибки «404 Not Found» и «410 Gone»

Если запрашиваемый клиентом файл не найден, то сервер ищет файл с расширением `*.410`. Если он будет найден, то сервер отправит ошибку «410 Gone». Если не найден, то будет отправлена ошибка «404 Not Found».

Ошибка «404 Not Found» подразумевает, что файл не найден, но в будущем может появиться по этому пути. Ошибка «410 Gone» используется для указания того, что файл раньше существовал по этому пути, но теперь удалён навсегда и клиентам следует удалить все ссылки на такой файл. Для индикации этого случая предусмотрен файл с двойным расширением `*.410`.


### Сжатые файлы

Сервер не умеет сжимать файлы «на лету», однако он умеет отдавать уже готовое сжатое содержимое. Для этого сжатое содержимое должно располагаться в специальном файле с двойным расширением. Для сжатия типа `gzip` используется расширение `*.gz`, для сжатия `deflate` — расширение `*.deflate`.

Для текстовых файлов кодировка определяется по оригинальному файлу и добавляется в заголовок ответа Content-Type. Несмотря на то, что для кодировок UTF-8 и UTF-16 LE сервер не отправляет клиенту метку BOM, то есть первые три или два байта, сервер отправляет сжатый файл полностью как есть. Поэтому для UTF-8 и UTF-16 BE файлов в стажом файле должна отсутствовать метка BOM.


## Согласование содержимого

В настоящее время сервер согласовывает с клиентом только сжатие данных по заголовку `Accept-Encoding`.

В ответе клиенту в заголовке `Vary` сервер указывает заголовки запроса клиента, по которому различается содержимое.


### Сжатое содержимое

Сервер проверяет существование сжатых вариантов оригинального файла, если таковые имеются, то в заголовке `Vary` устанавливает строку `Accept-Encoding`. Затем сервер просматривает заголовок запроса клиента `Accept-Encoding`. Если в заголовке указан один подходящий тип сжатого содержимого, то сервер отправляет соответствующий сжатый файл:

| Поддерживаемый тип сжатия в заголовке запроса `Accept-Encoding` | Отправляемый клиенту файл |
|----------------|---------|
| gzip | `*.gz` |
| deflate | `*.deflate` |


## Компиляция

Вебсервер можно скомпилировать как обычное консольное приложение и как службу Windows.


### Обычная версия

```
fbc.exe -mt -x WebServer.exe -l crypt32 -l Mswsock -i Classes -i Interfaces -i Modules Modules\Main.bas Mime.bas ProcessCgiRequest.bas ProcessConnectRequest.bas ProcessDeleteRequest.bas ProcessDllRequest.bas ProcessGetHeadRequest.bas ProcessOptionsRequest.bas ProcessPostRequest.bas ProcessPutRequest.bas ProcessTraceRequest.bas ProcessWebSocketRequest.bas URI.bas WebRequest.bas WebResponse.bas Modules\ConsoleColors.bas Modules\Http.bas Modules\Network.bas Modules\SafeHandle.bas Modules\ThreadProc.bas Modules\WebUtils.bas Modules\WriteHttpError.bas Classes\ArrayStringWriter.bas Classes\Configuration.bas Classes\HttpReader.bas Classes\NetworkStream.bas Classes\RequestedFile.bas Classes\ServerState.bas Classes\WebServer.bas Classes\WebSite.bas Classes\WebSiteContainer.bas Classes\InitializeVirtualTables.bas Resources.rc
```


### В виде службы Windows


```
fbc.exe -mt -x Station922.exe -d service -l crypt32 -l Mswsock -i Classes -i Interfaces -i Modules Modules\WebServerService.bas Mime.bas ProcessCgiRequest.bas ProcessConnectRequest.bas ProcessDeleteRequest.bas ProcessDllRequest.bas ProcessGetHeadRequest.bas ProcessOptionsRequest.bas ProcessPostRequest.bas ProcessPutRequest.bas ProcessTraceRequest.bas ProcessWebSocketRequest.bas URI.bas WebRequest.bas WebResponse.bas Modules\ConsoleColors.bas Modules\Http.bas Modules\Network.bas Modules\SafeHandle.bas Modules\ThreadProc.bas Modules\WebUtils.bas Modules\WriteHttpError.bas Classes\ArrayStringWriter.bas Classes\Configuration.bas Classes\HttpReader.bas Classes\NetworkStream.bas Classes\RequestedFile.bas Classes\ServerState.bas Classes\WebServer.bas Classes\WebSite.bas Classes\WebSiteContainer.bas Classes\InitializeVirtualTables.bas Resources.rc
```

Сервер не регистрирует службу. Для регистрации службы в системе можно использовать утилиту `sc`:

```
set current_dir=%~dp0
sc create Station922 binPath= "%current_dir%Station922.exe" start= "auto"
sc start Station922
```
