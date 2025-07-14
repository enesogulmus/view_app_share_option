# view_app_share_option

## 📦 Akıllı Dosya Paylaşım Flutter Plugini / Smart File Share Flutter Plugin

---

### 🇹🇷 Türkçe Açıklama

Bu Flutter plugini, uygulamanızın iOS ve Android platformlarında sistemin dosya paylaşım seçenekleri arasında görünmesini sağlar. Desteklenen dosya tipleriyle (PDF, Word, Excel, PowerPoint) uygulamanız üzerinden dosya paylaşımı yapıldığında, dosyanın yolunu Flutter tarafında kolayca yakalayabilirsiniz.

#### 🚀 Özellikler
- iOS ve Android desteği
- PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX dosya tipleri desteği
- Paylaşılan dosyanın yolunu uygulama içinde yakalama
- Basit ve hızlı entegrasyon

#### 🛠️ Kurulum
`pubspec.yaml` dosyanıza ekleyin:
```yaml
dependencies:
  view_app_share_option:
```

#### ⚙️ Platform Gereksinimleri
- **Android:** minSdkVersion 21+
- **iOS:** iOS 12.0+

#### 📲 Kullanım
```dart
import 'package:view_app_share_option/view_app_share_option.dart';

final plugin = ViewAppShareOption();

plugin.onFileShared.listen((_) async {
  final path = await plugin.getSharedFile();
  print('Paylaşılan dosya yolu: ' + (path ?? 'Yok'));
});
```

Daha fazla örnek için `example/` klasörüne bakabilirsiniz.

#### 📁 Desteklenen Dosya Tipleri
- PDF (.pdf)
- Word (.doc, .docx)
- Excel (.xls, .xlsx)
- PowerPoint (.ppt, .pptx)

---

### ⚙️ Platforma Özel Ayarlar

#### iOS: Info.plist
Aşağıdaki anahtarlar Info.plist dosyanızda **mutlaka** bulunmalı:

```xml
<key>CFBundleDocumentTypes</key>
<array>
  <!-- PDF, Word, Excel, PowerPoint için örnekler -->
  ...
</array>
<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
<key>NSUserActivityTypes</key>
<array>
  <string>NSUserActivityTypeBrowsingWeb</string>
  <string>com.apple.documentManager.documentInteraction</string>
</array>
```

#### iOS: AppDelegate.swift
Aşağıdaki override fonksiyonları ekleyin:
```swift
override func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  return super.application(application, open: url, options: options)
}

override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
  return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
}
```

#### Android: AndroidManifest.xml
Aşağıdaki intent-filter ve izinler ekli olmalı:
```xml
<activity ...>
  ...
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:mimeType="application/pdf" />
    <data android:mimeType="application/msword" />
    <data android:mimeType="application/vnd.openxmlformats-officedocument.wordprocessingml.document" />
    <data android:mimeType="application/vnd.ms-excel" />
    <data android:mimeType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />
    <data android:mimeType="application/vnd.ms-powerpoint" />
    <data android:mimeType="application/vnd.openxmlformats-officedocument.presentationml.presentation" />
    <data android:scheme="file" />
    <data android:scheme="content" />
  </intent-filter>
  <intent-filter>
    <action android:name="android.intent.action.SEND" />
    <category android:name="android.intent.category.DEFAULT" />
    <data android:mimeType="*/*" />
  </intent-filter>
</activity>
```

---

### 🇬🇧 English Description

This Flutter plugin allows your app to appear in the system's file share options on both iOS and Android. When a supported file type (PDF, Word, Excel, PowerPoint) is shared to your app, you can easily access the file path in Flutter.

#### 🚀 Features
- iOS & Android support
- PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX file types
- Catch the shared file path inside your app
- Simple and fast integration

#### 🛠️ Installation
Add to your `pubspec.yaml`:
```yaml
dependencies:
  view_app_share_option:
```

#### ⚙️ Platform Requirements
- **Android:** minSdkVersion 21+
- **iOS:** iOS 12.0+

#### 📲 Usage
```dart
import 'package:view_app_share_option/view_app_share_option.dart';

final plugin = ViewAppShareOption();

plugin.onFileShared.listen((_) async {
  final path = await plugin.getSharedFile();
  print('Shared file path: ' + (path ?? 'None'));
});
```

See the `example/` directory for more.

#### 📁 Supported File Types
- PDF (.pdf)
- Word (.doc, .docx)
- Excel (.xls, .xlsx)
- PowerPoint (.ppt, .pptx)

---

### ⚙️ Platform-specific Setup

#### iOS: Info.plist
Make sure the following keys are present in your Info.plist:

```xml
<key>CFBundleDocumentTypes</key>
<array>
  <!-- PDF, Word, Excel, PowerPoint examples -->
  ...
</array>
<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
<key>NSUserActivityTypes</key>
<array>
  <string>NSUserActivityTypeBrowsingWeb</string>
  <string>com.apple.documentManager.documentInteraction</string>
</array>
```

#### iOS: AppDelegate.swift
Add the following override functions:
```swift
override func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  return super.application(application, open: url, options: options)
}

override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
  return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
}
```

#### Android: AndroidManifest.xml
Make sure the following intent-filters and permissions are present:
```xml
<activity ...>
  ...
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:mimeType="application/pdf" />
    <data android:mimeType="application/msword" />
    <data android:mimeType="application/vnd.openxmlformats-officedocument.wordprocessingml.document" />
    <data android:mimeType="application/vnd.ms-excel" />
    <data android:mimeType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />
    <data android:mimeType="application/vnd.ms-powerpoint" />
    <data android:mimeType="application/vnd.openxmlformats-officedocument.presentationml.presentation" />
    <data android:scheme="file" />
    <data android:scheme="content" />
  </intent-filter>
  <intent-filter>
    <action android:name="android.intent.action.SEND" />
    <category android:name="android.intent.category.DEFAULT" />
    <data android:mimeType="*/*" />
  </intent-filter>
</activity>
```

---

#### 🤝 Katkı / Contribution
Pull request ve issue açabilirsiniz. Katkılarınızı bekliyoruz! / Pull requests and issues are welcome!

#### 📄 Lisans / License
Bu proje [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) ile lisanslanmıştır. Tüm ayrıntılar için LICENSE dosyasına bakınız.

