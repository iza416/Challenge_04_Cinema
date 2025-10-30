

# 🎬 Automação de Testes do Sistema de Cinema (Challenge 04)

Este projeto contém a suíte de testes de automação desenvolvida com **Robot Framework** para validar a estabilidade e segurança do sistema de gerenciamento de cinema (API e Front End Web).

## 🎯 Explicação do Projeto

O objetivo principal desta automação é garantir a qualidade das funcionalidades mais críticas do sistema. A suíte é dividida em duas grandes áreas, cada uma focada em uma camada diferente:

1.  **Back End Testes (API):** Focado em validações de **Controle de Acesso (Autorização)**, autenticação de usuários e correta manipulação dos *endpoints* (`/auth`, `/movies`, `/reservations`).
2.  **Front End Testes (Web):** Focado na experiência do usuário final, validando a navegação, o login e, principalmente, o **Fluxo Crítico de Reserva de Ingressos**.

### Cenários Independentes

Todos os Test Cases são projetados para serem **independentes**. Por exemplo, antes de testar a criação de filmes (`C2.4`), o *setup* garante a obtenção de tokens Admin e User válidos. Para testes de registro e login, e-mails dinâmicos são criados usando `timestamp` para evitar falhas por dados preexistentes.

-----

## 🛠️ Configuração e Execução

### Pré-requisitos

  * **Python:** Versão 3.x
  * **PIP:** Gerenciador de pacotes do Python.
  * **Drivers de Navegador:** Necessário ter o driver correspondente ao navegador (`Chrome`  ou outro) instalado e acessível no PATH para os testes de Front End.
  * **Serviços Locais:** Os serviços de Back End (`${API_URL}` = `http://localhost:3000/api/v1` [cite: 13][cite\_start]) e Front End (`${FRONTEND_URL}` = `http://localhost:3002` devem estar rodando.

### Configuração do Ambiente

1.  **Instale as Bibliotecas:**
    ```bash
    # Robot Framework, RequestsLibrary, SeleniumLibrary, etc.
    $ pip install robotframework robotframework-requests robotframework-seleniumlibrary
    ```
2.  **Verifique as Variáveis:** Confirme se as URLs e credenciais em `resources/api_variables.robot` e `resources/web_keywords.robot`  correspondem ao seu ambiente.

### Como Executar os Testes

| Conjunto de Testes | Comando de Execução |
| :--- | :--- |
| **Todos os Testes (Full Suite)** | `$ robot .` |
| **Apenas Back End (API)** | `$ robot back_end_testes/` |
| **Apenas Front End (Web)** | `$ robot front_end_testes/` |
| **Teste Específico** | `$ robot back_end_testes/movies_test.robot` |

-----

## 🏗️ Estrutura do Projeto e Padrões Aplicados

A suíte adota um padrão de organização claro para garantir a reusabilidade e a manutenibilidade.

| Pasta/Arquivo | Padrão Aplicado | Validações e Uso |
| :--- | :--- | :--- |
| `resources/auth_keywords.robot` | **ServiceObjects** | Contém a lógica de autenticação (`Perform Valid Login` , `Register And Perform Login` ) e a gestão dos tokens Admin/User. Abstrai chamadas diretas à API de autenticação. |
| `resources/web_keywords.robot` | **AppActions / PageObjects (Simples)** | Contém as palavras-chave de alto nível para interação com a UI (`Perform User Login` , `Select Available Seat` , `Proceed To Checkout And Pay` ). Abstrai localizadores do Selenium. |
| `back_end_testes/` | Cenários de **Validação de API** | Focado em verificar códigos de *status* (200, 201, 401, 403), corpo de resposta (`success=True`) e dados retornados. |
| `front_end_testes/` | Cenários de **Fluxo de UI** | Garante que a aplicação Web funcione conforme o design (e.g., `US-HOME-001` verifica elementos da página inicial ). |

-----

## 🔒 Validações Críticas e Cenários Complexos

### 1\. Cenário Mais Complexo (Back End: Autorização)

O teste **`C2.4 - Administrador Cria um Novo Filme`**  valida a segurança da rota `POST /movies`:

  * **Fluxo:** Obter Admin Token -\> Enviar `POST /movies` com *header* `Authorization: Bearer ${ADMIN_TOKEN}`[cite: 29].
  * **Validação Esperada:** Retorno de *status* `201 Created`.
  * **Status Atual (BUG):** Nos testes recentes, este cenário falhou, retornando **`403 Client Error: Forbidden`**. Isso indica uma falha na lógica de *middleware* do Back End, onde o token de Administrador não está sendo reconhecido ou autorizado para a ação de criação de conteúdo.

### 2\. Cenário Mais Complexo (Front End: Fluxo de Reserva)

O teste de reserva valida a jornada mais longa do usuário:

  * **Fluxo:** Navegação para Filmes -\> Seleção de Detalhes -\> Seleção de Assentos  -\> Confirmação de Pagamento.
  * **Validação:** O fluxo deve terminar com a verificação da mensagem **`Reserva Confirmada`** e o `ID da Reserva`.

### 3\. Validação de Segurança (Acesso Não Autorizado)

O teste **`C4.4 - Acesso Não Autorizado ao Histórico de Reservas`** confirma que o endpoint `/reservations/me` está protegido.

  * **Validação:** A requisição sem um token de autorização retorna o *status* **`401 Unauthorized`**.

    Aplicação Testada:

    back-end: https://github.com/juniorschmitz/cinema-challenge-back
    front-end: https://github.com/juniorschmitz/cinema-challenge-front
