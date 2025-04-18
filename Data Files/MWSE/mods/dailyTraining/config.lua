local defaultConfig = {
	townTrain = false,
	trainCD = true,
	cdMessages = true,
	trainCDtime = 24,
	streakBonus = true,
	gracePeriod = 48,
	wilMod = 5,
	endMod = 5,
	skillLimit = true,
	skillMax = 75,
	costMultH = 2,
	costMultM = 3,
	costMultF = 5,
	noColor = false,
	logLevel = "NONE"
}

local mwseConfig = mwse.loadConfig("Daily Training", defaultConfig)

return mwseConfig;
