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
