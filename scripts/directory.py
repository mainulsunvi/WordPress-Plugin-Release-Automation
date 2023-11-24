
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