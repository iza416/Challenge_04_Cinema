*** Settings ***
Library           SeleniumLibrary
Resource          ../resources/web_keywords.robot
Resource          ../resources/api_variables.robot
Test Setup        Start Browser Session
Test Teardown     End Browser Session

*** Test Cases ***
US-AUTH-002 - Login de Usuário Válido
    [Documentation]    Verifica se o usuário pode fazer login com sucesso.
    
    
    Perform User Login    test@example.com    password123
    
    
    Location Should Contain    ${FRONTEND_URL}/
    
US-AUTH-004 - Visualizar e Editar Nome do Perfil
    [Documentation]    Verifica a funcionalidade de perfil (navegação, exibição de dados e edição).
    
    
    Perform User Login    test@example.com    password123
    
    
    Click Element    xpath=//header//a[contains(@href, 'profile')] 
    
    
    
    Wait Until Page Contains Element    xpath=//h1[contains(text(), 'Perfil')]
    
    
    ${new_name}=    Generate Random String    10    [LOWER]
    
    Input Text  id=name   ${new_name}
    # auth_test.robot (Trecho US-AUTH-004)


    Click Element    xpath=//button[contains(., 'Salvar Alterações')]
 

    Wait Until Page Contains    Perfil atualizado com sucesso
 

    Click Button    OK 


    Sleep    2s


    Element Attribute Value Should Be    id=name    value    ${new_name}