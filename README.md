# sample_news_flutter_app

Flutter app demonstrating how to do http request, layout, etc

## Getting Started

To run the app:

- Follow Flutter documentation and setup information on their [site](https://flutter.io/)
- [Register](https://newsapi.org/docs/get-started) for an API key from NewsAPI, which this app uses to load in news data to display
- Create a `config.dart` file in the `lib` folder
- Add the following to `config.dart` : 

```
library config_library;

class ConfigOptions{
	final String privateNewsAPIKey = "<YOUR KEY HERE>";
	String get getNewsAPIKey => privateNewsAPIKey;
}
```

- The app will automatically load in your config key
- Build and run
