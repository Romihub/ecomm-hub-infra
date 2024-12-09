pipeline {
    agent any
    
    environment {
        TERRAFORM_DIR = 'Infrastructure-app-terraform/environments/dev'
        AZURE_CREDS = credentials('azure-cred')
    }
    
    stages {
        stage('Checkout Infrastructure') {
            steps {
                git url: 'https://github.com/Romihub/ecomm-hub-infra.git',
                    branch: 'master'
            }
        }

        stage('Azure Login') {
            steps {
                withCredentials([azureServicePrincipal('azure-cred')]) {
                    sh '''
                        az login --service-principal \
                            --username $AZURE_CLIENT_ID \
                            --password $AZURE_CLIENT_SECRET \
                            --tenant $AZURE_TENANT_ID
                        
                        az account set --subscription $AZURE_SUBSCRIPTION_ID
                        
                        # Verify login
                        az account show
                    '''
                }
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir(TERRAFORM_DIR) {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir(TERRAFORM_DIR) {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir(TERRAFORM_DIR) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
    
    post {
        always {
            sh '''
                # Logout from Azure
                az logout
                
                # Clear Azure CLI cache
                rm -rf ~/.azure
            '''
            cleanWs()
        }
        success {
            echo 'Infrastructure deployment successful!'
        }
        failure {
            echo 'Infrastructure deployment failed!'
        }
    }
}