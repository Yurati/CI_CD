node {
    def imageName = 'io/app:1.0.0'
    def tag = 'localhost:5000/my-app'
    def serverIP = '3.11.77.88'

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
        sh "docker rmi \$(docker images |grep 'localhost:5000/my-app\\|io/my-app')"
    }
    
    stage('Deploy approval'){
        timeout(time: 15, unit: "MINUTES") {
            input message: 'Deploy app to dev?', ok: 'Yes'
        }
    }
    
    stage('Run container on dev server'){
        def composePath = '/srv/io/docker-compose.yml'
        def dockerRun = "docker-compose -f ${composePath} up -d"
        sshagent(['dev-server']) {
            sh "ssh -o StrictHostKeyChecking=no ec2-user@${serverIP} ${dockerRun}"
        }
    }
}