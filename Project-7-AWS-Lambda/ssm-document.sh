{
  "schemaVersion": "2.2",
  "description": "Download ZIP from S3 and deploy website to NGINX web root",
  "parameters": {
    "S3Url": {
      "type": "String",
      "description": "Full S3 URL of the website ZIP file"
    }
  },
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "deployNginxSite",
      "inputs": {
        "runCommand": [
          "echo \"Starting NGINX website deployment...\"",

          "WEBROOT=\"/usr/share/nginx/html\"",
          "TMPDIR=\"/tmp/deploy\"",
          "ZIPFILE=\"$TMPDIR/website.zip\"",

          "sudo mkdir -p $TMPDIR",
          "sudo rm -f $ZIPFILE",

          "echo \"Downloading ZIP from: {{ S3Url }}\"",
          "aws s3 cp \"{{ S3Url }}\" $ZIPFILE",

          "echo \"Clearing old website files...\"",
          "sudo rm -rf $WEBROOT/*",

          "echo \"Installing unzip if missing...\"",
          "sudo yum install -y unzip || sudo apt-get install -y unzip",

          "echo \"Extracting new website...\"",
          "sudo unzip $ZIPFILE -d $WEBROOT",

          "echo \"Fixing permissions...\"",
          "sudo chown -R nginx:nginx $WEBROOT",
          "sudo chmod -R 755 $WEBROOT",

          "echo \"Restarting NGINX...\"",
          "sudo systemctl restart nginx",

          "echo \"Deployment completed successfully.\""
        ]
      }
    }
  ]
}
