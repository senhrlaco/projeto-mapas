# Sistema de Logística e Check-in (Geofencing)

Desenvolvido por Lucas dos Santos de Oliveira Mello.

---

## Sobre o Projeto

Este sistema foi criado para resolver a ineficiência e a instabilidade técnica geradas por sistemas de rastreamento contínuo em equipes externas. O projeto substitui o rastreamento em segundo plano por um modelo de check-in pontual baseado em geofencing.

Foi estabelecido um raio de validação de 100 metros do endereço do cliente. A solução preserva a privacidade e a bateria do colaborador, e garante à gestão (Painel Web) a segurança de que a visita foi realizada no local correto.

A estrutura do projeto é dividida em três partes:
1. **Mobile (App do Agente):** Aplicativo em React Native para o colaborador em campo registrar sua chegada com validação nativa de GPS simulado (Anti Fake-GPS).
2. **Back-end (API):** Servidor central em Node.js que recebe as coordenadas e realiza o cálculo da cerca virtual através da Fórmula de Haversine.
3. **Painel Web (Gestão):** Dashboard administrativo em React integrado à API do Mapbox para visualização, geocodificação e auditoria de presenças em tempo real.

---

## Tecnologias Utilizadas

- **Back-end:** Node.js, Express, Prisma ORM, TypeScript
- **Banco de Dados:** PostgreSQL
- **Painel Web:** React, Vite, TailwindCSS, Mapbox API
- **Mobile:** React Native, Expo
- **Infraestrutura:** Docker, Docker Compose

---

## Rodando com Docker

> Pré-requisito: ter o [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado.

Com o Docker Compose, o banco de dados PostgreSQL, a API e o painel web são iniciados juntos, sem a necessidade de instalar dependências locais.

### 1. Clonar o Repositório
```bash
git clone https://github.com/senhrlaco/projeto-mapas.git
cd projeto-mapas
```

### 2. Configurar o Token do Mapa (opcional)
Crie um arquivo `.env` na raiz do projeto:
```env
VITE_MAPBOX_TOKEN=coloque_aqui_sua_chave_publica_do_mapbox
```
> O token é necessário apenas para o mapa aparecer no painel. O restante do sistema funciona sem ele.

### 3. Subir tudo
```bash
docker compose up --build
```

Aguarde o build (~2 minutos na primeira vez). Quando aparecer `API rodando na porta 3333`, acesse:

| Serviço | Endereço |
|---|---|
| Painel Web | http://localhost:5173 |
| API | http://localhost:3333/api |

**Credenciais padrão:** login `lucas.mello` / senha `admin123`

### Parar os serviços
```bash
docker compose down
```

---

## Rodando Manualmente (sem Docker)

### Pré-requisitos
- Node.js 20+
- PostgreSQL instalado e rodando

### 1. Clonar o Repositório
```bash
git clone https://github.com/senhrlaco/projeto-mapas.git
cd projeto-mapas
```

### 2. Configurar a API (Back-end)
```bash
cd apps/backend-api
npm install
```
Crie um arquivo `.env` nesta pasta:
```env
DATABASE_URL="postgresql://usuario:senha@localhost:5432/logistica_db"
JWT_SECRET="chave_secreta_para_testes"
ADMIN_PASSWORD="admin123"
```
Crie as tabelas e o usuário admin:
```bash
npx prisma db push
npx prisma db seed
npm run dev
```
A API estará rodando na porta `3333`.

### 3. Configurar o Painel Web
Em um novo terminal:
```bash
cd apps/web-panel
npm install
```
Crie o arquivo `.env`:
```env
VITE_API_URL="http://localhost:3333/api"
VITE_MAPBOX_TOKEN="coloque_aqui_sua_chave_publica_do_mapbox"
```
```bash
npm run dev
```
Acesse `http://localhost:5173`.

### 4. Configurar o Aplicativo Mobile
```bash
cd apps/mobile-app
npm install
```
Crie o arquivo `.env` apontando para o IP da sua máquina na rede local:
```env
EXPO_PUBLIC_API_URL="http://192.168.1.246:3333"
```

Para testar no smartphone via **Expo Go**:
```bash
npx expo start --lan
```
Abra o app Expo Go no celular (conectado na mesma rede Wi-Fi) e escaneie o QR Code do terminal.

Para testar no emulador Android do computador:
```bash
npx expo start --android
```

**Credenciais para teste no mobile:** login `lucas.agr` / senha `admin123`

---

## Como gerar o instalador (APK) para Android

No terminal, dentro de `apps/mobile-app`:
```bash
npm install -g eas-cli
eas build -p android --profile preview
```
Ao finalizar, o terminal exibirá um link para baixar o `.apk`.
