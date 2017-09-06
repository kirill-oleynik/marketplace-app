[
  'Research', 'Trade Execution', 'Portfolio Management', 'Data Management',
  'Risk Management', 'Cash Management', 'Securities Pricing',
  'Trade Reconciliation', 'Investor Relations', 'Accounting', 'Compliance',
  'Administration', 'IT Support'
].each { |category| Category.where(title: category).first_or_create! }
