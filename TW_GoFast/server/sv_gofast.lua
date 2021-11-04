ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('T_GoFast:SellPackage')
AddEventHandler('T_GoFast:SellPackage', function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local money = math.random(20000, 30000)
    xPlayer.addAccountMoney('black_money', money)
    TriggerClientEvent('esx:showNotification', _src, "<C>~r~GoFast~s~</C>\nVous avez obtenu <C>~r~"..money.."$</C>~s~ pour la <C>~r~livraison</C>")
end)

RegisterServerEvent("GoFast:MessagePolice")
AddEventHandler("GoFast:MessagePolice", function()

	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
          if xPlayer.job.name == 'police' then
               Citizen.Wait(10*1000)
               TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Indic LSPD", "~b~Message de l'indic", "D'après mes infos, un GoFast à commencé.", "CHAR_JOSEF", 3)
		end
	end

end)