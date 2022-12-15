import {
  requireNativeComponent,
  UIManager,
  Platform,
  ViewStyle,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-quicklook' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type QuicklookProps = {
  color: string;
  style: ViewStyle;
};

const ComponentName = 'QuicklookView';

export const QuicklookView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<QuicklookProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
