require 'pony'

Mail.defaults do
  delivery_method :smtp,
  address: "smtp.gmail.com",
  port: 587,
  user_name: "fakefakematcha@gmail.com",
  password: "fakeaccountpassword",
  authentication: "plain"
end
