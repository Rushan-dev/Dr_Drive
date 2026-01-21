class Config {
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue:
        'AIzaSyA6TCAfxe_u-VrPCAAlmIEjGCfwjYtRj9Y', // Note: Move this to environment variables in production
  );
}
