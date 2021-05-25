variable cf_space {}

variable web_app_instances {}

variable web_app_memory {}

variable web_app_host_name {}

variable worker_app_instances { default = 1 }

variable worker_app_memory {}

variable redis_service_plan {}

variable docker_image {}

variable dockerhub_credentials {}

variable logstash_url {}

variable app_environment {}

variable app_environment_variables { type = map }

locals {
  web_app_name         = "publish-teacher-training-${var.app_environment}"
  worker_app_name      = "publish-teacher-training-worker-${var.app_environment}"
  redis_service_name   = "publish-teacher-training-redis-${var.app_environment}"
  web_app_routes       = [cloudfoundry_route.publish_service_gov_uk_route, cloudfoundry_route.web_app_cloudapps_digital_route]
  logging_service_name = "publish-teacher-training-logit-${var.app_environment}"
}
