---
name: cfe-init
description: Создать расширение конфигурации 1С (CFE) — scaffold XML-исходников. Используй когда нужно создать новое расширение для исправления, доработки или дополнения конфигурации
argument-hint: <Name> [-ConfigPath <path>] [-Purpose Patch|Customization|AddOn] [-CompatibilityMode Version8_3_24]
allowed-tools:
  - Bash
  - Read
  - Glob
---

> **Источник:** [Nikolay-Shirokov/cc-1c-skills](https://github.com/Nikolay-Shirokov/cc-1c-skills), коммит `91ebb9e`, лицензия MIT — см. [THIRD-PARTY-NOTICE.md](../THIRD-PARTY-NOTICE.md). Адаптировано для этого репозитория: пути скриптов переведены на `skills/cfe-init/scripts/`. Упоминания других скиллов набора (`/db-list`, `/db-repo`, `form-add` и т.п.) работают, только если соответствующие скиллы тоже скопированы.


# /cfe-init — Создание расширения конфигурации 1С

Создаёт scaffold расширения: `Configuration.xml`, язык в `Languages/`, опционально `Roles/`.

## Подготовка

Если есть выгрузка базовой конфигурации, передай `-ConfigPath` — скрипт автоматически возьмёт из базовой конфигурации `CompatibilityMode` и язык.

### Авто-определение ConfigPath

Если пользователь не указал `-ConfigPath` — попробуй определить автоматически:
1. Прочитай `.v8-project.json` из корня проекта
2. Разреши целевую базу (по имени, ветке или `default` — алгоритм из `/db-list`)
3. Если у базы есть поле `configSrc` — используй как `-ConfigPath`
4. Если `configSrc` нет — спроси у пользователя

Если `.v8-project.json` не найден и `-ConfigPath` не задан — расширение создастся с предупреждением (UUID языка = нули, CompatibilityMode по умолчанию).

## Параметры

| Параметр | Описание | По умолчанию |
|----------|----------|--------------|
| `Name` | Имя расширения (обязат.) | — |
| `Synonym` | Синоним | = Name |
| `NamePrefix` | Префикс собственных объектов | = Name + "_" |
| `OutputDir` | Каталог для создания; клади расширение в свой подкаталог, названный по имени: `1c\extensions\<Name>` | `1c\extensions` |
| `Purpose` | `Patch` (исправление) / `Customization` (доработка) / `AddOn` (дополнение) | `Customization` |
| `Version` | Версия расширения | — |
| `Vendor` | Поставщик | — |
| `CompatibilityMode` | Режим совместимости; при заданном `ConfigPath` определяется по базовой конфигурации и этот параметр не нужен | `Version8_3_24` |
| `ConfigPath` | Путь к выгрузке базовой конфигурации (авто-определяет CompatibilityMode и язык) | — |
| `NoRole` | Без основной роли | false |

## Команда

```powershell
powershell.exe -NoProfile -File "skills/cfe-init/scripts/cfe-init.ps1" -Name "МоёРасширение" -OutputDir "1c\extensions\МоёРасширение" -ConfigPath "1c"
```

## Примеры

```powershell
# Расширение для ERP с авто-определением совместимости из базовой конфигурации
... -Name Расш1 -ConfigPath 1c -OutputDir 1c\extensions\Расш1

# Расширение-исправление с явным режимом совместимости
... -Name Расш1 -Purpose Patch -CompatibilityMode Version8_3_17 -OutputDir 1c\extensions\Расш1

# Расширение-доработка с версией
... -Name МоёРасширение -Version "1.0.0.1" -Vendor "Компания" -OutputDir 1c\extensions\МоёРасширение

# Без роли, с явным префиксом
... -Name ИсправлениеБага -NamePrefix "ИБ_" -Purpose Patch -NoRole -OutputDir 1c\extensions\ИсправлениеБага
```

## Верификация

```
/cfe-validate <OutputDir> -ConfigPath <ConfigPath>
```

