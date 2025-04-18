local EasyMCM = require("easyMCM.EasyMCM");
local config  = require("dailyTraining.config")
local logger  = require("logging.logger")
local log     = logger.getLogger("Daily Training")

local modName = 'Daily Training';
local template = EasyMCM.createTemplate { name = modName }
template:saveOnClose(modName, config)
template:register()



local function createPage(label)
    local page = template:createSideBarPage {
        label = label,
        noScroll = false,
    }
    page.sidebar:createInfo {
        text = "                          Daily Training \n\nAllows the player to spend time training instead of wasting time waiting. Training awards a small amount of skill experience per hour trained. Skills cannot be trained beyond 75 by default.\n\nBy default, training has a 24 hour cooldown. Also, the amount of hours the player can train is limited by Endurance for non-magical skills and Willpower for skills that require the use of magic (configurable).\n\nMagical skills require magicka per hour, armor skills require health per hour, and all other skills require stamina per hour."
    }
    page.sidebar:createHyperLink {
        text = "Made by Kleidium",
        exec = "start https://www.nexusmods.com/users/5374229?tab=user+files",
        postCreate = function(self)
            self.elements.outerContainer.borderAllSides = self.indent
            self.elements.outerContainer.alignY = 1.0
            self.elements.info.layoutOriginFractionX = 0.5
        end,
    }
    return page
end

local settings = createPage("Settings")


----Global Settings-------------------------------------------------------------------------------------------------------------------------
local globalSettings = settings:createCategory("Settings")

globalSettings:createOnOffButton {
    label = "Training Cooldown",
    description = "Turn on or off training cooldown.",
    variable = mwse.mcm.createTableVariable { id = "trainCD", table = config }
}

globalSettings:createOnOffButton {
    label = "Cooldown Reminder Messages",
    description = "Turn on or off training cooldown messages. These messages will notify you when your training cooldown ends.",
    variable = mwse.mcm.createTableVariable { id = "cdMessages", table = config }
}

globalSettings:createSlider {
    label = "Cooldown Time",
    description = "The amount of in-game hours you must wait before training again. 168 hours is equal to one week. Default: 24",
    max = 168,
    min = 1,
    variable = EasyMCM:createTableVariable {
        id = "trainCDtime",
        table = config
    }
}

globalSettings:createOnOffButton {
    label = "Training Streak Bonus",
    description = "Turn on or off skill training streak bonus. If this is enabled, you receive an experience bonus equal to one extra hour of training if you train the same skill 3 days in a row each time you train afterward, until the streak is lost. This increases by one extra hour as the streak continues until you reach one year.\n\nStreak will only be active on the first skill trained or the first skill trained after streak is lost.\n\nTier 1 (Three Days): +1 exp per session.\nTier 2 (One week): +2 exp per session.\nTier 3 (One Month): +3 exp per session.\nTier 4 (Six Months): +4 exp per session.\nTier 5 (One Year): +5 exp per session!",
    variable = mwse.mcm.createTableVariable { id = "streakBonus", table = config }
}

globalSettings:createSlider {
    label = "Streak Grace Period",
    description = "The amount of in-game hours that must pass to lose your current training streak. 168 hours is equal to one week. Default: 48",
    max = 168,
    min = 24,
    variable = EasyMCM:createTableVariable {
        id = "gracePeriod",
        table = config
    }
}

globalSettings:createOnOffButton {
    label = "Skill Training Limit",
    description = "Turn on or off the skill training limit.",
    variable = mwse.mcm.createTableVariable { id = "skillLimit", table = config }
}

globalSettings:createSlider {
    label = "Skill Limit",
    description = "Once a skill reaches this limit, you can no longer train it by practicing this way. Default: 75",
    max = 200,
    min = 1,
    variable = EasyMCM:createTableVariable {
        id = "skillMax",
        table = config
    }
}

globalSettings:createOnOffButton {
    label = "Train in Town",
    description = "If this is turned on, you are allowed to train in areas where resting is illegal. Otherwise, you cannot.",
    variable = mwse.mcm.createTableVariable { id = "townTrain", table = config }
}

globalSettings:createSlider {
    label = "Endurance Bonus",
    description = "Every 10 points of Endurance increases the amount of hours you are able to train in one session by 1/10th of this amount, rounded. Applies to non-magical skills. Default: 5 (5 = 5 hours per session maximum at Endurance 100)",
    max = 10,
    min = 1,
    variable = EasyMCM:createTableVariable {
        id = "endMod",
        table = config
    }
}

globalSettings:createSlider {
    label = "Willpower Bonus",
    description = "Every 10 points of Willpower increases the amount of hours you are able to train in one session by 1/10th of this amount, rounded. Applies to magical skills. Default: 5 (5 = 5 hours per session maximum at Willpower 100)",
    max = 10,
    min = 1,
    variable = EasyMCM:createTableVariable {
        id = "wilMod",
        table = config
    }
}

globalSettings:createSlider {
    label = "Stamina Multiplier",
    description = "The amount of stamina per hour required to train non-magical, non-armor skills is multiplied by this amount. High level skills cost more stamina. 1 is very low, 10 is very high. Default: 5",
    max = 10,
    min = 1,
    variable = EasyMCM:createTableVariable {
        id = "costMultF",
        table = config
    }
}

globalSettings:createSlider {
    label = "Magicka Multiplier",
    description = "The amount of magicka per hour required to train magical skills is multiplied by this amount. High level skills cost more magicka. 1 is very low, 10 is very high. Default: 3",
    max = 10,
    min = 1,
    variable = EasyMCM:createTableVariable {
        id = "costMultM",
        table = config
    }
}

globalSettings:createSlider {
    label = "Health Multiplier",
    description = "The amount of health per hour required to train armor skills is multiplied by this amount. High level skills cost more health. 1 is very low, 10 is very high. Default: 2",
    max = 10,
    min = 1,
    variable = EasyMCM:createTableVariable {
        id = "costMultH",
        table = config
    }
}

globalSettings:createOnOffButton {
    label = "Disable Training Menu Colors",
    description = "If this is turned on, the training menu skill list reverts to default text/selection colors.",
    variable = mwse.mcm.createTableVariable { id = "noColor", table = config }
}

globalSettings:createDropdown {
    label = "Debug Logging Level",
    description = "Set the log level.",
    options = {
        { label = "TRACE", value = "TRACE" },
        { label = "DEBUG", value = "DEBUG" },
        { label = "INFO", value = "INFO" },
        { label = "ERROR", value = "ERROR" },
        { label = "NONE", value = "NONE" },
    },
    variable = mwse.mcm.createTableVariable { id = "logLevel", table = config },
    callback = function(self)
        log:setLogLevel(self.variable.value)
    end
}
