## Criação da VPC e recursos de redes

Etapa inicial onde criamos uma VPC para o projeto, utilizado tanto para ambientes de QA quanto PROD

#### Inputs a serem considerados

* Nome da VPC
* Região da VPC
* AZ's em que teremos subnets
* Tags particulares dos recursos de rede



Ideia de distribuição de subnets:
1 publica /22 por zona
1 reservada /22 por zona (para criação de estruturas privadas como redis e rds)
1 privada /19 por zona (para uso do EKS e distribuição de IPs para os nodes/pods)

Há uma folga de IPs entre cada tipo de subnet para a possível necessidade de expansão.

| Tipo     	| AZ 	| cidr          	|
|----------	|----	|---------------	|
| Public   	| 1  	| 192.168.0.0/22   	|
| Public   	| 2  	| 192.168.4.0/22   	|
| Public   	| 3  	| 192.168.8.0/22  	|
| Reserved 	| 1  	| 192.168.16.0/22  	|
| Reserved 	| 2  	| 192.168.20.0/22  	|
| Reserved 	| 3  	| 192.168.24.0/22  	|
| Private  	| 1  	| 192.168.32.0/19  	|
| Private  	| 2  	| 192.168.64.0/19  	|
| Private  	| 3  	| 192.168.96.0/19  	|


A criação de VPC foi baseada no [módulo público da AWS](https://github.com/terraform-aws-modules/terraform-aws-vpc), com algumas alterações para atender as necessidades do projeto. 
Para exemplificar uma forma de estruturar o código, separamos os parametros a serem definidos pelo usuário como variaveis no arquivo `variables.tf` e as configurações padrões do módulo no arquivo `main.tf`.