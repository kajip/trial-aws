/** LoadBalancer 定義 */

// Target Group
resource "aws_lb_target_group" "trial" {
  name     = "trial"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${aws_default_vpc.default.id}"

  health_check {
    path = "/hello"
    timeout = 5
    interval = 15
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

// Listener
resource "aws_lb_listener" "trial" {
  load_balancer_arn = "${aws_lb.trial.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.trial.arn}"
    type             = "forward"
  }
}

// LB
resource "aws_lb" "trial" {
  name            = "trial-lb"
  internal        = false
  load_balancer_type = "application"
  security_groups = [
    "${aws_default_security_group.default.id}",
    "${aws_security_group.allow_http.id}"
  ]
  subnets         = [
    "${var.subnet_id_a}",
    "${var.subnet_id_c}"
  ]

//  enable_deletion_protection = true

//  access_logs {
//    bucket = "${aws_s3_bucket.lb_logs.bucket}"
//    prefix = "trial-lb"
//  }

//  tags {
//    Environment = "production"
//  }
}