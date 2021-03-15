resource "aws_lb_target_group" "avis_front_tg" {
  name     = "avis-front-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.my_app.id}"
}

resource "aws_security_group" "alb_front_sg" {
  name        = "alb_front_sg"
  description = "Allow inbound traffic"
  vpc_id      = "${aws_vpc.my_app.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "avis_front_lb" {
  name               = "avis-front-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_front_sg.id}"]
  subnets            = ["${aws_subnet.public1.id}", "${aws_subnet.public2.id}"]
}

resource "aws_lb_listener" "avislistner" {
  load_balancer_arn = "${aws_lb.avis_front_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.avis_front_tg.arn}"
  }
}


resource "aws_lb_target_group" "avis_internal_tg" {
  name     = "avis-internal-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.my_app.id}"
}

resource "aws_lb" "avis_internal_lb" {
  name               = "avis-internal-lb-tf"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_front_sg.id}"]
  subnets            = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
}

resource "aws_lb_listener" "avis_internal_listner" {
  load_balancer_arn = "${aws_lb.avis_internal_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.avis_internal_tg.arn}"
  }
}