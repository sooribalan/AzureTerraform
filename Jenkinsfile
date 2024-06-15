pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        // Define environment variables for Terraform and Azure
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
    }

    stages {
         stage('Install Terraform') {
            steps {
                script {
                    sh '''
                    #!/bin/bash
                    TERRA_VERSION="1.8.5" # Replace with desired Terraform version
                    if ! [ -x "$(command -v terraform)" ]; then
                        echo 'Terraform is not installed, installing now...'
                        wget https://releases.hashicorp.com/terraform/${TERRA_VERSION}/terraform_${TERRA_VERSION}_linux_amd64.zip
                        unzip terraform_${TERRA_VERSION}_linux_amd64.zip
                        sudo mv terraform /usr/local/bin/
                        terraform -version
                    else
                        echo 'Terraform is already installed.'
                        terraform -version
                    fi
                    '''
                }
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/sooribalan/AzureTerraform.git'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Plan') {
            steps {
                sh 'terraform plan -out tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Apply / Destroy') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh 'terraform ${action} -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        sh 'terraform ${action} --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }

    }
}