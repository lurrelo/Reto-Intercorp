# Reto-Intercorp
# 1. Desplegar un contenedor de docker de Jenkins.

Pasos para la ejecución

1.1. git clone https://github.com/lurrelo/Reto-Intercorp.git

1.2. terraform init

1.3. terraform plan

1.4. terraform apply -auto-approve

Nota: Se debe contar con credenciales de acceso (Service Principal, Tenant ID, Client ID, Client Secret) para las pruebas de un nuevo despliegue DE infraestructura.

Infraestructura desplegada.

a. Virtual Network

b. Subnet

c. Network Security Group

d. Public IP

e. Network Interface

f. Virtual Machine

g. Virtual Machine extension

h. Storage Account

i. Storage Container

J. Kubernetes Cluster.

# Jenkis

http://52.167.55.111:8080/

usuario: lurrelo

password: moss2007

# 2. Job de Build

Pasos para la ejecución

2.1. git clone https://github.com/lurrelo/application-springboot.git

  2.2. Job de Jenkins: build-job

# 3. Job de pruebas unitarias

  3.1. Job de Jenkins: unit-test

3.2. Se ejecuta si el Job "build-job" acabo bien.

  3.2.1. Ejecuta pruebas unitarias

  3.2.2. empaqueta el JAR (Docker)

  3.2.3. Deploya el Jar a un docker hub.

# 4 Job de pruebas integrales

4.1 git clone https://github.com/lurrelo/application-springboot-test.git

4.2. Job de Jenkins: integration-test

4.3. Se ejecuta si el Job "unit-test" acabo bien.

4.3.1. A través de newman ejecuta el collection runer (formato JSON) de la API expuesta en el servicio dockerizado (ver ruta mas abajo) y entrega resultados en LOGs.

# 5 Job de Despliegue en Azure Kubernetes Services

5.1. Job de Jenkins: deploy-aks

5.2. El servicio expone un método GET en la ruta http://52.167.49.64:8080/

5.3. git clone https://github.com/lurrelo/application-springboot
