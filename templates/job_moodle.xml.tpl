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
        <name>*/MOODLE_37_STABLE</name>
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
      <command>cp -r /tmp/ansible/files/* $WORKSPACE/docker_files
docker build --rm -t local/c7-systemd -f  /tmp/ansible/centos_systemd/Dockerfile .
docker build -t ${app_name} -f  /tmp/ansible/files/Dockerfile .
docker tag ${app_name} gcr.io/${project}/${app_name}:0.0.1
gcloud auth activate-service-account --key-file /tmp/ansible/.ssh/gcp_devops.json
gcloud docker -- push gcr.io/${project}/${app_name}
gcloud container clusters get-credentials ${claster_name} --region ${location} --project ${project}
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=/tmp/ansible/.ssh/gcp_sql.json
kubectl create secret generic cloudsql-db-credentials --from-literal=username=${db_user} --from-literal=password=${db_pass}
kubectl apply -f /tmp/ansible/kubernetes/deployment-moodle.yml
kubectl apply -f /tmp/ansible/kubernetes/service-moodle.yml</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>