<img src = "docs/imgs/torch_logo.png" alt = "Logo Torch" width = "350">

---

# Frontend 🐾

Aplicativo mobile desenvolvido em Flutter para o projeto Torch, focado no agendamento rápido e intuitivo de serviços em Pet Shops.<br>
O Backend está disponível [aqui.](https://github.com/VStorch/TorchAppBackend)<br>
Já a página de redirecionamento para a redefinição de senha está [aqui](https://github.com/VStorch/PaginaRedirecionamento)

---

### Índice

- [Descrição](#descrição)
- [Funcionalidades](#funcionalidades)
- [Tipos de Usuário](#tipos-de-usuário)
- [Tecnologias e Dependências](#tecnologias-e-dependências)
- [Como rodar o projeto](#como-rodar-o-projeto)
- [Capturas de tela](#capturas-de-tela)
- [Fluxo de navegação](#fluxo-de-navegação)
- [Integração com o backend](#integração-com-o-backend)
- [Desenvolvedores](#desenvolvedores)
- [Status do projeto](#status-do-projeto)

---

### Descrição

O Torch é um aplicativo móvel desenvolvido para facilitar o agendamento de horários em Pet Shops. Com uma interface intuitiva, o app permite que os usuários agendem rapidamente serviços para seus animais de estimação, enquanto os Pet Shops podem gerenciar seus horários de forma eficiente. O objetivo é proporcionar agilidade tanto para os clientes quanto para os fornecedores de serviços.

---

### Funcionalidades

#### Tipos de Usuário

O Torch possui dois perfis de uso, cada um com funcionalidades específicas:

1. Cliente
    - Cadastra seus próprios pets
    - Visualiza serviços e ofertas disponibilizados pelos Pet Shops
    - Verifica horários livres conforme o serviço escolhido
    - Faz agendamentos
    - Gerencia agendamentos futuros
    - Atualiza seus dados

2. Dono de Pet Shop
    - Possui um Pet Shop associado à sua conta
    - Cadastra e edita serviços oferecidos
    - Gera slots de horário para dias específicos, vinculados aos serviços
    - Acompanha agendamentos realizados por clientes
    - Atualiza informações do Pet Shop
    - Gerencia perfil

---

### Tecnologias e Dependências

**Base**
- Flutter 3.32.3
- Dart 3.8.1
- Material Design 3
- Flutter Localizations

**Comunicação com API**
- Dio 5.7.0
- http 1.5.0

**Armazenamento Local**
- shared_preferences 2.2.2

**Imagens e Mídias**
- image_picker 1.0.4<br>
    Para capturar fotos da câmera ou selecionar da galeria

**Interface e animações**
- lottie 2.2.0<br>
    Exibição de animações em JSON

**Mapas**
- flutter_map 5.1.0

**Internacionalização**
- intl 0.20.2

**Assets**
- Animações diversificadas
- Imagens diversas
- Pastas organizadas em:<br>
    `lib/assets/images/`<br>
    `lib/assets/images_profile/`
    
**Fontes customizadas**
- Inknut Antiqua (Regular/Semibold/Bold/Black)
- InclusiveSans

---

### Como rodar o projeto

1. Clonar o repositório

    ```bash
    git clone https://github.com/VStorch/TorchApp.git
    cd TorchApp
    ```

2. Instalar dependências

    ```bash
    flutter pub get
    ```

3. Rodar o app

    ```bash
    flutter run
    ```

    Se houverem problemas com dependências ou configurações, execute os seguintes comandos:

    ```bash
    flutter clean
    flutter pub get
    flutter run
    ```
    
---

### Capturas de tela

Segue algumas telas do sistema

| ![](docs/screens/loading_page.png) | ![](docs/screens/login_page.png) |
|:----------------------------------:|:--------------------------------:|
| Tela de carregamento | Tela de login |

#### Telas do Pet Shop

| ![](docs/screens/petshop_home_page.png) | ![](docs/screens/service_creation.png) |
|:---------------------------------------:|:--------------------------------------:|
| Tela inicial do Pet Shop | Tela de serviços |

| ![](docs/screens/slots_creation.png) | ![](docs/screens/appointment_petshop_screen.png) |
|:------------------------------------:|:------------------------------------------------:|
| Tela de criação de slots de horário | Tela de agendamentos |


#### Telas do Cliente

| ![](docs/screens/client_home_page.png) | ![](docs/screens/service_search.png) |
|:--------------------------------------:|:-------------------------------------:|
| Tela inicial do Cliente | Tela que lista os serviços |

| ![](docs/screens/appointment.png) | ![](docs/screens/scheduled_appointment.png) |
|:---------------------------------:|:--------------------------------------------:|
| Tela de agendamento | Confirmação do agendamento |

---

### Fluxo de navegação

Abaixo está uma visão simplificada do fluxo geral de navegação do aplicativo Torch. O objetivo é apresentar o caminho principal que o usuário percorre, tanto no perfil de Cliente quanto no de Pet Shop.

1. Tela de carregamento
2. Autenticação
    - Login
    - Cadastro
3. Seleção de perfil
    - Cliente
    - Pet Shop
4. Página principal (Home)
    - Layout adaptado conforme o tipo de usuário
5. Fluxo do Cliente
    - Cadastro de Pets
    - Lista de Serviços
    - Seleção do Pet
    - Seleção do Horário
    - Confirmação do Agendamento
    - Avaliação do Pet Shop
    - Edição de Perfil
6. Fluxo do Pet Shop
    - Gerenciamento de Serviços
    - Criação de Slots de Horários
    - Lista de Agendamentos
    - Edição de Perfil (dados da empresa e do responsável)
7. Configurações
    - Habilitar/Desabilitar notificações
    - Alterar senha
    - Sobre o app
    - Sair (Logout)

---

### Integração com o backend

---

### Desenvolvedores

- [João Pedro Pitz](https://github.com/joaopedropitzz)
- [Leonardo Cortelim dos Santos](https://github.com/LeonardoCortelim)
- [Vinícius Storch](https://github.com/VStorch)

---

### Status do projeto

Em desenvolvimento.