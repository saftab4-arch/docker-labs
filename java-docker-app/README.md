# Project 03 - Java Dockerization

## Overview

This project demonstrates how to containerize a simple Java application using Docker.

The application prints a message to the console and exits successfully.

---

## Project Structure

```text
.
├── HelloWorld.java
├── Dockerfile
└── README.md
```

---

## Java Source Code

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello from Dockerized Java Application!");
    }
}
```

---

## Compile Application

```bash
javac HelloWorld.java
```

Generated file:

```text
HelloWorld.class
```

---

## Run Application

```bash
java HelloWorld
```

Expected Output:

```text
Hello from Dockerized Java Application!
```

---

## Dockerfile

```dockerfile
FROM eclipse-temurin:25-jdk

WORKDIR /app

COPY HelloWorld.java .

RUN javac HelloWorld.java

CMD ["java", "HelloWorld"]
```

---

## Build Docker Image

```bash
docker build -t java-demo:v1 .
```

Verify image:

```bash
docker images
```

---

## Run Container

```bash
docker run --name java-container java-demo:v1
```

Expected Output:

```text
Hello from Dockerized Java Application!
```

---

## Verify Container Status

```bash
docker ps -a
```

Example:

```text
java-container    Exited (0)
```

Exit code 0 indicates successful execution.

---

## Skills Demonstrated

- Java Compilation
- JVM Execution
- Docker Image Creation
- Dockerfile Development
- Container Lifecycle Management
- Java Application Containerization

---

## Author

Syed Aftab

Cloud / DevOps Engineering Portfolio Project
