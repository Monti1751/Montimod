--- STEAMODDED HEADER
--- MOD_NAME: Montimod
--- MOD_ID: Montimod
--- MOD_AUTHOR: [Monti]
--- MOD_DESCRIPTION: A vanilla+ mod that adds jokers.
--- PREFIX: Monti
--- BADGE_COLOR: 00AAFF
----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Jokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'aromatic_candles',
    loc_txt = {
        name = 'Aromatic Candles',
        text = {
            'Gain {C:chips}+40{} Chips per',
            '{C:attention}seal{} in deck',
            '{C:inactive}(Current: {C:chips}+#1#{C:inactive} Chips)'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {extra = {chips = 0}},
    
    loc_vars = function(self, info_queue, center)
        if not G or not G.playing_cards then return {vars = {0}} end
        
        local count = 0
        for _, c in ipairs(G.playing_cards) do
            if c and c.seal then count = count + 1 end
        end
        
        if center and center.ability then
            center.ability.extra = {chips = count * 40}
        end
        return {vars = {count * 40}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            if G and G.playing_cards then
                for _, c in ipairs(G.playing_cards) do
                    if c and c.seal then count = count + 1 end
                end
            end
            local chips_total = count * 40
            if chips_total > 0 then
                return {
                    chip_mod = chips_total,
                    message = '+'..chips_total..' Chips',
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
        return nil
    end,
    
    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'wax_museum',
    loc_txt = {
        name = 'Wax Museum',
        text = {
            'Each {C:attention}sealed{} card',
            'adds {C:mult}+5{} Mult',
            '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    pos = {x = 1, y = 0},
    config = {extra = {mult = 0}},
    
    loc_vars = function(self, info_queue, center)
        if not center or not center.ability then return {vars = {0}} end
        center.ability.extra = center.ability.extra or {mult = 0}
        
        local count = 0
        if G and G.playing_cards then
            for _, card in ipairs(G.playing_cards) do
                if card and card.seal then
                    count = count + 1
                end
            end
        end
        center.ability.extra.mult = count * 5
        return {vars = {center.ability.extra.mult}}
    end,
    
    calculate = function(self, card, context)
        if not card or not card.ability then return nil end
        card.ability.extra = card.ability.extra or {mult = 0}
        
        if not context or not context.joker_main then return nil end
        
        local count = 0
        if G and G.playing_cards then
            for _, c in ipairs(G.playing_cards) do
                if c and c.seal then
                    count = count + 1
                end
            end
        end
        local total_mult = count * 5
        if total_mult > 0 then
            return {
                mult_mod = total_mult,
                message = '+'..total_mult..' Mult',
                colour = G.C.MULT,
                card = card
            }
        end
        return nil
    end,
    
    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'candle_joker',
    loc_txt = {
        name = 'Candle Joker',
        text = {
            'Each {C:attention}sealed{} card',
            'adds {X:mult,C:white}X0.5{} Mult',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive})'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,
    pos = {x = 2, y = 0},
    config = {extra = {Xmult = 1}},
    
    loc_vars = function(self, info_queue, center)
        if not center or not center.ability then return {vars = {1}} end
        center.ability.extra = center.ability.extra or {Xmult = 1}
        
        local count = 0
        if G and G.playing_cards then
            for _, card in ipairs(G.playing_cards) do
                if card and card.seal then
                    count = count + 1
                end
            end
        end
        center.ability.extra.Xmult = 1 + (count * 0.5)
        return {vars = {center.ability.extra.Xmult}}
    end,
    
    calculate = function(self, card, context)
        if not card or not card.ability then return nil end
        card.ability.extra = card.ability.extra or {Xmult = 1}
        
        if not context or not context.joker_main then return nil end
        
        local count = 0
        if G and G.playing_cards then
            for _, c in ipairs(G.playing_cards) do
                if c and c.seal then
                    count = count + 1
                end
            end
        end
        local xmult = 1 + (count * 0.5)
        return {
            Xmult_mod = xmult,
            message = 'X'..string.format("%.1f", xmult),
            colour = G.C.MULT,
            card = card
        }
    end,
    
    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'detective',
    loc_txt = {
        name = 'The Detective Arrived',
        text = {
            'Each {C:diamonds}Diamond{} played',
            'adds {C:chips}+#1#{} chips when scored',
            '{C:inactive}(Current money: {C:money}$#2#{C:inactive})'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 0},
    
    loc_vars = function(self, info_queue, center)
        local current_money = G.GAME and G.GAME.dollars or 0
        return {vars = {current_money, current_money}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card then
            if context.other_card.config and context.other_card:is_suit('Diamonds') then
                local current_money = G.GAME and G.GAME.dollars or 0
                if current_money > 0 then
                    return {
                        message = '+'..current_money..' Chips',
                        chips = current_money,
                        colour = G.C.MONEY,
                        card = context.other_card
                    }
                end
            end
        end
        return nil
    end,
    
    in_pool = function(self) return true end
}

SMODS.Joker{ 
    key = 'survival', 
    loc_txt = {
        name = 'Survival',
        text = {
            'Each {C:attention}Ace{} played',
            'adds {X:mult,C:white}X0.11{} Mult',
            '{C:inactive}(Current: {X:mult,C:white}X#1#{C:inactive})'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 0},
    config = {extra = {Xmult = 1, aces_played = 0}},
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and context.other_card:get_id() == 14 then
            card.ability.extra.aces_played = (card.ability.extra.aces_played or 0) + 1
            card.ability.extra.Xmult = 1 + (card.ability.extra.aces_played * 0.11)
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "Ace! X"..string.format("%.2f", card.ability.extra.Xmult),
                colour = G.C.RED
            })
        end

        if context.joker_main then
            if card.ability.extra.Xmult > 1 then
                return {
                    Xmult_mod = card.ability.extra.Xmult,
                    message = 'X'..string.format("%.2f", card.ability.extra.Xmult),
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        return nil
    end,
    
    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'balatris',
    loc_txt = {
        name = 'BALATRIS',
        text = {
            '{C:chips}+60{} Chips if all',
            'scored cards are unique'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 0},
    config = {},
    
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            local unique = {}
            for _, c in ipairs(context.scoring_hand) do
                local card_id = c:get_id()
                if unique[card_id] then 
                    return nil 
                end
                unique[card_id] = true
            end
            return {
                chip_mod = 60,
                message = '+60 Chips',
                colour = G.C.CHIPS,
                card = card
            }
        end
        return nil
    end,
    
    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'jokernaut',
    loc_txt = {
        name = 'Jokernaut',
        text = {
            'Gains {X:mult,C:white}X0.5{} Mult',
            'each time {C:attention}Two Pair{} is played',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive})',
            '{C:inactive}(Max {X:mult,C:white}X10{C:inactive})'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 1},
    config = {extra = {Xmult = 1, triggered_this_round = false}},
    
    loc_vars = function(self, info_queue, center)
        if center and center.ability then
            return {vars = {string.format("%.1f", center.ability.extra.Xmult)}}
        else
            return {vars = {"1.0"}}
        end
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.triggered_this_round = false
            return nil
        end
        
        if context.before and context.scoring_name == 'Two Pair' and not card.ability.extra.triggered_this_round then
            card.ability.extra.triggered_this_round = true
            
            if card.ability.extra.Xmult < 10 then
                card.ability.extra.Xmult = math.min(card.ability.extra.Xmult + 0.5, 10)
                
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "Upgrade! X"..string.format("%.1f", card.ability.extra.Xmult),
                    colour = G.C.MULT,
                    delay = 0.4
                })
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
            else
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "MAX X10!",
                    colour = G.C.RED,
                    delay = 0.4
                })
            end
        end
        
        if context.joker_main then
            if card.ability.extra.Xmult > 1 then
                return {
                    Xmult_mod = card.ability.extra.Xmult,
                    message = 'X'..string.format("%.1f", card.ability.extra.Xmult),
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra = card.ability.extra or {Xmult = 1, triggered_this_round = false}
    end,
    
    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'masked',
    loc_txt = {
        name = 'El Enmascarado',
        text = {
            'Each round: Random effect',
            '{C:inactive}Todos llevamos una mascara'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 1},
    config = {},

    calculate = function(self, card, context)
        if context and context.joker_main then
            local reward_type = pseudorandom('masked') * 4
            reward_type = math.floor(reward_type) + 1
            
            if reward_type == 1 then
                return {chip_mod = 50, message = "+50 Chips", colour = G.C.CHIPS, card = card}
            elseif reward_type == 2 then
                return {mult_mod = 15, message = "+15 Mult", colour = G.C.MULT, card = card}
            elseif reward_type == 3 then
                return {Xmult_mod = 2, message = "X2 Mult", colour = G.C.WHITE, card = card}
            else
                ease_dollars(1)
                return {message = "+$1", colour = G.C.MONEY, card = card}
            end
        end
        return nil
    end,

    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'the_gods',
    loc_txt = {
        name = 'The Gods',
        text = {
            'When playing 3 {C:attention}Kings{}, 3 {C:attention}Queens{},',
            'or 3 {C:attention}Jacks{}, apply {X:mult,C:white}X20{} Mult'
        }
    },
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jokers',
    pos = {x = 2, y = 1},
    config = {},
    
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            local king_count, queen_count, jack_count = 0, 0, 0
            
            for _, c in ipairs(context.scoring_hand) do
                local card_id = c:get_id()
                if card_id == 13 then
                    king_count = king_count + 1
                elseif card_id == 12 then
                    queen_count = queen_count + 1
                elseif card_id == 11 then
                    jack_count = jack_count + 1
                end
            end
            
            if king_count >= 3 or queen_count >= 3 or jack_count >= 3 then
                local card_type = ""
                if king_count >= 3 then card_type = "Kings"
                elseif queen_count >= 3 then card_type = "Queens"
                else card_type = "Jacks" end
                
                return {
                    Xmult_mod = 20,
                    message = card_type..' X20',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        return nil
    end,

    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,

    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'coin_flip',
    loc_txt = {
        name = 'Tirada de Moneda',
        text = {
            '{X:mult,C:white}X10{} Mult, but',
            '{C:red}50%{} chance to destroy',
            'this joker when scored'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 3, y = 1},
    config = {},
    
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('coin_flip') < 0.5 and not card.ability.eternal then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        card:start_dissolve()
                        return true
                    end
                }))
            end
            return {
                Xmult_mod = 10,
                message = 'X10 Mult',
                colour = G.C.MULT,
                card = card
            }
        end
        return nil
    end,
    
    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'montini',
    loc_txt = {
        name = 'Montini',
        text = {
            'Played {C:attention}9s{} and {C:attention}2s{}',
            'score with {X:mult,C:white}X2{} Mult',
            '{C:inactive}(Only when scored)'
        }
    },
    atlas = 'Jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    soul_pos = {x = 0, y = 2},
    pos = {x = 4, y = 1},
    config = {},

    calculate = function(self, card, context)
        if not context or not context.individual or not context.other_card then 
            return nil 
        end
        
        if context.cardarea == G.play then
            local target = context.other_card
            local card_id = target:get_id()
            
            if card_id == 9 or card_id == 2 then
                return {
                    x_mult = 2,
                    colour = G.C.MULT,
                    card = target
                }
            end
        end
        return nil
    end,

    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'doctor',
    loc_txt = {
        name = 'The Doctor',
        text = {
            'After cards score,',
            'they become {C:dark_edition}Holographic{}',
            '{C:inactive}(Transforms after scoring)'
        }
    },
    atlas = 'Jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 1},
    soul_pos = {x = 1, y = 2},
    
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand and not context.blueprint then
            local cards_to_transform = {}
            for _, c in ipairs(context.scoring_hand) do
                if c and c.config and not c.debuff then
                    table.insert(cards_to_transform, c)
                end
            end
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    for _, scored_card in ipairs(cards_to_transform) do
                        if scored_card and scored_card.set_edition then
                            scored_card:set_edition({holo = true}, true)
                            card_eval_status_text(scored_card, 'extra', nil, nil, nil, {
                                message = "Holographic!",
                                colour = G.C.PURPLE,
                                delay = 0.2
                            })
                        end
                    end
                    return true
                end
            }))
            
            return {
                message = 'Allons-y!',
                colour = G.C.PURPLE,
                card = card
            }
        end
        return nil
    end,
    
    in_pool = function(self) return true end
}