# How to use these files. 

These files will deploy the stack into a kubernetes cluster. 

## set some things up first

  Note: your devops user and key should also be stored in a secret called `devops-secret`. 
  If you don't see it when you do a `kubectl get secrets` you can run 
  ```
  ping-devops generate devops-secret | k apply -f -
  ```


3. The files have some variables that will need to be filled when deploying. 
  - in the `shared-vars` file - replace domains as necessary. 
  - the ingresses will be set up based on value of var: PING_IDENTITY_DEVOPS_DNS_ZONE
    so, export this with:
    ```
    export PING_IDENTITY_DEVOPS_DNS_ZONE=your-base-domain.com
    ```

4. look at what you've done. run the following command to see the files that will be applied to the cluster. 
```
kustomize build . | envsubst '${PING_IDENTITY_DEVOPS_DNS_ZONE}'
```

## Deploy

```
kustomize build . | envsubst '${PING_IDENTITY_DEVOPS_DNS_ZONE}' | kubectl apply -f -
```

## View


```
kubectl get pods,svc,deploy,rs,job,ing,pvc
```
or `kall`

Once the ingresses show an address, you can go to that host in a browser