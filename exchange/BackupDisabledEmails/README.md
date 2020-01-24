~~Script para converter diversas caixas de email do Office 365 para o tipo Shared Mailbox (Caixa Compartilhada)~~
## Script para realizar o backup das contas desabilitadas no Office 365
#### Esse script faz automaticamente o backup de uma conta inativa no office 365, removendo as licenças das caixas, convertendo-as em Shared Mailboxes e ocultando-as da lista global de endereços

1. Adicione os usuários a serem convertidos no arquivo convert.csv
	1. Os usuários devem ser adicionados um por linha, no formato UPN (User Principal Name):
    ```
    **upn**
    usuario@contoso.com
    fulano@ciclano.com.br
    ...
    ```
	
2. Para executar, é necessário configurar sua conta e senha do Office365 no script. Altere seu usuário nos conectores credO365 e credExchOnprem
	
	2. Para configurar a senha é necessário rodar alguns comandos para salvá-la de uma forma segura em um arquivo. Se desejar não salvar a senha por segurança, altere o script para ler as credenciais direto do usuário.
	
	```
	Read-Host "Digite a senha" -AsSecureString |  ConvertFrom-SecureString | Out-File "C:\path\to\TrustyPassword.txt
	```

3. Execute o script `BackupDisabledEmails.ps1`
