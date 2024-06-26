import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import LocalizableMacros

let testMacros: [String: Macro.Type] = [
    "Localizable": LocalizableMacro.self,
]

final class LocalizableMacroTests: XCTestCase {
    func testLocalizedStructWithoutEnumString() {
        assertMacroExpansion(
            """
            @Localizable
            struct Localization {
            }
            """,
            expandedSource: """
            struct Localization {
            }
            """,
            diagnostics: [
                .init(message: "'Localizable' macro needs an internal enum which is a set of keys for localization", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    
    func testLocalizedStructWithPrivateLocalizationStringEnum() {
        assertMacroExpansion(
            """
            @Localizable
            struct Localization {
                private enum LocalizationString {
                    case next
                    case prev
                }
            }
            """,
            expandedSource: """
            struct Localization {
                private enum LocalizationString {
                    case next
                    case prev
                }
                static let next = String(localized: "next")
                static let prev = String(localized: "prev")
            }
            """,
            macros: testMacros
        )
    }
    
    func testLocalizedStructWithSomeLocalizationStringEnumCases() {
        assertMacroExpansion(
            """
            @Localizable
            struct Localization {
                enum LocalizationString {
                    case next
                    case prev
                }
            }
            """,
            expandedSource: """
            struct Localization {
                enum LocalizationString {
                    case next
                    case prev
                }
                static let next = String(localized: "next")
                static let prev = String(localized: "prev")
            }
            """,
            macros: testMacros
        )
    }
    
    func testLocalizedClassWithSomeLocalizationStringEnumCases() {
        assertMacroExpansion(
            """
            @Localizable
            class Localization {
                enum LocalizationString {
                    case next
                    case prev
                }
            }
            """,
            expandedSource: """
            class Localization {
                enum LocalizationString {
                    case next
                    case prev
                }
                static let next = String(localized: "next")
                static let prev = String(localized: "prev")
            }
            """,
            macros: testMacros
        )
    }
    
    func testLocalizedEnumWithSomeLocalizationStringEnumCases() {
        assertMacroExpansion(
            """
            @Localizable
            enum Localization {
                enum LocalizationString {
                    case next
                    case prev
                }
            }
            """,
            expandedSource: """
            enum Localization {
                enum LocalizationString {
                    case next
                    case prev
                }
                static let next = String(localized: "next")
                static let prev = String(localized: "prev")
            }
            """,
            macros: testMacros
        )
    }
    
    func testLocalizedStructWithLocalizationStringEnumWhereCasesWithParams() {
        assertMacroExpansion(
            """
            @Localizable
            struct Localization {
                enum LocalizationString {
                    case next
                    case prev
                    case news(String)
                    case smth(String, String)
                }
            }
            """,
            expandedSource: """
            struct Localization {
                enum LocalizationString {
                    case next
                    case prev
                    case news(String)
                    case smth(String, String)
                }
                static let next = String(localized: "next")
                static let prev = String(localized: "prev")
                static func news(_ value0: String) -> String {
                    String(localized: "news \\(value0)")
                }
                static func smth(_ value0: String, _ value1: String) -> String {
                    String(localized: "smth \\(value0) \\(value1)")
                }
            }
            """,
            macros: testMacros
        )
    }
}
