pipeline {
    agent any

    environment {
        TF_VAR_aws_access_key = credentials('AWS_ACCESS_KEY_ID')
        TF_VAR_aws_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Ansible Configuration') {
            steps {
                script {
                    sh 'ansible-playbook -i inventory.ini deploy_webserver.yml'
                }
            }
        }

        stage('Automated Tests') {
            steps {
                script {
                    // Run automated tests here (e.g., InSpec or Serverspec)
                    sh 'inspec exec tests/'
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deployment were successful!'
        }

        failure {
            echo 'Build or deployment failed. Please check the logs.'
        }
    }
}
