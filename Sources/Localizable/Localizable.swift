/// A macro that produces variables and methods, for your localization files.
/// From the enumeration keys.
///
/// For example, with the following input code:
///```swift
/// @Localizable
/// struct Localization {
///     private enum Strings {
///         case login_error
///         case login_welcome(String)
///     }
/// }
///```
/// The macro `Localizable` output will produce:
///```swift
/// @Localizable
/// struct Localization {
///     private enum Strings {
///         case login_error
///         case login_welcome(String)
///     }
///
///     static let login_error = String(localized: "login_error")
///     static func login_welcome(_ value0: String) -> String {
///         String(localized: "login_error \(value0)")
///     }
/// }
///```
@attached(member, names: arbitrary)
public macro Localizable() = #externalMacro(module: "LocalizableMacros", type: "LocalizableMacro")
