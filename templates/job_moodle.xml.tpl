<?xml version='1.1' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <hudson.plugins.disk__usage.DiskUsageProperty plugin="disk-usage@0.28"/>
    <com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty plugin="gitlab-plugin@1.5.12">
      <gitLabConnection></gitLabConnection>
    </com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty>
    <hudson.plugins.throttleconcurrents.ThrottleJobProperty plugin="throttle-concurrents@2.0.1">
      <maxConcurrentPerNode>0</maxConcurrentPerNode>
      <maxConcurrentTotal>0</maxConcurrentTotal>
      <categories class="java.util.concurrent.CopyOnWriteArrayList"/>
      <throttleEnabled>false</throttleEnabled>
      <throttleOption>project</throttleOption>
      <limitOneJobWithMatchingParams>false</limitOneJobWithMatchingParams>
      <paramsToUseForLimit></paramsToUseForLimit>
    </hudson.plugins.throttleconcurrents.ThrottleJobProperty>
  </properties>
  <scm class="hudson.plugins.git.GitSCM" plugin="git@3.10.0">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url>https://github.com/moodle/moodle.git</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>*/master</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>cp -r /tmp/ansible/moodle_d $WORKSPACE/
cp /tmp/ansible/files/config.php $WORKSPACE/moodle_d/
cp -r /tmp/ansible/kubernetes $WORKSPACE/
</command>
    </hudson.tasks.Shell>
    <jenkins.plugins.publish__over__ssh.BapSshBuilderPlugin plugin="publish-over-ssh@1.20.1">
      <delegate>
        <consolePrefix>SSH: </consolePrefix>
        <delegate plugin="publish-over@0.22">
          <publishers>
            <jenkins.plugins.publish__over__ssh.BapSshPublisher plugin="publish-over-ssh@1.20.1">
              <configName>docker_server</configName>
              <verbose>false</verbose>
              <transfers>
                <jenkins.plugins.publish__over__ssh.BapSshTransfer>
                  <remoteDirectory>moodle_d</remoteDirectory>
                  <sourceFiles>**/moodle_d/*</sourceFiles>
                  <excludes></excludes>
                  <removePrefix>/moodle_d</removePrefix>
                  <remoteDirectorySDF>false</remoteDirectorySDF>
                  <flatten>false</flatten>
                  <cleanRemote>false</cleanRemote>
                  <noDefaultExcludes>false</noDefaultExcludes>
                  <makeEmptyDirs>false</makeEmptyDirs>
                  <patternSeparator>[, ]+</patternSeparator>
                  <execCommand></execCommand>
                  <execTimeout>120000</execTimeout>
                  <usePty>false</usePty>
                  <useAgentForwarding>false</useAgentForwarding>
                </jenkins.plugins.publish__over__ssh.BapSshTransfer>
                <jenkins.plugins.publish__over__ssh.BapSshTransfer>
                  <remoteDirectory>kubernetes</remoteDirectory>
                  <sourceFiles>**/kubernetes/*</sourceFiles>
                  <excludes></excludes>
                  <removePrefix>/kubernetes</removePrefix>
                  <remoteDirectorySDF>false</remoteDirectorySDF>
                  <flatten>false</flatten>
                  <cleanRemote>false</cleanRemote>
                  <noDefaultExcludes>false</noDefaultExcludes>
                  <makeEmptyDirs>false</makeEmptyDirs>
                  <patternSeparator>[, ]+</patternSeparator>
                  <execCommand></execCommand>
                  <execTimeout>120000</execTimeout>
                  <usePty>false</usePty>
                  <useAgentForwarding>false</useAgentForwarding>
                </jenkins.plugins.publish__over__ssh.BapSshTransfer>
                <jenkins.plugins.publish__over__ssh.BapSshTransfer>
                  <remoteDirectory>/moodlefile</remoteDirectory>
                  <sourceFiles>**/**</sourceFiles>
                  <excludes></excludes>
                  <removePrefix>/</removePrefix>
                  <remoteDirectorySDF>false</remoteDirectorySDF>
                  <flatten>false</flatten>
                  <cleanRemote>false</cleanRemote>
                  <noDefaultExcludes>false</noDefaultExcludes>
                  <makeEmptyDirs>false</makeEmptyDirs>
                  <patternSeparator>[, ]+</patternSeparator>
                  <execCommand>sudo cp -r moodlefile/* /var/www/html/moodle
ansible-playbook /tmp/ansible/web.yml
docker build -t moodle-devops095 -f  moodle_d/Dockerfile .
docker tag moodle-devops095 gcr.io/lyrical-chassis-232614/moodle-devops095:0.0.1
gcloud auth activate-service-account --key-file /tmp/ansible/.ssh/gcp_devops.json
gcloud docker -- push gcr.io/lyrical-chassis-232614/moodle-devops095
gcloud beta container clusters get-credentials moodle-claster --region us-central1 --project lyrical-chassis-232614
kubectl create secret docker-registry gcr-json-key --docker-server=gcr.io --docker-username=_json_key --docker-password=&quot;$(cat /tmp/ansible/.ssh/gcp-viewer.json)&quot; --docker-email=arnio.if@gmail.com
kubectl patch serviceaccount default -p &apos;{&quot;imagePullSecrets&quot;: [{&quot;name&quot;: &quot;gcr-json-key&quot;}]}&apos;
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=/tmp/ansible/.ssh/gcp_sql.json
kubectl create secret generic cloudsql-db-credentials --from-literal=username=root --from-literal=password=moodle123
kubectl apply -f kubernetes/deployment-moodle.yml
kubectl apply -f kubernetes/ingress-moodle.yml
</execCommand>
                  <execTimeout>120000</execTimeout>
                  <usePty>false</usePty>
                  <useAgentForwarding>false</useAgentForwarding>
                </jenkins.plugins.publish__over__ssh.BapSshTransfer>
              </transfers>
              <useWorkspaceInPromotion>false</useWorkspaceInPromotion>
              <usePromotionTimestamp>false</usePromotionTimestamp>
            </jenkins.plugins.publish__over__ssh.BapSshPublisher>
          </publishers>
          <continueOnError>false</continueOnError>
          <failOnError>false</failOnError>
          <alwaysPublishFromMaster>false</alwaysPublishFromMaster>
          <hostConfigurationAccess class="jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin" reference="../.."/>
        </delegate>
      </delegate>
    </jenkins.plugins.publish__over__ssh.BapSshBuilderPlugin>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>