pipeline {
    agent any

    environment {
        // Define environment variables for Terraform and Azure
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
    }

    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select action to perform')
        booleanParam(name: 'AUTO_APPROVE', defaultValue: false, description: 'Automatically approve apply and destroy actions')
    }

    stages {
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
            when {
                expression {
                    return params.ACTION == 'plan'
                }
            }
            steps {
                sh 'terraform plan -out tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
                script {
                    def plan = readFile 'tfplan.txt'
                    echo plan
                }
            }
        }
        stage('Apply / Destroy') {
            when {
                expression {
                    return params.ACTION == 'apply' || params.ACTION == 'destroy'
                }
            }
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        if (!params.AUTO_APPROVE) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh 'terraform apply -input=false tfplan'
                    } else if (params.ACTION == 'destroy') {
                        sh 'terraform destroy --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "Terraform ${params.ACTION} succeeded."
        }
        failure {
            echo "Terraform ${params.ACTION} failed."
        }
    }
}
