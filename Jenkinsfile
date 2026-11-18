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
                sh 'javac HelloWorld.java'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing application'
                sh 'java HelloWorld'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image'
                sh 'docker build -t hello-world-jenkins:latest .'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application'
                sh 'docker run --rm hello-world-jenkins:latest'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
    }
}
