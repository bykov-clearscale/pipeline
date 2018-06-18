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
          print "Running packer validate on : ${params.packer_file}"
        }
      
      sh "packer -v ; packer validate ${packer_file}"

    stage 'Build'
      AMI=sh(returnStdout: true, "packer build ${packer_file}")
      echo $AMI
    }
}
