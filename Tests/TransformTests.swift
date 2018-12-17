//
//  TransformTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 3/24/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import XCTest
@testable import BonMot
import SnapshotTesting

private extension Locale {

    static var german: Locale {
        return Locale(identifier: "de_DE")
    }

}

class TransformTests: XCTestCase {

    func testStyle(withTransform theTransform: Transform) -> StringStyle {
        return StringStyle(
            .color(.darkGray),
            .xmlRules([
                .style("bold", StringStyle(
                    .color(.blue),
                    .transform(theTransform)
                )),
                ]))
    }

    func testLowercase() {
        let styled = "Time remaining: <bold>&lt; 1 DAY</bold> FROM NOW"
        .styled(with: testStyle(withTransform: .lowercase))

        assertSnapshot(matching: styled, as: .dump)
        assertSnapshot(matching: styled, as: .image)
    }

    func testUppercase() {
        let styled = "Time remaining: <bold>&lt; 1 day</bold> from now"
        .styled(with: testStyle(withTransform: .uppercase))

        assertSnapshot(matching: styled, as: .dump)
        assertSnapshot(matching: styled, as: .image)
    }

    func testCapitalized() {
        let styled = "Time remaining: <bold>&lt; 1 day after the moment that is now</bold> (but no longer)"
        .styled(with: testStyle(withTransform: .capitalized))

        assertSnapshot(matching: styled, as: .dump)
        assertSnapshot(matching: styled, as: .image)
    }

    func testLocalizedLowercase() {
        let styled = "Translation: <bold>&lt;Straße&gt;</bold> is German for <bold>street</bold>.".styled(with: testStyle(withTransform: .lowercaseWithLocale(.german)))

        assertSnapshot(matching: styled, as: .dump)
        assertSnapshot(matching: styled, as: .image)
    }

    func testLocalizedUppercase() {
        let styled = "Translation: <bold>&lt;Straße&gt;</bold> is German for <bold>street</bold>.".styled(with: testStyle(withTransform: .uppercaseWithLocale(.german)))

        assertSnapshot(matching: styled, as: .dump)
        assertSnapshot(matching: styled, as: .image)
    }

    func testLocalizedCapitalized() {
        let styled = "Translation: <bold>&lt;straße&gt;</bold> is German for <bold>street</bold>.".styled(with: testStyle(withTransform: .capitalizedWithLocale(.german)))

        assertSnapshot(matching: styled, as: .dump)
        assertSnapshot(matching: styled, as: .image)
    }

    func testCustom() {
        let doubler = { (string: String) -> String in
            let doubled = string.flatMap { (character: Character) -> [Character] in
                switch character {
                case " ": return [character]
                default: return [character, character]
                }
            }
            let joined = String(doubled)
            return joined
        }

        let styled = "Time remaining: <bold>&lt; 1 day</bold> from now"
            .styled(with: testStyle(withTransform: .custom(doubler)))

        assertSnapshot(matching: styled, as: .dump)
        assertSnapshot(matching: styled, as: .image)
    }

}
