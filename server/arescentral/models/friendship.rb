module AresCentral
  class Friendship < Ohm::Model
    include ObjectModel

    reference :owner, "AresCentral::Handle"
    reference :friend, "AresCentral::Handle"
  end
end