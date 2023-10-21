## Padronização das Tags

Este módulo visa padronizar a criação de tags que são obrigatórias para os recursos criados no projeto. 
A partir das tags vamos conseguir identificar os recursos criados para o projeto e também conseguir gerenciar os custos dos recursos.

O modelo de tags pensado foi baseado em um modelo de negócios com:

> Unidades de Negócio, Tribos e Squads

> Ambientes distintos (QA, PROD, DEV, etc)

> Tipos de recursos (EC2, RDS, S3, etc)

A partir das tags especificadas, podemos identificar os recursos de cada parte do modelo de negócios, combinando com o ambiente e o tipo de recurso, para entender os diferentes custos de cada infraestrutura e de cada produto.

A tag `Name` está comentada no módulo, pois apesar de não está sendo usada, é possível utilizar para padronizar o nome dos recursos, caso seja um interesse.