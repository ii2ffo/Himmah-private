# همّة — Himmah

Flutter fitness application.

## Correct repository structure
Upload the **contents of this folder** to the root of the GitHub repository. `pubspec.yaml`, `lib/`, and `codemagic.yaml` must appear directly on the repository home page.

## Codemagic
Use **Switch to YAML configuration**, then select either:
- `android` to produce an APK.
- `ios-unsigned` to verify the iOS build. Installing on an iPhone or publishing through TestFlight requires Apple signing credentials.

The native Android and iOS runner files are generated on Codemagic during the build.
