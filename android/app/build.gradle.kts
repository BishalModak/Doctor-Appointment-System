plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin
    id("com.google.gms.google-services")    // Firebase plugin
}

android {
    namespace = "com.example.firebasesetup"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.example.firebasesetup"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    ndkVersion = "25.2.9519653"

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // for testing only
        }
    }
}

flutter {
    source = "../.."
}
