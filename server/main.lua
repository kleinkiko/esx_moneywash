function secondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

RegisterServerEvent('esx_moneywash:washMoney')
AddEventHandler('esx_moneywash:washMoney', function(amount, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local tax
	local timer
	local enableTimer = false
	print(zone)
	for k, spot in pairs (Config.Zones) do
		if zone == k then
			tax = spot.TaxRate
			enableTimer = spot.enableTimer
			timer = spot.timer
		end
	end
	print(tax)
	amount = ESX.Math.Round(tonumber(amount))
	washedCash = amount * tax
	washedTotal = ESX.Math.Round(tonumber(washedCash))

	print(tax.. ' ' .. timer)
	
	if enableTimer == true then
		--local timer = Config.timer
		local timeClock = ESX.Math.Round(timer / 1000)
	
		if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_washed_waiting') ..  secondsToClock(timeClock))
			Citizen.Wait(timer)
			
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_received') .. ESX.Math.GroupDigits(washedTotal) .. _U('clean_money'))
			xPlayer.addMoney(washedTotal)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	else 
	
		if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_washed') .. ESX.Math.GroupDigits(amount) .. _U('dirty_money') .. _U('you_have_received') .. ESX.Math.GroupDigits(washedTotal) .. _U('clean_money'))
			xPlayer.addMoney(washedTotal)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end
	
end)

RegisterServerEvent('esx_moneywash:sendToDiscord')
AddEventHandler('esx_moneywash:sendToDiscord', function(amount)
	
  local xPlayer = ESX.GetPlayerFromId(source)
  local id = xPlayer.getIdentifier()
  local logs = Config.Webhook
  local communtiylogo = Config.WebhookLogo --Must end with .png or .jpg
  local name = xPlayer.getName()
  local DATE = os.date(" %d.%m.%y %H:%M ")
  local connect = {
	{
		["color"] = "64242",
		["title"] = "Black Money Wash",
		["title"] = "Betrag : $"..amount.."",
		["description"] = "".. name .. " [" .. id .. "] " .. "hat Schwarzgeld gewaschen am:" .. DATE .. "" ,
		["footer"] = {
		["text"] = "FunRP Money Wash Log",
		},
	}
}

PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = Config.WebhookName, embeds = connect}), { ['Content-Type'] = 'application/json' })
end)
