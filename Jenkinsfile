library(
    identifier: 'pipeline-lib@4.3.4',
    retriever: modernSCM([$class: 'GitSCMSource',
                          remote: 'https://github.com/SmartColumbusOS/pipeline-lib',
                          credentialsId: 'jenkins-github-user'])
)

def image

node('infrastructure') {
    ansiColor('xterm') {
        scos.doCheckoutStage()

        stage('Build') {
            image = docker.build("scos_ex:${env.GIT_COMMIT_HASH}")
        }

        scos.doStageIf(scos.changeset.isRelease, "Publish") {
            withCredentials([string(credentialsId: 'hex-token', variable: 'HEX_TOKEN')]) {
                image.inside {
                    sh('''
                    mix hex.organization auth smartcolumbus_os --key $HEX_TOKEN
                    mix hex.publish --yes
                    '''.trim())
                }
            }
        }
    }
}
