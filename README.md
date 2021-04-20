# Mood Detector
Aplicativo que busca os tweets mais recentes de um usuário e, utilizando a API de Natural Language do Google, analisa e exibe o sentimento do tweet selecionado.

Projeto desenvolvido utilizando MVVM-C, padrão escolhido pelo tamanho e complexidade do projeto.
Também foi utilizado Combine, um framework Rx que venho estudando atualmente e este projeto foi usado como prática.

## Bibliotecas
Não foram utilizadas bibliotecas de terceiros.

## Execução
É necessário incluir uma classe `APIKeys` que implementa o protocolo `APIKeysProtocol` no projeto com as chaves de segurança das API do Twitter e Google.

## Demo
![Vídeo](simulator.mp4)

## Testes
Cobertura de 83% em testes unitários.
