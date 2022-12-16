# react-native-quicklook

ios quicklook

## Installation

```sh
npm install react-native-quicklook
```

## Usage

```js
import Quicklook from 'react-native-quicklook';

// ...

Quicklook.open(path, { displayName: 'demo' }) //path to local file.
  .then(() => {
    // success
  })
  .catch((error) => {
    // error
  });
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
