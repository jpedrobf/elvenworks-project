## Criação do EKS e seus recursos

Nesta etapa criamos o cluster do EKS e seus recursos, como nodegroups, roles, security groups, etc. 
O cluster é criado na VPC criada anteriormente, utilizando as subnets privadas para a criação dos nodes e pods. Utilizamos de todas as AZ's da região, para garantir máxima disponibilidade.

É criado um nodegroup de `Monitoring`, que será usado exclusivamente para recursos de monitoramento, como Prometheus, Grafana, etc. Este nodegroup é separado devido ao grande uso de recurso que o Prometheus pode ter, garantindo que o monitoramento não causará impacto nas aplicações a rodarem no cluster.

O outro nodegroup criado se chama `Apps1` como um exemplo, onde rodarão as aplicações do proejto. Por motivos de simplificação, é o único nodegroup de aplicações, porém pode ser facilmente replicado para outros nodegroups, caso seja necessário.
    * Um outro modelo que pode ser seguido (e pessoalmente me agrada mais), é o modelo de nodegroups por tipo de perfomance. Por exemplo, um nodegroup `compute`, com máquinas da família C, para aplicações que utilizam mais CPU (geralmente um ratio cpu:mem 1:2), um nodegroup `memory`, com máquinas da família R (ratio cpu:mem 1:10), para aplicações que utilizam mais memória e um nodegroup `general`, com máquinas da família M, para aplicações que utilizam uma proporção balanceada. Este modelo é mais complexo, porém permite uma melhor utilização dos recursos, com um melhor custo benefício, agrupando containers com necessidades similares em um mesmo nodegroup e permitindo uma melhor alocação de recursos. Nesse cenário, um nodegroup não é criado para cada aplicação, mas sim para cada tipo de aplicação, com necessidades similares de recursos.

Para a criação do cluster, utilizamos o [módulo público da AWS](https://github.com/terraform-aws-modules/terraform-aws-eks). 

Para exemplificar uma segunda forma de estruturar o código, separamos os parametros a serem definidos pelo usuário como parametros no arquivo `local.tf` e as configurações padrões do módulo no arquivo `main.tf`.

Como o EKS é um recurso mais volátil, com alterações mais frequentes, foi criado como um projeto separado da VPC, para garantir que o estado da VPC não seja alterado sem a devida atenção.

---

Há melhorias a serem implementadas no terraform do cluster para que seja um projeto mais completo, como criar os "one-shot addons" que são críticos em todo ambiente. No terraform é criado o core-dns, aws-node e kube-proxy, porém há outros addons que são importantes, como:

    * Metrics Server                -- Usado para habilitar métricas de usage de pods e nodes, habilitando o HPA (Horizontal Pod Autoscaler)
    * AWS Load Balancer Controller  -- Usado para criar Load Balancers do tipo ALB e NLB
    * Cluster Autoscaler            -- Usado para escalar os worklodas do cluster de acordo com a necessidade de recursos
    * External DNS                  -- Usado para criar registros DNS no Route53 de acordo com os serviços criados no cluster
    * Node Local DNS Cache          -- Usado para criar um cache local de DNS nos nodes, melhorando a performance de resolução de DNS e evitando problemas como conntrack racing
    * Dns Autoscaler                -- Usado para escalar o core-dns de acordo com o crescimento do cluster
    * Stack de monitoramento        -- Usado para criar o Prometheus, Grafana, Alertmanager, etc

Para isso, pode ser usado o [helmfile](https://github.com/helmfile/helmfile).
