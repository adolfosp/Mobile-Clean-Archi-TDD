Feature: Login
Como um cliente
Quero poder acessar minha conta e me manter Iogado
Para que eu possa ver e responder enquetes de forma rápida

Scenario: Credenciais Válidas
Given: Dado que o cliente informou credenciais válidas
When: Quando solicitar para fazer login
Then: Então o sistema deve enviar o usuário para a tela de pesquisas
And: E manter o usuário conectado

Scenario: Credenciais Inválidas
Given: Dado que o cliente informou credenciais inválidas
When: Quando solicitar para fazer login
Then: Então o sistema deve retornar uma mensagem de erro