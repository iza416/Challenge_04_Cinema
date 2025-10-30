*** Settings ***
Library           SeleniumLibrary
Resource          ../resources/web_keywords.robot
Resource          ../resources/api_variables.robot
Test Setup        Start Browser Session
Test Teardown     End Browser Session
Force Tags        E2E    Reserva

*** Test Cases ***
US-RESERVE-001_002 - Reserva Completa de Ingresso
    [Documentation]    Testa o fluxo completo de reserva: Login, Seleção de Filme, Assento e Pagamento.
    
    # 1. PRÉ-REQUISITO: LOGIN
    # Usa o usuário comum que está funcionando perfeitamente
    Perform User Login    test@example.com    password123
    
    # 2. SELEÇÃO DO FILME/SESSÃO
    Click Film Details And Session
    
    # 3. SELEÇÃO DE ASSENTOS (US-RESERVE-001)
    Select Available Seat
    
    # 4. CHECKOUT (US-RESERVE-002)
    Proceed To Checkout And Pay
    
    # 5. VALIDAÇÃO FINAL
    Verify Reservation Success