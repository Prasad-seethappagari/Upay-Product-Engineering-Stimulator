# UPay — iOS UPI Product Engineering Project

UPay is a **local UPI payment simulator** built for an iOS Product Engineer internship portfolio.
It is intentionally designed around the engineering habits described in the role:

- Swift + SwiftUI
- MVVM
- Combine / reactive state
- Repository pattern
- Payment validation before execution
- Transaction state machine
- Device-friendly logging
- Git-friendly, narrow feature scope
- P2P, merchant, QR, bill-payment and transaction-history flows

> **Important:** This project does not connect to a bank, NPCI, UPI rail, or real payment SDK. No real money moves.
> It is a portfolio/learning simulator whose purpose is to demonstrate product-engineering patterns.

## Requirements

- macOS with Xcode 15+
- iOS 17+
- Swift 5.9+
- A simulator or physical iPhone

## Suggested Xcode setup

Create a new **iOS App** in Xcode:

- Product Name: `UPay`
- Interface: SwiftUI
- Language: Swift
- Minimum Deployment: iOS 17

Then copy the `UPay/` source folder from this repository into the Xcode target.

## Architecture

```text
SwiftUI Views
     ↓
ViewModels
     ↓
Repository Protocol
     ↓
MockPaymentRepository
     ↓
In-memory transaction store
```

Supporting services:

```text
PaymentValidator
PaymentLogger
QRCodeGenerator
```

The payment flow is deliberately:

```text
Input
  ↓
Validate
  ↓
Create pending transaction
  ↓
Simulate network/API call
  ↓
Success / Failure
  ↓
Persist in repository
  ↓
Update UI
```

## Product flows

1. P2P payment
2. Merchant payment
3. QR payment
4. Bill payment
5. Transaction history
6. Transaction detail
7. Payment validation
8. Success/failure state
9. Debug logging

## Engineering decisions

### Verification first
The app validates:

- UPI ID format
- amount > 0
- amount limit
- note length
- bill/customer reference where required

The repository is not called until validation succeeds.

### Narrow scope
The app uses an in-memory mock repository instead of introducing a backend, authentication system, or real payment SDK.

### Minimalism
The project intentionally avoids unnecessary third-party dependencies. The QR code is generated using Apple's CoreImage APIs.

### Production-minded failure states
The UI explicitly handles:

- invalid input
- processing
- success
- failure
- empty transaction history

## Interview talking points

Be able to explain:

- Why MVVM?
- Why use a repository protocol?
- Where would a real API client live?
- Why validate before making a payment request?
- How would you prevent duplicate payments?
- How would you add idempotency?
- How would you handle network timeout?
- How would you store transaction history securely?
- How would you test the validator?
- What would you log in production and what would you never log?
- How would UIKit and SwiftUI coexist?
- Where could Combine be useful?
- How would you debug a payment that succeeds on simulator but fails on a physical iPhone?

## Future production upgrades

For a real fintech system, this simulator would need:

- backend APIs
- authentication/device binding
- secure credential/key handling
- idempotency keys
- server-side transaction state
- retry policy
- observability
- analytics with privacy controls
- secure local storage
- certificate/network security appropriate to the backend
- automated unit/UI tests
- real payment SDK integration under approved provider/NPCI flows

Do not present the simulator as a real UPI app in interviews.
