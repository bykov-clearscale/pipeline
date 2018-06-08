pipeline {
    agent {
        node {
            label 'master'
        }
    }
environment {
		TERRAFORM_CONFIGS="terraform"
        TERRAFORM_CMD = 'docker run --network host -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v $(pwd)/$TERRAFORM_CONFIGS:/app -e TF_LOG=INFO -e TF_LOG_PATH=terraform.log hashicorp/terraform:light'
        TFLINT_CMD = 'docker run --rm -v $(pwd)/$TERRAFORM_CONFIGS:/data -t wata727/tflint'
    }
    stages {
        stage('checkout repo') {
            steps {
              checkout scm
            }
        }
        stage('pull latest light terraform image') {
            steps {
                sh  """
                    docker pull hashicorp/terraform:light
                    """
            }
        }
        stage('init') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} init -backend=true -input=false
                    """
            }
        }
        stage('workspace') {
        	steps {
        		sh """
        		   ${TERRAFORM_CMD} workspace select ${params.env}
        		   """
        	}
        }
        stage('plan') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} plan -out=tfplan.json -input=false -parallelism=50
                    """
                script {
                  timeout(time: 10, unit: 'MINUTES') {	
                    input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                  }
                }
            }
        }
        stage('verify') {
        	steps {
        		sh """
        		   
        		   """
        	}
        }
        stage('apply') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} apply -lock=false -input=false tfplan.json -parallelism=50
                    """
			}
        }
    }
}
