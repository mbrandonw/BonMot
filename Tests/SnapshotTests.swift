import XCTest
@testable import BonMot
import SnapshotTesting

class SnapshotTests: XCTestCase {

  func testSnapshot() {

    let poincare = UIImage.init(named: "poincare", in: Bundle.init(for: SnapshotTests.self), compatibleWith: nil)!
    .styled(with: .baselineOffset(-4))

    let string = """
    <strong>Mathematics</strong> is the <strong>art</strong> of giving the same name to different things.
    - Henri Poincare <poincare/>
    """.styled(with: StringStyle(
        .font(UIFont(name: "AmericanTypewriter", size: 17)!),
        .lineHeightMultiple(1.1)
      ),
      .xmlRules([
        .style("strong", StringStyle(.font(UIFont(name: "AmericanTypewriter-Bold", size: 17)!))),
        .exit(element: "poincare", insert: poincare)
      ])
    )

//    record = true
    assertSnapshot(matching: string, as: .dump)
    assertSnapshot(matching: string, as: .image)

//    XCTAssertEqual(
//      UIFont(name: "AmericanTypewriter", size: 17)!,
//      string.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as! UIFont
//    )
//
//    let paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.lineHeightMultiple = 1.1
//    XCTAssertEqual(
//      paragraphStyle,
//      string.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as! NSParagraphStyle
//    )

  }
}

extension Snapshotting where Value == NSAttributedString, Format == UIImage {
  static let image: Snapshotting = Snapshotting<UIView, UIImage>.image.pullback { (attributedString) -> UIView in
    let label = UILabel()
    label.attributedText = attributedString
    label.numberOfLines = 0
    label.backgroundColor = .white
    label.frame.size = label.systemLayoutSizeFitting(
      CGSize(width: 300, height: 0),
      withHorizontalFittingPriority: .defaultHigh,
      verticalFittingPriority: .defaultLow
    )
    return label
  }
}


