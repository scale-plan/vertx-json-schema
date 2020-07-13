## Vert.x JSON Schema for 3.9.x

This repo contains backport of Vert.x JSON Schema from version 4.x to version 3.9.x.

## Install

The artifact for this repo is hosted on Bintray. See: https://bintray.com/beta/#/scaleplan/maven/vertx-json-schema?tab=overview

### Gradle

Add ScalePlan Bintray repository to your `build.gradle`:
```groovy
repositories {
	maven {
		url  "https://dl.bintray.com/scaleplan/maven"
	}
}
```

Add dependency in `dependencies` section in  `build.gradle`:
```groovy
implementation 'net.scaleplan:vertx-json-schema:3.9.1'
```


### Maven

Put the following in `settings.xml` next to `pom.xml`:
```xml
<settings xmlns='http://maven.apache.org/SETTINGS/1.0.0' xsi:schemaLocation='http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
  <profiles>
    <profile>
      <repositories>
        <repository>
          <snapshots>
            <enabled>
              false
            </enabled>
          </snapshots>
          <id>
            bintray-scaleplan-maven
          </id>
          <name>
            bintray
          </name>
          <url>
            https://dl.bintray.com/scaleplan/maven
          </url>
        </repository>
      </repositories>
      <pluginRepositories>
        <pluginRepository>
          <snapshots>
            <enabled>
              false
            </enabled>
          </snapshots>
          <id>
            bintray-scaleplan-maven
          </id>
          <name>
            bintray-plugins
          </name>
          <url>
            https://dl.bintray.com/scaleplan/maven
          </url>
        </pluginRepository>
      </pluginRepositories>
      <id>
        bintray
      </id>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>
      bintray
    </activeProfile>
  </activeProfiles>
</settings>
```

Add the following in the `dependencies` section in `pom.xml`:
```xml
<dependency>
  <groupId>net.scaleplan</groupId>
  <artifactId>vertx-json-schema</artifactId>
  <version>3.9.1</version>
  <type>pom</type>
</dependency>
```

## Architecture

* `SchemaParser`: Parses the schemas. It can be used to parse various schemas. Every JSON Schema dialect/version has one
* `SchemaRouter`: Contains a cache of parsed schemas and resolve cached/local/external `$ref`. You can share it across various `SchemaParser`
* `Validator`: Contains validation logic for single/multiple keyword(s)
* `Schema`: Represents a schema and contains `Validator` instances
* `ValidatorFactory`: Represents a factory for a `Validator`

## How to use
````java
SchemaRouter router = SchemaRouter.create(vertx)
SchemaParserOptions options = new SchemaParserOptions();
SchemaParser parser = Draft7SchemaParser.create(options, router);
Schema schema = parser.parse(schema, scope);
Future validationResult = schema.validateAsync(objectToValidate);
````

Or shorthand

```java
Schema schema = Draft7SchemaParser.parse(vertx, schema, scope);
Future validationResult = schema.validateAsync(objectToValidate);
```

## Extend the validator
To support custom keywords, you can create a new `ValidatorFactory` and register to a `SchemaParser` with `SchemaParserOptions.putAdditionalValidatorFactory()`
