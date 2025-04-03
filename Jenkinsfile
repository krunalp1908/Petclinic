@Library('Shared') _
pipeline {
    agent any 
    
    tools{
        jdk 'jdk17'
        maven 'maven3'
    }
    
    environment {
        SCANNER_HOME=tool 'Sonar'
    }
    
    stages{
        
        stage("Git Checkout"){
            steps{
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/krunalp1908/Petclinic.git'
            }
        }
        
        stage("Compile"){
            steps{
                sh "mvn clean compile"
            }
        }
        
         stage("Test Cases"){
            steps{
                sh "mvn test"
            }
        }
        
        stage("Trivy: Filesystem scan"){
            steps{
                script{
                    trivy_scan()
                }
            }
        }
        
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('Sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Petclinic \
                    -Dsonar.projectKey=Petclinic \
                    -Dsonar.sources=. \
                    -Dsonar.java.binaries=target/classes
                     '''
    
                }
            }
        }
        
        stage("OWASP: Dependency check"){
            steps{
                script{
                    owasp_dependency()
                }
            }
        }
        
        stage("Build Artifact "){
            steps{
                sh "mvn clean install"
            }
        }
        
        stage("Docker: build images"){
            steps{
                script{
                    docker_build("petclinic-app","latest","krunalp19") 
                }
            }
        }

        
        stage("Docker: Push to DockerHub"){
            steps{
                script{
                    docker_push("petclinic-app","latest","krunalp19")
                }
            }
        }

        ''' docker run will not happen because this code is buiid for tomcat server. '''
        stage("Run docker image"){
            steps{
                sh "docker run -d -p 8082:8082 krunalp19/petclinic-app:latest"
            }
        }
    }
}
