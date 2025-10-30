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
    
    # 1. Espera simples pelo texto (o mais robusto) [cite: 2]
    Wait Until Page Contains    Filmes em Cartaz
    
    # 2. Espera que os filmes tenham carregado (prova de integração API)
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'movie-card')]

US-NAV-001 - Navegação do Cabeçalho
    [Documentation]    Verifica a navegação principal para a página de filmes.
    
    # Clica no link de Filmes/Catálogo (Usando XPath que procura a URL ou o texto)
    Click Element    xpath=//header//a[contains(text(), 'Filmes') or contains(@href, '/movies')] 
    
    # Critério: Esperar pelo título da página de Listagem de Filmes (o H1)
    Wait Until Page Contains Element    xpath=//h1[contains(text(), 'Filmes')]
    
    # Critério: Checar URL
    Location Should Contain    /movies