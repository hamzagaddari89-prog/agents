---
name: android-app-builder
description: Turn a user app idea or single prompt into a runnable Android application, preserving existing projects when present, using Kotlin, Jetpack Compose, Material 3, and Gradle by default. Covers product analysis, UI, navigation, app logic, data/API integration, local storage, build repair, APK verification, and dist output. Use when the user asks to build, generate, create, prototype, or modify an Android app and expects a real debug APK.
license: MIT
---

# Android App Builder

Deliver a real, buildable Android application from the user's description. Treat the
prompt as the product requirement and make sensible technical decisions without
asking the user to choose routine implementation details. Ask one focused question
only when a missing decision changes product behavior, legal access, credentials, or
cannot be safely inferred.

## Non-negotiable defaults

- Use Kotlin, Jetpack Compose, Material 3, and Gradle unless the user explicitly
  requests another Android stack.
- Do not use Flutter or React Native unless explicitly requested.
- Prefer the smallest maintainable architecture that satisfies the feature. Use
  MVVM, Repository, Room, Retrofit/OkHttp, and Coroutines only when the app needs
  them; do not add layers or dependencies speculatively.
- Never claim success from generated source alone. A successful deliverable includes
  a real `assembleDebug` build and a non-empty APK, or an explicit external blocker.
- Never put credentials, private endpoints, or signing secrets in source or the APK.
  Use `local.properties` or environment variables for development-only configuration.

## Workflow

### 1. Discover the project and baseline

Before editing:

1. Inspect the requested path and nearby project markers only; do not dump the whole
   repository. Look for `settings.gradle(.kts)`, `build.gradle(.kts)`, `gradlew`,
   `gradlew.bat`, `AndroidManifest.xml`, `app/`, and existing package sources.
2. If an Android project exists, modify it in place. Preserve its package/application
   ID, architecture, existing data, visual language, and build configuration unless
   the requirement explicitly changes them.
3. If no project exists, choose a short project directory requested by the user or
   create one under the user's working directory. Record the chosen package name
   and output location.
4. Capture `git status --short` before changes. Do not overwrite or delete unrelated
   work. Do not delete files outside the project.

### 2. Check the build environment

Run focused, non-destructive checks before implementation:

- `java -version` and `javac -version` (a JRE alone is not a JDK).
- `gradle -v`, then prefer the project's `gradlew.bat`/`gradlew` when present.
- Inspect `ANDROID_HOME` and `ANDROID_SDK_ROOT`; check the SDK platform and build
  tools required by the project.
- Check `adb version` and `adb devices` for optional device smoke testing.

Use installed tools instead of reinstalling them. Do not install Android Studio just
for a command-line build. If the SDK/JDK is absent, explain the exact missing tool
and try only a minimal permitted setup; otherwise report the environment blocker.
Do not change global agent configuration to work around a project problem.

### 3. Analyze the prompt into an implementation brief

Write a compact internal brief before coding:

- primary user journey and success condition;
- screens, routes, back behavior, and navigation entry points;
- actions, forms, buttons, validation, dialogs, and permissions;
- data models and their source (static, local, or remote);
- loading, empty, error, offline, and retry states;
- local persistence and refresh behavior;
- API contract, URL opening behavior, and network policy;
- accessibility, orientation, light/dark behavior, and responsive constraints.

Infer ordinary details from the domain. Do not invent unrelated accounts, analytics,
payments, settings, or backend features. For external data, clearly distinguish a
real API integration from sample data and do not silently present placeholders as
live content.

### 4. Implement the smallest complete app

For a new project, create a complete Gradle Android project with a valid manifest,
resources, package structure, Compose entry point, and debug configuration. Keep
versions mutually compatible with the installed toolchain and existing project.

Build only the required pieces:

- Compose screens with Material 3 theme, meaningful content, proper spacing, and
  phone-sized layouts;
- clear navigation (use the existing navigation solution when present);
- state and business logic in a ViewModel or similarly simple state holder when
  state survives recomposition or screen recreation;
- repository/data source only when separating remote or persistent data helps;
- Room only for actual structured local persistence; simple preferences or files for
  genuinely simple settings;
- network permission and safe URL handling when the feature needs the network;
- loading, empty, error, retry, and disabled states where applicable;
- accessible labels, sensible content descriptions, touch targets, and readable
  contrast;
- legal, locally available icons or vector resources. Do not reference nonexistent
  assets, remote images without a loading/error strategy, or copyrighted assets
  without a permitted source.

Avoid hardcoded secrets and machine-specific absolute paths. Keep API credentials out
of logs, reports, checkpoints, and commits. If an API key is needed at runtime, make
the missing configuration fail clearly and document the environment variable or
`local.properties` key without recording its value.


### 5. Build and repair loop

After implementation, build the actual project. On Windows use the wrapper when
available:

```powershell
.\gradlew.bat assembleDebug
```

If the wrapper is unavailable but a compatible Gradle installation exists, use:

```powershell
gradle assembleDebug
```

Use a bounded repair loop (normally no more than 5 meaningful attempts):

1. Capture the complete failing command and the first actionable error.
2. Classify it as syntax/compile, dependency/version, manifest/resource, SDK/JDK,
   generated-code, or environment failure.
3. Inspect the referenced file and relevant build configuration; do not guess from
   the last line alone.
4. Make one focused fix that addresses the diagnosed cause.
5. Re-run the same build and record whether the error changed.

Never hide errors by weakening tests, removing requested behavior, disabling lint,
using broad exclusions, or swallowing exceptions. If the same error repeats without
a new diagnosis, stop and report the blocker and the attempted fixes. Do not claim an
APK exists unless the build command actually completed successfully.

### 6. APK output and verification

After a successful build:

1. Locate the produced debug APK, normally under `app/build/outputs/apk/debug/`.
2. Verify the file exists and its byte length is greater than zero.
3. Copy the built artifact to `<project>\dist\app-debug.apk` (create `dist` only
   inside the project) and verify the copied file too.
4. Verify the package/application ID from the manifest/build output and confirm that
   no dependency-resolution or compilation errors occurred.
5. If `adb devices` reports an available device or emulator, install the APK with
   `adb install -r` and perform a minimal smoke test of launch and the primary user
   flow. A device is optional; its absence does not invalidate a successful build.
6. If a required check was not possible, label it `UNVERIFIED` rather than implying
   it passed. Separate build evidence from UI/device evidence.

Report the absolute APK path, package ID, build variant, file size, and any checks
that were unavailable.

### 7. Completion and commit

Before reporting completion, map each requested acceptance criterion to executed
evidence: relevant tests or commands, observed result, and any uncovered criterion.
Run the project's existing tests when present, then run the applicable shared-agent
verification if this skill itself is being changed.

When the user requested or approved a commit, follow the `smart-commit` workflow:

- inspect status, diff, staged diff, HEAD, and recent commit style;
- classify files as TASK, PRE-EXISTING, or AMBIGUOUS;
- stage only reviewed TASK paths, never broad `git add .` or `git add -A`;
- scan staged content for secrets, conflict markers, and unrelated artifacts;
- recheck HEAD and the staged tree immediately before committing;
- create a local commit such as `feat: add android app builder skill`;
- never push, reset unrelated work, or rewrite history.

## Final report format

For an Android app task, report concisely:

```text
Android app: PASS / FAIL / PARTIALLY DONE
Project: <absolute path>
Package: <application ID>
Build: <command and observed result>
APK: <absolute dist\app-debug.apk path or NOT BUILT>
Device smoke test: PASS / NOT AVAILABLE / FAIL
Remaining issues: <real issues only or None>
```

For changes to this Skill, also report the skill path, discovery result, shared-agent
test command/result, Android toolchain status, and local commit hash. Never include
credentials or secret values in the report.
