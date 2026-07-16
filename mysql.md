# Configurando o MySQL Workbench

## Passo 1: Baixar o Instalador
Acesse a página oficial de downloads: https://dev.mysql.com/downloads/installer/

Na página, você verá duas opções de download com a extensão `.msi`. Clique no botão **Download** da segunda opção (a que possui o tamanho maior, geralmente mais de 300 MB). Esse é o instalador offline e ajuda a evitar interrupções de internet durante a instalação.

Na tela seguinte, o site vai sugerir a criação de uma conta na Oracle. Não é necessário. Basta clicar no link discreto na parte inferior da tela: *"No thanks, just start my download."*

## Passo 2: Selecionar os Componentes
Execute o arquivo que você acabou de baixar.

Na primeira tela (*"Choosing a Setup Type"*), selecione a opção **Custom** (Personalizado) e clique em **Next**. Fazer isso evita instalar um monte de ferramentas secundárias que vão pesar no seu sistema à toa.

Na tela *"Select Products"*, você verá uma lista à esquerda. Você precisa expandir as categorias, selecionar os itens abaixo e clicar na setinha verde (→) para jogá-los para o quadro da direita:

* Expanda **MySQL Servers > MySQL Server** > Selecione a versão mais recente e mova para a direita.
* Expanda **Applications > MySQL Workbench** > Selecione a versão mais recente e mova para a direita.

Clique em **Next** e depois em **Execute**. O instalador vai preparar esses dois componentes. Quando o status ficar como *"Complete"*, clique em **Next**.

## Passo 3: Configurar o Banco de Dados
Você chegará na tela *"Product Configuration"*. Clique em **Next** para começar a configurar o servidor.

Na tela *"Type and Networking"*, deixe as configurações padrão (*Development Computer* e a porta `3306`). Clique em **Next**.

Em *"Authentication Method"*, mantenha a opção recomendada (*Use Strong Password Encryption*) e avance.

Na tela *"Accounts and Roles"*, crie uma senha para o **MySQL Root Password** (o usuário administrador). Anote e guarde essa senha muito bem, pois você precisará dela sempre que for se conectar ao banco de dados pelo Workbench!

Na tela *"Windows Service"*, deixe tudo como está. Isso fará com que o MySQL inicie automaticamente junto com o Windows, facilitando seu estudo. Clique em **Next**.

Clique em **Execute** para aplicar todas essas configurações. Ao finalizar, clique em **Finish** e depois vá avançando até concluir a instalação.

## Passo 4: Acessar o Workbench
No menu Iniciar do seu computador, procure e abra o **MySQL Workbench**.

Na tela inicial dele, logo abaixo de *"MySQL Connections"*, haverá um retângulo cinza chamado **Local instance MySQL80** (ou algo muito parecido).

Clique nesse retângulo. Ele pedirá a senha do usuário Root que você criou no passo anterior.

Digite a senha, marque a opção *"Save password in vault"* (para não precisar digitar toda hora) e clique em **OK**.
