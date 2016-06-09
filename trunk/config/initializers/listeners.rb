#global publish/subscribe listeners
Wisper.subscribe(Listeners::ProjectMilestone.new, scope: :MilestoneFundingRequest)
Wisper.subscribe(Listeners::Messages.new, scope: :Message)
Wisper.subscribe(Listeners::WithdrawalRequests.new, scope: :WithdrawalRequest)
Wisper.subscribe(Listeners::MilestoneInvoices.new, scope: :MilestoneInvoice)
Wisper.subscribe(Listeners::WithdrawalInvoices.new, scope: :WithdrawalInvoice)
Wisper.subscribe(Listeners::DepositRequests.new, scope: :DepositRequest)
Wisper.subscribe(Listeners::DepositInvoices.new, scope: :DepositInvoice)
Wisper.subscribe(Listeners::MilestoneFunds.new, scope: :MilestoneReleaseFundRequest)
Wisper.subscribe(Listeners::PaymentsListener.new, scope: :Payment)
Wisper.subscribe(Listeners::ReleaseFundsPayment.new, scope: "Listeners::PaymentsListener")
Wisper.subscribe(Listeners::FundInvoicePayment.new, scope: "Listeners::MilestoneInvoices")
Wisper.subscribe(Listeners::Requests::PayPalWithdrawals.new, scope: "Listeners::WithdrawalRequests")
Wisper.subscribe(Listeners::Requests::PayFastWithdrawals.new, scope: "Listeners::WithdrawalRequests")
Wisper.subscribe(Listeners::Requests::BrainTreeWithdrawals.new, scope: "Listeners::WithdrawalRequests")
Wisper.subscribe(Listeners::Requests::AuthorizeCreditWithdrawals.new, scope: "Listeners::WithdrawalRequests")
Wisper.subscribe(Listeners::WithdrawalPayment.new, scope: "Listeners::WithdrawalInvoices")
Wisper.subscribe(Listeners::Requests::PayPalDeposits.new, scope: "Listeners::DepositRequests")
Wisper.subscribe(Listeners::Requests::PayFastDeposits.new, scope: "Listeners::DepositRequests")
Wisper.subscribe(Listeners::Requests::BrainTreeDeposits.new, scope: "Listeners::DepositRequests")
Wisper.subscribe(Listeners::Requests::AuthorizeCreditDeposits.new, scope: "Listeners::DepositRequests")
Wisper.subscribe(Listeners::DepositPayment.new, scope: "Listeners::DepositInvoices")