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

# Provide a prompt to the user with a message associated with _message_key_
def prompt(message_key)
  puts "==> #{MESSAGES[message_key]}"
end

# Is _input_ a valid integer or float that is either positive or non-negative
# (as specified by _include_zero_)?
def valid_number?(input, include_zero: false)
  is_number = (valid_integer?(input) || valid_float?(input))
  is_within_range = include_zero ? input.to_f >= 0 : input.to_f > 0
  is_number && is_within_range
end

# Is _input_ a vald integer?
def valid_integer?(input)
  input.to_i.to_s == input
end

# Is _input_ a valid float?
def valid_float?(input)
  input.to_f.to_s == input
end

# Format _payment_ as a string
def format_payment(payment)
  "$#{format('%.2f', payment)}"
end

# MAIN METHODS

# Determine the monthly payment for a loan with a given _principle_,
# _monthly_interest_rate, and _loan_duration_
def compute_monthly_payment(principle, monthly_interest_rate, loan_duration)
  return principle / loan_duration if monthly_interest_rate == 0
  principle * (monthly_interest_rate / (1 - (1 + monthly_interest_rate)**\
  (-loan_duration)))
end

# Retrieve the loan amount from the user
def retrieve_loan_amount
  prompt("loan_amount")

  loan_amount_input = ''
  loop do
    loan_amount_input = gets.chomp
    break if valid_number?(loan_amount_input)
    prompt("invalid_loan_amount")
  end

  loan_amount_input
end

# Retrieve the annual percentage rate from the user, as a percentage
def retrieve_apr
  prompt("apr")

  apr_input = ''
  loop do
    apr_input = gets.chomp
    break if valid_number?(apr_input, include_zero: true)
    prompt("invalid_apr")
  end

  apr_input
end

# Retrieve the loan duration in years from the user
def retrieve_loan_years
  prompt("loan_duration")

  loan_years_input = ''
  loop do
    loan_years_input = gets.chomp
    break if valid_number?(loan_years_input)
    prompt("invalid_loan_duration")
  end

  loan_years_input
end

# PROGRAM BODY

prompt("welcome")

loop do
  loan_amount = retrieve_loan_amount().to_f
  monthly_interest_rate = retrieve_apr().to_f / 100 / 12
  loan_months = retrieve_loan_years().to_f * 12
  monthly_payment = compute_monthly_payment(loan_amount, monthly_interest_rate,\
                                            loan_months)

  prompt("result")
  puts format_payment(monthly_payment)

  prompt("run_again")
  break unless gets.chomp.downcase == "y"
end

prompt("finished")
