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
     stage('deploy to k8s'){
         steps{
          sh "chmod +x tag.sh"
          sh "./tag.sh ${DOCKER_TAG}"
          sshagent(['kops']) {
             sh "scp -o StrictHostKeyChecking=no service.yml my-app-pod.yml ubuntu@ip-172-31-13-254:/home/ubuntu/"
              script{
                  try{
                      sh "ssh ubuntu@ip-172-31-13-254 kubectl apply -f ."
                  }
                  catch(error){
                      sh "ssh ubuntu@ip-172-31-13-254 kubectl create -f ."
                  }
                      
              }
          
           }
        }
            
    }
}

def getVersion(){
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
