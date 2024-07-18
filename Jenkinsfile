pipeline {
    agent any
    // environment {
    //     // Define AWS credentials from Jenkins credentials store
    //     AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    //     AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    // }

    stages {
        stage('Clone Repository') {
            steps {
                // Clean workspace before cloning
                deleteDir()

                // Clone the repository from GitHub
                // git url: REPO_URL
                git branch: 'main', credentialsId: 'GITHUB', url: 'https://github.com/shivakumar-darapu/vault-backup-copy-to-s3/'
            }
        }

        stage('Substitute AWS Credentials') {
            steps {
                script {
                    // Retrieve AWS credentials from Jenkins credentials store
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        // Replace AWS credentials in the script
                        def SCRIPT_NAME = params.SCRIPT_NAME
                        def AWS_DEFAULT_REGION = params.AWS_DEFAULT_REGION
                        def filePath = params.FILE_PATH
                        def FILE_PATH = params.FILE_PATH
                        def BUCKET_NAME = params.BUCKET_NAME
                        def AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
                        def AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                        
                        def ant = new AntBuilder()
                        // Perform replacement in-place
                        ant.replace(file: SCRIPT_NAME, token: 'FILE_PATH_PLACEHOLDER', value: filePath)
                        sh('cat ./${SCRIPT_NAME')
                        
                        sh('echo AWS_ACCESS_KEY_ID : ${AWS_ACCESS_KEY_ID}')
                        sh('echo AWS_SECRET_ACCESS_KEY : ${AWS_SECRET_ACCESS_KEY}')
                        sh "echo 'SCRIPT_NAME : $SCRIPT_NAME'"
                        sh "echo 'AWS_DEFAULT_REGION : $AWS_DEFAULT_REGION'"
                        sh "echo 'FILE_PATH : $filePath'"
                        sh "echo 'BUCKET_NAME : $BUCKET_NAME'"
                        sh '''
                            sed -i "s/AWS_ACCESS_KEY_ID_PLACEHOLDER/'"${AWS_ACCESS_KEY_ID}"'/g" ./${SCRIPT_NAME}
                        '''
                        // sh '''
                        //     sed -i "s/AWS_SECRET_ACCESS_KEY_PLACEHOLDER/'"${AWS_SECRET_ACCESS_KEY}"'/g" ./${SCRIPT_NAME}
                        // '''
                        sh('sed -i s/AWS_DEFAULT_REGION_PLACEHOLDER/${AWS_DEFAULT_REGION}/g ./\${SCRIPT_NAME}')
                        // sh ('sed -i s/FILE_PATH_PLACEHOLDER/${FILE_PATH}/g ./\${SCRIPT_NAME}')
                        // sh '''
                        //     sed -i '"s|FILE_PATH_PLACEHOLDER|'"${FILE_PATH}"'|g"' ./${SCRIPT_NAME}
                        // '''
                        
                        sh ('sed -i s/BUCKET_NAME_PLACEHOLDER/${params.BUCKET_NAME}/g ./\${SCRIPT_NAME}')
                    }
                }
            }
        }

        stage('Copy Script to Remote Server') {
            steps {
                // Copy the modified script to the remote server using SSH
                sshagent([params.CREDS]) {
                    sh "scp ./\${SCRIPT_NAME} \${USERNAME}@\${REMOTE_HOST}:\${REMOTE_PATH}/"
                }
            }
        }

        stage('Run Script on Remote Server') {
            steps {
                // Execute the script on the remote server using SSH
                sshagent([params.CREDS]) {
                    sh "ssh \${USERNAME}@\${REMOTE_HOST} 'cd \${REMOTE_PATH} && ./\${SCRIPT_NAME}'"
                }
            }
        }
    }
}
