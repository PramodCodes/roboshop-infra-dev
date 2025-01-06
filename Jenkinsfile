// Jenkinsfile (Declarative Pipeline) 
pipeline{
    agent {
        // run on the AGENT-1 node
        node {
            label 'AGENT-1'
        }
    }
    // parameters section, this section is used to define the parameters that can be used in the pipeline
    // define the environment variables canbe accesed globally ,the following are additional to existing environment variables
    // we use ansiColor plugin to print the logs in color
    options {
        ansiColor('xterm')
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
    }
    // we need to get version from the application for this we use pipeline, for this we will use pipeline utilities plugin
    // this can be used across pipeline
    environment {
        packageVersion = ''
        nexusURL = '172.31.92.207:8081'
    }
    //build stages
    
    stages {
        stage('VPC') {
            steps {
               sh """
                  echo 'creating VPC'
                  cd 01-vpc
                  terraform init -reconfigure
                  terraform apply -auto-approve
               """
            }
        }
        stage('SG') {
            steps {
               sh """
                  echo 'creating SG'
                  cd 02-sg
                  terraform init -reconfigure
                  terraform apply -auto-approve
               """
            }
        }
        stage('03-vpn') {
            steps {
               sh """
                  echo 'creating 03-vpn'
                  cd 03-vpn
                  terraform init -reconfigure
                  terraform apply -auto-approve
               """
            }
        }
        stage('DB-ALB') {
            parallel{
                stage('04-databases') {
                    steps {
                    sh """
                        echo 'creating 04-databases'
                        cd 04-databases
                        terraform init -reconfigure
                        terraform apply -auto-approve
                    """
                    }
                }
                stage('05-app-alb') {
                    steps {
                    sh """
                        echo 'creating 05-app-alb'
                        cd 05-app-alb
                        terraform init -reconfigure
                        terraform apply -auto-approve
                    """
                    }
                }
            }
        }
    }


    // post section
    post {
        always {
            echo 'This will always run irrespective of status of the pipeline'
            // you need to delete workspace after the build because we are using the same workspace for all the builds
            deleteDir()
        }
        failure {
            echo 'This will run only if the pipeline is failed, We use thsi for alerting the team' 
        }
        success {
            echo 'This will run only if the pipeline is successful'
        }
    }
}