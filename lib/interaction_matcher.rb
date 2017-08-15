success_case = Dry::Matcher::Case.new(
  match: -> (monad) { monad.right? },
  resolve: -> (monad) { monad.value }
)

failure_case = Dry::Matcher::Case.new(
  match: -> (monad, *patterns) {
    monad.left? && patterns.any? ? patterns.include?(monad.value.first)
                                 : true
  },
  resolve: -> (monad) { monad.value.last }
)

InteractionMatcher =  Dry::Matcher.new(
  success: success_case, failure: failure_case
)
