# ECR REPOSITORY
resource "aws_ecrpublic_repository" "ecr" {

  repository_name = "ecr"
}





# ECS CLUSTER
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "clusterDev"
}





# TASK DEFINITION -1
resource "aws_ecs_task_definition" "task-1" {
  family                   = "HTTPserver"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "${data.aws_iam_role.ecs-task.arn}"

  container_definitions = jsonencode([
    {
      name   = "golang-container-1"
      image  =  aws_ecrpublic_repository.ecr.repository_uri #URI
      cpu    = 256
      memory = 512
      portMappings = [
        {
          containerPort = 80
        }
      ]
    }
  ])
}









# ECS SERVICE-1
resource "aws_ecs_service" "svc-1" {
  name            = "golang-Service-1"
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task-1.id}"
  desired_count   = 1
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = ["${aws_subnet.pub-subnets[0].id}", "${aws_subnet.pub-subnets[1].id}"]
    security_groups  = ["${aws_security_group.sg2.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
    container_name   = "golang-container-1"
    container_port   = "80"
  }
}



