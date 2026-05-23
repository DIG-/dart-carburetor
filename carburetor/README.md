# Carburetor

[![pub.dev](https://img.shields.io/pub/v/carburetor?logo=dart&logoColor=white)](https://pub.dev/packages/carburetor)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Dart SDK](https://img.shields.io/badge/Dart-%5E3.7.0-blue?logo=dart)](https://dart.dev)

**Carburetor is a dependency injection library for Dart — nothing more, nothing less.** It does not manage state, handle navigation, or provide any other framework-level concerns. Its single responsibility is to wire up your object graph in a clean, type-safe, and efficient way, using code generation to resolve all dependencies at build time with zero runtime reflection.

## Features

- **Annotation-based** — declare dependencies directly on your classes
- **Code generation** — zero runtime overhead, all wiring is resolved at build time
- **Singleton support** — lazy, eager, and weak-reference singletons
- **Async support** — first-class `Future`-based providers and singletons
- **Module system** — organize and access your dependency graph through typed modules
- **Null-safe & type-safe** — built for modern Dart

## Installation

```bash
dart pub add carburetor
dart pub add --dev carburetor_build build_runner
```

### Versioning

Carburetor follows a `x.y.z-w` versioning scheme:

| Segment | Meaning |
|---|---|
| `x` | Major — breaking API changes |
| `y` | Minor — new features, backwards-compatible |
| `z` | Patch — bug fixes |
| `w` | Build — no API changes; bumped solely to widen the supported version range of transitive dependencies |

The `w` segment allows the library to remain compatible with a broader ecosystem without introducing any functional change. If you are experiencing dependency conflicts, check whether a newer `w` release is available before overriding constraints manually.

## Quick Start

### 1. Annotate your classes

Use `@Provide()` for regular instances and `@Singleton()` for singletons:

```dart
import 'package:carburetor/provide.dart';

@Provide()
class UserRepository {
  final ApiClient client;
  const UserRepository(this.client);
}

@Singleton()
class ApiClient {
  const ApiClient();
}
```

### 2. Create a Module

Declare a module class with `@Module()` and extend `CarburetorModule`:

```dart
import 'package:carburetor/module.dart';
import 'my_module.carburetor.dart'; // generated file

@Module()
class MyModule extends CarburetorModule with $MyModuleImplementation {
  static final instance = MyModule();
}
```

### 3. Run the code generator

```bash
dart run build_runner build
```

This generates the `*.carburetor.dart` file with all the wiring code.

### 4. Use your dependencies

```dart
void main() {
  final repo = MyModule.instance.get<UserRepository>();
}
```

---

## Annotations Reference

| Annotation | Description |
|---|---|
| `@Provide()` | Creates a new instance every time it is requested |
| `@Provide.async()` | Same as `@Provide()`, but the factory is `async` |
| `@Singleton()` | Single instance, created lazily by default |
| `@Singleton(lazy: false)` | Single instance, created eagerly at module initialization |
| `@Singleton(weak: true)` | Singleton held via a `WeakReference` — can be garbage collected |
| `@Singleton.async()` | Async singleton, resolved lazily |
| `@Singleton.async(lazy: false)` | Async singleton, resolved eagerly |
| `@Singleton.async(weak: true)` | Async singleton held via a `WeakReference` |
| `@Module()` | Marks a class as a dependency module |

## Async Dependencies

Carburetor supports `async` providers and singletons out of the box. Use `getAsync<T>()` to resolve them:

```dart
@Provide.async()
class SettingsService {
  final RemoteConfig config;
  const SettingsService(this.config);
}

@Singleton.async()
class RemoteConfig {
  const RemoteConfig();
}

// Resolve:
final settings = await MyModule.instance.getAsync<SettingsService>();
```

## Migration Utility

`CarburetorDynamicModule` is a wrapper that helps you migrate incrementally from a runtime dependency injection system to Carburetor's build-time approach.

During migration, some dependencies may not yet be registered in a Carburetor-generated module. `CarburetorDynamicModule` lets you provide those dependencies at runtime by calling `set`, while all already-migrated dependencies are resolved normally through the underlying generated module. Once every dependency has been migrated, the wrapper can be removed and the generated module used directly.

```dart
import 'package:carburetor/dynamic.dart';

final dynamic = CarburetorDynamicModule(appModule);

// Provide a dependency that has not been migrated yet.
dynamic.set<LegacyService>(legacyServiceInstance);

// Resolved from the runtime override.
final legacy = dynamic.get<LegacyService>();

// Resolved by the underlying generated module.
final migrated = dynamic.get<MigratedService>();
```

Once all dependencies are migrated:

```dart
// Remove the wrapper and use the generated module directly.
final migrated = appModule.get<MigratedService>();
```

> `CarburetorDynamicModule` is also useful in tests to override specific dependencies without replacing the entire module.

## Roadmap

The following features are planned for future releases:

- **Deferred import support** — allow providers to be loaded lazily via Dart's deferred imports, reducing initial load time
- **Named constructor support** — resolve dependencies using constructors other than the default one
- **Inheritance-based injection** — declare a provider for a supertype and have it automatically injected wherever the supertype is required
- **Generic type injection** — support dependency resolution for generic classes (e.g. `Repository<User>` and `Repository<Product>` as distinct bindings)

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.
