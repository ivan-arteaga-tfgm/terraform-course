# **Continous Docker deployment to AWS Fargate from Gitlab**

<div align="center">
    <img src="images/waf.png" width="800" />
</div>

***
## **Course guide**
   1- Install Gitlab
   2- Devops task for Gitlab
   3- Fargate CLI
   4- GitLab pipeline to Fargate

## **Objectives**
  * Setting up GitLab
  * Backing up GitLab
  * Upgrading GitLab
  * Creating a Fargate cluster via the CLI
  * Creating a Fargate task via the CLI
  * Updating a Fargate service via the CLI
  * Creating and testing a GitLab deployment pipeline
  
## **GitLab CE**

### __Requirements__

  * 2 CPU
  * 8 GRAM
  * 120 GB hard disk

*__Note:__* keep it healthy, backed up and keep the installation up to date with new features and security patches.

***

```
ssh -i gitlab ubuntu@54.75.59.250 -p 24922
```
***
sudo docker restart gitlab
### __Troubleshoot__
```
sudo docker logs -f gitlab
```
### __Gitlab backup__
```
sudo docker exec -t gitlab-rake gitlab:backup:create
```
### __Gitlab backup store__
```
cd /srv/gitlab/data/backups
```

***