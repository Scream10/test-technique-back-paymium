require 'json'

data = JSON.parse(File.open('data.json').read)

# Parsing data from data.json and check if queued_orders can be perform
def queuedOrders(data)
    user_1_direction = data["queued_orders"][0]["direction"]
    user_1_price = data["queued_orders"][0]["price"]
    user_1_btc_balance = data["users"][0]["btc_balance"]
    user_1_btc_amount = data["queued_orders"][0]["btc_amount"]
    user_1_eur_balance = data["users"][0]["eur_balance"]

    user_2_direction = data["queued_orders"][1]["direction"]
    user_2_price = data["queued_orders"][1]["price"]
    user_2_btc_balance = data["users"][1]["btc_balance"]
    user_2_btc_amount = data["queued_orders"][1]["btc_amount"]
    user_2_eur_balance = data["users"][1]["eur_balance"]
    newDataFromQueuedOrders = {}

    if (user_1_direction != user_2_direction && user_1_price === user_2_price)
        user_2_btc_balance -= user_2_btc_amount
        user_2_eur_balance += user_2_btc_amount * user_2_price
        user_1_btc_balance += user_1_btc_amount
        user_1_eur_balance -= user_1_btc_amount * user_1_price
        newDataFromQueuedOrders = {"user_2_btc_balance" => user_2_btc_balance, "user_1_btc_balance" => user_1_btc_balance, "user_2_eur_balance" => user_2_eur_balance, "user_1_eur_balance" => user_1_eur_balance   }
        return newDataFromQueuedOrders
    else 
        puts "QueuedOrders can't be perform :\n 1) their direction have to be different\n 2) The price of both have to be exactly matched"
    end
end

queuedOrders(data)

# Storing output.json with new queued_orders data
newData = {
	users: [
		{ id: 1, btc_balance: queuedOrders(data)["user_1_btc_balance"], eur_balance: queuedOrders(data)["user_1_eur_balance"] },
		{ id: 2, btc_balance: queuedOrders(data)["user_2_btc_balance"], eur_balance: queuedOrders(data)["user_2_eur_balance"] }
	],
	queued_orders: [
		{ id: 1, user_id: 1, direction: "buy", btc_amount: 1, price: 5, state: "execute" },
		{ id: 2, user_id: 2, direction: "sell", btc_amount: 1, price: 5, state: "execute" }
	]
}

File.open('output.json', 'w') do |file|
  file.write(JSON.pretty_generate(newData))
end