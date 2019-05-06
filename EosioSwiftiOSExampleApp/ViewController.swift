//
//  ViewController.swift
//  EosioSwiftiOSExampleApp
//
//  Created by Brandon Fancher on 4/25/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import UIKit
import EosioSwift
import EosioSwiftAbieosSerializationProvider
import EosioSwiftSoftkeySignatureProvider

// SUPPLY VALUES TO THESE VARIABLES TO RUN EXAMPLE APP

    let endpoint = URL(string: "https://supply-value")! // override with node endpoint URL
    let privateKeys = ["SUPPLY VALUE"]
    let currencySymbol = "SYS" // override to the token of your choice (e.g., "EOS")
    let permission = "active" // override if needed

    // Transfer action data variables
    let from = "SUPPLY VALUE"
    let to = "SUPPLY VALUE"
    let quantity = "1.0000 SYS" // override if needed (e.g., "1.0000 EOS")
    let memo = "" // override if needed

// END VARIABLE VALUES CONFIG SECTION

/// Action data structure for transaction.
struct TransferActionData: Codable {
    var from: EosioName
    var to: EosioName
    var quantity: String
    var memo: String = ""
}

let buttonHeight = CGFloat(integerLiteral: 200)


class ViewController: UIViewController {
    let button = RoundButton()
    var buttonTapped = false

    var variablesSupplied = true

    var rpcProvider: EosioRpcProvider?
    var transactionFactory: EosioTransactionFactory?

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var idLabelBottomConstraint: NSLayoutConstraint!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if endpoint.absoluteString == "https://supply-value" || privateKeys[0] == "SUPPLY VALUE" || from == "SUPPLY VALUE" || to == "SUPPLY VALUE" {
            variablesSupplied = false
            return
        }

        // First, we set our providers.
        rpcProvider = EosioRpcProvider(endpoint: endpoint)
        guard let rpcProvider = rpcProvider else {
            print("ERROR: No RPC provider found.")
            return
        }

        let serializationProvider = EosioAbieosSerializationProvider()

        // Note that the EosioSoftkeySignatureProvider is for testing purposes only; storing keys in memory is not secure.
        // We recommend https://www.github.com/EOSIO/eosio-swift-vault-signature-provider for production apps.
        let signatureProvider = try! EosioSoftkeySignatureProvider(privateKeys: privateKeys)

        // We then instantiate the transaction factory so that we can always get new, ready-to-use transactions with these providers pre-configured.
        transactionFactory = EosioTransactionFactory(
            rpcProvider: rpcProvider,
            signatureProvider: signatureProvider,
            serializationProvider: serializationProvider
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // If developer does not supply values for chain and action information, throw alert.
        if variablesSupplied == false {
            alertSupplyValues()
            return
        }

        refreshBalance() // After the view loads, we use the RPC provider to get the account's currency balance.
        setUpView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        balanceTopConstraint.constant = ((self.view.frame.height - buttonHeight) / 4) - 37
        idLabelBottomConstraint.constant = ((self.view.frame.height - buttonHeight) / 4) - 25

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resumeAnimation),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func alertSupplyValues() {
        let message = "To run this example app, please supply the required values at the top of ViewController.swift.\n\nRefer to the instructions in README.md for more details."
        let alert = UIAlertController(title: "Configuration Required", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Close App", style: .default, handler: { (action) in
            exit(-1)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func setUpView() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        button.doWhenTapped {
            if self.buttonTapped{
                return
            }
            self.buttonTapped = true
            self.button.doWaitingAnimation()
            self.executeTransferTransaction()
        }

        button.backgroundColor = .blue
        button.layer.cornerRadius = 100
        button.label.text = "Send Tokens"
    }

    @objc func resumeAnimation() {
        self.button.doNormalAnimation()
    }

    func refreshBalance() {
        guard let rpcProvider = rpcProvider else {
            print("ERROR: No RPC provider found.")
            return
        }

        // Set up the currency balance request.
        let balanceRequest = EosioRpcCurrencyBalanceRequest(code: "eosio.token", account: from, symbol: currencySymbol)

        // Pass it into our RPC Provider instance. Handle success and failure as appropriate.
        // Remember, you can also get promises back with: `rpcProvider.getCurrencyBalance(.promise, requestParameters: balanceRequest)`.
        rpcProvider.getCurrencyBalance(requestParameters: balanceRequest) { result in
            switch result {
            case .success(let balance):
                self.refreshBalanceLabel(balance: balance.currencyBalance[0])
            case .failure(let error):
                DispatchQueue.main.async {
                    self.button.doErrorAnimation()
                    self.balanceLabel.text = "BALANCE ERROR"
                }
                print("BALANCE REFRESH FAILURE")
                print(error)
                print(error.reason)
            }
        }
    }

    // Executed when the "Send Tokens" button is tapped.
    func executeTransferTransaction() {
        guard let transactionFactory = transactionFactory else {
            print("ERROR: No transaction factory found.")
            return
        }

        // Get a new transaction from our transaction factory.
        let transaction = transactionFactory.newTransaction()

        // Set up our transfer action.
        let action = try! EosioTransaction.Action(
            account: EosioName("eosio.token"),
            name: EosioName("transfer"),
            authorization: [EosioTransaction.Action.Authorization(
                actor: EosioName(from),
                permission: EosioName(permission)
            )],
            data: TransferActionData(
                from: EosioName(from),
                to: EosioName(to),
                quantity: quantity,
                memo: memo
            )
        )

        // Add that action to the transaction.
        transaction.add(action: action)

        // Sign and broadcast.
        // Remember, you can also get promises back with: `transaction.signAndBroadcast(.promise)`.
        transaction.signAndBroadcast { result in
            self.buttonTapped = false
            DispatchQueue.main.async {
                self.button.doNormalAnimation()
            }
            
            print(try! transaction.toJson(prettyPrinted: true))

            // Handle our result, success or failure, appropriately.
            switch result {
            case .failure (let error):
                DispatchQueue.main.async {
                    self.idLabel.text = "TRANSACTION ERROR"
                    self.button.doErrorAnimation()
                }
                print("ERROR SIGNING OR BROADCASTING TRANSACTION")
                print(error)
                print(error.reason)
            case .success:
                if let transactionId = transaction.transactionId {
                    // If the transaction was successful, display the transaction ID on the screen...
                    DispatchQueue.main.async { self.idLabel.text = "Transaction ID \(transactionId)" }
                    // and update the balance.
                    self.refreshBalance()
                }
            }
        }
    }

    // Format tokens balance string.
    func formatTokens(from: String) -> String {
        let balanceComponents = from.components(separatedBy: CharacterSet(charactersIn: ". "))

        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        guard let amount = Int(balanceComponents[0]) else {
            return from
        }

        guard let result  = currencyFormatter.string(from: NSNumber(value: amount)) else {
            return from
        }
        return "\(result).\(balanceComponents[1]) \(balanceComponents[2])"
    }

    // Update the balance label.
    func refreshBalanceLabel(balance: String) -> Void {
        func animateView () {
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.balanceLabel.transform = self.balanceLabel.transform.scaledBy(x: 0.8, y: 0.8)
                    self.balanceLabel.alpha = 0
                },
                completion: { _ in
                    self.balanceLabel.text = self.formatTokens(from: balance)
                    UIView.animate(
                        withDuration: 0.2,
                        animations: {
                            self.balanceLabel.transform = .identity
                            self.balanceLabel.alpha = 1
                        }
                    )
                }
            )
        }

        DispatchQueue.main.async { animateView() }
    }

}
