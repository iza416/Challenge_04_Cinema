*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   ../resources/api_variables.robot
Resource   ../resources/auth_keywords.robot
Test Setup    Create API Session

*** Test Cases ***
C1.1 - Cadastro de Novo Usuário com Dados Válidos
    [Documentation]    Valida o endpoint POST /auth/register
    
    # GERA E-MAIL ÚNICO CORRIGIDO
    ${timestamp}=    Get Time    epoch    # Obtém o tempo atual
    ${unique_email}=    Catenate    SEPARATOR=    teste_reg_${timestamp}@email.com
    
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=    Create Dictionary    name=${NEW_USER_NAME}    email=${unique_email}    password=${NEW_USER_PASSWORD}
    ${response}=    POST On Session    cinema_api    /auth/register    json=${body}    headers=${headers}
    
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[success]    True
    Should Contain    ${response.json()}[data]    token

C1.4 - Realizar Login com Credenciais Válidas
    [Documentation]    Valida o endpoint POST /auth/login, registrando um usuário no momento do teste.
    
    # 1. GERA E-MAIL ÚNICO PARA ESTE TESTE
    ${timestamp}=    Get Time    epoch
    ${login_email}=    Catenate    SEPARATOR=    teste_login_${timestamp}@email.com
    
    # 2. REGISTRA E LOGA O NOVO USUÁRIO
    ${token}=    Register And Perform Login    ${login_email}    ${NEW_USER_PASSWORD}
    Should Not Be Empty    ${token}