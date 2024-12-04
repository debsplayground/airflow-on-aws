pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/debsplayground/airflow-on-aws.git'
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                echo "Checking for existing Terraform binary..."
                if [ -x "$(command -v terraform)" ]; then
                    echo "Removing existing Terraform binary..."
                    sudo rm -f /usr/local/bin/terraform
                fi
                echo "Installing Terraform..."
                curl -LO https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
                unzip -o terraform_1.5.0_linux_amd64.zip
                sudo mv terraform /usr/local/bin/
                terraform --version
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}