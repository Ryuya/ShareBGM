FactoryBot.define do
  factory :room_chat_log do
    log { "MyString" }
    user { nil }
    room { nil }
  end
end
