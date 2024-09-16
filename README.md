# Cupertino Clock

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason][mason_badge]][mason_link]
[![License: MIT][license_badge]][license_link]

An analog clock that looks and feels the same as iPhone's analog clock from Standby Mode.

## Installation 💻

**❗ In order to start using Cupertino Clock, you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
dart pub add cupertino_clock
```

---

## Features 🚀

Cupertino Clock offers a Cupertino-style analog clock widget for Flutter applications. It's designed to seamlessly integrate with both iOS and Android platforms, providing a stylish and functional time display option.

- **Configurable Time Zones**
- **Customizable Sizes**
- **ONLY Dark Mode Compatibility**

---

## Continuous Integration 🤖

Cupertino Clock comes with built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link], but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using [Very Good Coverage][very_good_coverage_link].

---

## Running Tests 🧪

For first time users, install the [very_good_cli][very_good_cli_link]:

```sh
dart pub global activate very_good_cli
```

To run all unit tests:

```sh
very_good test --coverage
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov):

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

## Usage Example 📝

Here's a quick example to get you started with Cupertino Clock:

```dart
import 'package:flutter/material.dart';
import 'package:cupertino_clock/cupertino_clock.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: CupertinoClock.round(
            size: 300,
            location: 'America/New_York',
          ),
        ),
      ),
    ),
  );
}
```

## License 📄

Cupertino Clock is available under the MIT license. See the LICENSE file for more info.

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[mason_badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge
[mason_link]: https://github.com/felangel/mason
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
