# Creating-AWS-resources-using-Terraform
Creating AWS networking resources with Terraform


1. Setup the Virtual Private Cloud (VPC):

    VPC stands for Virtual Private Cloud (VPC). It is a virtual network where you create and manage your AWS resource in a more secure and scalable manner. Go to the VPC section     of the AWS services, and click on the Create VPC button.

    Give your VPC a name and a CIDR block of 10.0.0.0/16


2. Setup the Internet Gateway


3. Create 4 Subnets:

    The subnet is a way for us to group our resources within the VPC with their IP range. A subnet can be public or private. EC2 instances within a public subnet have public IPs     and can directly access the internet while those in the private subnet does not have public IPs and can only access the internet through a NAT gateway.
    
    For our setup, we shall be creating the following subnets with the corresponding IP ranges.
    
    demo-public-subnet-1 | CIDR (10.0.1.0/24) | Availability Zone (us-east-1a)
    
    demo-public-subnet-2 | CIDR (10.0.2.0/24) | Availability Zone (us-east-1b)
    
    demo-private-subnet-3 | CIDR (10.0.3.0/24) | Availability Zone (us-east-1a)
    
    demo-private-subnet-4 | CIDR(10.0.4.0/24) | Availability Zone (us-east-1b)


4. Create Two Route Tables: 

    We need two route tables; private route table and public route table. The public route table will define which subnets that will have direct access to the internet ( ie.         public subnets) while the private route table will define which subnet goes through the NAT gateway (ie private subnet).
 
    The public and the private subnet needs to be associated with the public and the private route table respectively.
    
    To do that, we select the route table and then choose the Subnet Association tab.


5. Create the NAT Gateway: 

    The NAT gateway enables the EC2 instances in the private subnet to access the internet. The NAT Gateway is an AWS managed service for the NAT instance. To create the NAT         gateway, navigate to the NAT Gateways page, and then click on the Create NAT Gateway.
    
    Please ensure that you know the Subnet ID for the demo-public-subnet-2. This will be needed when creating the NAT gateway.


6. Create Elastic Load Balancer: 

    From our architecture, our frontend tier can only accept traffic from the elastic load balancer which connects directly with the internet gateway while our backend tier will     receive traffic through the internal load balancer. The essence of the load balancer is to distribute load across the EC2 instances serving that application. If however, the     application is using sessions, then the application needs to be rewritten such that sessions can be stored in either the Elastic Cache or the DynamoDB. To create the two         load balancers needed in our architecture, we navigate to the Load Balancer page and click on Create Load Balancer.
    
    a. Select the Application Load Balancer.
    
    b. Configure the Load Balancer with a name. Select internet facing for the load balancer that we will use to communicate with the frontend and internal for the one we will           use for our backend.
    
    c. Under the Availability Zone, for the internet facing Load Balancer, we will select the two public subnets while for our internal Load Balancer, we will select the two             private subnet.
    
    d. Under the Security Group, we only need to allow ports that the application needs. For instance, we need to allow HTTP port 80 and/or HTTPS port 443 on our internet facing         load balancer. For the internal load balancer, we only open the port that the backend runs on (eg: port 3000) and the make such port only open to the security group of           the frontend. This will allow only the frontend to have access to that port within our architecture.
    
    e. Under the Configure Routing, we need to configure our Target Group to have the Target type of instance. We will give the Target Group a name that will enable us to               identify it. This is will be needed when we will create our Auto Scaling Group. For example, we can name the Target Group of our frontend to be Demo-Frontend-TG
        Skip the Register Targets and then go ahead and review the configuration


7. Auto Scaling Group: 

    We can simply create like two EC2 instances and directly attach these EC2 instances to our load balancer. The problem with that is that our application will no longer scale     to accommodate traffic or shrink when there is no traffic to save cost. With Auto Scaling Group, we can achieve this feat. Auto Scaling Group is can automatically adjust the     size of the EC2 instances serving the application based on need. This is what makes it a good approach rather than directly attaching the EC2 instances to the load balancer.
