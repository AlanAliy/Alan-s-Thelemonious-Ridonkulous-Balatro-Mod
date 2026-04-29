
--Creates an atlas for cards to use
SMODS.Atlas {
	-- Key for code to find it with
	key = "alan_jokers",
	-- The name of the file, for the code to pull the atlas from
	path = "Jokers-AlanMod.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}
SMODS.Atlas{
    key = "alan_jokers2",
    path = "Jokers2-AlanMod.png",
    px = 71,
    py = 95
}


SMODS.Sound{
    key = "music_tongueday",
    path = "Turbo_Turabi.ogg",

    select_music_track = function(self)
        if G.jokers then
            for _, joker in ipairs(G.jokers.cards) do
                if joker.config.center.key == "j_alanMod_tongueday_joker" then
                    return 10
                end
            end
        end
        return false
    end
}



SMODS.Joker {
    key = "turkey_joker",

    loc_txt = {
        name = "Turkey",
        text = {
            "Halve your money when bought,",
            "{C:mult}+#1#{} Mult"
        }
    },

    config = { extra = { mult = 10 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 0, y = 0 },
    cost = 3,

    -- Halve money when bought
    add_to_deck = function(self, card, from_debuff)
        if G and G.GAME and G.GAME.dollars then
            local new_money = math.floor(G.GAME.dollars / 2)
            local diff = new_money - G.GAME.dollars
            ease_dollars(diff)
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker{
    key = "bell_joker",
    
    loc_txt = {
        name = "bELL hOOKS",
        text = {
            "Each scored queen gives,",
            "{C:mult}+#1#{} Mult"
        }
    },

    config = { extra = { mult = 10 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 1, y = 0 },
    cost = 4,

calculate = function(self, card, context)

        -- check cards that were scored
        if context.individual and context.cardarea == G.play then

            -- check if card is a queen
            if context.other_card:get_id() == 12 then
                return {
                    mult = card.ability.extra.mult,
                    message = "ding!"
                }
            end
        end

    end
}

SMODS.Joker{
    key = "philippines_joker",

    loc_txt = {
        name = "Philippines",
        text = {
            "When sold,",
            "make bird nest soup"
        }
    },

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 2, y = 0 },
    cost = 5,

    calculate = function(self, card, context)
        if context.selling_card and context.card == card then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({
                        key = "j_egg"
                    })
                    return true
                end
            }))
            return {
                message = "Egg!"
            }
        end
    end
}

SMODS.Joker{
    key = "cocaine_joker",

    loc_txt = {
        name = "Cocaine",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Gains {X:mult,C:white}X#2#{} Mult",
            "whenever a scored {C:attention}8{} is played",
            "Resets each ante"
        }
    },

    config = { extra = { xmult = 1, gain = 0.2, base = 1 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.gain
            }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 3, y = 0 },
    cost = 6,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 8 then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
                return {
                    message = "Snort"
                }
            end
        end

        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and G.GAME.blind.boss then
            card.ability.extra.xmult = card.ability.extra.base
            return {
                message = "Reset"
            }
        end
    end
}

SMODS.Joker{
    key = "tongueday_joker",

    loc_txt = {
        name = "Turabi",
        text = {
            "{C:chips}+#1#{} Chips",
            "What else could it",
            "possibly do..."
        }
    },

    config = { extra = { chips = 50 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 4, y = 0 },
    cost = 4,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}
SMODS.Joker{
    key = "popeyes_microwave",

    loc_txt = {
        name = "Popeyes in Microwave",
        text = {
            "{C:attention}#1#{} hands until active,",
            "then next hand gives {C:mult}+#2#{} Mult"
        }
    },

    config = { extra = { hands_left = 3, mult = 500, active = false } },

    loc_vars = function(self, info_queue, card)
        local display = card.ability.extra.active and "Active!" or tostring(card.ability.extra.hands_left)
        return {
            vars = {
                display,
                card.ability.extra.mult
            }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 5, y = 0 },
    cost = 7,

    calculate = function(self, card, context)
        -- if armed, explode during normal joker scoring
        if context.joker_main and card.ability.extra.active then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:start_dissolve()
                    return true
                end
            }))

            return {
                mult = card.ability.extra.mult,
                message = "Boom!"
            }
        end

        -- countdown after each hand
        if context.after and not context.blueprint and not card.ability.extra.active then
            card.ability.extra.hands_left = card.ability.extra.hands_left - 1

            if card.ability.extra.hands_left <= 0 then
                card.ability.extra.active = true
                return {
                    message = "Active!"
                }
            else
                return {
                    message = tostring(card.ability.extra.hands_left)
                }
            end
        end
    end
}

SMODS.Joker{
    key = "gag_joker",

    loc_txt = {
        name = "GAG",
        text = {
            "Played {C:attention}Full House{}",
            "gives {X:mult,C:white}X#1#{} Mult"
        }
    },

    config = { extra = { xmult = 2 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 6, y = 0 },
    cost = 6,

    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Full House" then
            return {
                x_mult = card.ability.extra.xmult,
                message = "GAGged"
            }
        end
    end
}

SMODS.Joker{
    key = "broom_joker",

    loc_txt = {
        name = "Broom",
        text = {
            "Gains {C:mult}+#2#{} Mult for every",
            "discarded card this round",
            "Currently {C:mult}+#1#{} Mult",
            "{C:inactive}(Resets each round)"
        }
    },

    config = { extra = { mult = 0, gain = 2 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.gain
            }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 1, y = 1 },
    cost = 4,

    calculate = function(self, card, context)

        -- Gain mult once per discarded card
        if context.discard and context.other_card and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain

            return {
                message = "Sweep!"
            }
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end

        if context.end_of_round and not context.blueprint then
            card.ability.extra.mult = 0
            return {
                message = "Reset"
            }
        end
    end
}



SMODS.Consumable{
    key = "weed_planet",
    set = "Planet",

    loc_txt = {
        name = "Weed",
        text = {
            "Upgrade {C:attention}High Card{}",
            "by {C:attention}+2{} levels"
        }
    },

    atlas = "alan_jokers",
    pos = { x = 0, y = 1 },
    cost = 3,

    use = function(self, card, area, copier)
        level_up_hand(card, "High Card", nil, 2)
    end,

    can_use = function(self, card)
        return true
    end
}
SMODS.Joker{
    key = "theft_joker",

    loc_txt = {
        name = "Theft",
        text = {
            "Lose {C:money}$#1#{} at end of round,",
            "gain {X:mult,C:white}X#2#{} Mult"
        }
    },

    config = { extra = { dollars = 5, xmult = 5 } },

    loc_vars = function(self, info_queue, card)
        local dollars = 5
        local xmult = 5

        if card and card.ability and card.ability.extra then
            dollars = card.ability.extra.dollars or 5
            xmult = card.ability.extra.xmult or 5
        end

        return {
            vars = { dollars, xmult }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 2, y = 1 },
    cost = 7,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            ease_dollars(-card.ability.extra.dollars)
            return {
                message = "-$" .. card.ability.extra.dollars
            }
        end
    end
}


SMODS.Joker{
    key = "happy_hour",

    loc_txt = {
        name = "Happy Hour",
        text = {
            "Gain {C:money}$1{} for every",
            "{C:money}$5{} spent in the shop",
            "{C:inactive}(Currently #1#/$5)"
        }
    },

    config = { extra = { spent = 0 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.spent }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 3, y = 1 },
    cost = 5,

    calculate = function(self, card, context)

        -- Detect purchases
        if context.buying_card and context.card and not context.blueprint then

            local price = context.card.cost or 0
            card.ability.extra.spent = card.ability.extra.spent + price

            local reward = math.floor(card.ability.extra.spent / 5)

            if reward > 0 then
                card.ability.extra.spent = card.ability.extra.spent % 5
                ease_dollars(reward)

                return {
                    message = "+$"..reward
                }
            end
        end
    end
}

SMODS.Joker{
    key = "god_joker",

    loc_txt = {
        name = "God",
        text = {
            "{X:mult,C:white}X#1#{} Mult,",
            "gain {C:money}$#2#{} at end of round"
        }
    },

    config = { extra = { xmult = 20, dollars = 50 } },

    loc_vars = function(self, info_queue, card)
        local xmult = 20
        local dollars = 50

        if card and card.ability and card.ability.extra then
            xmult = card.ability.extra.xmult or 20
            dollars = card.ability.extra.dollars or 50
        end

        return {
            vars = { xmult, dollars }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 4, y = 1 },
    cost = 20,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            ease_dollars(card.ability.extra.dollars)
            return {
                message = "+$" .. card.ability.extra.dollars
            }
        end
    end
}

SMODS.Joker{
    key = "late_joker",

    loc_txt = {
        name = "Late Joker",
        text = {
            "Activates in {C:attention}#1#{} rounds,",
            "then gives {C:money}$#2#{}",
            "and destroys itself"
        }
    },

    config = { extra = { rounds_left = 12, dollars = 200 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.rounds_left,
                card.ability.extra.dollars
            }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 5, y = 1 },
    cost = 7,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1

            if card.ability.extra.rounds_left <= 0 then
                ease_dollars(card.ability.extra.dollars)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve()
                        return true
                    end
                }))

                return {
                    message = "+$" .. card.ability.extra.dollars
                }
            else
                return {
                    message = tostring(card.ability.extra.rounds_left)
                }
            end
        end
    end
}

SMODS.Joker{
    key = "aperol_joker",

    loc_txt = {
        name = "Aperol",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "never perishes"
        }
    },

    config = { extra = { xmult = 5 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers",
    pos = { x = 6, y = 1 },
    cost = 8,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Joker{
    key = "prophet_joker",

    loc_txt = {
        name = "Prophet",
        text = {
            "{C:green}#1# in #2#{} chance at end of round",
            "to transform into",
            "{C:attention}God{}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local prob = (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1
        return {
            vars = { 1 * prob, 10 }
        }
    end,

    rarity =1,
    atlas = "alan_jokers2",
    pos = { x = 0, y = 0 },
    cost = 6,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'prophet', 1, 10) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve()
                        SMODS.add_card({
                            key = "j_alanMod_god_joker"
                        })
                        return true
                    end
                }))
                return {
                    message = "He has arrived"
                }
            end
        end
    end
}

SMODS.Consumable{
    key = "erdogan",
    set = "Spectral",

    loc_txt = {
        name = "Erdogan",
        text = {
            "Set money to {C:money}-$50{},",
            "create a random",
            "{C:legendary}Legendary Joker{}"
        }
    },

    atlas = "alan_jokers2",
    pos = { x = 1, y = 0 },
    cost = 4,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local target_money = -50
        local diff = target_money - (G.GAME.dollars or 0)

        ease_dollars(diff)

        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({
                    set = "Joker",
                    rarity = 4
                })
                return true
            end
        }))
    end
}

SMODS.Joker{
    key = "john_joker",

    loc_txt = {
        name = "John Joker",
        text = {
            "Just likes to hang around",
            "{C:green}#1# in #2#{} chance to say hello.",
            "will not answer the phone"
        }
    },

    loc_vars = function(self, info_queue, card)
        local prob = (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1
        return {
            vars = { 1 * prob, 4 }
        }
    end,

    rarity = 1,
    atlas = "alan_jokers2",
    pos = { x = 2, y = 0 },
    cost = 3,

    calculate = function(self, card, context)
        if context.joker_main then

            -- hidden jackpot, not shown in text
            if SMODS.pseudorandom_probability(card, 'john_big', 1, 100) then
                ease_dollars(10000)
                return {
                    message = "john."
                }
            end

            -- visible hello chance
            if SMODS.pseudorandom_probability(card, 'john_hello', 1, 4) then
                return {
                    message = "hey"
                }
            end

        end
    end
}