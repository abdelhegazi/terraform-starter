http://code.hootsuite.com/how-to-use-terraform-and-remote-state-with-s3/

To setup remote state using S3 you need to first have a bucket that can store your statefiles and AWS CLI tools set up. This includes making sure you have your access key, secret access key and default region set. Then, configuring remote state is as easy as running:

```
$ terraform remote config -backend=S3 -backend-config="bucket=<bucket>" -backend-config="key=<path to file>"
```

This will setup S3 as your remote storage provider, and store remote states in the bucket you specify. 

Locally, this will put a terraform.tfstate file in the .terraform directory which will have details about remote state.

```
"remote": {
        "type": "s3",
	"config": {
	    bucket = <bucket>
	key = <path to statefile>
	}
}
```

If you already have a local statefile you will probably want to push it up to S3. So, run:
``` terraform remote push```

Now whenever you run a terraform plan or terraform apply the remote state will be pulled down to your local machine and you (probably) will not clobber another developer’s changes. Finally when you apply a change the resulting changes state will be uploaded to the remote server.

To pull changes from the remote state you can simply run:
``` terraform remote pull```


