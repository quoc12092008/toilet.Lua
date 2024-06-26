local Client = require(game.ReplicatedStorage.Library.Client)
local TradingCmds = require(game.ReplicatedStorage.Library.Client.TradingCmds)
local Library = require(game.ReplicatedStorage:WaitForChild('Library'))
local RAPValues = Library.RAPCmds
local HttpService = game:GetService("HttpService")

function GetTradeID() return TradingCmds.GetState()._id end
function GetCounter() return TradingCmds.GetState()._counter end
function getDiamonds() return game.Players.LocalPlayer.leaderstats["💎 Diamonds"].Value end

function GetItemRAP(Class, itemTable)
    return(RAPValues.Get({
        Class = {Name = Class},

        IsA = function(InputClass)
            return InputClass == Class
        end,

        GetId = function()
            return itemTable.id
        end,

        StackKey = function()
            return HttpService:JSONEncode({id = itemTable.id, pt = itemTable.pt, sh = itemTable.sh, tn = itemTable.tn})
        end
    }) or 0)
end

if getgenv().config.debugPrints and getgenv().config.autoTrade then warn("autoTrader Loaded") end
while getgenv().config.autoTrade do
	local itemsToTrade = {}
	for Class,classTables in pairs(Client.InventoryCmds.State().container._store._byType) do
		if table.find(getgenv().config.itemConfig.classBlacklist, Class) then continue end
		if getgenv().config.debugPrints then warn("Checking:",Class) end
		for uid,Item in pairs(classTables._byUID) do
			if table.find(getgenv().config.itemConfig.itemBlacklist, Item._data.id) then
				if getgenv().config.debugPrints then warn("Skipped because item found on blacklist :",Item._data.id) end
				continue
			end

			if TradingCmds.CanTrade(Item) then
				local RAP = GetItemRAP(Class, Item._data)
				if RAP then
					if not table.find(itemsToTrade, {Class, uid, Item}) then
						if getgenv().config.debugPrints then print("Added:",Item._data.id,"to items to trade.") end
						table.insert(itemsToTrade, {["Class"] = Class, ["uid"] = uid, ["Item"] = Item})
					end
				elseif not RAP and Class == "Currency" and Item._data.id == "Diamonds" and Item._data._am >= getgenv().config.minimumRAP then
					if not table.find(itemsToTrade, {Class, uid, Item}) then
						if getgenv().config.debugPrints then print("Added:",Item._data.id,"to items to trade.") end
						table.insert(itemsToTrade, {["Class"] = Class, ["uid"] = uid, ["Item"] = Item})
					end
				end
			end
		end
	end

	if not TradingCmds.GetState() then
		if #itemsToTrade >= 1 then
			if getgenv().config.debugPrints then warn("TradeWindow not Enabled") end
			if game.Players:FindFirstChild(getgenv().config.userToTrade) then
				if getgenv().config.debugPrints then warn("Found Target Player") end
				repeat
					local requestSuccess,requestReason = Library.Network.Invoke("Server: Trading: Request", game.Players[getgenv().config.userToTrade]) 
					if getgenv().config.debugPrints then warn("Requesting Trade:", requestSuccess,"| Reason:",requestReason) end
				until requestSuccess or requestReason == "Request already sent!"
			else
				if getgenv().config.debugPrints then warn("Couldn't find Target Player") end
				getgenv().config.autoTrade = false
			end
		else
			if getgenv().config.debugPrints then warn("You do not have enough Items") end
		end
	end

	if TradingCmds.GetState() then
		if getgenv().config.debugPrints then warn("TradeWindow Enabled, Starting autoTrade") end
		for _,v in pairs(itemsToTrade) do
			print(v.Class, v.uid, v.Item,"\n",v.Item._data)
			local setSuccess,setReason = Library.Network.Invoke("Server: Trading: Set Item", GetTradeID(), v.Class, v.uid, (v.Item._data._am or 1)) task.wait(.1)
			if getgenv().config.debugPrints then print("Added",v.Item._data.id,":", setSuccess,"| Reason:",setReason) end
			if setReason == "Trade is full!" then
				if getgenv().config.debugPrints then warn("Trade Full Detected") end
				break
			end
		end
		repeat
			local readySuccess, readyReason = Library.Network.Invoke("Server: Trading: Set Ready", GetTradeID(), true, GetCounter())
			if getgenv().config.debugPrints then warn("Attempting Accept:", readySuccess,"| Reason:",readyReason) end
		until readySuccess
		repeat task.wait(1) until not TradingCmds.GetState()
	end
    task.wait(getgenv().config.tradeTimer)
end
