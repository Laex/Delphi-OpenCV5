# Генератор привязок

[← Документация](README.md) · [Структура](project-structure.md)

Каталог `generator/` в `.gitignore`. Если он есть локально, `generator.py` может генерировать заготовки C++/Delphi по заголовкам OpenCV.

**Не запускайте** генерацию для `objdetect` без обновления конфигурации — перезапишет ручной `wrapper/objdetect.cpp` и `OpenCV5.Objdetect.pas`.

Ручные доработки также в `wrapper/yolo_postprocess.cpp` — см. [Демо → YOLO](demos.md).
