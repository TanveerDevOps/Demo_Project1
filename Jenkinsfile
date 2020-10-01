pipeline{
    agent any
    environment {
      DOCKER_TAG = getVersion()
    }
    stages{
        stage('SCM'){
            steps{
                git credentialsId: 'git', 
                    url: 'https://github.com/TanveerDevOps/Demo_Project1'
            }
        }
    
        
    stage('Maven Build'){
            steps{
                sh "mvn clean package"
            }
        }    
    
    stage('Docker image build'){
            steps{
                sh "docker build . -t tanveerdevops/my-app:${DOCKER_TAG} "
            }
        }   
    
    stage('Docker image push'){
            steps{
                withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhubpass')]) {
                    sh "docker login -u tanveerdevops -p ${dockerhubpass} "
                }    
                sh "docker push tanveerdevops/my-app:${DOCKER_TAG} "
            }
        }    
    
    stage('deploy to dev server'){
            steps{
             ansiblePlaybook credentialsId: 'dev-server', disableHostKeyChecking: true, extras: "-e DOCKER_TAG=${DOCKER_TAG}", installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy.yml'
            }
        }    
        
    }
}

def getVersion(){
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
