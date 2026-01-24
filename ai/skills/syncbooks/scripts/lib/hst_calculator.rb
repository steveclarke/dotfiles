# frozen_string_literal: true

module SyncBooks
  class HstCalculator
    Result = Struct.new(
      :charged, :reclaimed,
      :invoice_hst, :bills_hst, :expenses_hst, :bad_debt_hst,
      :bank_charged, :bank_reclaimed,
      :invoice_count, :drafts_excluded, :bills_count, :expenses_count,
      :writeoffs_count, :bank_txn_count,
      keyword_init: true
    ) do
      def net_owing
        charged - reclaimed
      end
    end

    def initialize(fa_client)
      @fa_client = fa_client
    end

    def calculate(from_date:, to_date:, quiet: false)
      result = Result.new(
        charged: 0.0, reclaimed: 0.0,
        invoice_hst: 0.0, bills_hst: 0.0, expenses_hst: 0.0, bad_debt_hst: 0.0,
        bank_charged: 0.0, bank_reclaimed: 0.0,
        invoice_count: 0, drafts_excluded: 0, bills_count: 0, expenses_count: 0,
        writeoffs_count: 0, bank_txn_count: 0
      )

      fetch_invoices(result, from_date, to_date, quiet)
      fetch_bills(result, from_date, to_date, quiet)
      fetch_expenses(result, from_date, to_date, quiet)
      fetch_bad_debt_relief(result, from_date, to_date, quiet)
      fetch_bank_transactions(result, from_date, to_date, quiet)

      result.charged = result.invoice_hst + result.bank_charged
      result.reclaimed = result.bills_hst + result.expenses_hst + result.bad_debt_hst + result.bank_reclaimed

      result
    end

    private

    def fetch_invoices(result, from_date, to_date, quiet)
      print "Fetching invoices..." unless quiet
      all_invoices = @fa_client.invoices_by_date(from_date: from_date, to_date: to_date)
      # Exclude draft invoices - they haven't been sent yet so no HST is due
      invoices = all_invoices.reject { |i| i.status == "Draft" }
      result.invoice_hst = invoices.sum { |i| i.sales_tax_value || 0 }
      result.invoice_count = invoices.length
      result.drafts_excluded = all_invoices.length - invoices.length
      puts " #{result.invoice_count} invoices (#{result.drafts_excluded} drafts excluded)" unless quiet
    end

    def fetch_bills(result, from_date, to_date, quiet)
      print "Fetching bills..." unless quiet
      bills = @fa_client.bills(from_date: from_date, to_date: to_date)
      result.bills_hst = bills.sum { |b| (b.sales_tax_value || 0).abs }
      result.bills_count = bills.length
      puts " #{result.bills_count} bills" unless quiet
    end

    def fetch_expenses(result, from_date, to_date, quiet)
      print "Fetching expenses..." unless quiet
      expenses = @fa_client.expenses(from_date: from_date, to_date: to_date)
      result.expenses_hst = expenses.sum { |e| e.hst_amount }
      result.expenses_count = expenses.length
      puts " #{result.expenses_count} expenses" unless quiet
    end

    def fetch_bad_debt_relief(result, from_date, to_date, quiet)
      print "Fetching bad debt relief..." unless quiet
      written_off = @fa_client.written_off_invoices_by_period(from_date: from_date, to_date: to_date)
      result.bad_debt_hst = written_off.sum { |i| i.sales_tax_value || 0 }
      result.writeoffs_count = written_off.length
      puts " #{result.writeoffs_count} write-offs ($#{"%.2f" % result.bad_debt_hst} HST)" unless quiet
    end

    def fetch_bank_transactions(result, from_date, to_date, quiet)
      print "Fetching bank transactions..." unless quiet
      accounts = @fa_client.bank_accounts.select(&:active?)

      accounts.each do |acc|
        exps = @fa_client.bank_transaction_explanations(acc.url, from_date: from_date, to_date: to_date)
        result.bank_txn_count += exps.length
        exps.each do |e|
          stv = e["sales_tax_value"]
          next unless stv

          val = stv.to_f.abs
          cat = e["category"]&.split("/")&.last.to_i
          if cat < 100
            result.bank_charged += val
          else
            result.bank_reclaimed += val
          end
        end
      end
      puts " #{result.bank_txn_count} transactions" unless quiet
    end
  end
end
