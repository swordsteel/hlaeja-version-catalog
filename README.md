# Hlæja Version Catalog.

A Version Catalog in Gradle is a centralized way to manage and reference dependency versions across multiple projects, reducing duplication and ensuring consistency in dependency management. It simplifies the process of updating dependencies by maintaining a single source of truth for versions.

## Releasing version catalog.

Run `release.sh` script from `master` branch.

## Publishing version catalog.

### Publish version catalog locally.

```shell
./gradlew clean publishToMavenLocal
```

### Publish version catalog to repository.

```shell
./gradlew clean publish
```

### Global gradle properties.

To authenticate with Gradle to access repositories that require authentication, you can set your user and token in the `gradle.properties` file. 

Here's how you can do it:

1. Open or create the `gradle.properties` file in your Gradle user home directory:
    - On Unix-like systems (Linux, macOS), this directory is typically `~/.gradle/`.
    - On Windows, this directory is typically `C:\Users\<YourUsername>\.gradle\`.
2. Add the following lines to the `gradle.properties` file:
    ```properties
    repository.user=your_user
    repository.token=your_token_value
    ```
    or use environment variables `REPOSITORY_USER` and `REPOSITORY_TOKEN`
