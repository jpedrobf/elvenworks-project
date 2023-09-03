# elvenworks-project
Projeto final do curso da elvenworks

![projeto](/docs/diagrams/projeto.png)

## Overview
  Criação de infraestrutura de redes, utilizando Terraform para criar AWS VPC e um Internet Gateway associando subnets publicas. NAT Gateways associados às subnets privadas 

  Criação de um AWS EKS para orquestração de aplicações em kubernetes. Popular o EKS com um nodegroup dedicado a stack de observabilidade (Prometheus) e um nodegroup para as aplicações.

  Gerenciar os critical-addons utilizando o Helm tornando o cluster pronto para gerenciar aplicações de uma hipotética equipe de desenvolvimento. 

  Popular os recursos criados com as tags necessárias, distinguindo BU (unidade de negócio), responsabilidade de uso e categoria, possibilitando o acompanhamento via Cost Explorer ou outra ferramenta de acompanhamento de custos.

## Redes
- VPC
- Subnets Publicas e Privadas
- Security Group
- Nat Gateway
- Internet Gateway


## Infra
- EKS
- Nodegroup
- Helmfile?

