pipeline {
    agent {
        node {
            label 'master'
        }
    }
environment {
        PACKER_VERSION="1.2.4"
        PACKER_CMD = 'docker run --rm hashicorp/packer:$PACKER_VERSION'
    }
    stages {
        stage('checkout repo') {
            steps {
              checkout scm
            }
        }
        stage('Validate') {
          steps {
            print "Running packer validate on : ${params.packer_file}"
            sh "packer -v ; packer validate ${packer_file}"
          }
        }
        stage('Build') {
          steps {
            AMI=sh(returnStdout: true, "packer build -var 'vpc_id=${params.vpc_id}' -var 'subnet_id={params.subnet_id}' packer.json")
            echo $AMI
          }
        }
        
    }
}
