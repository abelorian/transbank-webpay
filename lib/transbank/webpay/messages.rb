module Transbank
  module Webpay
    VCI = {
      "TSY": "Autenticación exitosa",
      "TSN": "Autenticación fallida.",
      "TO": "Tiempo máximo excedido para autenticación.",
      "ABO": "Autenticación abortada por tarjetahabiente.",
      "U3": "Error interno en la autenticación.",
      "EMPTY": "Error interno en la autenticación."
    }.freeze
  end
end