//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `TabBarStory`.
    static let tabBarStory = _R.storyboard.tabBarStory()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "TabBarStory", bundle: ...)`
    static func tabBarStory(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.tabBarStory)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 1 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 13 images.
  struct image {
    /// Image `add_icon`.
    static let add_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "add_icon")
    /// Image `arrow`.
    static let arrow = Rswift.ImageResource(bundle: R.hostingBundle, name: "arrow")
    /// Image `back_icon`.
    static let back_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "back_icon")
    /// Image `checkElement`.
    static let checkElement = Rswift.ImageResource(bundle: R.hostingBundle, name: "checkElement")
    /// Image `configure_icon`.
    static let configure_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "configure_icon")
    /// Image `delete_icon`.
    static let delete_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "delete_icon")
    /// Image `dismiss_icon`.
    static let dismiss_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "dismiss_icon")
    /// Image `faceId_icon`.
    static let faceId_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "faceId_icon")
    /// Image `home_bg`.
    static let home_bg = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_bg")
    /// Image `home_icon`.
    static let home_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_icon")
    /// Image `image_placeholder`.
    static let image_placeholder = Rswift.ImageResource(bundle: R.hostingBundle, name: "image_placeholder")
    /// Image `settings_icon`.
    static let settings_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "settings_icon")
    /// Image `touchId_icon`.
    static let touchId_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "touchId_icon")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "add_icon", bundle: ..., traitCollection: ...)`
    static func add_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.add_icon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "arrow", bundle: ..., traitCollection: ...)`
    static func arrow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrow, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "back_icon", bundle: ..., traitCollection: ...)`
    static func back_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.back_icon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "checkElement", bundle: ..., traitCollection: ...)`
    static func checkElement(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.checkElement, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "configure_icon", bundle: ..., traitCollection: ...)`
    static func configure_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.configure_icon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "delete_icon", bundle: ..., traitCollection: ...)`
    static func delete_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.delete_icon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "dismiss_icon", bundle: ..., traitCollection: ...)`
    static func dismiss_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.dismiss_icon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "faceId_icon", bundle: ..., traitCollection: ...)`
    static func faceId_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.faceId_icon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_bg", bundle: ..., traitCollection: ...)`
    static func home_bg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_bg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_icon", bundle: ..., traitCollection: ...)`
    static func home_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_icon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "image_placeholder", bundle: ..., traitCollection: ...)`
    static func image_placeholder(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.image_placeholder, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "settings_icon", bundle: ..., traitCollection: ...)`
    static func settings_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.settings_icon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "touchId_icon", bundle: ..., traitCollection: ...)`
    static func touchId_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.touchId_icon, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.info` struct is generated, and contains static references to 1 properties.
  struct info {
    struct uiApplicationSceneManifest {
      static let _key = "UIApplicationSceneManifest"
      static let uiApplicationSupportsMultipleScenes = false

      struct uiSceneConfigurations {
        static let _key = "UISceneConfigurations"

        struct uiWindowSceneSessionRoleApplication {
          struct defaultConfiguration {
            static let _key = "Default Configuration"
            static let uiSceneConfigurationName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneConfigurationName") ?? "Default Configuration"
            static let uiSceneDelegateClassName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneDelegateClassName") ?? "$(PRODUCT_MODULE_NAME).SceneDelegate"

            fileprivate init() {}
          }

          fileprivate init() {}
        }

        fileprivate init() {}
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  /// This `R.string` struct is generated, and contains static references to 2 localization tables.
  struct string {
    /// This `R.string.launchScreen` struct is generated, and contains static references to 0 localization keys.
    struct launchScreen {
      fileprivate init() {}
    }

    /// This `R.string.localizable` struct is generated, and contains static references to 28 localization keys.
    struct localizable {
      /// en translation: Add new album
      ///
      /// Locales: en, ru
      static let addAlbumTitle = Rswift.StringResource(key: "addAlbumTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Add photos
      ///
      /// Locales: en, ru
      static let addPhotos = Rswift.StringResource(key: "addPhotos", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Albums
      ///
      /// Locales: en, ru
      static let albumsTitle = Rswift.StringResource(key: "albumsTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Are you sure you want to delete the album %@?
      ///
      /// Locales: en, ru
      static let albumViewerAreYouSure = Rswift.StringResource(key: "albumViewerAreYouSure", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Cancel
      ///
      /// Locales: en, ru
      static let cancel = Rswift.StringResource(key: "cancel", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Change Password
      ///
      /// Locales: en, ru
      static let settingsCellChangePassword = Rswift.StringResource(key: "settingsCellChangePassword", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Change album photo
      ///
      /// Locales: en, ru
      static let changeAlbumPhoto = Rswift.StringResource(key: "changeAlbumPhoto", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Create
      ///
      /// Locales: en, ru
      static let addAlbumCreateButtonTitle = Rswift.StringResource(key: "addAlbumCreateButtonTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Delete
      ///
      /// Locales: en, ru
      static let delete = Rswift.StringResource(key: "delete", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Delete album
      ///
      /// Locales: en, ru
      static let deleteAlbum = Rswift.StringResource(key: "deleteAlbum", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Don't remember the pin code?
      ///
      /// Locales: en, ru
      static let localAuthDontRemember = Rswift.StringResource(key: "localAuthDontRemember", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Edit album
      ///
      /// Locales: en, ru
      static let editAlbum = Rswift.StringResource(key: "editAlbum", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Enter album name...
      ///
      /// Locales: en, ru
      static let addAlbumTextPlaceholder = Rswift.StringResource(key: "addAlbumTextPlaceholder", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Enter pin code
      ///
      /// Locales: en, ru
      static let localAuthEnterPin = Rswift.StringResource(key: "localAuthEnterPin", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Face ID
      ///
      /// Locales: en, ru
      static let settingsCellFaceID = Rswift.StringResource(key: "settingsCellFaceID", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Feedback
      ///
      /// Locales: en, ru
      static let settingsCellFeedback = Rswift.StringResource(key: "settingsCellFeedback", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: General
      ///
      /// Locales: en, ru
      static let settingsCellGeneral = Rswift.StringResource(key: "settingsCellGeneral", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Language
      ///
      /// Locales: en, ru
      static let settingsCellLanguage = Rswift.StringResource(key: "settingsCellLanguage", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Last update: %@
      ///
      /// Locales: en, ru
      static let albumViewerLastUpdate = Rswift.StringResource(key: "albumViewerLastUpdate", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Password
      ///
      /// Locales: en, ru
      static let settingsCellPassword = Rswift.StringResource(key: "settingsCellPassword", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Publications: %@
      ///
      /// Locales: en, ru
      static let albumViewerCountLabel = Rswift.StringResource(key: "albumViewerCountLabel", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Security
      ///
      /// Locales: en, ru
      static let settingsCellSecurity = Rswift.StringResource(key: "settingsCellSecurity", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Select
      ///
      /// Locales: en, ru
      static let select = Rswift.StringResource(key: "select", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Settings
      ///
      /// Locales: en, ru
      static let settingsTitle = Rswift.StringResource(key: "settingsTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: This will permanently delete all content in the album
      ///
      /// Locales: en, ru
      static let albumViewerDeleteAlbumDescription = Rswift.StringResource(key: "albumViewerDeleteAlbumDescription", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Touch ID
      ///
      /// Locales: en, ru
      static let settingsCellTouchID = Rswift.StringResource(key: "settingsCellTouchID", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Version
      ///
      /// Locales: en, ru
      static let settingsCellVersion = Rswift.StringResource(key: "settingsCellVersion", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Yes
      ///
      /// Locales: en, ru
      static let yes = Rswift.StringResource(key: "yes", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)

      /// en translation: Add new album
      ///
      /// Locales: en, ru
      static func addAlbumTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("addAlbumTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "addAlbumTitle"
        }

        return NSLocalizedString("addAlbumTitle", bundle: bundle, comment: "")
      }

      /// en translation: Add photos
      ///
      /// Locales: en, ru
      static func addPhotos(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("addPhotos", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "addPhotos"
        }

        return NSLocalizedString("addPhotos", bundle: bundle, comment: "")
      }

      /// en translation: Albums
      ///
      /// Locales: en, ru
      static func albumsTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("albumsTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "albumsTitle"
        }

        return NSLocalizedString("albumsTitle", bundle: bundle, comment: "")
      }

      /// en translation: Are you sure you want to delete the album %@?
      ///
      /// Locales: en, ru
      static func albumViewerAreYouSure(_ value1: String, preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          let format = NSLocalizedString("albumViewerAreYouSure", bundle: hostingBundle, comment: "")
          return String(format: format, locale: applicationLocale, value1)
        }

        guard let (locale, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "albumViewerAreYouSure"
        }

        let format = NSLocalizedString("albumViewerAreYouSure", bundle: bundle, comment: "")
        return String(format: format, locale: locale, value1)
      }

      /// en translation: Cancel
      ///
      /// Locales: en, ru
      static func cancel(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("cancel", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "cancel"
        }

        return NSLocalizedString("cancel", bundle: bundle, comment: "")
      }

      /// en translation: Change Password
      ///
      /// Locales: en, ru
      static func settingsCellChangePassword(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsCellChangePassword", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsCellChangePassword"
        }

        return NSLocalizedString("settingsCellChangePassword", bundle: bundle, comment: "")
      }

      /// en translation: Change album photo
      ///
      /// Locales: en, ru
      static func changeAlbumPhoto(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("changeAlbumPhoto", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "changeAlbumPhoto"
        }

        return NSLocalizedString("changeAlbumPhoto", bundle: bundle, comment: "")
      }

      /// en translation: Create
      ///
      /// Locales: en, ru
      static func addAlbumCreateButtonTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("addAlbumCreateButtonTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "addAlbumCreateButtonTitle"
        }

        return NSLocalizedString("addAlbumCreateButtonTitle", bundle: bundle, comment: "")
      }

      /// en translation: Delete
      ///
      /// Locales: en, ru
      static func delete(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("delete", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "delete"
        }

        return NSLocalizedString("delete", bundle: bundle, comment: "")
      }

      /// en translation: Delete album
      ///
      /// Locales: en, ru
      static func deleteAlbum(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("deleteAlbum", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "deleteAlbum"
        }

        return NSLocalizedString("deleteAlbum", bundle: bundle, comment: "")
      }

      /// en translation: Don't remember the pin code?
      ///
      /// Locales: en, ru
      static func localAuthDontRemember(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("localAuthDontRemember", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "localAuthDontRemember"
        }

        return NSLocalizedString("localAuthDontRemember", bundle: bundle, comment: "")
      }

      /// en translation: Edit album
      ///
      /// Locales: en, ru
      static func editAlbum(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("editAlbum", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "editAlbum"
        }

        return NSLocalizedString("editAlbum", bundle: bundle, comment: "")
      }

      /// en translation: Enter album name...
      ///
      /// Locales: en, ru
      static func addAlbumTextPlaceholder(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("addAlbumTextPlaceholder", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "addAlbumTextPlaceholder"
        }

        return NSLocalizedString("addAlbumTextPlaceholder", bundle: bundle, comment: "")
      }

      /// en translation: Enter pin code
      ///
      /// Locales: en, ru
      static func localAuthEnterPin(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("localAuthEnterPin", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "localAuthEnterPin"
        }

        return NSLocalizedString("localAuthEnterPin", bundle: bundle, comment: "")
      }

      /// en translation: Face ID
      ///
      /// Locales: en, ru
      static func settingsCellFaceID(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsCellFaceID", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsCellFaceID"
        }

        return NSLocalizedString("settingsCellFaceID", bundle: bundle, comment: "")
      }

      /// en translation: Feedback
      ///
      /// Locales: en, ru
      static func settingsCellFeedback(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsCellFeedback", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsCellFeedback"
        }

        return NSLocalizedString("settingsCellFeedback", bundle: bundle, comment: "")
      }

      /// en translation: General
      ///
      /// Locales: en, ru
      static func settingsCellGeneral(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsCellGeneral", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsCellGeneral"
        }

        return NSLocalizedString("settingsCellGeneral", bundle: bundle, comment: "")
      }

      /// en translation: Language
      ///
      /// Locales: en, ru
      static func settingsCellLanguage(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsCellLanguage", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsCellLanguage"
        }

        return NSLocalizedString("settingsCellLanguage", bundle: bundle, comment: "")
      }

      /// en translation: Last update: %@
      ///
      /// Locales: en, ru
      static func albumViewerLastUpdate(_ value1: String, preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          let format = NSLocalizedString("albumViewerLastUpdate", bundle: hostingBundle, comment: "")
          return String(format: format, locale: applicationLocale, value1)
        }

        guard let (locale, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "albumViewerLastUpdate"
        }

        let format = NSLocalizedString("albumViewerLastUpdate", bundle: bundle, comment: "")
        return String(format: format, locale: locale, value1)
      }

      /// en translation: Password
      ///
      /// Locales: en, ru
      static func settingsCellPassword(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsCellPassword", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsCellPassword"
        }

        return NSLocalizedString("settingsCellPassword", bundle: bundle, comment: "")
      }

      /// en translation: Publications: %@
      ///
      /// Locales: en, ru
      static func albumViewerCountLabel(_ value1: String, preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          let format = NSLocalizedString("albumViewerCountLabel", bundle: hostingBundle, comment: "")
          return String(format: format, locale: applicationLocale, value1)
        }

        guard let (locale, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "albumViewerCountLabel"
        }

        let format = NSLocalizedString("albumViewerCountLabel", bundle: bundle, comment: "")
        return String(format: format, locale: locale, value1)
      }

      /// en translation: Security
      ///
      /// Locales: en, ru
      static func settingsCellSecurity(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsCellSecurity", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsCellSecurity"
        }

        return NSLocalizedString("settingsCellSecurity", bundle: bundle, comment: "")
      }

      /// en translation: Select
      ///
      /// Locales: en, ru
      static func select(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("select", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "select"
        }

        return NSLocalizedString("select", bundle: bundle, comment: "")
      }

      /// en translation: Settings
      ///
      /// Locales: en, ru
      static func settingsTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsTitle"
        }

        return NSLocalizedString("settingsTitle", bundle: bundle, comment: "")
      }

      /// en translation: This will permanently delete all content in the album
      ///
      /// Locales: en, ru
      static func albumViewerDeleteAlbumDescription(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("albumViewerDeleteAlbumDescription", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "albumViewerDeleteAlbumDescription"
        }

        return NSLocalizedString("albumViewerDeleteAlbumDescription", bundle: bundle, comment: "")
      }

      /// en translation: Touch ID
      ///
      /// Locales: en, ru
      static func settingsCellTouchID(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsCellTouchID", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsCellTouchID"
        }

        return NSLocalizedString("settingsCellTouchID", bundle: bundle, comment: "")
      }

      /// en translation: Version
      ///
      /// Locales: en, ru
      static func settingsCellVersion(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("settingsCellVersion", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "settingsCellVersion"
        }

        return NSLocalizedString("settingsCellVersion", bundle: bundle, comment: "")
      }

      /// en translation: Yes
      ///
      /// Locales: en, ru
      static func yes(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("yes", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "yes"
        }

        return NSLocalizedString("yes", bundle: bundle, comment: "")
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try tabBarStory.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct tabBarStory: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let hehe = StoryboardViewControllerResource<RootTabBarController>(identifier: "Hehe")
      let name = "TabBarStory"

      func hehe(_: Void = ()) -> RootTabBarController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: hehe)
      }

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
        if _R.storyboard.tabBarStory().hehe() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'hehe' could not be loaded from storyboard 'TabBarStory' as 'RootTabBarController'.") }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
