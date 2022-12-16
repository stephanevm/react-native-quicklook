import React, { useState, useEffect } from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { QuicklookView } from 'react-native-quicklook';
import ReactNativeBlobUtil from 'react-native-blob-util';

function Preview() {
  const [fileUrl, setFileUrl] = useState('');

  useEffect(() => {
    ReactNativeBlobUtil.config({
      fileCache: true,
      appendExt: 'zip',
    })
      .fetch(
        'GET',
        'http://212.183.159.230/10MB.zip',
        //'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-large-zip-file.zip',
        // 'http://samples.leanpub.com/thereactnativebook-sample.pdf',
        {
          //some headers ..
        }
      )
      .then((res) => {
        // the temp file path
        console.log('The file saved to ', res.path());
        setFileUrl(res.path());
      });
  }, []);

  if (fileUrl) {
    return <QuicklookView fileUrl={fileUrl} style={styles.box} />;
  }

  return <Text style={styles.box}>Loading...</Text>;
}

export default function App() {
  return (
    <View style={styles.container}>
      <Preview />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  box: {
    flex: 1,
  },
});
