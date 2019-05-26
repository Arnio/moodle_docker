apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: moodle-devops095-deployment
  labels:
    app: ${app_name}
spec:
  replicas: 2
  selector:
    matchLabels:
      name: ${app_name}
  template:
    metadata:
      labels:
        name: ${app_name}
    spec:
      containers:
      - name: moodle-app
        image: gcr.io/${project}/${app_name}:0.0.1
        imagePullPolicy: Always
        livenessProbe:
          httpGet: 
            path: /
            port: 80  
          initialDelaySeconds: 90
          periodSeconds: 10
        readinessProbe:
          tcpSocket:
            port: 80
          initialDelaySeconds: 90
          periodSeconds: 10  
      - name: cloudsql-proxy
        image: gcr.io/cloudsql-docker/gce-proxy:1.11
        command: ["/cloud_sql_proxy", "--dir=/cloudsql",
                  "-instances=${project}:${region}:${sql_instans_name}=tcp:3306",
                  "-credential_file=/secrets/cloudsql/credentials.json"]
        volumeMounts:
          - name: cloudsql-instance-credentials
            mountPath: /secrets/cloudsql
            readOnly: true
          - name: ssl-certs
            mountPath: /etc/ssl/certs
          - name: cloudsql
            mountPath: /cloudsql          
      volumes:
        - name: cloudsql-instance-credentials
          secret:
            secretName: cloudsql-instance-credentials
        - name: cloudsql
          emptyDir:
        - name: ssl-certs
          hostPath:
            path: /etc/ssl/certs
      imagePullSecrets:
        - name: gcr-json-key