data "aws_iam_role" "codedeploy_service_role" {
  name = "CodeDeployServiceRole"
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = data.aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/CodeDeployServiceRole"
}

resource "aws_codedeploy_app" "strapi_app" {
  name             = "strapi-codedeploy-app"
  compute_platform = "ECS"
}



resource "aws_codedeploy_deployment_group" "strapi_deploy_group" {
  app_name               = aws_codedeploy_app.strapi_app.name
  deployment_group_name = "strapi-deployment-group"
  service_role_arn       = data.aws_iam_role.codedeploy_service_role.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  
  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                              = "TERMINATE"
      termination_wait_time_in_minutes    = 5
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.strapi_cluster.name
    service_name = aws_ecs_service.strapi_service.name
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = aws_lb_target_group.blue.name
      }
      target_group {
        name = aws_lb_target_group.green.name
      }

      prod_traffic_route {
        listener_arns = [aws_lb_listener.http.arn]
      }
    }
  }
}
