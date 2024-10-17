import java.lang.System.getenv

plugins {
    `version-catalog`
    `maven-publish`
}

description = "Hlæja Version Catalog"
group = "ltd.hlaeja.catalog"

catalog {
    versionCatalog {
        from(files("hlaeja.versions.toml"))
    }
}

publishing {
    repositories {

        fun retrieveConfiguration(
            property: String,
            environment: String,
        ): String? = project.findProperty(property)?.toString() ?: getenv(environment)

        maven {
            url = uri("https://maven.pkg.github.com/swordsteel/${project.name}")
            name = "GitHubPackages"
            credentials {
                username = retrieveConfiguration("repository.user", "REPOSITORY_USER")
                password = retrieveConfiguration("repository.token", "REPOSITORY_TOKEN")
            }
        }
    }
    publications {
        create<MavenPublication>(project.name) {
            groupId = "$group"
            artifactId = project.name
            version = version
            from(components["versionCatalog"])
        }
    }
}

tasks.register("clean") {
    group = "build"
    doLast {
        delete("${rootDir.path}/build")
        println("Default Cleaning!")
    }
}
