# Mortgage / Car Loan Calculator
# ============================================================================

# PROBLEM
# ============================================================================

=begin

Build a mortgage calculator.

Input:
- The _loan_amount_ as a float
- The _apr_ (annual percentage rate) as a float
- The _loan_duration_ (in years) as a float

Output:
- Monthly payment as a float

Domain Knowledge:

m = p * (j / (1 - (1 + j)**(-n)))

m = monthly payment
p = loan amount
j = monthly interest rate
n = loan duration in months

Questions to consider:
- How to express the interest rate? Whole number % or decimal?

Assumptions:
- Any of the user inputs (loan amount, apr, loan duration) can be decimal
values (floats)
- Loan amount and duration must be positive numbers
- APR must be non-negative (it can be 0, if the loan doesn't accumulate
  interest)

=end

# ALGORITHM
# ============================================================================

=begin

Retrieve & verify loan amount, APR, & loan duration (in years) from user

Convert user inputs to expected formula inputs
- loan amount -> principle
- apr -> monthly interest rate
- loan duration (in years) -> loan duration (in months)

Run the formula w/ inputs
Print the result (monthly payment)
Run program again if requested by user

=end

# CODE
# ============================================================================

# REQUIREMENTS

require 'yaml'
MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')

# HELPER METHODS

def prompt(message_key)
  puts "==> #{MESSAGES[message_key]}"
end

def valid_number?(input, include_zero: false)
  is_number = (valid_integer?(input) || valid_float?(input))
  is_within_range = include_zero ? input.to_f >= 0 : input.to_f > 0
  is_number && is_within_range
end

def valid_integer?(input)
  input.to_i.to_s == input
end

def valid_float?(input)
  input.to_f.to_s == input
end

def format_payment(payment)
  "$#{format('%.2f', payment)}"
end

def retrieve_input
  input = gets.chomp
  system("clear")
  input
end

# MAIN METHODS

def compute_monthly_payment(principle, monthly_interest_rate, loan_duration)
  return principle / loan_duration if monthly_interest_rate == 0
  principle * (monthly_interest_rate / (1 - (1 + monthly_interest_rate)**\
  (-loan_duration)))
end

def retrieve_loan_amount
  prompt("loan_amount")

  loan_amount_input = ''
  loop do
    loan_amount_input = retrieve_input()
    break if valid_number?(loan_amount_input)
    prompt("invalid_loan_amount")
  end

  loan_amount_input.to_f
end

def retrieve_apr
  prompt("apr")

  apr_input = ''
  loop do
    apr_input = retrieve_input()
    break if valid_number?(apr_input, include_zero: true)
    prompt("invalid_apr")
  end

  apr_input.to_f
end

def retrieve_loan_years
  prompt("loan_duration")

  loan_years_input = ''
  loop do
    loan_years_input = retrieve_input()
    break if valid_number?(loan_years_input)
    prompt("invalid_loan_duration")
  end

  loan_years_input.to_f
end

def retrieve_yes_no
  prompt("run_again")

  again_input = ''
  loop do
    again_input = retrieve_input().downcase
    break if ['yes', 'y', 'no', 'n'].include?(again_input)
    prompt("invalid_yes_no")
  end

  again_input
end

def display_monthly_payment(monthly_payment)
  prompt("result")
  puts format_payment(monthly_payment)
end

# PROGRAM BODY

prompt("welcome")

loop do
  loan_amount = retrieve_loan_amount()
  apr = retrieve_apr()
  monthly_interest_rate = apr / 100 / 12
  loan_years = retrieve_loan_years()
  loan_months = loan_years * 12

  monthly_payment = compute_monthly_payment(loan_amount, monthly_interest_rate,\
                                            loan_months)

  display_monthly_payment(monthly_payment)

  play_again = retrieve_yes_no()
  break unless play_again == "yes" || play_again == "y"
end

prompt("finished")
