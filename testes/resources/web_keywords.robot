*** Settings ***
Library           SeleniumLibrary
Library           String


*** Variables ***
${BROWSER}        Chrome
${FRONTEND_URL}   http://localhost:3002
${WAIT_TIME}      30s               # Mantendo 30s para segurança

*** Keywords ***
Start Browser Session
    [Documentation]    Inicia o navegador e navega para a URL do Front-end.
    Open Browser    ${FRONTEND_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${WAIT_TIME}
    Go To Homepage

End Browser Session
    [Documentation]    Fecha o navegador.
    Close Browser

Go To Homepage
    [Documentation]    Navega para a página inicial e espera o carregamento do cabeçalho.
    Go To    ${FRONTEND_URL}
    Wait Until Page Contains Element    xpath=//header
    
Perform User Login
    [Documentation]    Realiza o login de usuário comum (test@example.com / password123).
    [Arguments]    ${email}    ${password}
    Click Element    xpath=//a[contains(@href, '/login') or contains(text(), 'Login')]
    Wait Until Page Contains    Login
    
    # Assumindo que os campos de login têm IDs ou nomes claros
    Input Text    id=email    ${email}
    Input Text    id=password    ${password}
    Click Button    xpath=//button[text()='Entrar']
    
    # Critério: Redirecionado para a página inicial (Filmes em Cartaz)
    Wait Until Location Is    ${FRONTEND_URL}/
    Wait Until Page Contains    Filmes em Cartaz

Click Film Details And Session
    [Documentation]    Navega para a lista de filmes, clica no card, e seleciona a sessão.
    
    Go To Filmes Page 
    
    # 1. Clica no link/botão 'Ver Detalhes'
    Click Element    xpath=//*[contains(text(), 'Ver Detalhes')][1]
    
    # 2. Espera que o link 'Selecionar Assentos' apareça
    Wait Until Page Contains Element    xpath=//a[contains(text(), 'Selecionar Assentos')]
    
    # 3. Clica no link 'Selecionar Assentos'
    Click Element    xpath=//a[contains(text(), 'Selecionar Assentos')]
    
    # CORREÇÃO FINAL DA ESPERA: Espera o primeiro assento aparecer (prova que o carregamento da API foi concluído)
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'seat')][1]

Select Available Seat
    [Documentation]    Clica no primeiro assento disponível (US-RESERVE-001).
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'seat')][1]
    
    # Critério: Clica no primeiro assento disponível
    Click Element    xpath=//button[contains(@class, 'seat') and contains(@class, 'available')][1]
    
    # Critério: Verifica se a opção 'Continuar para Pagamento' apareceu
    Wait Until Page Contains    Continuar para Pagamento

Proceed To Checkout And Pay
    [Documentation]    Avança para o checkout, seleciona pagamento e finaliza a compra (US-RESERVE-002).
    
    # 1. Clica no botão para ir para o pagamento (Usa o texto como localizador mais robusto)
    Click Element    Continuar para Pagamento
    
    # 2. Espera a página de checkout (Espera pelo botão final)
    Wait Until Page Contains Element    xpath=//button[contains(text(), 'Finalizar Compra')]
    
    # 3. Seleciona o método de pagamento (Clica no primeiro método - Cartão de Crédito)
    Click Element    xpath=//div[contains(@class, 'payment-method')][1] 
    
    # 4. Finaliza a Compra (Usa o texto simples, como é o mais robusto para botões com SVG)
    Click Element    Continuar para Pagamento

Verify Reservation Success
    [Documentation]    Verifica se a confirmação final da reserva apareceu.
    Wait Until Page Contains    Reserva Confirmada
    
    # Critério de Aceitação: Verifica o ID da Reserva (Assumindo que o texto aparece na tela)
    Page Should Contain    ID da Reserva

Go To Filmes Page 
    
    # 1. Clica no link/botão 'Ver Detalhes'
    Click Element    xpath=//*[contains(text(), 'Ver Detalhes')][1]
    
    # NOVO CHECKPOINT: Espera por um elemento confiável da página de Detalhes
    # Assumimos que o título do filme (H1) aparece rapidamente
    Wait Until Page Contains Element    xpath=//h1[contains(text(), 'Filme')]
    
    # CORREÇÃO: Agora, esperamos que o LINK 'Selecionar Assentos' apareça (garantindo que a API da sessão carregou)
    Wait Until Page Contains Element    xpath=//a[contains(text(), 'Selecionar Assentos')]
    
    # 2. Clica no link 'Selecionar Assentos'
    Click Element    xpath=//a[contains(text(), 'Selecionar Assentos')]
    
    # 3. VALIDAÇÃO FINAL: Espera o título da próxima página de assentos
    Wait Until Page Contains    Seleção de Assentos

   