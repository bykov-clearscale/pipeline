pipeline {
    agent {
        node {
            label 'master'
        }
    }
environment {
		TERRAFORM_VERSION="0.11.7"
        TERRAFORM_CMD = 'docker run --network host -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v $(pwd)/${params.terraform_path}:/app -e TF_LOG=INFO -e TF_LOG_PATH=terraform.log hashicorp/terraform:$TERRAFORM_VERSION'
        TFLINT_CMD = 'docker run --rm -v $(pwd)/${params.terraform_path}:/data -t wata727/tflint'
        AWS_REGION = "us-west-2"
        S3_BUCKET = "revinate-terraform-logs"
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
                    docker pull hashicorp/terraform:$TERRAFORM_VERSION
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
        stage('select workspace') {
        	steps {
        		sh """
        		   ${TERRAFORM_CMD} workspace select ${params.env}
        		   """
        	}
        }
        stage('plan') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} plan -out=${params.project_name}-tfplan-${BUILD_ID}.json -input=false -parallelism=50
                    """
            }
        }
        stage('verify') {
        	steps {
        		sh """
        		   ${TFLINT_CMD} ${TERRAFORM_CONFIGS}/
        		   """
                script {
                  timeout(time: 10, unit: 'MINUTES') {	
                    input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                  }
                }
        	}
        }
        stage('apply') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} apply -lock=false -input=false ${params.project_name}-tfplan-${BUILD_ID}.json
                    """
			}
        }
        stage('upload logs') {
        	steps {
        		s3Upload(bucket:"${S3_BUCKET}", path:"${params.project_name}/${BUILD_ID}/${params.project_name}-tfplan-${BUILD_ID}.json", file:"${params.terraform_path}/${params.project_name}-tfplan-${BUILD_ID}.json")
        		s3Upload(bucket:"${S3_BUCKET}", path:"${params.project_name}/${BUILD_ID}/terraform.log", file:"${params.terraform_path}/terraform.log")
        	}
        }
    }
}
