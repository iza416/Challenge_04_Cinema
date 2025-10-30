*** Settings ***
Library           SeleniumLibrary
Resource          ../resources/web_keywords.robot
Resource          ../resources/api_variables.robot
Test Setup        Start Browser Session
Test Teardown     End Browser Session

*** Test Cases ***
*** Test Cases ***
US-HOME-001 - Carregamento e Elementos da Página Inicial
    [Documentation]    Verifica se os elementos chave da Home Page estão presentes.
    
    
    Wait Until Page Contains    Filmes em Cartaz
    
    
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'movie-card')]

US-NAV-001 - Navegação do Cabeçalho
    [Documentation]    Verifica a navegação principal para a página de filmes.
    
    
    Click Element    xpath=//header//a[contains(text(), 'Filmes') or contains(@href, '/movies')] 
    
    
    Wait Until Page Contains Element    xpath=//h1[contains(text(), 'Filmes')]
    
    
    Location Should Contain    /movies