*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   ../resources/api_variables.robot
Resource   ../resources/auth_keywords.robot


Test Setup    Create API Session 

*** Test Cases ***
C2.1 - Acessar a Lista de Filmes (Acesso Público)
    [Documentation]    GET /movies deve retornar status 200 e uma lista de filmes.
    ${response}=    GET On Session    cinema_api    /movies
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[success]    True
    ${movies}=    Set Variable    ${response.json()}[data]
    Should Not Be Empty    ${movies}
    Dictionary Should Contain Key    ${movies}[0]    title

C2.4 - Administrador Cria um Novo Filme
    [Documentation]    POST /movies - Apenas Admin pode criar.
    
    
    Setup Authentication Tokens
    
    
    Run Keyword If    '${ADMIN_TOKEN}' == '${EMPTY}'    Fail    Token Admin não foi obtido.
    
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ADMIN_TOKEN}
    ${movie_body}=    Create Dictionary    title=Filme Teste Robot    genre=[Ação, Comédia]    releaseDate=2025-01-01    duration=120
    ${response}=    POST On Session    cinema_api    /movies    json=${movie_body}    headers=${headers}
    
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[success]    True
    Should Be Equal As Strings    ${response.json()}[data][title]    Filme Teste Robot