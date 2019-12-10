node {
    def imageName = 'ldudek/app:1.0.0'
    def tag = 'localhost:5000/my-app'
    def serverIP = ''
    def dockerRegistryIP = '18.130.199.0'

    stage('Git checkout'){
        git credentialsId: 'ab374df5-aa7f-4986-99ca-29347cb0a646', url: 'https://github.com/Yurati/CI_CD'
    }
    
    stage('Gradle package'){
        def gradleHome = tool name: 'Gradle', type: 'gradle'
        def gradleCMD = "${gradleHome}/bin/gradle"
        sh "${gradleCMD} build"
        sh "${gradleCMD} unpack"
    }
    
    stage('Build Docker image'){
        sh "docker build -t ${imageName} ."
    }
    
    stage('Image push'){
        sh "docker tag ${imageName} ${tag}"
        sh "docker push ${tag}"
    }
    
    stage('Deploy approval'){
        timeout(time: 15, unit: "MINUTES") {
            input message: 'Deploy app to dev?', ok: 'Yes'
        }
    }
    
    stage('Run container on dev server'){
        def dockerRun = "docker run -p 8080:8080 -d --name App ${dockerRegistryIP}:5000/my-app"
        sshagent(['dev-server']) {
            sh "ssh -o StrictHostKeyChecking=no ec2-user@${serverIP} ${dockerRun}"
        }
    }
}