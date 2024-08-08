Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to close all open PSSessions
function Close-Sessions {
    Get-PSSession | Remove-PSSession
}

# Function to enable remote mailbox
function EnableRemoteRouting {
    param (
        [string]$username,
        [pscredential]$UserCredential
    )
    Write-Host "Inicializando conexão com o Exchange Local..." -ForegroundColor Green

    try {
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940021/PowerShell/ -Authentication Kerberos -Credential $UserCredential -ErrorAction Stop
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Autenticação falhou, verifique suas credenciais", "Erro", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    Write-Host "Conexão OK, importando sessão" -ForegroundColor Green
    Import-PSSession $Session -AllowClobber

    Write-Host "Habilitando caixa para $($username)@grq.mail.onmicrosoft.com" -ForegroundColor Cyan
    try {
        Enable-RemoteMailbox -Identity $username -RemoteRoutingAddress ($username+"@grq.mail.onmicrosoft.com") -ErrorAction Stop
        [System.Windows.Forms.MessageBox]::Show("Caixa habilitada com sucesso para $username", "Sucesso", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, "Erro", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }

    Close-Sessions
}

# Function to disable remote mailbox
function DisableRemoteRouting {
    param (
        [string]$username,
        [pscredential]$UserCredential
    )
    Write-Host "Inicializando conexão com o Exchange Local..." -ForegroundColor Green

    try {
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940021/PowerShell/ -Authentication Kerberos -Credential $UserCredential -ErrorAction Stop
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Autenticação falhou, verifique suas credenciais", "Erro", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    Write-Host "Conexão OK, importando sessão" -ForegroundColor Green
    Import-PSSession $Session -AllowClobber

    Write-Host "Desabilitando caixa para $($username)" -ForegroundColor Cyan
    try {
        Disable-RemoteMailbox -Identity $username -Confirm:$false -ErrorAction Stop
        [System.Windows.Forms.MessageBox]::Show("Caixa desabilitada com sucesso para $username", "Sucesso", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, "Erro", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }

    Close-Sessions
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Manage Remote Mailbox"
$form.Size = New-Object System.Drawing.Size(400, 400)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.BackColor = [System.Drawing.Color]::LightSteelBlue

# Create a font for the labels and buttons
$font = New-Object System.Drawing.Font("Segoe UI", 10)

# Create the comment label
$commentLabel = New-Object System.Windows.Forms.Label
$commentLabel.Text = "Este script gerencia a caixa de correio remoto para um usuário no Exchange."
$commentLabel.Location = New-Object System.Drawing.Point(10, 10)
$commentLabel.Size = New-Object System.Drawing.Size(360, 40)
$commentLabel.Font = $font
$commentLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($commentLabel)

# Create the credentials label and textbox
$credentialsLabel = New-Object System.Windows.Forms.Label
$credentialsLabel.Text = "Credenciais (domínio\usuário):"
$credentialsLabel.Location = New-Object System.Drawing.Point(10, 60)
$credentialsLabel.Size = New-Object System.Drawing.Size(160, 40)
$credentialsLabel.Font = $font
$credentialsLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($credentialsLabel)

$credentialsTextBox = New-Object System.Windows.Forms.TextBox
$credentialsTextBox.Location = New-Object System.Drawing.Point(180, 60)
$credentialsTextBox.Size = New-Object System.Drawing.Size(180, 30)
$credentialsTextBox.Font = $font
$credentialsTextBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($credentialsTextBox)

# Create the password label and textbox
$passwordLabel = New-Object System.Windows.Forms.Label
$passwordLabel.Text = "Senha:"
$passwordLabel.Location = New-Object System.Drawing.Point(10, 110)
$passwordLabel.Size = New-Object System.Drawing.Size(150, 30)
$passwordLabel.Font = $font
$passwordLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($passwordLabel)

$passwordTextBox = New-Object System.Windows.Forms.TextBox
$passwordTextBox.Location = New-Object System.Drawing.Point(180, 110)
$passwordTextBox.Size = New-Object System.Drawing.Size(180, 30)
$passwordTextBox.PasswordChar = '*'
$passwordTextBox.Font = $font
$passwordTextBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($passwordTextBox)

# Create the username label and textbox
$usernameLabel = New-Object System.Windows.Forms.Label
$usernameLabel.Text = "Usuário (target):"
$usernameLabel.Location = New-Object System.Drawing.Point(10, 160)
$usernameLabel.Size = New-Object System.Drawing.Size(150, 30)
$usernameLabel.Font = $font
$usernameLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($usernameLabel)

$usernameTextBox = New-Object System.Windows.Forms.TextBox
$usernameTextBox.Location = New-Object System.Drawing.Point(180, 160)
$usernameTextBox.Size = New-Object System.Drawing.Size(180, 30)
$usernameTextBox.Font = $font
$usernameTextBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($usernameTextBox)

# Create the enable button
$enableButton = New-Object System.Windows.Forms.Button
$enableButton.Text = "Habilitar"
$enableButton.Location = New-Object System.Drawing.Point(20, 210)
$enableButton.Size = New-Object System.Drawing.Size(100, 40)
$enableButton.Font = $font
$enableButton.BackColor = [System.Drawing.Color]::ForestGreen
$enableButton.ForeColor = [System.Drawing.Color]::White
$enableButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$enableButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
$enableButton.Add_Click({
    $username = $usernameTextBox.Text
    $usernameTextBox.Clear()

    $UserCredential = New-Object System.Management.Automation.PSCredential($credentialsTextBox.Text, (ConvertTo-SecureString $passwordTextBox.Text -AsPlainText -Force))
    #$credentialsTextBox.Clear()
    $passwordTextBox.Clear()

    EnableRemoteRouting -username $username -UserCredential $UserCredential
})
$form.Controls.Add($enableButton)

# Create the disable button
$disableButton = New-Object System.Windows.Forms.Button
$disableButton.Text = "Desabilitar"
$disableButton.Location = New-Object System.Drawing.Point(140, 210)
$disableButton.Size = New-Object System.Drawing.Size(100, 40)
$disableButton.Font = $font
$disableButton.BackColor = [System.Drawing.Color]::Tomato
$disableButton.ForeColor = [System.Drawing.Color]::White
$disableButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$disableButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
$disableButton.Add_Click({
    $username = $usernameTextBox.Text
    $usernameTextBox.Clear()

    $UserCredential = New-Object System.Management.Automation.PSCredential($credentialsTextBox.Text, (ConvertTo-SecureString $passwordTextBox.Text -AsPlainText -Force))
    #$credentialsTextBox.Clear()
    $passwordTextBox.Clear()

    DisableRemoteRouting -username $username -UserCredential $UserCredential
})
$form.Controls.Add($disableButton)

# Create the cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Fechar"
$cancelButton.Location = New-Object System.Drawing.Point(260, 210)
$cancelButton.Size = New-Object System.Drawing.Size(100, 40)
$cancelButton.Font = $font
$cancelButton.BackColor = [System.Drawing.Color]::LightSlateGray
$cancelButton.ForeColor = [System.Drawing.Color]::White
$cancelButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$cancelButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
$cancelButton.Add_Click({
    Close-Sessions
    $form.Close()
})
$form.Controls.Add($cancelButton)

# Show the form
$form.ShowDialog()
