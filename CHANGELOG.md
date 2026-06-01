# Changelog

All notable changes to this project are documented here. Version numbers match
Git tags and the `version` field in `.cursor-plugin/plugin.json` and
`.claude-plugin/plugin.json`.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.1.0] - 2026-06-02

### Changed

- Renamed the **feature** skill to **implement**. Invoke with `/implement {task-id}`
  (e.g. `/implement CHK01-01`) instead of `/feature implement {task-id}`.
- Renamed the plugin identifier from `dskills` to `daddia-skills` in Cursor and
  Claude plugin manifests.
- Updated cross-references across README, skills-index, delivery conventions,
  and related skills to use **implement** and task terminology.

### Added

- **implement** skill (`skills/implement/`) with implementation prompt aligned to
  Task IDs in `docs/work/{epic}/tasks.md`.

### Removed

- **feature** skill directory (replaced by **implement**).

## [1.0.0] - 2026-06-01

### Added

- Initial release of the daddia skills plugin: product delivery skills for
  strategy, architecture, epic design, tasks, implementation, code review,
  validation, and sprint refinement.
- Cursor and Claude plugin manifests, skills.sh catalogue, and validation CI.
