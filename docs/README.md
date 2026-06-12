# OpenCV 5.0 Delphi Wrapper — Documentation

Section index. All paths are relative to the repository root.

## Contents

| Section | Description |
|---------|-------------|
| [Project structure](project-structure.md) | directories, layers, CMR, SEH |
| [Building](building.md) | wrapper, executables, BPL, multiple Delphi versions |
| [Delphi units](delphi-units.md) | unit table and API overview |
| [Components](components.md) | IDE palette, camera, view, MUX |
| [TcvPipeline](pipeline.md) | stages, presets, events, Tier 2/3 |
| [Demos and tests](demos.md) | sample programs, CLI options |
| [Models](models.md) | `download_models.ps1`, files in `bin/` |
| [Cookbook](cookbook.md) | code examples |
| [Troubleshooting](troubleshooting.md) | common issues |
| [Generator](generator.md) | local `generator/` (not in git) |
| [Licenses](license.md) | OpenCV, models |

## Quick links

- Repository overview: [../README.md](../README.md)
- Scripts: `build_all.ps1`, `build_package.ps1`, `download_models.ps1`, `ci.ps1`
- Component example: `Test/Utit2` (camera → pipeline → MUX → view)
- Test report: `bin/test_results.txt`
- Model list: `bin/models/README.txt`
- Russian documentation: [ru/README.md](ru/README.md)

## Related sections

```
project-structure ──► building ──► components ──► pipeline
        │                  │            │
        ▼                  ▼            ▼
  delphi-units          demos        cookbook
        │                  │
        ▼                  ▼
     models ◄──────── troubleshooting
```
