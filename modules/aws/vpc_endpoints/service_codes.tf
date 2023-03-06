locals {
  #aws ec2 describe-vpc-phz_name-services --filter Name=service-type,Values=Interface --query ServiceNames
  #https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html
  aws_services = {
    #Access Analyzer Yes
    access-analyzer = {
      name         = "com.amazonaws.${var.region}.access-analyzer"
      service_name = "Access Analyzer"
      phz_name     = "access-analyzer.${var.region}.amazonaws.com"
    }
    #AWS Account Management	 Yes
    account = {
      name         = "com.amazonaws.${var.region}.account"
      service_name = "AWS Account Management"
      phz_name     = "account.${var.region}.amazonaws.com"
    }
    #Amazon API Gateway	 Yes
    execute-api = {
      name         = "com.amazonaws.${var.region}.execute-api"
      service_name = "Amazon API Gateway"
      phz_name     = "execute-api.${var.region}.amazonaws.com"
      a_record     = "*"
    }
    #AWS App Mesh	 No
    appmesh-envoy-management = {
      name         = "com.amazonaws.${var.region}.appmesh-envoy-management"
      service_name = "AWS App Mesh"
      phz_name     = "appmesh-envoy-management.${var.region}.amazonaws.com"
    }
    #AWS App Runner	 Yes
    apprunner = {
      name         = "com.amazonaws.${var.region}.apprunner"
      service_name = "AWS App Runner"
      phz_name     = "apprunner.${var.region}.amazonaws.com"
    }
    #Application Auto Scaling	 Yes
    application-autoscaling = {
      name         = "com.amazonaws.${var.region}.application-autoscaling"
      service_name = "Application Auto Scaling"
      phz_name     = "application-autoscaling.${var.region}.amazonaws.com"
    }
    #AWS Application Migration Service	 Yes
    mgn = {
      name         = "com.amazonaws.${var.region}.mgn"
      service_name = "AWS Application Migration Service"
      phz_name     = "mgn.${var.region}.amazonaws.com"
    }
    #Amazon AppStream 2.0	 No
    "appstream.api" = {
      name         = "com.amazonaws.${var.region}.appstream.api"
      service_name = "Amazon AppStream 2.0"
      phz_name     = "appstream2.${var.region}.amazonaws.com"
    }
    "appstream.streaming" = {
      name         = "com.amazonaws.${var.region}.appstream.streaming"
      service_name = "Amazon AppStream 2.0"
      phz_name     = "streaming.appstream.${var.region}.amazonaws.com"
    }
    #Amazon Athena	 Yes
    athena = {
      name         = "com.amazonaws.${var.region}.athena"
      service_name = "Amazon Athena"
      phz_name     = "athena.${var.region}.amazonaws.com"
    }
    #AWS Audit Manager	 Yes
    auditmanager = {
      name         = "com.amazonaws.${var.region}.auditmanager"
      service_name = "AWS Audit Manager"
      phz_name     = "auditmanager.${var.region}.amazonaws.com"
    }
    #AWS Auto Scaling	 Yes
    autoscaling-plans = {
      name         = "com.amazonaws.${var.region}.autoscaling-plans"
      service_name = "AWS Auto Scaling"
      phz_name     = "autoscaling-plans.${var.region}.amazonaws.com"
    }
    #AWS Backup	 Yes
    backup = {
      name         = "com.amazonaws.${var.region}.backup"
      service_name = "AWS Backup"
      phz_name     = "backup.${var.region}.amazonaws.com"
    }
    backup-gateway = {
      name         = "com.amazonaws.${var.region}.backup-gateway"
      service_name = "AWS Backup"
      phz_name     = "backup-gateway.${var.region}.amazonaws.com"
    }
    #AWS Batch	 Yes
    batch = {
      name         = "com.amazonaws.${var.region}.batch"
      service_name = "AWS Batch"
      phz_name     = "batch.${var.region}.amazonaws.com"
    }
    #AWS Billing Conductor	 Yes
    billingconductor = {
      name         = "com.amazonaws.${var.region}.billingconductor"
      service_name = "AWS Billing Conductor"
      phz_name     = "billingconductor.${var.region}.amazonaws.com"
    }
    #Amazon Braket	 Yes
    braket = {
      name         = "com.amazonaws.${var.region}.braket"
      service_name = "Amazon Braket"
      phz_name     = "braket.${var.region}.amazonaws.com"
    }
    #AWS Certificate Manager Private Certificate Authority	 Yes
    acm-pca = {
      name         = "com.amazonaws.${var.region}.acm-pca"
      service_name = "AWS Certificate Manager Private Certificate Authority"
      phz_name     = "acm-pca.${var.region}.amazonaws.com"
    }
    #Amazon Cloud Directory	 Yes
    clouddirectory = {
      name         = "com.amazonaws.${var.region}.clouddirectory"
      service_name = "Amazon Cloud Directory"
      phz_name     = "clouddirectory.${var.region}.amazonaws.com"
    }
    #AWS CloudFormation	 Yes
    cloudformation = {
      name         = "com.amazonaws.${var.region}.cloudformation"
      service_name = "AWS CloudFormation"
      phz_name     = "cloudformation.${var.region}.amazonaws.com"
    }
    #AWS CloudHSM  Yes
    cloudhsmv2 = {
      name         = "com.amazonaws.${var.region}.cloudhsmv2"
      service_name = "AWS CloudHSM"
      phz_name     = "cloudhsmv2.${var.region}.amazonaws.com"
    }
    #AWS CloudTrail	 No
    cloudtrail = {
      name         = "com.amazonaws.${var.region}.cloudtrail"
      service_name = "AWS CloudTrail"
      phz_name     = "cloudtrail.${var.region}.amazonaws.com"
    }
    #Amazon CloudWatch	 Yes
    evidently = {
      name         = "com.amazonaws.${var.region}.evidently"
      service_name = "Amazon CloudWatch"
      phz_name     = "evidently.${var.region}.amazonaws.com"
    }
    evidently-dataplane = {
      name         = "com.amazonaws.${var.region}.evidently-dataplane"
      service_name = "Amazon CloudWatch"
      phz_name     = "dataplane.evidently.${var.region}.amazonaws.com"
    }
    monitoring = {
      name         = "com.amazonaws.${var.region}.monitoring"
      service_name = "Amazon CloudWatch"
      phz_name     = "monitoring.${var.region}.amazonaws.com"
    }
    rum = {
      name         = "com.amazonaws.${var.region}.rum"
      service_name = "Amazon CloudWatch"
      phz_name     = "rum.${var.region}.amazonaws.com"
    }
    rum-dataplane = {
      name         = "com.amazonaws.${var.region}.rum-dataplane"
      service_name = "Amazon CloudWatch"
      phz_name     = "dataplane.rum.${var.region}.amazonaws.com"
    }
    synthetics = {
      name         = "com.amazonaws.${var.region}.synthetics"
      service_name = "Amazon CloudWatch"
      phz_name     = "synthetics.${var.region}.amazonaws.com"
    }
    #Amazon CloudWatch Events	 Yes
    events = {
      name         = "com.amazonaws.${var.region}.events"
      service_name = "Amazon CloudWatch Event"
      phz_name     = "events.${var.region}.amazonaws.com"
    }
    #Amazon CloudWatch Logs	 Yes
    logs = {
      name         = "com.amazonaws.${var.region}.logs"
      service_name = "Amazon CloudWatch Logs"
      phz_name     = "logs.${var.region}.amazonaws.com"
    }
    #AWS CodeArtifact	 Yes
    "codeartifact.api" = {
      name         = "com.amazonaws.${var.region}.codeartifact.api"
      service_name = "AWS CodeArtifact"
      phz_name     = "codeartifact.${var.region}.amazonaws.com"
    }
    "codeartifact.repositories" = {
      name         = "com.amazonaws.${var.region}.codeartifact.repositories"
      service_name = "AWS CodeArtifact"
      phz_name     = "d.codeartifact.${var.region}.amazonaws.com"
      a_record     = "*"
    }
    #AWS CodeBuild	 Yes
    codebuild = {
      name         = "com.amazonaws.${var.region}.codebuild"
      service_name = "AWS CodeBuild"
      phz_name     = "codebuild.${var.region}.amazonaws.com"
    }
    codebuild-fips = {
      name         = "com.amazonaws.${var.region}.codebuild-fips"
      service_name = "AWS CodeBuild"
      phz_name     = "codebuild-fips.${var.region}.amazonaws.com"
    }
    #AWS CodeCommit	 Yes
    codecommit = {
      name         = "com.amazonaws.${var.region}.codecommit"
      service_name = "AWS CodeCommit"
      phz_name     = "codecommit.${var.region}.amazonaws.com"
    }
    codecommit-fips = {
      name         = "com.amazonaws.${var.region}.codecommit-fips"
      service_name = "AWS CodeCommit"
      phz_name     = "codecommit-fips.${var.region}.amazonaws.com"
    }
    git-codecommit = {
      name         = "com.amazonaws.${var.region}.git-codecommit"
      service_name = "AWS CodeCommit"
      phz_name     = "git-codecommit.${var.region}.amazonaws.com"
    }
    git-codecommit-fips = {
      name         = "com.amazonaws.${var.region}.git-codecommit-fips"
      service_name = "AWS CodeCommit"
      phz_name     = "git-codecommit-fips.${var.region}.amazonaws.com"
    }
    #AWS CodeDeploy	 Yes
    codedeploy = {
      name         = "com.amazonaws.${var.region}.codedeploy"
      service_name = "AWS CodeDeploy"
      phz_name     = "codedeploy.${var.region}.amazonaws.com"
    }
    codedeploy-commands-secure = {
      name         = "com.amazonaws.${var.region}.codedeploy-commands-secure"
      service_name = "AWS CodeDeploy"
      phz_name     = "codedeploy-commands-secure.${var.region}.amazonaws.com"
    }
    #Amazon CodeGuru Profiler	 No
    codeguru-profiler = {
      name         = "com.amazonaws.${var.region}.codeguru-profiler"
      service_name = "Amazon CodeGuru Profiler"
      phz_name     = "codeguru-profiler.${var.region}.amazonaws.com"
    }
    #Amazon CodeGuru Reviewer	 No
    codeguru-reviewer = {
      name         = "com.amazonaws.${var.region}.codeguru-reviewer"
      service_name = "Amazon CodeGuru Reviewer"
      phz_name     = "codeguru-reviewer.${var.region}.amazonaws.com"
    }
    #AWS CodePipeline	 No
    codepipeline = {
      name         = "com.amazonaws.${var.region}.codepipeline"
      service_name = "AWS CodePipeline"
      phz_name     = "codepipeline.${var.region}.amazonaws.com"
    }
    #AWS CodeStar Connections	 Yes
    "codestar-connections.api" = {
      name         = "com.amazonaws.${var.region}.codestar-connections.api"
      service_name = "AWS CodeStar Connections"
      phz_name     = "codestar-connections.${var.region}.amazonaws.com"
    }
    #Amazon Comprehend	 Yes
    comprehend = {
      name         = "com.amazonaws.${var.region}.comprehend"
      service_name = "Amazon Comprehend"
      phz_name     = "comprehend.${var.region}.amazonaws.com"
    }
    #Amazon Comprehend Medical	 Yes
    comprehendmedical = {
      name         = "com.amazonaws.${var.region}.comprehendmedical"
      service_name = "Amazon Comprehend Medical"
      phz_name     = "comprehendmedical.${var.region}.amazonaws.com"
    }
    #AWS Config	 Yes
    config = {
      name         = "com.amazonaws.${var.region}.config"
      service_name = "AWS Config"
      phz_name     = "config.${var.region}.amazonaws.com"
    }
    #Amazon Connect	 Yes
    app-integrations = {
      name         = "com.amazonaws.${var.region}.app-integrations"
      service_name = "Amazon Connect"
      phz_name     = "app-integrations.${var.region}.amazonaws.com"
    }
    connect-campaigns = {
      name         = "com.amazonaws.${var.region}.connect-campaigns"
      service_name = "Amazon Connect"
      phz_name     = "connect-campaigns.${var.region}.amazonaws.com"
    }
    profile = {
      name         = "com.amazonaws.${var.region}.profile"
      service_name = "Amazon Connect"
      phz_name     = "profile.${var.region}.amazonaws.com"
    }
    voiceid = {
      name         = "com.amazonaws.${var.region}.voiceid"
      service_name = "Amazon Connect"
      phz_name     = "voiceid.${var.region}.amazonaws.com"
    }
    wisdom = {
      name         = "com.amazonaws.${var.region}.wisdom"
      service_name = "Amazon Connect"
      phz_name     = "wisdom.${var.region}.amazonaws.com"
    }
    #AWS Data Exchange	 Yes
    dataexchange = {
      name         = "com.amazonaws.${var.region}.dataexchange"
      service_name = "AWS Data Exchange"
      phz_name     = "dataexchange.${var.region}.amazonaws.com"
    }
    #AWS Database Migration Service	 Yes
    dms = {
      name         = "com.amazonaws.${var.region}.dms"
      service_name = "AWS Database Migration Service"
      phz_name     = "dms.${var.region}.amazonaws.com"
    }
    dms-fips = {
      name         = "com.amazonaws.${var.region}.dms-fips"
      service_name = "AWS Database Migration Service"
      phz_name     = "dms-fips.${var.region}.amazonaws.com"
    }
    #AWS DataSync	 No
    datasync = {
      name         = "com.amazonaws.${var.region}.datasync"
      service_name = "AWS DataSync"
      phz_name     = "datasync.${var.region}.amazonaws.com"
    }
    #Amazon DevOps Guru	 Yes
    devops-guru = {
      name         = "com.amazonaws.${var.region}.devops-guru"
      service_name = "Amazon DevOps Guru"
      phz_name     = "devops-guru.${var.region}.amazonaws.com"
    }
    #Amazon EBS direct APIs	 No
    ebs = {
      name         = "com.amazonaws.${var.region}.ebs"
      service_name = "Amazon EBS direct APIs"
      phz_name     = "ebs.${var.region}.amazonaws.com"
    }
    #Amazon EC2	 Yes
    ec2 = {
      name         = "com.amazonaws.${var.region}.ec2"
      service_name = "Amazon EC2"
      phz_name     = "ec2.${var.region}.amazonaws.com"
    }
    #Amazon EC2 Auto Scaling	 Yes
    autoscaling = {
      name         = "com.amazonaws.${var.region}.autoscaling"
      service_name = "Amazon EC2 Auto Scaling"
      phz_name     = "autoscaling.${var.region}.amazonaws.com"
    }
    #EC2 Image Builder	 Yes
    imagebuilder = {
      name         = "com.amazonaws.${var.region}.imagebuilder"
      service_name = "EC2 Image Builder"
      phz_name     = "imagebuilder.${var.region}.amazonaws.com"
    }
    #Amazon ECR	 Yes
    "ecr.api" = {
      name         = "com.amazonaws.${var.region}.ecr.api"
      service_name = "Amazon ECR"
      phz_name     = "api.ecr.${var.region}.amazonaws.com"
    }
    "ecr.dkr" = {
      name         = "com.amazonaws.${var.region}.ecr.dkr"
      service_name = "Amazon ECR"
      phz_name     = "dkr.ecr.${var.region}.amazonaws.com"
      a_record     = "*"

    }
    #Amazon ECS	 Yes
    ecs = {
      name         = "com.amazonaws.${var.region}.ecs"
      service_name = "Amazon ECS"
      phz_name     = "ecs.${var.region}.amazonaws.com"
    }
    ecs-agent = {
      name         = "com.amazonaws.${var.region}.ecs-agent"
      service_name = "Amazon ECS"
      phz_name     = "ecs-a.${var.region}.amazonaws.com"
    }
    ecs-telemetry = {
      name         = "com.amazonaws.${var.region}.ecs-telemetry"
      service_name = "Amazon ECS"
      phz_name     = "ecs-t.${var.region}.amazonaws.com"
    }
    #AWS Elastic Beanstalk	 Yes
    elasticbeanstalk = {
      name         = "com.amazonaws.${var.region}.elasticbeanstalk"
      service_name = "AWS Elastic Beanstalk"
      phz_name     = "elasticbeanstalk.${var.region}.amazonaws.com"
    }
    elasticbeanstalk-health = {
      name         = "com.amazonaws.${var.region}.elasticbeanstalk-health"
      service_name = "AWS Elastic Beanstalk"
      phz_name     = "elasticbeanstalk-health.${var.region}.amazonaws.com"
    }
    #AWS Elastic Disaster Recovery	 Yes
    drs = {
      name         = "com.amazonaws.${var.region}.drs"
      service_name = "AWS Elastic Disaster Recovery"
      phz_name     = "drs.${var.region}.amazonaws.com"
    }
    #Amazon Elastic File System	 Yes
    elasticfilesystem = {
      name         = "com.amazonaws.${var.region}.elasticfilesystem"
      service_name = "Amazon Elastic File System"
      phz_name     = "elasticfilesystem.${var.region}.amazonaws.com"
    }
    elasticfilesystem-fips = {
      name         = "com.amazonaws.${var.region}.elasticfilesystem-fips"
      service_name = "Amazon Elastic File System"
      phz_name     = "elasticfilesystem-fips.${var.region}.amazonaws.com"
    }
    #Amazon Elastic Inference	 No
    "elastic-inference.runtime" = {
      name         = "com.amazonaws.${var.region}.elastic-inference.runtime"
      service_name = "Amazon Elastic Inference"
      phz_name     = "runtime.elastic-inference.${var.region}.amazonaws.com"
    }
    #Elastic Load Balancing	 Yes
    elasticloadbalancing = {
      name         = "com.amazonaws.${var.region}.elasticloadbalancing"
      service_name = "Elastic Load Balancing"
      phz_name     = "elasticloadbalancing.${var.region}.amazonaws.com"
    }
    #Amazon ElastiCache	 Yes
    elasticache = {
      name         = "com.amazonaws.${var.region}.elasticache"
      service_name = "Amazon ElastiCache"
      phz_name     = "elasticache.${var.region}.amazonaws.com"
    }
    #Amazon EMR	 Yes
    elasticmapreduce = {
      name         = "com.amazonaws.${var.region}.elasticmapreduce"
      service_name = "Amazon EMR"
      phz_name     = "elasticmapreduce.${var.region}.amazonaws.com"
    }
    #Amazon EMR on EKS	 Yes
    emr-containers = {
      name         = "com.amazonaws.${var.region}.emr-containers"
      service_name = "Amazon EMR on EKS"
      phz_name     = "emr-containers.${var.region}.amazonaws.com"
    }
    #Amazon EMR Serverless	 Yes
    emr-serverless = {
      name         = "com.amazonaws.${var.region}.emr-serverless"
      service_name = "Amazon EMR Serverless"
      phz_name     = "emr-serverless.${var.region}.amazonaws.com"
    }
    #Amazon EventBridge	 Yes
    events = {
      name         = "com.amazonaws.${var.region}.events"
      service_name = "Amazon EventBridge"
      phz_name     = "events.${var.region}.amazonaws.com"
    }
    #AWS Fault Injection Simulator	 Yes
    fis = {
      name         = "com.amazonaws.${var.region}.fis"
      service_name = "AWS Fault Injection Simulator"
      phz_name     = "fis.${var.region}.amazonaws.com"
    }
    #Amazon FinSpace	 Yes
    finspace = {
      name         = "com.amazonaws.${var.region}.finspace"
      service_name = "Amazon FinSpace"
      phz_name     = "finspace.${var.region}.amazonaws.com"
    }
    finspace-api = {
      name         = "com.amazonaws.${var.region}.finspace-api"
      service_name = "Amazon FinSpace"
      phz_name     = "finspace-api.${var.region}.amazonaws.com"
    }
    #Amazon Forecast	 Yes
    forecast = {
      name         = "com.amazonaws.${var.region}.forecast"
      service_name = "Amazon Forecast"
      phz_name     = "forecast.${var.region}.amazonaws.com"
    }
    forecastquery = {
      name         = "com.amazonaws.${var.region}.forecastquery"
      service_name = "Amazon Forecast"
      phz_name     = "forecastquery.${var.region}.amazonaws.com"
    }
    forecast-fips = {
      name         = "com.amazonaws.${var.region}.forecast-fips"
      service_name = "Amazon Forecast"
      phz_name     = "forecast-fips.${var.region}.amazonaws.com"
    }
    forecastquery-fips = {
      name         = "com.amazonaws.${var.region}.forecastquery-fips"
      service_name = "Amazon Forecast"
      phz_name     = "forecastquery-fips.${var.region}.amazonaws.com"
    }
    #Amazon Fraud Detector	 Yes
    frauddetector = {
      name         = "com.amazonaws.${var.region}.frauddetector"
      service_name = "Amazon Fraud Detector"
      phz_name     = "frauddetector.${var.region}.amazonaws.com"
    }
    #Amazon FSx	 Yes
    fsx = {
      name         = "com.amazonaws.${var.region}.fsx"
      service_name = "Amazon FSx"
      phz_name     = "fsx.${var.region}.amazonaws.com"
    }
    fsx-fips = {
      name         = "com.amazonaws.${var.region}.fsx-fips"
      service_name = "Amazon FSx"
      phz_name     = "fsx-fips.${var.region}.amazonaws.com"
    }
    #AWS Glue	 Yes
    glue = {
      name         = "com.amazonaws.${var.region}.glue"
      service_name = "AWS Glue"
      phz_name     = "glue.${var.region}.amazonaws.com"
    }
    #AWS Glue DataBrew	 Yes
    databrew = {
      name         = "com.amazonaws.${var.region}.databrew"
      service_name = "AWS Glue DataBrew"
      phz_name     = "databrew.${var.region}.amazonaws.com"
    }
    #Amazon Managed Grafana	 Yes
    grafana = {
      name         = "com.amazonaws.${var.region}.grafana"
      service_name = "Amazon Managed Grafana"
      phz_name     = "grafana.${var.region}.amazonaws.com"
    }
    #AWS Ground Station	 Yes
    groundstation = {
      name         = "com.amazonaws.${var.region}.groundstation"
      service_name = "AWS Ground Station"
      phz_name     = "groundstation.${var.region}.amazonaws.com"
    }
    #Amazon HealthLake	 Yes
    healthlake = {
      name         = "com.amazonaws.${var.region}.healthlake"
      service_name = "Amazon HealthLake"
      phz_name     = "healthlake.${var.region}.amazonaws.com"
    }
    #Amazon Inspector	 Yes
    inspector2 = {
      name         = "com.amazonaws.${var.region}.inspector2"
      service_name = "Amazon Inspector"
      phz_name     = "inspector2.${var.region}.amazonaws.com"
    }
    #AWS IoT Core	 No
    "iot.data" = {
      name         = "com.amazonaws.${var.region}.iot.data"
      service_name = "AWS IoT Core"
      phz_name     = "data.iot.${var.region}.amazonaws.com"
    }
    #AWS IoT Core for LoRaWAN	 No
    "iotwireless.api" = {
      name         = "com.amazonaws.${var.region}.iotwireless.api"
      service_name = "AWS IoT Core for LoRaWAN"
      phz_name     = "api.iotwireless.${var.region}.amazonaws.com"
    }
    "lorawan.cups" = {
      name         = "com.amazonaws.${var.region}.lorawan.cups"
      service_name = "AWS IoT Core for LoRaWAN"
      phz_name     = "cups.lorawan.${var.region}.amazonaws.com"
      a_record     = "*"
    }
    "lorawan.lns" = {
      name         = "com.amazonaws.${var.region}.lorawan.lns"
      service_name = "AWS IoT Core for LoRaWAN"
      phz_name     = "lns.lorawan.${var.region}.amazonaws.com"
      a_record     = "*"
    }
    #AWS IoT Greengrass	 Yes
    greengrass = {
      name         = "com.amazonaws.${var.region}.greengrass"
      service_name = "AWS IoT Greengrass"
      phz_name     = "greengrass.${var.region}.amazonaws.com"
    }
    #AWS IoT SiteWise	 No
    "iotsitewise.api" = {
      name         = "com.amazonaws.${var.region}.iotsitewise.api"
      service_name = "AWS IoT SiteWise"
      phz_name     = "api.iotsitewise.${var.region}.amazonaws.com"
    }
    "iotsitewise.data" = {
      name         = "com.amazonaws.${var.region}.iotsitewise.data"
      service_name = "AWS IoT SiteWise"
      phz_name     = "data.iotsitewise.${var.region}.amazonaws.com"
    }
    #AWS IoT TwinMaker	 Yes
    "iottwinmaker.api" = {
      name         = "com.amazonaws.${var.region}.iottwinmaker.api"
      service_name = "AWS IoT TwinMaker"
      phz_name     = "api.iottwinmaker.${var.region}.amazonaws.com"
    }
    "iottwinmaker.data" = {
      name         = "com.amazonaws.${var.region}.iottwinmaker.data"
      service_name = "AWS IoT TwinMaker"
      phz_name     = "data.iottwinmaker.${var.region}.amazonaws.com"
    }
    #Amazon Kendra	 Yes
    kendra = {
      name         = "com.amazonaws.${var.region}.kendra"
      service_name = "Amazon Kendra"
      phz_name     = "kendra.${var.region}.amazonaws.com"
    }
    #AWS Key Management Service	 Yes
    kms = {
      name         = "com.amazonaws.${var.region}.kms"
      service_name = "AWS Key Management Service"
      phz_name     = "kms.${var.region}.amazonaws.com"
    }
    #Amazon Keyspaces (for Apache Cassandra)	 Yes
    cassandra = {
      name         = "com.amazonaws.${var.region}.cassandra"
      service_name = "Amazon Keyspaces (for Apache Cassandra)"
      phz_name     = "cassandra.${var.region}.amazonaws.com"
    }
    cassandra-fips = {
      name         = "com.amazonaws.${var.region}.cassandra-fips"
      service_name = "Amazon Keyspaces (for Apache Cassandra)"
      phz_name     = "cassandra-fips.${var.region}.amazonaws.com"
    }
    #Amazon Kinesis Data Firehose	 Yes
    kinesis-firehose = {
      name         = "com.amazonaws.${var.region}.kinesis-firehose"
      service_name = "Amazon Kinesis Data Firehose"
      phz_name     = "firehose.${var.region}.amazonaws.com"
    }
    #Amazon Kinesis Data Streams	 Yes
    kinesis-streams = {
      name         = "com.amazonaws.${var.region}.kinesis-streams"
      service_name = "Amazon Kinesis Data Streams"
      phz_name     = "kinesis.${var.region}.amazonaws.com"
    }
    #AWS Lake Formation	 Yes
    lakeformation = {
      name         = "com.amazonaws.${var.region}.lakeformation"
      service_name = "AWS Lake Formation"
      phz_name     = "lakeformation.${var.region}.amazonaws.com"
    }
    #AWS Lambda	 Yes
    lambda = {
      name         = "com.amazonaws.${var.region}.lambda"
      service_name = "AWS Lambda"
      phz_name     = "lambda.${var.region}.amazonaws.com"
    }
    #Amazon Lex	 Yes
    models-v2-lex = {
      name         = "com.amazonaws.${var.region}.models-v2-lex"
      service_name = "Amazon Lex"
      phz_name     = "models-v2-lex.${var.region}.amazonaws.com"
    }
    runtime-v2-lex = {
      name         = "com.amazonaws.${var.region}.runtime-v2-lex"
      service_name = "Amazon Lex"
      phz_name     = "runtime-v2-lex.${var.region}.amazonaws.com"
    }
    #AWS License Manager	 Yes
    license-manager = {
      name         = "com.amazonaws.${var.region}.license-manager"
      service_name = "AWS License Manager"
      phz_name     = "license-manager.${var.region}.amazonaws.com"
    }
    license-manager-fips = {
      name         = "com.amazonaws.${var.region}.license-manager-fips"
      service_name = "AWS License Manager"
      phz_name     = "license-manager-fips.${var.region}.amazonaws.com"
    }
    #Amazon Lookout for Equipment	 Yes
    lookoutequipment = {
      name         = "com.amazonaws.${var.region}.lookoutequipment"
      service_name = "Amazon Lookout for Equipment"
      phz_name     = "lookoutequipment.${var.region}.amazonaws.com"
    }
    #Amazon Lookout for Metrics	 Yes
    lookoutmetrics = {
      name         = "com.amazonaws.${var.region}.lookoutmetrics"
      service_name = "Amazon Lookout for Metrics"
      phz_name     = "lookoutmetrics.${var.region}.amazonaws.com"
    }
    #Amazon Lookout for Vision	 Yes
    lookoutvision = {
      name         = "com.amazonaws.${var.region}.lookoutvision"
      service_name = "Amazon Lookout for Vision"
      phz_name     = "lookoutvision.${var.region}.amazonaws.com"
    }
    #Amazon Macie	 No
    macie2 = {
      name         = "com.amazonaws.${var.region}.macie2"
      service_name = "Amazon Macie"
      phz_name     = "macie2.${var.region}.amazonaws.com"
    }
    #Amazon Managed Service for Prometheus	 No
    aps = {
      name         = "com.amazonaws.${var.region}.aps"
      service_name = "Amazon Managed Service for Prometheus"
      phz_name     = "aps.${var.region}.amazonaws.com"
    }
    aps-workspaces = {
      name         = "com.amazonaws.${var.region}.aps-workspaces"
      service_name = "Amazon Managed Service for Prometheus"
      phz_name     = "aps-workspaces.${var.region}.amazonaws.com"
    }
    #Amazon Managed Workflows for Apache Airflow	 Yes
    "airflow.api" = {
      name         = "com.amazonaws.${var.region}.airflow.api"
      service_name = "Amazon Managed Workflows for Apache Airflow"
      phz_name     = "api.airflow.${var.region}.amazonaws.com"
    }
    "airflow.env" = {
      name         = "com.amazonaws.${var.region}.airflow.env"
      service_name = "Amazon Managed Workflows for Apache Airflow"
      phz_name     = "env.airflow.${var.region}.amazonaws.com"
    }
    "airflow.ops" = {
      name         = "com.amazonaws.${var.region}.airflow.ops"
      service_name = "Amazon Managed Workflows for Apache Airflow"
      phz_name     = "ops.airflow.${var.region}.amazonaws.com"
    }
    #Amazon MemoryDB for Redis	 Yes
    memory-db = {
      name         = "com.amazonaws.${var.region}.memory-db"
      service_name = "Amazon MemoryDB for Redis"
      phz_name     = "memory-db.${var.region}.amazonaws.com"
    }
    memorydb-fips = {
      name         = "com.amazonaws.${var.region}.memorydb-fips"
      service_name = "Amazon MemoryDB for Redis"
      phz_name     = "memorydb-fips.${var.region}.amazonaws.com"
    }
    #Migration Hub Orchestrator	 Yes
    migrationhub-orchestrator = {
      name         = "com.amazonaws.${var.region}.migrationhub-orchestrator"
      service_name = "Migration Hub Orchestrator"
      phz_name     = "migrationhub-orchestrator.${var.region}.amazonaws.com"
    }
    #AWS Migration Hub Refactor Spaces	 No
    refactor-spaces = {
      name         = "com.amazonaws.${var.region}.refactor-spaces"
      service_name = "AWS Migration Hub Refactor Spaces"
      phz_name     = "refactor-spaces.${var.region}.amazonaws.com"
    }
    #Migration Hub Strategy Recommendations	 Yes
    migrationhub-strategy = {
      name         = "com.amazonaws.${var.region}.migrationhub-strategy"
      service_name = "Migration Hub Strategy Recommendations"
      phz_name     = "migrationhub-strategy.${var.region}.amazonaws.com"
    }
    #Amazon Nimble Studio	 Yes
    nimble = {
      name         = "com.amazonaws.${var.region}.nimble"
      service_name = "Amazon Nimble Studio"
      phz_name     = "nimble.${var.region}.amazonaws.com"
    }
    #AWS Panorama	 Yes
    panorama = {
      name         = "com.amazonaws.${var.region}.panorama"
      service_name = "AWS Panorama"
      phz_name     = "panorama.${var.region}.amazonaws.com"
    }
    #Amazon Pinpoint	 Yes
    pinpoint-sms-voice-v2 = {
      name         = "com.amazonaws.${var.region}.pinpoint-sms-voice-v2"
      service_name = "Amazon Pinpoint"
      phz_name     = "sms-voice.${var.region}.amazonaws.com"
    }
    #AWS Proton	 Yes
    proton = {
      name         = "com.amazonaws.${var.region}.proton"
      service_name = "AWS Proton"
      phz_name     = "proton.${var.region}.amazonaws.com"
    }
    #Amazon QLDB	 Yes
    "qldb.session" = {
      name         = "com.amazonaws.${var.region}.qldb.session"
      service_name = "Amazon QLDB"
      phz_name     = "session.qldb.${var.region}.amazonaws.com"
    }
    #Amazon RDS	 Yes
    rds = {
      name         = "com.amazonaws.${var.region}.rds"
      service_name = "Amazon RDS"
      phz_name     = "rds.${var.region}.amazonaws.com"
    }
    #Amazon RDS Data API	 Yes
    rds-data = {
      name         = "com.amazonaws.${var.region}.rds-data"
      service_name = "mazon RDS Data API"
      phz_name     = "rds-data.${var.region}.amazonaws.com"
    }
    #Amazon Redshift	 Yes
    redshift = {
      name         = "com.amazonaws.${var.region}.redshift"
      service_name = "Amazon Redshift"
      phz_name     = "redshift.${var.region}.amazonaws.com"
    }
    redshift-data = {
      name         = "com.amazonaws.${var.region}.redshift-data"
      service_name = "Amazon Redshift"
      phz_name     = "redshift-data.${var.region}.amazonaws.com"
    }
    redshift-fips = {
      name         = "com.amazonaws.${var.region}.redshift-fips"
      service_name = "Amazon Redshift"
      phz_name     = "redshift-fips.${var.region}.amazonaws.com"
    }
    #Amazon Rekognition	 Yes
    rekognition = {
      name         = "com.amazonaws.${var.region}.rekognition"
      service_name = "Amazon Rekognition"
      phz_name     = "rekognition.${var.region}.amazonaws.com"
    }
    rekognition-fips = {
      name         = "com.amazonaws.${var.region}.rekognition-fips"
      service_name = "Amazon Rekognition"
      phz_name     = "rekognition-fips.${var.region}.amazonaws.com"
    }
    #AWS RoboMaker	 Yes
    robomaker = {
      name         = "com.amazonaws.${var.region}.robomaker"
      service_name = "AWS RoboMaker"
      phz_name     = "robomaker.${var.region}.amazonaws.com"
    }
    #Amazon S3	 Yes
    s3 = {
      name         = "com.amazonaws.${var.region}.s3"
      service_name = "Amazon S3"
      phz_name     = "s3.${var.region}.amazonaws.com"
      a_record     = "*"
    }
    #Amazon S3 on Outposts	 Yes
    s3-outposts = {
      name         = "com.amazonaws.${var.region}.s3-outposts"
      service_name = "Amazon S3 on Outposts"
      phz_name     = "s3-outposts.${var.region}.amazonaws.com"
    }
    #Amazon S3 Multi-Region Access Points	 Yes
    "s3-global.accesspoint" = {
      name         = "com.amazonaws.s3-global.accesspoint"
      service_name = "Amazon S3 Multi-Region Access Points"
      phz_name     = "accesspoint.s3-global.amazonaws.com"
      a_record     = "*"
    }
    #Amazon SageMaker	 Yes
    "notebook" = {
      name         = "aws.sagemaker.${var.region}.notebook"
      service_name = "Amazon SageMaker"
      phz_name     = "notebook.${var.region}.sagemaker.aws"
      a_record     = "*"
    }
    "studio" = {
      name         = "aws.sagemaker.${var.region}.studio"
      service_name = "Amazon SageMaker"
      phz_name     = "studio.${var.region}.sagemaker.aws"
      a_record     = "*"
    }
    "sagemaker.api" = {
      name         = "com.amazonaws.${var.region}.sagemaker.api"
      service_name = "Amazon SageMaker"
      phz_name     = "api.sagemaker.${var.region}.amazonaws.com"
    }
    "sagemaker.featurestore-runtime" = {
      name         = "com.amazonaws.${var.region}.sagemaker.featurestore-runtime"
      service_name = "Amazon SageMaker"
      phz_name     = "featurestore-runtime.sagemaker.${var.region}.amazonaws.com"
    }
    "sagemaker.runtime" = {
      name         = "com.amazonaws.${var.region}.sagemaker.runtime"
      service_name = "Amazon SageMaker"
      phz_name     = "runtime.sagemaker.${var.region}.amazonaws.com"
    }
    "sagemaker.runtime-fips" = {
      name         = "com.amazonaws.${var.region}.sagemaker.runtime-fips"
      service_name = "Amazon SageMaker"
      phz_name     = "runtime-fips.sagemaker.${var.region}.amazonaws.com"
    }
    #AWS Secrets Manager	 Yes
    secretsmanager = {
      name         = "com.amazonaws.${var.region}.secretsmanager"
      service_name = "AWS Secrets Manager"
      phz_name     = "secretsmanager.${var.region}.amazonaws.com"
    }
    #AWS Security Hub	 Yes
    securityhub = {
      name         = "com.amazonaws.${var.region}.securityhub"
      service_name = "AWS Security Hub"
      phz_name     = "securityhub.${var.region}.amazonaws.com"
    }
    #AWS Security Token Service	 Yes
    sts = {
      name         = "com.amazonaws.${var.region}.sts"
      service_name = "AWS Security Token Service"
      phz_name     = "sts.${var.region}.amazonaws.com"
    }
    #AWS Server Migration Service	 No
    awsconnector = {
      name         = "com.amazonaws.${var.region}.awsconnector"
      service_name = "AWS Server Migration Service"
      phz_name     = "awsconnector.${var.region}.amazonaws.com"
    }
    sms = {
      name         = "com.amazonaws.${var.region}.sms"
      service_name = "AWS Server Migration Service"
      phz_name     = "sms.${var.region}.amazonaws.com"
    }
    sms-fips = {
      name         = "com.amazonaws.${var.region}.sms-fips"
      service_name = "AWS Server Migration Service"
      phz_name     = "sms-fips.${var.region}.amazonaws.com"
    }
    #AWS Service Catalog	 Yes
    servicecatalog = {
      name         = "com.amazonaws.${var.region}.servicecatalog"
      service_name = "AWS Service Catalog"
      phz_name     = "servicecatalog.${var.region}.amazonaws.com"
    }
    servicecatalog-appregistry = {
      name         = "com.amazonaws.${var.region}.servicecatalog-appregistry"
      service_name = "AWS Service Catalog"
      phz_name     = "servicecatalog-appregistry.${var.region}.amazonaws.com"
    }
    #Amazon SES	 No
    email-smtp = {
      name         = "com.amazonaws.${var.region}.email-smtp"
      service_name = "Amazon SES"
      phz_name     = "email-smtp.${var.region}.amazonaws.com"
    }
    #AWS Snow Device Management	 Yes
    snow-device-management = {
      name         = "com.amazonaws.${var.region}.snow-device-management"
      service_name = "AWS Snow Device Management"
      phz_name     = "snow-device-management.${var.region}.amazonaws.com"
    }
    #Amazon SNS	 Yes
    sns = {
      name         = "com.amazonaws.${var.region}.sns"
      service_name = "Amazon SNS"
      phz_name     = "sns.${var.region}.amazonaws.com"
    }
    #Amazon SQS	 Yes
    sqs = {
      name         = "com.amazonaws.${var.region}.sqs"
      service_name = "Amazon SQS"
      phz_name     = "sqs.${var.region}.amazonaws.com"
    }
    #AWS Step Functions	 Yes
    states = {
      name         = "com.amazonaws.${var.region}.states"
      service_name = "AWS Step Functions"
      phz_name     = "states.${var.region}.amazonaws.com"
    }
    sync-states = {
      name         = "com.amazonaws.${var.region}.sync-states"
      service_name = "AWS Step Functions"
      phz_name     = "sync-states.${var.region}.amazonaws.com"
    }
    #AWS Storage Gateway	 No
    storagegateway = {
      name         = "com.amazonaws.${var.region}.storagegateway"
      service_name = "AWS Storage Gateway"
      phz_name     = "storagegateway.${var.region}.amazonaws.com"
    }
    #AWS Systems Manager	 Yes
    ec2messages = {
      name         = "com.amazonaws.${var.region}.ec2messages"
      service_name = "AWS Systems Manager"
      phz_name     = "ec2messages.${var.region}.amazonaws.com"
    }
    ssm = {
      name         = "com.amazonaws.${var.region}.ssm"
      service_name = "AWS Systems Manager"
      phz_name     = "ssm.${var.region}.amazonaws.com"
    }
    ssm-contacts = {
      name         = "com.amazonaws.${var.region}.ssm-contacts"
      service_name = "AWS Systems Manager"
      phz_name     = "ssm-contacts.${var.region}.amazonaws.com"
    }
    ssm-incidents = {
      name         = "com.amazonaws.${var.region}.ssm-incidents"
      service_name = "AWS Systems Manager"
      phz_name     = "ssm-incidents.${var.region}.amazonaws.com"
    }
    ssmmessages = {
      name         = "com.amazonaws.${var.region}.ssmmessages"
      service_name = "AWS Systems Manager"
      phz_name     = "ssmmessages.${var.region}.amazonaws.com"
    }
    #Amazon Textract	 Yes
    textract = {
      name         = "com.amazonaws.${var.region}.textract"
      service_name = "Amazon Textract"
      phz_name     = "textract.${var.region}.amazonaws.com"
    }
    textract-fips = {
      name         = "com.amazonaws.${var.region}.textract-fips"
      service_name = "Amazon Textract"
      phz_name     = "textract-fips.${var.region}.amazonaws.com"
    }
    #Amazon Transcribe	 Yes
    transcribe = {
      name         = "com.amazonaws.${var.region}.transcribe"
      service_name = "Amazon Transcribe"
      phz_name     = "transcribe.${var.region}.amazonaws.com"
    }
    transcribestreaming = {
      name         = "com.amazonaws.${var.region}.transcribestreaming"
      service_name = "Amazon Transcribe"
      phz_name     = "transcribestreaming.${var.region}.amazonaws.com"
    }
    #Amazon Transcribe Medical	 Yes
    transcribe = {
      name         = "com.amazonaws.${var.region}.transcribe"
      service_name = "Amazon Transcribe Medical"
      phz_name     = "transcribe.${var.region}.amazonaws.com"
    }
    #AWS Transfer for SFTP	 No
    transfer = {
      name         = "com.amazonaws.${var.region}.transfer"
      service_name = "AWS Transfer for SFTP"
      phz_name     = "transfer.${var.region}.amazonaws.com"
    }
    "transfer.server" = {
      name         = "com.amazonaws.${var.region}.transfer.server"
      service_name = "AWS Transfer for SFTP"
      phz_name     = "server.transfer.${var.region}.amazonaws.com"
      a_record     = "*"
    }
    #Amazon Translate	 Yes
    translate = {
      name         = "com.amazonaws.${var.region}.translate"
      service_name = "Amazon Translate"
      phz_name     = "translate.${var.region}.amazonaws.com"
    }
    #Amazon WorkSpaces	 Yes
    workspaces = {
      name         = "com.amazonaws.${var.region}.workspaces"
      service_name = "Amazon WorkSpaces"
      phz_name     = "workspaces.${var.region}.amazonaws.com"
    }
    #AWS X-Ray	 Yes
    xray = {
      name         = "com.amazonaws.${var.region}.xray"
      service_name = "AWS X-Ray"
      phz_name     = "xray.${var.region}.amazonaws.com"
    }
  }
}
