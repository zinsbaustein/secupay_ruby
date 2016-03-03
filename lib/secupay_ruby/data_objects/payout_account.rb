module SecupayRuby
  module DataObjects
    class PayoutAccount < Base
      API_FIELDS = {
        iban: :iban,
        bic: :bic
      }
    end
  end
end