# pub_serve_proxy
Example of how to reverse proxy over `pub run build_runner serve`.
`package:angel_proxy` supports proxying over any HTTP server, including WebSocket
support, so it can be used with `webpack-dev-server` and co. as well.

## Development
In development, simply run:

```bash
# To start the server:
dart bin/main.dart

# Run this in a separate terminal/window; starts the dev server:
pub run build_runner serve
```

## Production
In production, instead of proxying, our server will serve static files, including
our dart2js-compiled app:

```bash
# Firstly, build the app via dart2js:
pub run build_runner build --release -o build

# Next, just launch the server:
ANGEL_ENV=production dart bin/main.dart
```