# Board Games Empire

A monorepo-based companion application for board game enthusiasts, providing collection management,
play tracking, and social features. Built with Nx and Flutter to create a cross-platform experience
that works seamlessly across web, mobile, and desktop.

This project is in its early stages and is nowhere near feature-complete. Expect almost everything
to be broken at this point.

## 🎯 Project Goals

- **Universal Access**: Create a unified experience across web, mobile, and desktop platforms
- **Self-Hostable**: Allow users to connect to their own server instances or hosted services
- **Robust Authentication**: Implement secure, session-tracked authentication with proper device management
- **Rich Board Game Management**: Track collections, plays, campaigns, and social interactions
- **Privacy-Focused**: Keep user data under their control through self-hosting options

## 🏗️ Technology Stack

- **Nx**: Monorepo tooling for coordinated development and deployment
- **Flutter**: Cross-platform UI framework for mobile, web, and desktop
- **NestJS**: Backend API with PostgreSQL database (Prisma ORM)
- **JWT + Session Tracking**: Hybrid authentication approach

## 📁 Project Structure

```
board-games-empire/
├── apps/
│   ├── api/               # NestJS backend API
│   ├── client/            # Flutter cross-platform UI
│   └── web/               # Web application - Maybe?
├── libs/
│   ├── api/               # API related libraries
├── scripts/               # Project tooling and scripts
├── nx.json                # Nx configuration
├── workspace.json         # Workspace configuration
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v16+)
- [Nx CLI](https://nx.dev/getting-started/intro)
- [Flutter](https://flutter.dev/docs/get-started/install) (v3.7+)
- [Docker](https://www.docker.com/get-started) (for development database)

### Initial Setup

1. Clone the repository

```bash
git clone https://github.com/BoardGamesEmpire/board-games-empire
cd board-games-empire
```

2. Install dependencies

```bash
npm install
```

3. Set up environment variables

   - Copy the example .env file in the project root and client directories

   ```bash
   cp apps/client/.env.example apps/client/.env
   cp .env.example .env
   ```

   - Edit the .env files with your configuration

4. Start the development database

```bash
supply your own db!
```

5. Run the migrations

```bash
npm run db:migrate:dev
```

## 🔧 Environment Configuration

### Mobile App Configuration (.env)

The mobile application uses dev environment variables for configuration. Place a `.env` file in the `apps/mobile/` directory with the following variables:

```bash
# API Configuration
API_URL=http://localhost
SERVER_PORT=33333
```

### Environment Handling

The application handles environment variables differently based on the platform:

- **Web**: Environment variables are injected during build time using the Nx build configuration
- **Mobile/Desktop**: Variables are read from the .env file in the client project root

## 🛠️ Development Workflows

### Running the API

```bash
npm start
```

The API will be available at http://localhost:33333/api/v1

### Running the Client App

```bash
# iOS Simulator
nx run client:run:ios

# Android Emulator
nx run client:run:android

# Web
nx run client:run:web

# Desktop (macOS)
nx run client:run:macos
```

### Building for Production

```bash
# API
nx build api

# Mobile Apps
nx run client:build-ipa
nx run client:build-apk

# Web
nx build client:web - not yet

# Desktop
nx build client:desktop - not uet
```

## 📱 Current Features

### Authentication

- **Multi-Server Support**: Connect to multiple server instances (mobile/desktop)
- **Server Auto-Detection**: Web version automatically connects to hosting server
- **Session Management**: View and manage active login sessions - WIP
- **Secure Token Storage**: Platform-specific secure storage for auth tokens

### Server Configuration

- **Server Setup**: First-time setup wizard for server configuration
- **Server Switching**: Easily switch between different server connections
- **Connection Validation**: Test connections before saving

### Platform-Specific Behavior

- **Web**: Uses hosting server URL, disables server configuration
- **Mobile/Desktop**: Full server management capabilities

## 🚧 Limitations & Work in Progress

- User profile management is limited
- Game collection features are still in development
- No offline support yet
- Limited data import/export capabilities

## 🚀 Deployment

### API Deployment

The API can be deployed as a Node.js application or using Docker:

```bash
# Build the API
nx build api

# Start in production mode
node dist/apps/api/main.js
```

Docker deployment:

```bash
nx run api:docker:build
nx run api:docker:push
```

### Mobile App Deployment - Maybe?

For mobile app stores:

```bash
nx run client:build:ios-prod
nx run client:build:android-prod
```

### Web Deployment

```bash
nx run client:build:web-prod
```

The built files will be available in `dist/apps/client/web` and can be deployed to any static hosting service.

## 🔄 CI/CD

The project uses GitHub Actions for CI/CD:

- **Pull Requests**: Builds and tests all affected projects
- **Main Branch**: Builds, tests, and deploys to staging
- **Release Branches**: Builds, tests, and deploys to production

## 📈 Future Roadmap

- Offline support with data synchronization
- Advanced game collection management
- Campaign tracking system
- Statistical analysis of play data
- Social integration and sharing
- Import from BoardGameGeek
- Push notifications
- Event management and coordination

## 🤝 Contributing

Contributions are welcome! Please check out our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

Not yet licensed
