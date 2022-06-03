# Оглавление
1. [Микросервисы](#Микросервисы).
2. [Запуск приложения](#Запуск-приложения).
    1. [Настройки для env файлов](#Настройки-для-env-файлов).
    2. [Необходимые поля в env файле](#Необходимые-поля-в-env-файле).
    3. [Выполнение тестов](#Выполнение-тестов).
    4. [Запуск и установка приложения](#Запуск-и-установка-приложения).
    5. [Разворачивание докер контейнера](#Разворачивание-докер-контейнера).
3. [Token market back](#Token-market-back).

# Микросервисы

- [авторизация](https://gitlab.com/universal5/auth)
- [часто задаваемые вопросы](https://gitlab.com/universal5/faq)
____
# Запуск приложения

____
## Настройки для env файлов

- Для запуска приложения в режиме разработки необходимо в репозитории создать `.development.env` файл и добавить в него [необходимые поля](#Необходимые-поля-в-env-файле);
- Для запуска приложения в режиме продакшен необходимо создать `.production.env` файл и добавить в него [необходимые поля](#Необходимые-поля-в-env-файле);
- Для запуска тестов необходимо создать `.test.env` файл и добавить в него [необходимые поля](#Необходимые-поля-в-env-файле).

____
## Необходимые поля в env файле

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

____
## Выполнение тестов

- **npm run test:e2e** для запуска e2e тестов.
- **npm run test** для запуска спецификаций.

____
## Запуск и установка приложения

- скачать [микросервисы](#Микросервисы).
- в кажом из репозиториев выполнить следующее:
    - создать необходимые [.env файлы](#Настройки-для-env-файлов);
    - выполнить команду **npm install** для установки пакетов;
    - выполнить команду **npm run build**;
    - выполнить команду **npm run start** - для запуска продакшен версии или **npm run start:dev** для запуска версии для разработки.

____
## Разворачивание докер контейнера

- выполнить команду **docker-compose up --build**

____
# Token market back
