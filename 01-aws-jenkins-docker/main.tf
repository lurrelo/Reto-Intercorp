provider "aws" {
    access_key              = "${var.access_key}"
    secret_key              = "${var.secret_key}"
    region                  = "${var.region}"
    # shared_credentials_file = "/root/.aws/credentials"
    # profile                 = "terraform"
}

resource "aws_instance" "jenkins_server" {

    ami                    = "${var.ami}"
    instance_type          = "${var.instance_type}"
    key_name               = "${var.key_name}"
    user_data              = "${file("$(path.module)/data/docker-jenkins.sh")}"
    vpc_security_group_ids = ["${aws_security_group.jenkins_server_security.id}"]
    tags {
        Name = "${var.jenkins_tag_name}"
    }
}

resource "aws_security_group" "jenkins_server_security" {
    name = "${var.jenkins_tag_name}_security"
    # acceso web a servidor jenkins
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Acceso SSH (caso troubleshooting)
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.jenkins_tag_name}_security"
    }
}
    resource "aws_instance" "app_server" {

    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    user_data = "${file("$(path.module)/data/docker.sh")}"
    vpc_security_group_ids = ["${aws_security_group.app_server_security}"]
    
    tags {
        Name = "${var.app_tag_name}"
    }
}
    resource "aws_security_group" "app_server_security" {
    name = "${var.jenkins_tag_name}_security"
    # acceso web a servidor de aplicaciones
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Acceso SSH (caso troubleshooting)
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.app_tag_name}_security"
    }

}
