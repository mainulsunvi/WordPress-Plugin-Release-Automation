import boto3
from api4jenkins import Jenkins
from time import sleep

awsAccessKey = input("Enter AWS Access Key: ")
awsSeretKey = input("Enter AWS Secret Key: ")
awsRegion = 'us-east-1'
dockerHubPass = input("Enter Docker Hub Password: ")

session = boto3.client(
    'ec2',
    aws_access_key_id = awsAccessKey,
    aws_secret_access_key = awsSeretKey,
    region_name = awsRegion
    
)

response = session.describe_instances (
     Filters=[
        {
            'Name': 'tag:Name',
            'Values': ['jenkins-server']
        },
        {
            'Name': 'instance.group-name',
            'Values': ['launch-wizard-2']
		}
    ]
)
instances = response['Reservations'][0]["Instances"]

for instance in instances:
    public_ip = instance['PublicIpAddress']


server = Jenkins(f"http://{public_ip}:8080", auth=('admin', 'ca18edb5bddb479db244d081a8606e6b'))

xmlPayload = f'''<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
  <id>dockerHub</id>
  <username>msunvi</username>
  <password>{dockerHubPass}</password>
  <description>Docker Hub Credentials</description>
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>'''

server.credentials.create(xmlPayload)

credentials = server.credentials.get('dockerHub')

print(credentials)