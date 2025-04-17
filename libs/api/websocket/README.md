# WebSocket API Module

This module provides real-time WebSocket functionality for the Board Games Empire application.

## Features

- Secure WebSocket connections with JWT authentication
- Room-based messaging system
- Request/response pattern for complex operations
- Integration with Prisma for data persistence
- Automatic user session management

## Security

The WebSocket module implements several security features:

1. **JWT Authentication**: All connections require a valid JWT token
2. **Session Validation**: Ensures the user's session is still valid
3. **Token Revocation Checking**: Verifies tokens haven't been revoked
4. **Room Authorization**: Controls which rooms users can join

## Usage

### Server-Side

Import the WebSocket module in your application:

```typescript
import { WebSocketModule } from '@bg-empire/api-websocket';

@Module({
  imports: [
    WebSocketModule,
    // ... other modules
  ],
})
export class AppModule {}
```

Configure the WebSocket adapter in your main.ts:

```typescript
import { WebSocketModule } from '@bg-empire/api-websocket';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Apply the WebSocket adapter
  app.useWebSocketAdapter(WebSocketModule.getAdapter(app));

  await app.listen(3000);
}
bootstrap();
```

### Client-Side

Connect to the WebSocket server with authentication:

```typescript
import { io } from 'socket.io-client';

const socket = io('http://your-server-url/socket', {
  auth: {
    token: 'your-jwt-token',
  },
});

// Listen for connection events
socket.on('connect', () => {
  console.log('Connected to WebSocket server');
});

socket.on('disconnect', () => {
  console.log('Disconnected from WebSocket server');
});

// Example: Join a chat room
socket.emit('joinRoom', { roomId: 'general' }, (response) => {
  if (response.success) {
    console.log(`Joined room: ${response.roomId}`);
  } else {
    console.error(`Failed to join room: ${response.error}`);
  }
});

// Example: Send a chat message
socket.emit(
  'sendMessage',
  {
    content: 'Hello, world!',
    roomId: 'general',
  },
  (response) => {
    if (response.success) {
      console.log(`Message sent with ID: ${response.messageId}`);
    } else {
      console.error(`Failed to send message: ${response.error}`);
    }
  },
);

// Listen for incoming messages
socket.on('chatMessage', (message) => {
  console.log(`${message.senderName}: ${message.content}`);
});

// Example: Make a request with the request/response pattern
socket.emit(
  'request',
  {
    type: 'searchGames',
    requestId: 'search-1',
    payload: {
      query: 'Catan',
      externalSource: 'BoardGameGeek',
    },
  },
  (response) => {
    if (response.error) {
      console.error(`Search failed: ${response.error}`);
    } else {
      console.log('Search results:', response.payload);
    }
  },
);

// Listen for server-pushed search results
socket.on('searchResults', (results) => {
  console.log('Received search results:', results);
});
```

## Custom Request Handlers

To add custom request handlers, create a handler class and register it with the WebSocketService:

```typescript
@Injectable()
export class YourCustomHandler {
  constructor(private readonly wsService: WebSocketService) {
    // Register this handler with the WebSocket service
    this.wsService.registerRequestHandler('yourRequestType', this.handleYourRequest.bind(this));
  }

  async handleYourRequest(user: any, payload: any) {
    // Process the request
    // Return the response
  }
}
```

Then add your handler to the WebSocket module providers:

```typescript
@Module({
  // ...
  providers: [
    // ...
    YourCustomHandler,
  ],
})
export class WebSocketModule {}
```
