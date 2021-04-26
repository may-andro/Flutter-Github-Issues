# flutter_github

A new Flutter application for Github action and Firebase app distribution demonstration.

## Getting Started

### Here is the work flow for Github actions to upload apk as artifact with every git push:

build_apk:
    name: Build Android APK
    needs: [flutter_test]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-java@v1
        with:
          java-version: '12.x'
      - uses: subosito/flutter-action@v1
        with:
          channel: "stable"
          flutter-version: '2.0.5'
      - run: flutter pub get
      - run: flutter clean
      - name: Build APK
        run: flutter build apk --release
      - name: Upload APK
        uses: actions/upload-artifact@master
        with:
          name: apk
          path: build/app/outputs/apk/release/app-release.apk

### Here is the work flow for Github actions to upload apk as release with every git push:

release_apk:
    name: Build Android Release APK
    needs: [flutter_test]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: actions/setup-java@v1
        with:
          java-version: "12.x"
      - uses: subosito/flutter-action@v1
        with:
          channel: "stable"
          flutter-version: '2.0.5'
      - run: flutter pub get
      - run: flutter clean
      - run: flutter build apk --release --split-per-abi
      - uses: ncipollo/release-action@v1
        with:
          artifacts: "build/app/outputs/apk/release/*.apk"
          token: ${{secrets.FLUTTER_GITHUB_ISSUES}}

### Here is the work flow for Github actions to upload beta apk for QA with every git push:

beta_apk:
    name: Build Android Beta APK
    needs: [build_apk]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: actions/setup-java@v1
        with:
          java-version: "12.x"
      - name: Download APK Artifact
        uses: actions/download-artifact@master
        with:
          name: apk
      - name: Upload APK to Firebase
        uses: wzieba/Firebase-Distribution-Github-Action@v1.3.2
        with:
          appId: ${{secrets.FIREBASE_APP_ID}}
          token: ${{secrets.FIREBASE_TOKEN}}
          groups: Tester
          file: app-release.apk
          
          
### Application Arch: 

App uses the clean architecture with bloc pattern and redux for state management.

