require 'CSV'
require 'pry'

class BankTransaction

  def initialize(transaction)
    @bank_data = transaction
  end

  def debit?
      if @bank_data > 0
        return true
      else
        return false
      end
  end

  def credit?
      if @bank_data < 0
        return true
      else
        return false
      end
  end

  def summary(account_type)
    summary = []
    @bank_data.each do |hash|
      if hash[:amount] > 0 && hash[:account] == account_type
        summary << "$#{hash[:amount]}  DEBIT  #{hash[:date]} - #{hash[:description]}"
      end
      if hash[:amount] < 0 && hash[:account] == account_type
        summary << "$#{hash[:amount]}  CREDIT  #{hash[:date]} - #{hash[:description]}"
      end
    end
    return summary
  end

end

class BankAccount

  attr_reader :starting, :ending
  def initialize(type)
    @type = type
    @bank_data = grab_data('bank_data.csv')
    @balances = grab_data('balances.csv')
    @starting = get_starting_balance(type)
    @ending = get_ending_balance(@starting, type)
  end

  def grab_data(filename)
    bank_data = []
    CSV.foreach(filename, headers: true, :header_converters => :symbol, :converters => :all) do |row|
      bank_data << row.to_hash
    end
    return bank_data
  end

  def get_starting_balance(account_type)
    balance = nil
    @balances.each do |hash|
      if hash[:account] == account_type
        balance = hash[:balance]
      end
    end
    return balance
  end

  def get_ending_balance(starting_balance, account_type)
    @bank_data.each do |hash|
      if hash[:account] == account_type
        starting_balance += hash[:amount]
      end
    end
    return starting_balance
  end

  def summary
    bank_transactions = BankTransaction.new(@bank_data)
    puts "\n==== #{@type} ====\nStarting Balance: $#{@starting}\nEnding Balance: $#{@ending}\n\n"
    puts bank_transactions.summary(@type)
  end

end

purchasing = BankAccount.new("Purchasing Account")
business = BankAccount.new("Business Checking")
puts purchasing.summary
puts business.summary


# def grab_bank_data
#     bank_data = {}
#     counter = 1
#     CSV.foreach('bank_data.csv', headers: true, :header_converters => :symbol, :converters => :all) do |row|
#       row = row.to_hash
#       if row[:amount] < 0
#         bank_data["credit #{counter}"] = row
#         counter += 1
#       else row[:amount] > 0
#        bank_data["debit #{counter}"] = row
#        counter += 1
#       end
#     end
#     return bank_data
#   end
# bank = BankTransaction.new(grab_bank_data)
