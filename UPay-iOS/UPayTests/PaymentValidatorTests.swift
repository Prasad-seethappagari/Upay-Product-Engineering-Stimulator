import XCTest
@testable import UPay

final class PaymentValidatorTests: XCTestCase {
    private let validator = PaymentValidator()

    func testValidP2PPayment() {
        let result = validator.validate(
            type: .p2p,
            payee: "alex@upi",
            amount: 500,
            note: "Lunch",
            reference: nil
        )

        XCTAssertTrue(result.isValid)
    }

    func testRejectsZeroAmount() {
        let result = validator.validate(
            type: .p2p,
            payee: "alex@upi",
            amount: 0,
            note: "",
            reference: nil
        )

        XCTAssertFalse(result.isValid)
    }

    func testRejectsP2PWithoutUPIIdentifier() {
        let result = validator.validate(
            type: .p2p,
            payee: "alex",
            amount: 500,
            note: "",
            reference: nil
        )

        XCTAssertFalse(result.isValid)
    }

    func testBillRequiresReference() {
        let result = validator.validate(
            type: .bill,
            payee: "Electricity",
            amount: 1000,
            note: "",
            reference: ""
        )

        XCTAssertFalse(result.isValid)
    }
}
