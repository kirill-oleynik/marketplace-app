module CustomPredicates
  include Dry::Logic::Predicates

  predicate(:file?) do |value|
    value.is_a?(File)
  end

  predicate(:email?) do |value|
    email_regexp = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

    value.match? email_regexp
  end
end
