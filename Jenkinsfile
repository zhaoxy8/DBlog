pipeline {
    agent any
    environment {
        uid = "${env.JOB_NAME}-${currentBuild.id}"
    }
    tools {
        maven 'maven-3.6.3'
    }
    parameters {
        string(
            name: 'version',
            defaultValue: 'blog-web-2.2.0.Beta.jar',
            description: 'version'
            )
        choice(
            name: 'helm_env',
            choices: 'bixby_dev_helm',
            description: 'helm env'
            )
        choice(
            name: 'helm_chart',
            choices: 'oneblog',
            description: 'A Helm chart'
            )
    }
    
    stages {
        stage('Prepare') {
            steps {
                echo """version : ${params.version}
                helm_env : ${params.helm_env}
                helm_chart : ${params.helm_chart}
                uid: ${uid}
                """
            }
        }
        
        stage('get clone'){
            steps {
                git credentialsId: 'zhaoxy8 (github)', url: 'https://github.com/zhaoxy8/DBlog.git'
            }
        }
        
        stage('mvn build'){
            steps {
                sh "mvn clean install -Dmaven.test.skip=true"
            }
        }

        stage('SonarQube analysis') {
            steps {
                sh 'echo "pass"'
            }
        }

        stage('archive'){
            steps {
                echo "pipeline success!" 
                archiveArtifacts 'blog-web/target/*.jar' 
            }
        
        }
    }
}
