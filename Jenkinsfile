pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Getting source code'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building application'
                bat 'javac HelloWorld.java'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing application'
                bat 'java HelloWorld'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image'
                bat 'docker build -t hello-world-jenkins:latest .'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application'
                bat 'docker run --rm hello-world-jenkins:latest'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
    }
}
