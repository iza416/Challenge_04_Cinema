

# 🎬 Automação de Testes do Sistema de Cinema (Challenge 04)

Este projeto contém a suíte de testes de automação desenvolvida com **Robot Framework** para validar a estabilidade e segurança do sistema de gerenciamento de cinema (API e Front End Web).

## 🎯 Explicação do Projeto

O objetivo principal desta automação é garantir a qualidade das funcionalidades mais críticas do sistema. A suíte é dividida em duas grandes áreas, cada uma focada em uma camada diferente:

1.  **Back End Testes (API):** Focado em validações de **Controle de Acesso (Autorização)**, autenticação de usuários e correta manipulação dos *endpoints* (`/auth`, `/movies`, `/reservations`).
2.  **Front End Testes (Web):** Focado na experiência do usuário final, validando a navegação, o login e, principalmente, o **Fluxo Crítico de Reserva de Ingressos**.

### Cenários Independentes

[cite\_start]Todos os Test Cases são projetados para serem **independentes**[cite: 35]. [cite\_start]Por exemplo, antes de testar a criação de filmes (`C2.4`), o *setup* garante a obtenção de tokens Admin e User válidos[cite: 7, 8, 9]. [cite\_start]Para testes de registro e login, e-mails dinâmicos são criados usando `timestamp` para evitar falhas por dados preexistentes[cite: 31, 34].

-----

## 🛠️ Configuração e Execução

### Pré-requisitos

  * **Python:** Versão 3.x
  * **PIP:** Gerenciador de pacotes do Python.
  * [cite\_start]**Drivers de Navegador:** Necessário ter o driver correspondente ao navegador (`Chrome` [cite: 15] ou outro) instalado e acessível no PATH para os testes de Front End.
  * [cite\_start]**Serviços Locais:** Os serviços de Back End (`${API_URL}` = `http://localhost:3000/api/v1` [cite: 13][cite\_start]) e Front End (`${FRONTEND_URL}` = `http://localhost:3002` [cite: 15]) devem estar rodando.

### Configuração do Ambiente

1.  **Instale as Bibliotecas:**
    ```bash
    # Robot Framework, RequestsLibrary, SeleniumLibrary, etc.
    $ pip install robotframework robotframework-requests robotframework-seleniumlibrary
    ```
2.  [cite\_start]**Verifique as Variáveis:** Confirme se as URLs e credenciais em `resources/api_variables.robot` e `resources/web_keywords.robot` [cite: 13, 15] correspondem ao seu ambiente.

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
| `resources/auth_keywords.robot` | **ServiceObjects** | [cite\_start]Contém a lógica de autenticação (`Perform Valid Login` [cite: 3][cite\_start], `Register And Perform Login` [cite: 6][cite\_start]) e a gestão dos tokens Admin/User[cite: 7, 8, 9]. Abstrai chamadas diretas à API de autenticação. |
| `resources/web_keywords.robot` | **AppActions / PageObjects (Simples)** | [cite\_start]Contém as palavras-chave de alto nível para interação com a UI (`Perform User Login` [cite: 19][cite\_start], `Select Available Seat` [cite: 22][cite\_start], `Proceed To Checkout And Pay` [cite: 23]). [cite\_start]Abstrai localizadores do Selenium[cite: 21]. |
| `back_end_testes/` | Cenários de **Validação de API** | [cite\_start]Focado em verificar códigos de *status* (200, 201, 401, 403), corpo de resposta (`success=True`) e dados retornados[cite: 27, 30]. |
| `front_end_testes/` | Cenários de **Fluxo de UI** | [cite\_start]Garante que a aplicação Web funcione conforme o design (e.g., `US-HOME-001` verifica elementos da página inicial [cite: 11]). |

-----

## 🔒 Validações Críticas e Cenários Complexos

### 1\. Cenário Mais Complexo (Back End: Autorização)

[cite\_start]O teste **`C2.4 - Administrador Cria um Novo Filme`** [cite: 28] valida a segurança da rota `POST /movies`:

  * [cite\_start]**Fluxo:** Obter Admin Token -\> Enviar `POST /movies` com *header* `Authorization: Bearer ${ADMIN_TOKEN}`[cite: 29].
  * [cite\_start]**Validação Esperada:** Retorno de *status* `201 Created`[cite: 30].
  * **Status Atual (BUG):** Nos testes recentes, este cenário falhou, retornando **`403 Client Error: Forbidden`**. Isso indica uma falha na lógica de *middleware* do Back End, onde o token de Administrador não está sendo reconhecido ou autorizado para a ação de criação de conteúdo.

### 2\. Cenário Mais Complexo (Front End: Fluxo de Reserva)

O teste de reserva valida a jornada mais longa do usuário:

  * [cite\_start]**Fluxo:** Navegação para Filmes [cite: 21] [cite\_start]-\> Seleção de Detalhes -\> Seleção de Assentos [cite: 25] [cite\_start]-\> Confirmação de Pagamento[cite: 23].
  * [cite\_start]**Validação:** O fluxo deve terminar com a verificação da mensagem **`Reserva Confirmada`** e o `ID da Reserva`[cite: 24].

### 3\. Validação de Segurança (Acesso Não Autorizado)

[cite\_start]O teste **`C4.4 - Acesso Não Autorizado ao Histórico de Reservas`** [cite: 39] confirma que o endpoint `/reservations/me` está protegido.

  * [cite\_start]**Validação:** A requisição sem um token de autorização retorna o *status* **`401 Unauthorized`**[cite: 40].

    Aplicação Testada:

    back-end: https://github.com/juniorschmitz/cinema-challenge-back
    front-end: https://github.com/juniorschmitz/cinema-challenge-front
