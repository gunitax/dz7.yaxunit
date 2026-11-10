---
name: db-update
description: Обновление конфигурации базы данных 1С. Используй когда нужно обновить БД, применить конфигурацию, UpdateDBCfg
argument-hint: "[database]"
allowed-tools:
  - Bash
  - Read
  - Glob
  - AskUserQuestion
---

> **Источник:** [Nikolay-Shirokov/cc-1c-skills](https://github.com/Nikolay-Shirokov/cc-1c-skills), коммит `91ebb9e`, лицензия MIT — см. [THIRD-PARTY-NOTICE.md](../THIRD-PARTY-NOTICE.md). Адаптировано для этого репозитория: пути скриптов переведены на `skills/db-update/scripts/`. Упоминания других скиллов набора (`/db-list`, `/db-repo`, `form-add` и т.п.) работают, только если соответствующие скиллы тоже скопированы.

> **База по умолчанию этого проекта** (правило из AGENTS.md, «Проверка расширений загрузкой в базу»): `-InfoBasePath "D:\infobase\vebinar7.yaxunit" -UserName Администратор` (пароль пустой; это одноразовая копия базы). Платформа — 8.5.1.1529 (`C:\Program Files\1cv8\8.5.1.1529\bin\1cv8.exe`); 8.3.27.1688 тоже установлена, но база работает на 8.5.1.


# /db-update — Обновление конфигурации БД

Применяет изменения основной конфигурации к конфигурации базы данных (`/UpdateDBCfg`) —
отдельным шагом после загрузки. У `/db-load-xml` и `/db-load-git` то же самое делает
ключ `-UpdateDB`.

## Usage

```
/db-update [database]
/db-update dev
/db-update dev -Dynamic on
```

## Параметры подключения

Прочитай `.v8-project.json` из корня проекта и разреши базу:
1. Если пользователь указал параметры подключения (путь, сервер) — используй напрямую
2. Если указал базу по имени — ищи по id / alias / name в `.v8-project.json`
3. Если не указал — сопоставь текущую ветку Git с `databases[].branches`
4. Если ветка не совпала — используй `default`
Платформа — `v8path` найденной записи базы, иначе корневой `v8path`. Не задан ни там, ни там — `-V8Path` не передавай.
Если файла нет — предложи `/db-list add`.
Если использованная база не зарегистрирована — после выполнения предложи добавить через `/db-list add`.

## Команда

```powershell
powershell.exe -NoProfile -File "skills/db-update/scripts/db-update.ps1" <параметры>
```

### Параметры скрипта

| Параметр | Обязательный | Описание |
|----------|:------------:|----------|
| `-V8Path <путь>` | нет | Каталог bin платформы, или полный путь к `1cv8.exe` / `ibcmd.exe` |
| `-InfoBasePath <путь>` | * | Файловая база |
| `-InfoBaseServer <сервер>` | * | Сервер 1С (для серверной базы) |
| `-InfoBaseRef <имя>` | * | Имя базы на сервере |
| `-UserName <имя>` | нет | Имя пользователя |
| `-Password <пароль>` | нет | Пароль |
| `-Extension <имя>` | нет | Обновить расширение |
| `-AllExtensions` | нет | Обновить все расширения |
| `-NoApplyCheck` | нет | Не проверять применимость расширения после обновления |
| `-Dynamic <on/off>` | нет | `on` — динамическое обновление, без монопольного доступа к базе; `off` — отключить |
| `-Server` | нет | Обновление на стороне сервера |
| `-WarningsAsErrors` | нет | Предупреждения считать ошибками |
| `-AdditionalV8Arguments <список>` | нет | Доп. аргументы запуска `1cv8.exe` через запятую, напр. `/UseHwLicenses+` |
| `-AdditionalIbcmdArguments <список>` | нет | Доп. аргументы `ibcmd` через запятую, в форме `--ключ=значение` |

> `*` — нужен либо `-InfoBasePath`, либо пара `-InfoBaseServer` + `-InfoBaseRef`

### Фоновое обновление (серверная база)

| Параметр | Описание |
|----------|----------|
| `-BackgroundStart` | Начать фоновое обновление |
| `-BackgroundFinish` | Дождаться окончания |
| `-BackgroundCancel` | Отменить |
| `-BackgroundSuspend` | Приостановить |
| `-BackgroundResume` | Возобновить |

## Примеры

```powershell
# Обычное обновление (файловая база)
powershell.exe -NoProfile -File "skills/db-update/scripts/db-update.ps1" -InfoBasePath "C:\Bases\MyDB" -UserName "Admin"

# Динамическое обновление
powershell.exe -NoProfile -File "skills/db-update/scripts/db-update.ps1" -InfoBaseServer "srv01" -InfoBaseRef "MyDB" -UserName "Admin" -Password "secret" -Dynamic on

# Обновление расширения
powershell.exe -NoProfile -File "skills/db-update/scripts/db-update.ps1" -InfoBasePath "C:\Bases\MyDB" -UserName "Admin" -Extension "МоёРасширение"
```
