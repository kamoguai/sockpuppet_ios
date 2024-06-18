fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Push a new beta build to TestFlight

### ios build_and_sign

```sh
[bundle exec] fastlane ios build_and_sign
```



### ios tests

```sh
[bundle exec] fastlane ios tests
```



### ios archive

```sh
[bundle exec] fastlane ios archive
```

Build and archive APP

### ios hello

```sh
[bundle exec] fastlane ios hello
```

response echo

### ios gama

```sh
[bundle exec] fastlane ios gama
```

Deploy to TestFlight with updated names

### ios download_development_certificates

```sh
[bundle exec] fastlane ios download_development_certificates
```

Download Development Certificates And Profiles

### ios download_distribution_certificates

```sh
[bundle exec] fastlane ios download_distribution_certificates
```

Download Distribution Certificates And Profiles

### ios dev_beta

```sh
[bundle exec] fastlane ios dev_beta
```

build dev

### ios release_beta

```sh
[bundle exec] fastlane ios release_beta
```

release to app-store

### ios replace_icons

```sh
[bundle exec] fastlane ios replace_icons
```

replace appIcon & splash icon 

### ios release_testing

```sh
[bundle exec] fastlane ios release_testing
```

Release Testing: Build and distribute the app for testing

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
