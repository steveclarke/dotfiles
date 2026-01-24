# frozen_string_literal: true

module SyncBooks
  class FinancialSummary
    Result = Struct.new(
      :balance, :invoices_total, :open_invoices, :overdue_invoices,
      :bills_total, :open_bills, :overdue_bills,
      :hst_charged, :hst_reclaimed, :hst_net,
      keyword_init: true
    ) do
      def net_position
        balance - hst_net - bills_total
      end
    end

    def initialize(fa_client)
      @fa_client = fa_client
    end

    def fetch_all(hst_from_date:, hst_to_date:, quiet: false)
      result = Result.new

      # Balance
      print "Fetching balance..." unless quiet
      accounts = @fa_client.bank_accounts.select(&:active?)
      result.balance = accounts.sum { |a| a.current_balance || 0 }
      puts " $#{"%.2f" % result.balance}" unless quiet

      # Invoices
      print "Fetching open invoices..." unless quiet
      result.open_invoices = @fa_client.invoices(view: "open")
      open_total = result.open_invoices.sum { |i| i.total_value || 0 }
      puts " #{result.open_invoices.length} invoices ($#{"%.2f" % open_total})" unless quiet

      print "Fetching overdue invoices..." unless quiet
      result.overdue_invoices = @fa_client.invoices(view: "overdue")
      overdue_total = result.overdue_invoices.sum { |i| i.total_value || 0 }
      puts " #{result.overdue_invoices.length} invoices ($#{"%.2f" % overdue_total})" unless quiet

      result.invoices_total = open_total + overdue_total

      # Bills
      print "Fetching open bills..." unless quiet
      result.open_bills = @fa_client.bills_by_view(view: "open")
      open_bills_total = result.open_bills.sum { |b| b.total_value || 0 }
      puts " #{result.open_bills.length} bills ($#{"%.2f" % open_bills_total})" unless quiet

      print "Fetching overdue bills..." unless quiet
      result.overdue_bills = @fa_client.bills_by_view(view: "overdue")
      overdue_bills_total = result.overdue_bills.sum { |b| b.total_value || 0 }
      puts " #{result.overdue_bills.length} bills ($#{"%.2f" % overdue_bills_total})" unless quiet

      result.bills_total = open_bills_total + overdue_bills_total

      # HST
      calculator = HstCalculator.new(@fa_client)
      hst_result = calculator.calculate(from_date: hst_from_date, to_date: hst_to_date, quiet: quiet)
      result.hst_charged = hst_result.charged
      result.hst_reclaimed = hst_result.reclaimed
      result.hst_net = hst_result.net_owing

      result
    end

    def fetch_balance
      accounts = @fa_client.bank_accounts.select(&:active?)
      accounts.sum { |a| a.current_balance || 0 }
    end

    def fetch_receivables
      open_invoices = @fa_client.invoices(view: "open")
      overdue_invoices = @fa_client.invoices(view: "overdue")
      {
        open: open_invoices,
        overdue: overdue_invoices,
        open_total: open_invoices.sum { |i| i.total_value || 0 },
        overdue_total: overdue_invoices.sum { |i| i.total_value || 0 },
        total: open_invoices.sum { |i| i.total_value || 0 } + overdue_invoices.sum { |i| i.total_value || 0 }
      }
    end

    def fetch_bills
      open_bills = @fa_client.bills_by_view(view: "open")
      overdue_bills = @fa_client.bills_by_view(view: "overdue")
      {
        open: open_bills,
        overdue: overdue_bills,
        open_total: open_bills.sum { |b| b.total_value || 0 },
        overdue_total: overdue_bills.sum { |b| b.total_value || 0 },
        total: open_bills.sum { |b| b.total_value || 0 } + overdue_bills.sum { |b| b.total_value || 0 }
      }
    end
  end
end
