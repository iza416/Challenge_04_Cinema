*** Settings ***
Library    Collections
Library    String
Library    DateTime

*** Variables ***
# Configurações da API
${BASE_URL}             http://localhost:3000
${API_PREFIX}           /api/v1
${API_URL}              ${BASE_URL}${API_PREFIX}

# Credenciais de Teste (ATUALIZADAS CONFORME A SAÍDA DO SEU SCRIPT DE SETUP)
${ADMIN_EMAIL}          admin@example.com
${ADMIN_PASSWORD}       admin123        # <-- CONFIRMADO: Senha do Admin
${USER_EMAIL}           test@example.com    # <-- CORRIGIDO: E-MAIL CORRETO DO USUÁRIO
${USER_PASSWORD}        password123     # <-- CORRIGIDO: Senha correta do Usuário
${NEW_USER_NAME}        Novo Usuario Teste
${NEW_USER_PASSWORD}    senha456        # Senha para o novo usuário do C1.1

# Tokens (Inicialmente vazios, serão preenchidos após o login)
${ADMIN_TOKEN}          ${EMPTY}
${USER_TOKEN}           ${EMPTY}