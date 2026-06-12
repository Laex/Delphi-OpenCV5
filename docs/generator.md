# Binding generator

[← Documentation](README.md) · [Structure](project-structure.md)

The `generator/` folder is in `.gitignore`. If present locally, `generator.py` can generate C++/Delphi stubs from OpenCV headers.

**Do not run** generation for `objdetect` without updating the configuration — it will overwrite hand-written `wrapper/objdetect.cpp` and `OpenCV5.Objdetect.pas`.

Manual changes also live in `wrapper/yolo_postprocess.cpp` — see [Demos → YOLO](demos.md).
