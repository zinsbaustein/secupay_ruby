# require "spec_helper"
#
# describe SecupayRuby::Payment do
#   include_context "configuration"
#
#   it "can do a payment" do
#     payment = SecupayRuby::Payment.new
#     payment.init amount: 500,
#                  payment_type: SecupayRuby::Payment::Types::PREPAY
#     # payment.load_status
#
#     binding.pry
#
#     "DE12500105170648489890"
#
#     payment.capture
#     payment.cancel
#   end
# end
