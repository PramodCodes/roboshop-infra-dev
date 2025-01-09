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
        nexusURL = 'nexus.pka.in.net:8081'
    }
    //build stages
    
    stages {
        stage('VPC') {
            steps {
               sh """
                  echo 'creating VPC'
                  pwd
                  cd 01-vpc
                  pwd
                  terraform init -reconfigure
                  terraform apply -auto-approve
                  echo 'VPC created'
               """
            }
        }
        stage('SG') {
            steps {
               sh """
                  echo 'creating SG'
                  pwd
                  cd 02-sg
                  pwd
                  terraform init -reconfigure
                  terraform apply -auto-approve
                  echo 'SG created'
               """
            }
        }
        stage('03-vpn') {
            steps {
               sh """
                  echo 'creating 03-vpn'
                  pwd
                  cd 03-vpn
                  pwd
                  terraform init -reconfigure
                  terraform apply -auto-approve
                  echo 'VPN created'
               """
            }
        }
        stage('DB-ALB') {
            parallel{
                stage('04-databases') {
                    steps {
                    sh """
                        echo 'creating 04-databases'
                        pwd
                        cd 04-databases
                        pwd
                        terraform init -reconfigure
                        terraform apply -auto-approve
                        echo 'databases created'
                    """
                    }
                }
                stage('05-app-alb') {
                    steps {
                    sh """
                        echo 'creating 05-app-alb'
                        pwd
                        cd 05-app-alb
                        pwd
                        terraform init -reconfigure
                        terraform apply -auto-approve
                        echo 'app-alb created'
                    """
                    }
                }
                stage('06-catalogue') {
                    steps {
                    sh """
                        echo 'creating 06-catalogue'
                        cd 06-catalogue
                        pwd
                        terraform init -reconfigure
                        terraform apply -auto-approve
                        echo 'catalogue infra created'
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