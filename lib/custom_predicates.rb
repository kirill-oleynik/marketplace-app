module CustomPredicates
  include Dry::Logic::Predicates

  predicate(:file?) do |value|
    value.is_a?(File)
  end
end
