import { NativeModules, NativeEventEmitter } from 'react-native';

const { QuickLookManager } = NativeModules;
const eventEmitter = QuickLookManager
  ? new NativeEventEmitter(QuickLookManager)
  : null;

let lastId = 0;

function open(path: string, options = {}) {
  if (!eventEmitter) {
    return;
  }
  const _options =
    typeof options === 'string' ? { displayName: options } : options;
  const { onDismiss, ...nativeOptions } = _options as any;

  return new Promise((resolve, reject) => {
    const currentId = ++lastId;

    const openSubscription = eventEmitter.addListener(
      'QLViewerDidOpen',
      ({ id, error }) => {
        if (id === currentId) {
          openSubscription.remove();
          return error ? reject(new Error(error)) : resolve('');
        }
      }
    );
    const dismissSubscription = eventEmitter.addListener(
      'QLViewerDidDismiss',
      ({ id }) => {
        if (id === currentId) {
          dismissSubscription.remove();
          onDismiss && onDismiss();
        }
      }
    );

    QuickLookManager.open(path, currentId, nativeOptions);
  });
}

export default { open };
export { open };
