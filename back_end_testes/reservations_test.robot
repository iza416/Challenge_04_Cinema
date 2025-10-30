*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   ../resources/api_variables.robot
Resource   ../resources/auth_keywords.robot

# Removemos o Setup que falha em cascata. O login será chamado por teste.
Test Setup    Create API Session

*** Test Cases ***
C4.4 - Usuário Logado Acessa Seu Histórico de Reservas
    [Documentation]    GET /reservations/me - Apenas usuário logado pode acessar.
    
    
    Setup Authentication Tokens
    
    
    Run Keyword If    '${USER_TOKEN}' == '${EMPTY}'    Fail    Token de Usuário não foi obtido.
    
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${USER_TOKEN}
    ${response}=    GET On Session    cinema_api    /reservations/me    headers=${headers}
    
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[success]    True
    Log    Histórico de reservas acessado com sucesso.

C4.4 - Acesso Não Autorizado ao Histórico de Reservas
    [Documentation]    GET /reservations/me sem token deve falhar.
    
    
    ${response}=    GET On Session    cinema_api    /reservations/me    expected_status=401
    
    
    Should Be Equal As Strings    ${response.status_code}    401
    
    
