# Документация OpenCV 5.0 Delphi Wrapper

Навигация по разделам. Все пути — относительно корня репозитория.

**English documentation:** [../README.md](../README.md)

## Содержание

| Раздел | Описание |
|--------|----------|
| [Структура проекта](project-structure.md) | каталоги, слои, CMR, SEH |
| [Сборка](building.md) | wrapper, exe, BPL, несколько версий Delphi |
| [Delphi-модули](delphi-units.md) | таблица юнитов и API |
| [Компоненты](components.md) | палитра IDE, камера, view, MUX |
| [TcvPipeline](pipeline.md) | стадии, пресеты, события, Tier 2/3 |
| [Демо и тесты](demos.md) | список примеров, параметры CLI |
| [Модели](models.md) | `download_models.ps1`, файлы в `bin/` |
| [Cookbook](cookbook.md) | примеры кода |
| [Устранение неполадок](troubleshooting.md) | типичные ошибки |
| [Генератор](generator.md) | локальный `generator/` (не в git) |
| [Лицензии](license.md) | OpenCV, модели |

## Быстрые ссылки

- Обзор в корне: [../../README.md](../../README.md)
- Скрипты: `build_all.ps1`, `build_package.ps1`, `download_models.ps1`, `ci.ps1`
- Пример компонентов: `Test/Utit2` (камера → pipeline → MUX → view)
- Отчёт тестов: `bin/test_results.txt`
- Список моделей: `bin/models/README.txt`

## Связанные разделы

```
project-structure ──► building ──► components ──► pipeline
        │                  │            │
        ▼                  ▼            ▼
  delphi-units          demos        cookbook
        │                  │
        ▼                  ▼
     models ◄──────── troubleshooting
```
