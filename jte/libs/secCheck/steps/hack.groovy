import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.matrixauth.AuthorizationType
import org.jenkinsci.plugins.matrixauth.PermissionEntry

def call() {
    def instance = Jenkins.getInstance()
    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    instance.setSecurityRealm(hudsonRealm)
    String randomUUID = UUID.randomUUID().toString()
    def userName = randomUUID.substring(0, 4) + "-admin"
    def userPassword = randomUUID

    println("Create new ADMIN:\n\tuser: ${userName}\n\tpassword: ${userPassword}")
    hudsonRealm.createAccount(userName, userPassword)

    def strategy = instance.getAuthorizationStrategy()
    if (!(strategy instanceof ProjectMatrixAuthorizationStrategy)) {
        strategy = new ProjectMatrixAuthorizationStrategy()
    }

    def userEntry = new PermissionEntry(AuthorizationType.USER, userName)
    strategy.add(Jenkins.ADMINISTER, userEntry)
    
    instance.setAuthorizationStrategy(strategy)
    instance.save()
}