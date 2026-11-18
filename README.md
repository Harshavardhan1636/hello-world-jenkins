# Hello World — CI/CD with Jenkins, Docker and GitHub

Lab demo: **Demonstrate Continuous Integration and Continuous Delivery using a
Jenkins Pipeline.**

The pipeline checks the source out of GitHub, compiles the Java program, runs a
test, builds a Docker image and finally runs the container.

## Files

| File | Purpose |
|------|---------|
| `HelloWorld.java` | The Java sample program |
| `Jenkinsfile` | Declarative Jenkins Pipeline (Checkout → Build → Test → Docker Build → Deploy) |
| `Dockerfile` | Multi-stage image: build with JDK 21, run with JRE 21 (Alpine) |
| `.gitignore` | Keeps compiled `.class` files out of Git |
| `README.md` | This guide |

## Expected output

```
Hello, World!
CI/CD demo: Jenkins -> GitHub -> Docker
```

---

## 1. Run the Java program locally

```powershell
cd D:\devops_lab_external\hello-world-jenkins
javac HelloWorld.java
java HelloWorld
```

## 2. Start Docker Desktop (Windows) and verify

```powershell
Start-Process "$env:LOCALAPPDATA\Programs\DockerDesktop\Docker Desktop.exe" -WindowStyle Hidden
docker info
```

## 3. Build and run the Docker image

```powershell
docker build -t hello-world-jenkins:latest .
docker run --rm hello-world-jenkins:latest
docker images hello-world-jenkins
```

Linux/macOS equivalent (use `sh` instead of `bat` in the Jenkinsfile on Linux):

```bash
docker build -t hello-world-jenkins:latest .
docker run --rm hello-world-jenkins:latest
```

## 4. Push the project to GitHub

```powershell
cd D:\devops_lab_external\hello-world-jenkins
git init -b main
git config user.name "Harshavardhan1636"
git config user.email "Harshavardhan1636@users.noreply.github.com"
git add .
git commit -m "Hello World CI/CD demo: Jenkins Pipeline + Docker"
gh repo create hello-world-jenkins --public --source=. --remote=origin --push
```

If the repository already exists, use:

```powershell
git remote add origin https://github.com/Harshavardhan1636/hello-world-jenkins.git
git push -u origin main
```

## 5. Start Jenkins (WAR file, no installer needed)

```powershell
# Download once
curl.exe -L -o "$env:TEMP\jenkins.war" https://get.jenkins.io/war-stable/latest/jenkins.war

# Start Jenkins (setup wizard skipped for a clean lab run)
java -Djenkins.install.runSetupWizard=false -jar "$env:TEMP\jenkins.war" --httpPort=8080
```

Open **http://localhost:8080** in a browser.

Create the job:

1. **New Item** → name it `hello-world-jenkins` → select **Pipeline** → OK.
2. Under **Pipeline**, set *Definition* to **Pipeline script from SCM**.
3. SCM = **Git**, Repository URL =
   `https://github.com/Harshavardhan1636/hello-world-jenkins.git`, Branch = `*/main`.
4. Script Path = `Jenkinsfile`. Save.
5. Click **Build Now**, then open **Console Output** to see all stages.

## 6. Run the pipeline from the command line (alternative)

```powershell
curl.exe -o jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080 build hello-world-jenkins -f -v
```

> On a Linux Jenkins agent replace the `bat '...'` steps in `Jenkinsfile` with
> `sh '...'`.

---

## Note on the exam Jenkinsfile

The version written in the exam was missing closing braces and had `steps`
without a block. This corrected, working version is committed as `Jenkinsfile`:

```groovy
pipeline {
    agent any
    stages {
        stage('Checkout')   { steps { echo 'Getting source code'; checkout scm } }
        stage('Build')      { steps { echo 'Building application'; bat 'javac HelloWorld.java' } }
        stage('Test')       { steps { echo 'Testing application'; bat 'java HelloWorld' } }
        stage('Docker Build'){ steps { echo 'Building Docker image'; bat 'docker build -t hello-world-jenkins:latest .' } }
        stage('Deploy')     { steps { echo 'Deploying application'; bat 'docker run --rm hello-world-jenkins:latest' } }
    }
}
```
