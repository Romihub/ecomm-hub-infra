pipeline {
    agent any
    
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select Terraform action')
    }
    
    environment {
        TERRAFORM_DIR = 'Infrastructure-app-terraform/environments/dev'
        AZURE = credentials('aks-cred')
    }
    
    stages {
        stage('Checkout Infrastructure') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Romihub/ecomm-hub-infra.git',
                        credentialsId: 'github'
                    ]]
                ])
            }
        }
        
        stage('Terraform Operations') {
            steps {
                withCredentials([azureServicePrincipal('aks-cred')]) {
                    dir(TERRAFORM_DIR) {
                        script {
                            // Set Azure credentials for all Terraform operations
                            def azureEnv = """
                                export ARM_CLIENT_ID=\${AZURE_CLIENT_ID}
                                export ARM_CLIENT_SECRET=\${AZURE_CLIENT_SECRET}
                                export ARM_SUBSCRIPTION_ID=\${AZURE_SUBSCRIPTION_ID}
                                export ARM_TENANT_ID=\${AZURE_TENANT_ID}
                            """
                            
                            // Terraform Init
                            stage('Terraform Init') {
                                sh """
                                    ${azureEnv}
                                    terraform init
                                """
                            }
                            
                            if (params.ACTION == 'destroy') {
                                // Terraform Destroy
                                stage('Terraform Destroy') {
                                    sh """
                                        ${azureEnv}
                                        terraform plan -destroy -out=tfplan
                                        terraform apply -auto-approve tfplan
                                    """
                                }
                            } else {
                                // Terraform Plan
                                stage('Terraform Plan') {
                                    sh """
                                        ${azureEnv}
                                        terraform plan -out=tfplan
                                    """
                                }
                                
                                // Terraform Apply
                                stage('Terraform Apply') {
                                    //sh """
                                        //${azureEnv}
                                        //terraform apply -auto-approve tfplan
                                    //"""
                                    sh "ls -lrth"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            sh '''
                # Logout from Azure
                #az logout
                
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