node {
    def tag = 'localhost:5000/my-app'

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
        sh 'docker build -t ldudek/app:1.0.0 .'
    }
    
    stage('Image push'){
        withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHunPassword')]) {
            sh "docker login -u ldudek -p ${dockerHunPassword}"
        }
        sh "docker tag ldudek/app:1.0.0 ${tag}"
        sh "docker push ${tag}"
    }
    
    stage('Deploy approval'){
        timeout(time: 15, unit: "MINUTES") {
            input message: 'Deploy app to dev?', ok: 'Yes'
        }
    }
    
    stage('Run container on dev server'){
        def dockerRegistryIP = '18.130.193.246:5000'
        def dockerRun = "docker run -p 8080:8080 -d --name App ${dockerRegistryIP}/my-app"
        sshagent(['dev-server']) {
            sh "ssh -o StrictHostKeyChecking=no ec2-user@18.130.193.246 ${dockerRun}"
        }
    }
}