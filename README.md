# Hello World — CI/CD with Jenkins, Docker and GitHub

Lab demo: **Demonstrate Continuous Integration and Continuous Delivery using a
Jenkins Pipeline.**

The pipeline checks the source out of GitHub, compiles the Java program, runs a
test, builds a Docker image and finally runs the container.

**Repository:** https://github.com/Harshavardhan1636/hello-world-jenkins

## Files

| File | Purpose |
|------|---------|
| `HelloWorld.java` | The Java sample program |
| `Jenkinsfile` | Declarative Pipeline: Checkout → Build → Test → Docker Build → Deploy |
| `Dockerfile` | Multi-stage image: build with JDK 21, run with JRE 21 (Alpine) |
| `.gitignore` | Keeps compiled `.class` files out of Git |
| `README.md` | This guide |

## Expected output

```
Hello, World!
CI/CD demo: Jenkins -> GitHub -> Docker
```

---

## 1. Run the Java program locally (Windows / PowerShell)

```powershell
cd D:\devops_lab_external\hello-world-jenkins
javac HelloWorld.java
java HelloWorld
```

## 2. Start Docker Desktop and verify

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

## 4. Push the project to GitHub

```powershell
cd D:\devops_lab_external\hello-world-jenkins
git init -b main
git config user.name "Harshavardhan1636"
git config user.email "Harshavardhan1636@users.noreply.github.com"
git add .
git commit -m "Hello World CI/CD demo: Jenkins Pipeline + Docker"
git remote add origin https://github.com/Harshavardhan1636/hello-world-jenkins.git
git push -u origin main
```

If the repository does not exist yet, create it first with the GitHub CLI:

```powershell
gh repo create hello-world-jenkins --public --source=. --remote=origin --push
```

## 5. Open Jenkins

This lab already runs Jenkins in a container at **http://localhost:8080**
(the built-in agent has `javac`, `git` and the Docker CLI with the socket mounted).

If you need to start it yourself:

```powershell
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 `
  -v //var/run/docker.sock:/var/run/docker.sock `
  -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

Unlock it once with the value from:

```powershell
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## 6. Create and run the Pipeline job (CLI)

```powershell
curl.exe -o "$env:TEMP\jenkins-cli.jar" http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar "$env:TEMP\jenkins-cli.jar" -s http://localhost:8080 create-job hello-world-jenkins < config.xml
java -jar "$env:TEMP\jenkins-cli.jar" -s http://localhost:8080 build hello-world-jenkins -f -v
```

`config.xml` (Pipeline script from SCM):

```xml
<flow-definition plugin="workflow-job">
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps">
    <scm class="hudson.plugins.git.GitSCM" plugin="git">
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/Harshavardhan1636/hello-world-jenkins.git</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec><name>*/main</name></hudson.plugins.git.BranchSpec>
      </branches>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
</flow-definition>
```

Or create it in the UI: **New Item → Pipeline → Pipeline script from SCM → Git**,
paste the repository URL, branch `*/main`, script path `Jenkinsfile`, then **Build Now**.

## 7. View the result

```powershell
# Console output of the last build (browser)
Start-Process "http://localhost:8080/job/hello-world-jenkins/lastBuild/console"

# Or pull it with PowerShell
Invoke-RestMethod "http://localhost:8080/job/hello-world-jenkins/lastBuild/consoleText"

# Verify the image built by Jenkins
docker images hello-world-jenkins
docker run --rm hello-world-jenkins:latest
```

---

## Note on the exam Jenkinsfile

The version written in the exam was missing closing braces and had `steps`
without a block. This corrected, working version is committed as `Jenkinsfile`.
On a Windows Jenkins agent replace the `sh '...'` steps with `bat '...'`.
