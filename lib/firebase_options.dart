import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyB_eD2l_V4s5dAhLASnu_hvp_blDP6Kq3E',
        appId: '1:495047509570:android:e8a962148ffded5c798fdb',
        messagingSenderId: '495047509570',
        projectId: 'lasttry-a3479',
        //storageBucket: 'YOUR_STORAGE_BUCKET',
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      return const FirebaseOptions(
        apiKey: 'YOUR_IOS_API_KEY',
        appId: 'YOUR_IOS_APP_ID',
        messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
        projectId: 'YOUR_PROJECT_ID',
        storageBucket: 'YOUR_STORAGE_BUCKET',
        iosClientId: 'YOUR_IOS_CLIENT_ID',
        iosBundleId: 'YOUR_IOS_BUNDLE_ID',
      );
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for your current platform.'
            'Platform: ${defaultTargetPlatform.toString()}',
      );
    }
  }
}