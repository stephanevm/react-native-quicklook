import React, { useState, useEffect } from 'react';

import { StyleSheet, View, Text } from 'react-native';
import Quicklook from 'react-native-quicklook';
import ReactNativeBlobUtil from 'react-native-blob-util';

function Preview() {
  const [fileUrl, setFileUrl] = useState('');

  useEffect(() => {
    ReactNativeBlobUtil.config({
      fileCache: true,
      appendExt: 'wav',
    })
      .fetch(
        'GET',
        'https://file-examples.com/storage/fe88dacf086398d1c98749c/2017/11/file_example_WAV_1MG.wav',
        //'http://samples.leanpub.com/thereactnativebook-sample.pdf',
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
    Quicklook.open(fileUrl, {});
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
