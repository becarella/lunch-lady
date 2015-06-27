# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  User.delete_all
  Order.delete_all
  LineItem.delete_all
  Charge.delete_all
end

user = User.create(first_name: 'Test', last_name: 'Example', email: 'test@example.com')

order = Order.create(user: user, site: 'Seamless', restaurant: 'Baz', order_number: 'Test 123',
                     subtotal: 8.0, total: 8.71, tax: 0.71, discount: 0.0, tip: 0.0)
LineItem.create(order: order, charge_to_nickname: 'TESTA', subtotal: 4.0, description: %Q{
1 Bagel with Cream Cheese
[Vegetable Cream Cheese, Everything Bagel]
Special Instructions: Toasted. TESTA
})
LineItem.create(order: order, charge_to_nickname: 'TESTB', subtotal: 4.0, description: %Q{
1 Bagel with Cream Cheese
[Scallion Cream Cheese, Pumpernickel Everything Bagel]
Special Instructions: Toasted. TESTB
})


order = Order.create(user: user, site: 'Seamless', restaurant: 'Mooncake', order_number: 'Test 1234',
                     subtotal: 35.8, total: 44.83, subtotal: 35.80, tax: 3.18, discount: 0.0, tip: 5.85)
charge = Charge.create(user: user, order: order, memo: 'Blah blah blah',
                       subtotal: 10.95, tax: 0.97, tip: 1.79, discount: 0, delivery: 0,
                       payment_source: 'Venmo', payment_id: '986363',
                       charged_to_venmo_id: 'asdfasdfasd', charged_by_venmo_id: 'asfadf09990')
LineItem.create(order: order, charge_to_nickname: 'TESTA', subtotal: 13.90, description: %Q{
1 Tofu Kebabs Plate
[Brown Rice, Add Avocado]
Special Instructions: TESTA
})
LineItem.create(order: order, charge_to_nickname: 'TESTB', subtotal: 10.95, description: %Q{
1 Grilled Pork Chops Plate
[White Rice]
Special Instructions: TESTB
})
li = LineItem.create(order: order, charge_to_nickname: 'TESTC', subtotal: 10.95, description: %Q{
1 Octopus and Spinach Noodles Plate
[White Rice]
Special Instructions: TESTC
}, charge: charge)
