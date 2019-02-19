# Sonarqube Scanner CLI container
Docker container image for use in build servers such as Jenkins to execute code quality scans using Sonarqube scanner.

This container provides the following standard commands:
 * sonar-scanner
 * sonar-scanner-debug

## Usage PR analysis
Setup your CI pipeline with the following command to execute in this container:
```bash
sonar-scanner -D sonar.host.url=<URL> \ 
              -D sonar.projectKey=<SONAR_PROJECT_KEY> \
              -D sonar.pullrequest.branch=<BRANCH_NAME> \
              -D sonar.pullrequest.key=<PR_ID> \
              -D sonar.pullrequest.base=<TARGET_BRANCH_FOR_PR>\
              -D sonar.projectVersion=<SCM_HASH/ID>
```

Alteratively use a `sonar-project.properties` file stored in git replacing URL, Branch and PR details using a replace tokens step.

>Note: Depending on your version of Sonarqube you can also configure the scanner to compare branches which will require a Developer Edition at minimum.

## Sample Jenkinsfile
Below you will find a sample configuration that can be used in a pipeline scripted jenkins setup to automate testing and deployment using this Docker CI image.


```groovy
pipeline {
    agent { 
        docker { 
            image 'curlybracket/sonar-scanner:latest' 
            args '-u root'
        }
    }
    stages {
		stage('Codequality') {
			
            steps {
                sh '''sonar-scanner -D sonar.host.url=<URL> \\
                                  -D sonar.projectKey=<SONAR_PROJECT_KEY> \\
                                  -D sonar.pullrequest.branch=<BRANCH_NAME> \\
                                  -D sonar.pullrequest.key=<PR_ID> \\
                                  -D sonar.pullrequest.base=<TARGET_BRANCH_FOR_PR> \\
                                  -D sonar.projectVersion=<SCM_HASH/ID>'''
			}
        }
    }
}
```
