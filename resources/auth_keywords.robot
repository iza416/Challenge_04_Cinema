*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   ./api_variables.robot

*** Keywords ***
Create API Session
    [Documentation]    Cria a sessão de RequestsLibrary.
    Create Session    cinema_api    ${API_URL}    verify=True

Set Admin Token
    [Arguments]    ${token}
    Set Suite Variable    ${ADMIN_TOKEN}    ${token}

Set User Token
    [Arguments]    ${token}
    Set Suite Variable    ${USER_TOKEN}    ${token}

Perform Valid Login
    [Arguments]    ${email}    ${password}
    [Documentation]    Realiza login e retorna o token JWT.
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST On Session    cinema_api    /auth/login    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[success]    True
    ${token}=    Set Variable    ${response.json()}[data][token]
    [Return]    ${token}


Register And Perform Login
    [Arguments]    ${email}    ${password}    ${name}=New Test User    ${role}=user  # <-- ADICIONE O ARGUMENTO ${role}
    [Documentation]    Registra um novo usuário e faz login imediatamente.
    
    # 1. Registro (Endpoint POST /auth/register)
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=    Create Dictionary    email=${email}    password=${password}    name=${name}    role=${role} # <-- INCLUA ROLE NO BODY
    ${response}=    POST On Session    cinema_api    /auth/register    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    
    
    ${token}=    Perform Valid Login    ${email}    ${password}
    [Return]    ${token}

Setup Authentication Tokens
    [Documentation]    Registra/loga novos usuários Admin e User para garantir tokens válidos.
    
    # GERA E-MAIL ÚNICO PARA O NOVO USUÁRIO ADMIN E COMUM
    ${timestamp}=    Get Time    epoch
    ${admin_email}=    Catenate    SEPARATOR=    robot_admin_${timestamp}@example.com
    ${user_email}=    Catenate    SEPARATOR=    robot_user_${timestamp}@example.com

    
    ${admin_token}=    Register And Perform Login    ${admin_email}    ${ADMIN_PASSWORD}    Robot Admin    admin
    Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}
    Log To Console    Admin Token obtido.

    
    ${user_token}=    Register And Perform Login    ${user_email}    ${NEW_USER_PASSWORD}    Robot User
    Set Suite Variable    ${USER_TOKEN}    ${user_token}
    Log To Console    User Token obtido.