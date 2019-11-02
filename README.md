# kube-nginx-letsencrypt

Obtain and install Let's Encrypt certificates for Kubernetes Ingresses

Reference urls:

     https://runnable.com/blog/how-to-use-lets-encrypt-on-kubernetes
     https://hub.docker.com/r/sjenning/kube-nginx-letsencrypt/



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

## Nginx secret 

    apiVersion: v1
    kind: Secret
    metadata:
      name: nginx
    type: Opaque
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

## Letsencrypt service account ##

    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: letsencrypt
      namespace: default
    ---
    apiVersion: rbac.authorization.k8s.io/v1beta1
    kind: ClusterRoleBinding
    metadata:
      name: letsencrypt
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
    - kind: ServiceAccount
      name: letsencrypt
      namespace: default
## Letsencrypt service ##

     apiVersion: v1
     kind: Service
     metadata:
       name: letsencrypt
     spec:
       selector:
         app: letsencrypt
       ports:
       - protocol: "TCP"
         port: 80

## Letsencrypt Job ##

    apiVersion: batch/v1
    kind: Job
    metadata:
      name: letsencrypt
      labels:
        app: letsencrypt
    spec:
      template:
        metadata:
          name: letsencrypt
          labels:
            app: letsencrypt
        spec:
          serviceAccountName: letsencrypt
          containers:
          - image: phanikumary1995/letsencrypt
            name: letsencrypt
            imagePullPolicy: Always
            ports:
            - name: letsencrypt
              containerPort: 80
            env:
            - name: DOMAINS
              value: example.com,www.example.com
            - name: EMAIL
              value: admin@example.com
            - name: SECRET
              value: nginx
            - name: DEPLOYMENT
              value: nginx
          restartPolicy: Never
