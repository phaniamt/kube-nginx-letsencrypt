# kube-nginx-letsencrypt

Obtain and install Let's Encrypt certificates for Kubernetes Ingresses

https://hub.docker.com/r/sjenning/kube-nginx-letsencrypt/


## Ingress ##
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      name: nginx
    spec:
      tls:
      - hosts:
        - www.example.com
        secretName: nginx
      rules:
      - host: www.example.com
        http:
          paths:
          - path: /
            backend:
              serviceName: wordpress
              servicePort: 80
          - path: /.well-known
            backend:
              serviceName: letsencrypt
              servicePort: 80
## Nginx Deployment

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: nginx
      name: nginx
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: nginx
            image: nginx
            ports:
            - containerPort: 80
   
 ## Nginx service  ##
 
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx
    spec:
      selector:
        app: nginx
      ports:
      - protocol: "TCP"
        port: 80

