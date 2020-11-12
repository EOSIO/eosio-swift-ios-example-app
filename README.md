![Swift Logo](/img/swift-logo.png)
# EOSIO SDK for Swift: iOS Example App ![EOSIO Alpha](https://img.shields.io/badge/EOSIO-Alpha-blue.svg)


[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift-ios-example-app/blob/master/LICENSE)
[![Swift 5.2](https://img.shields.io/badge/Language-Swift_5.2-orange.svg)](https://swift.org)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2012-blue.svg)

The EOSIO SDK for Swift: iOS Example App is a simple application demonstrating how to integrate with EOSIO-based blockchains using [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift). The application does two things: fetches your account token balance and pushes a transfer action.

*All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.*

<p align="center">
  <img src="/img/cap1.png" width="200" />
  <span> </span>
  <img src="/img/cap2.png" width="200" />
</p>

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [About the App](#about-the-app)
- [Want to Help?](#want-to-help)
- [License & Legal](#license)

## Requirements

* Xcode 11 or higher
* Swift Package Manager (SPM) 5.2 or higher
* For iOS, iOS 12+

## Installation

To get the example application up and running:

1. Clone this repo: `git clone https://github.com/EOSIO/eosio-swift-ios-example-app.git`
1. The project is already configured to use Swift Package Manager for dependencies and will download them automatically.
1. At the top of `ViewController.swift`, supply values for the node URL, private key(s), `from` account, `to` account, `currencySymbol`, `quantity` and anything else you wish to adjust.
1. Run the app!

## About the App

This app demonstrates how to:

* use the [default RPC provider](https://github.com/EOSIO/eosio-swift/tree/master#rpc-using-the-default-rpc-provider) to query the chain for an account's token balance,
* get a new transaction from the [`TransactionFactory`](https://github.com/EOSIO/eosio-swift/tree/master#the-transaction-factory),
* create an action and add it to a transaction,
* and sign and broadcast the transaction.

To do this, we're using a few libraries and providers, in concert:

* [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift): The core EOSIO SDK for Swift library
* [Default RPC Provider](https://github.com/EOSIO/eosio-swift/tree/master#rpc-using-the-default-rpc-provider): The default RPC provider implementation in the core library
* [ABIEOS Serialization Provider](https://github.com/EOSIO/eosio-swift/tree/master#abieos-serialization-provider-usage): A pluggable serialization provider for EOSIO SDK for Swift using ABIEOS (for transaction and action conversion between JSON and binary data representations)
* [Softkey Signature Provider](https://github.com/EOSIO/eosio-swift/tree/master#softkey-signature-provider-usage): An example pluggable signature provider for EOSIO SDK for Swift for signing transactions using in-memory keys (not for production use)

For a more comprehensive list of available provider implementations, see [EOSIO SDK for Swift - Provider Protocol Architecture](https://github.com/EOSIO/eosio-swift/tree/master#provider-protocol-architecture).

The code in `ViewController.swift` is documented with brief inline comments. For a deeper dive into EOSIO SDK for Swift, see the [Usage Documentation here](https://github.com/EOSIO/eosio-swift/tree/master#basic-usage).


## Want to help?

Interested in improving the example application? That's awesome! Here are some [Contribution Guidelines](./CONTRIBUTING.md) and the [Code of Conduct](./CONTRIBUTING.md#conduct).

If you'd like to contribute to the EOSIO SDK for Swift libraries themselves, please see the contribution guidelines on those individual repos.

## License

[MIT](https://github.com/EOSIO/eosio-swift-ios-example-app/blob/master/LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation. Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.  Any person using or offering this software in connection with providing software, goods or services to third parties shall advise such third parties of these license terms, disclaimers and exclusions of liability.  Block.one, EOSIO, EOSIO Labs, EOS, the heptahedron and associated logos are trademarks of Block.one.

Wallets and related components are complex software that require the highest levels of security.  If incorrectly built or used, they may compromise users’ private keys and digital assets. Wallet applications and related components should undergo thorough security evaluations before being used.  Only experienced developers should work with this software.
