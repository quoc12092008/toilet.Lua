getgenv().KiTTYWARE = {
    autoPrepare = {
        Usernames = {
            "ZeidmanLR6686",
            "FrancesJY4292",
            "WitherwBB1668",
            "FishkinBR9680",
            "MusacchNK8431",
            "BartholDM7663",
            "DungVH2061",
            "PerseNB8969",
            "FahrneyDJ2832",
            "GummereMP7489",
        },

        sendPets = true, 
        petConfig = {
            {petName = "Frostbyte Husky", petType = "Regular", petAmount = 16}
        },
        
        sendPots = false,
        potConfig = {
            {potName = "Damage", potTier = 1, potAmount = 1}
        },
        
        sendEnch = false,
        enchConfig = {
            {enchName = "Coins", enchTier = 1, enchAmount = 1}
        },
        
        sendFruit = false,
        fruitConfig = {
            {fruitName = "Banana", fruitAmount = 10},
            {fruitName = "Apple", fruitAmount = 10}
        },
        
        sendGems = true,
        gemsAmount = 200000,
    }
}

loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/920918ba6d30cd410dacee97916c773e.lua"))()
