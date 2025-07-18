# Python-flask-app

## Openshift deployment

### CLI deployment: 

Create a new project
```  
oc new-project cli-ns
oc new-app --name=flask-app-cli --strategy=docker https://github.com/EhsanUllahKhan/python-flask-app.git
```

Check the logs of build if it completed successfully
```
oc logs -f buildconfig/flask-app-cli
oc status
oc get all -n cli-ns
```

Update the deployment to include the command in container section
```
oc get deploy/flask-app-cli -n cli-ns -oyaml > flask-app-cli.yaml
nano flask-app-cli.yaml 
oc apply -f flask-app-cli.yaml 
oc get po -n cli-ns
```

Check if service has been created by new-app command or not, if not then create the service
```
oc get svc -n cli-ns
oc expose deployment  flask-app-cli --port=5000 --name=flask-app-svc
```

After creating the service expose it and create the route 
```
oc get po,svc -n cli-ns
oc expose service flask-app-svc
oc get route
```

To automate the build process upon every push in the branch
```
oc describe bc flask-app-cli
```

Look for Webhook GitHub in the output of describe command. For example, 
```
Webhook GitHub:
	URL:	https://c117-e.us-south.containers.cloud.ibm.com:31334/apis/build.openshift.io/v1/namespaces/eh-cli-ns/buildconfigs/flask-app-cli/webhooks/<secret>/github
```

Get the secret for github. Run the following command to retrieve the full BuildConfig in YAML or JSON:
```
oc get bc flask-app-cli -n eh-cli-ns -o yaml
```

Look under the spec.triggers section. You’ll see entries like this:
```
spec:
  triggers:
    - type: GitHub
      github:
        secret: <your-github-secret>
    - type: Generic
      generic:
        secret: <your-generic-secret>
```
How to Actually Allow Webhook Access (Safely)
To allow unauthenticated GitHub webhooks to trigger builds without making your entire cluster vulnerable, follow this namespace-scoped solution:

🛠️ Step-by-Step: Allow Webhook Access to BuildConfig
Create a Role in your project (cli-ns) that allows anonymous users to trigger webhooks:
```
cat <<EOF | oc apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: webhook-trigger
  namespace: cli-ns
rules:
- apiGroups: ["build.openshift.io"]
  resources: ["buildconfigs/webhooks"]
  verbs: ["create"]
EOF
```

Bind that Role to system:anonymous within your project only:
```
oc create rolebinding allow-webhook \
  --role=webhook-trigger \
  --user=system:anonymous \
  --namespace=cli-ns
```
This says:
Allow system:anonymous to create webhook triggers (and nothing else) for BuildConfigs in namespace cli-ns.

If oc get builds is not showing a new build being triggered, the problem is most likely one of the following:
Does the BuildConfig point to the correct GitHub repository and branch?
Inside the _**spec.source.git.uri**_ and **_spec.source.git.ref_**, you should have:
```
source:
  git:
    uri: https://github.com/EhsanUllahKhan/python-flask-app.git
    ref: main
```

If the ref is not main, the webhook will not trigger builds even though it reaches the endpoint.

#### By default, OpenShift expects pushes to the master branch unless you explicitly set ref: main
Add ref: main to the BuildConfig
Run the following command:
```
oc patch bc flask-app-cli -p '{"spec":{"source":{"git":{"ref":"main"}}}}'
```

Then Trigger Webhook Again
After patching, trigger the GitHub webhook again by:
Doing a push to the main branch.

Or manually using the GitHub Web UI → Repo → Settings → Webhooks → “Redeliver”.


