apiVersion: v1
kind: Service
metadata:
  name: moodle-devops095 
spec:
  selector:
    name: moodle-devops095 
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  loadBalancerIP: ${lb_ip}
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
      - ip: ${lb_ip}