
# Оглавление
1. [Микросервисы](#Микросервисы).
2. [Запуск приложения](#Запуск-приложения).
    1. [Настройки для env файлов](#Настройки-для-env-файлов).
    2. [Необходимые поля в env файле](#Необходимые-поля-в-env-файле).
        1. [Token market back](#Token-market-back)
        2. [FAQ microservice](#FAQ-microservice)
    3. [Выполнение тестов](#Выполнение-тестов).
    4. [Запуск и установка приложения](#Запуск-и-установка-приложения).
    5. [Разворачивание докер контейнера](#Разворачивание-докер-контейнера).

____
# Микросервисы

- [авторизация](https://gitlab.com/universal5/auth) (в данный момент не работает);
- [часто задаваемые вопросы](https://gitlab.com/universal5/faq).

____
# Запуск приложения

Для начала работы установите на свой компьютер [node.js](https://nodejs.org/en/blog/release/v16.14.2/).  

____
## Настройки для env файлов

- Для запуска приложения в режиме разработки необходимо в репозитории создать `.development.env` файл и добавить в него [необходимые поля](#Необходимые-поля-в-env-файле);
- Для запуска приложения в режиме продакшен необходимо создать `.production.env` файл и добавить в него [необходимые поля](#Необходимые-поля-в-env-файле);
- Для запуска тестов необходимо создать `.test.env` файл и добавить в него [необходимые поля](#Необходимые-поля-в-env-файле).

____
## Необходимые поля в env файле

### Token market back

PORT - порт на котором запускается приложение.  
SALT_ROUNDS - соль, необходимая для bcrypt.  
POSTGRES_HOST - ip на котором расположена база данных.  
POSTGRES_PORT - порт на котором развернут PostgreSQL.  
POSTGRES_USER - роль входа в PostgreSQL.  
POSTGRES_PASSWORD - пароль от роли входа в PostgreSQL.  
POSTGRES_DB - имя базы данных.  
JWT_SECRET - секретное слово, используемое во время авторизации.  
REFRESH_SECRET - секретное слово, для создания refresh токена.  
ACCESS_SECRET - серетное слово, для создания access токена.  
DOMAIN_STR - домен, для доступа к api приложения. Например: localhost или www.google.com.  
PROTOCOL_STR - протокол передачи данных. http или https.  
PROXY_STR - в случае запуска приложения на localhost указать ':PORT', в остальных случаях оставить пустым ''.  

Пример .env файла:  

```
PORT=5000
SALT_ROUNDS=12
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=user_name
POSTGRES_PASSWORD=user_password
POSTGRES_DB=base_name
JWT_SECRET=JWT_SECRET
REFRESH_SECRET=REFRESH_SECRET
ACCESS_SECRET=ACCESS_SECRET
DOMAIN_STR=localhost
PROTOCOL_STR=http
PROXY_STR=:5000
```

### FAQ microservice
PORT - порт на котором запускается приложение.  
POSTGRES_HOST - ip на котором расположена база данных.  
POSTGRES_PORT - порт на котором развернут PostgreSQL.  
POSTGRES_USER - роль входа в PostgreSQL.  
POSTGRES_PASSWORD - пароль от роли входа в PostgreSQL.  
POSTGRES_DB - имя базы данных.  

Пример .env файла:  

```
PORT=5001
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=user_name
POSTGRES_PASSWORD=user_password
POSTGRES_DB=base_name
```

____
## Запуск и установка приложения

- скачать [микросервисы](#Микросервисы).
- в каждом из репозиториев выполнить следующее:
    - создать необходимые [.env файлы](#Настройки-для-env-файлов);
    - выполнить команду **npm install**;
    - выполнить команду **npm run build**;
    - выполнить команду **npm run start** - для запуска продакшен версии или **npm run start:dev** для запуска версии для разработки.

____
## Выполнение тестов

- **npm run test:e2e** для запуска e2e тестов из папки test.
- **npm run test** для запуска спецификаций.
