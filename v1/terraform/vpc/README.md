## Criação da VPC e recursos de redes

Etapa inicial onde criamos uma VPC para o projeto, utilizado tanto para ambientes de QA quanto PROD

#### Inputs a serem considerados

* Nome da VPC
* Região da VPC
* AZ's em que teremos subnets
* Tags particulares dos recursos de rede



Ideia de distribuição de subnets:
1 publica /22 por zona
1 reservada /22 por zona (para criação de estruturas como redis e rds)
1 privada /19 por zona (para uso do EKS e distribuição de IPs para os nodes/pods)


| Tipo     	| AZ 	| cidr          	|
|----------	|----	|---------------	|
| Public   	| 1  	| 10.0.0.0/22   	|
| Public   	| 2  	| 10.0.4.0/22   	|
| Public   	| 3  	| 10.0.8.0/22   	|
| Public   	| 4  	| 10.0.12.0/22  	|
| Reserved 	| 1  	| 10.0.16.0/22  	|
| Reserved 	| 2  	| 10.0.20.0/22  	|
| Reserved 	| 3  	| 10.0.24.0/22  	|
| Reserved 	| 4  	| 10.0.28.0/22  	|
| Private  	| 1  	| 10.0.32.0/19  	|
| Private  	| 2  	| 10.0.64.0/19  	|
| Private  	| 3  	| 10.0.96.0/19  	|
| Private  	| 4  	| 10.0.128.0/19 	|