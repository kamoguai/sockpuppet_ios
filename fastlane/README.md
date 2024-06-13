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

### ios syncCertificates

```sh
[bundle exec] fastlane ios syncCertificates
```

dowload certificates from the git

### ios connectByAPI

```sh
[bundle exec] fastlane ios connectByAPI
```

Connect App Store connect by API

### ios archive

```sh
[bundle exec] fastlane ios archive
```

Build and archive APP

### ios update_names

```sh
[bundle exec] fastlane ios update_names
```

Update Bundle Name and App Name

### ios gama

```sh
[bundle exec] fastlane ios gama
```

Deploy to TestFlight with updated names and icons

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



### ios release_beta

```sh
[bundle exec] fastlane ios release_beta
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
