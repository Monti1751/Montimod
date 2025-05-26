--- STEAMODDED HEADER
--- MOD_NAME: Montimod
--- MOD_ID: Montimod
--- MOD_AUTHOR: [Monti]
--- MOD_DESCRIPTION: A vanilla+ mod that adds jokers .
--- PREFIX: Monti
--- BADGE_COLOR: 00AAFF
----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'aromatic_candles',
    loc_txt = {
        name = 'Aromatic Candles', --Nombre
        text = { --Descripción
            'Gain {C:chips}+40{} Chips per',
            '{C:attention}seal{} in deck',
            '{C:inactive}(Current: {C:chips}+#1#{C:inactive} Chips)'
        }
    },
    atlas = 'Jokers',
    rarity = 2, --Rareza
    cost = 6, --Precio
    unlocked = true, --Desbloqueado
    discovered = true, --Descubierto
    blueprint_compat = true, --Puede ser copiado por blueprint
    eternal_compat = true, --Puede ser eterno
    perishable_compat = true, --Puede ser destruido
    pos = {x = 0, y = 0}, -- Posicion en el atlas
    config = {extra = {chips = 0}},  -- Caché para el contador
    
    loc_vars = function(self, info_queue, center)
        -- Solo calcular en juego
        if not G or not G.playing_cards then return {vars = {0}} end
        
        local count = 0
        for _, c in ipairs(G.playing_cards) do
            if c and c.seal then count = count + 1 end
        end
        
        -- Guardar en caché y mostrar
        if center and center.ability then
            center.ability.extra = {chips = count * 40}
        end
        return {vars = {count * 40}}
    end,

    calculate = function(self, card, context) --A la hora de puntuar los Jokers
        if context.joker_main then
            local count = card.ability.extra.chips / 40  -- Recuperar del caché
            return {
                chip_mod = count * 40,
                message = '+'..(count * 40)..' Chips',
                colour = G.C.CHIPS,
                card = card
            }
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
        return {
            mult_mod = total_mult,
            message = '+'..total_mult..' Mult',
            colour = G.C.MULT,
            card = card
        }
    end,
    
    in_pool = function(self) return true end
}

-- Función helper para contar sellos en todas las zonas
function count_all_sealed_cards()
    local count = 0
    local all_zones = {G.deck, G.discard, G.hand, G.play, G.consumeables, G.jokers, G.consumeables, G.vouchers}
    
    for _, zone in ipairs(all_zones) do
        if zone and zone.cards then
            for _, card in ipairs(zone.cards) do
                if card.config and card.config.center and card.config.center.seal then
                    count = count + 1
                end
            end
        end
    end
    
    return count
end

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
            'adds {C:blue}$#1#{} chips when scored',
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
        -- Activar solo al puntuar cartas jugadas
        if context.cardarea == G.play and context.other_card and not context.blueprint then
            -- Verificar si es diamante de forma segura
            if context.other_card.config and context.other_card:is_suit('Diamonds') then
                local current_money = G.GAME and G.GAME.dollars or 0
                if current_money > 0 then
                    -- Añadir el dinero actual como bonus
                    return {
                        message = '+'..current_money..' Chips',
                        chip_mod = current_money,
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
            'adds {X:mult,C:white}x0.11{} Mult',
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
        -- Registra Ases jugados (cuando se juegan)
        if context.individual and context.cardarea == G.play and context.other_card and context.other_card:get_id() == 14 then
            card.ability.extra.aces_played = (card.ability.extra.aces_played or 0) + 1
            card.ability.extra.Xmult = 1 + (card.ability.extra.aces_played * 0.11)
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "Ace Recorded! (x"..string.format("%.2f", card.ability.extra.Xmult)..")",
                colour = G.C.RED
            })
        end

        -- Aplica el multiplicador al puntuar
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X'..string.format("%.2f", card.ability.extra.Xmult),
                colour = G.C.MULT,
                card = card
            }
        end
    end,
    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'balatris',
    loc_txt = {
        name = 'BALATRIS',
        text = {
            '{C:chips}+20{} Chips if all',
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
        if context.cardarea == G.play and context.scoring_hand then
            local unique = {}
            for _, c in ipairs(context.scoring_hand) do
                if unique[c.base.id] then return nil end
                unique[c.base.id] = true
            end
            return {
                chip_mod = 10,
                message = '+10 Chips',
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker{
    key = 'jokernaut',
    loc_txt = {
        name = 'Jokernaut',
        text = {
            'Gains {X:mult,C:white}+0.5X{} Mult',
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
        -- Resetear al inicio de ronda
        if context.setting_blind and not context.blueprint then
            card.ability.extra.triggered_this_round = false
            return
        end
        
        -- Activar solo cuando se juega la jugada completa (no al seleccionar)
        if context.after and context.scoring_name == 'Two Pair' and not card.ability.extra.triggered_this_round then
            
            -- Marcar como activado para esta ronda
            card.ability.extra.triggered_this_round = true
            
            -- Incrementar el multiplicador (hasta máximo X10)
            if card.ability.extra.Xmult < 10 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + 0.5
                
                -- Feedback visual
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "Two Pair Played! X"..string.format("%.1f", card.ability.extra.Xmult),
                    colour = G.C.MULT,
                    delay = 0.4
                })
                
                -- Animación
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
                    message = "MAX POWER X10!",
                    colour = G.C.RED,
                    delay = 0.4
                })
            end
        end
        
        -- Aplicar el multiplicador al puntuar
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X'..string.format("%.1f", card.ability.extra.Xmult),
                colour = G.C.MULT,
                card = card
            }
        end
    end,
    
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra = card.ability.extra or {Xmult = 1, triggered_this_round = false}
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.6,
            func = function()
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = 'Lo viejo funciona, Juan',
                    colour = G.C.MULT
                })
                return true
            end
        }))
    end,
    
    in_pool = function(self) return true end
}

SMODS.Joker{
    key = 'masked',
    loc_txt = {
        name = 'El Enmascarado',
        text = {
            'Each round: Random effect',
            '{C:inactive}Todos llevamos una mascara',
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
            local reward_type = math.random(4)
            
            if reward_type == 1 then
                return {chip_mod = 50, message = "+50 Chips", colour = G.C.CHIPS}
            elseif reward_type == 2 then
                return {mult_mod = 15, message = "+15 Mult", colour = G.C.MULT}
            elseif reward_type == 3 then
                return {Xmult_mod = 2, message = "X2 Mult", colour = G.C.WHITE}
            else
                ease_dollars(1)
                return {message = "+$1", colour = G.C.MONEY}
            end
        end
        return nil
    end,

    in_pool = function(self) return true end
}

-- Función de ayuda para comparar tablas necesaria para evitar loops
function compare_tables(t1, t2)
    if #t1 ~= #t2 then return false end
    for i = 1, #t1 do
        if t1[i] ~= t2[i] then return false end
    end
    return true
end

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
            
            -- Count K, Q, J in played cards
            for _, c in ipairs(context.scoring_hand) do
                local card_id = c:get_id()
                if card_id == 13 then     -- King
                    king_count = king_count + 1
                elseif card_id == 12 then -- Queen
                    queen_count = queen_count + 1
                elseif card_id == 11 then -- Jack
                    jack_count = jack_count + 1
                end
            end
            
            -- Apply X20 if any trio is found
            if king_count >= 3 or queen_count >= 3 or jack_count >= 3 then
                local card_type = ""
                if king_count >= 3 then card_type = "Kings"
                elseif queen_count >= 3 then card_type = "Queens"
                else card_type = "Jacks" end
                
                return {
                    Xmult_mod = 20,
                    message = card_type..' Blessing! X20',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        return nil
    end,

    loc_vars = function(self, info_queue, center)
        return {}
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
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 1},
    config = {},
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('coin_flip') < 0.5 then
                card:start_dissolve()
            end
            return {
                Xmult_mod = 10,
                message = 'X10 Mult',
                colour = G.C.MULT
            }
        end
    end
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
        -- Verificación ultra-básica para evitar crashes
        if not context or not context.individual or not context.other_card then return nil end
        
        -- Solo activar cuando la carta está puntuando (no en mano)
        if context.cardarea == G.play then
            local target = context.other_card
            local card_id = target:get_id()  -- Safe porque ya verificamos context.other_card
            
            if card_id == 9 or card_id == 2 then
                return {
                    Xmult_mod = 2,
                    message = 'X2 Montini',
                    colour = G.C.MULT,
                    card = target  -- Añadido para mejor feedback visual
                }
            end
        end
        return nil
    end,

    in_pool = function(self) return true end  -- Añadido por seguridad
}

SMODS.Joker{
    key = 'doctor',
    loc_txt = {
        name = 'The Doctor',
        text = {
            'After cards score,',
            'they become {C:dark_edition}Holographic{}',
            '{C:inactive}(Transforms after scoring){C:inactive}'
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
        -- Verificar que estamos después de puntuar y hay cartas que puntuaron
        if context.joker_main and context.scoring_hand and not context.blueprint then
            -- Crear copia segura de las cartas que puntuaron
            local cards_to_transform = {}
            for _, c in ipairs(context.scoring_hand) do
                if c and c.config and not c.debuff then
                    table.insert(cards_to_transform, c)
                end
            end
            
            -- Programar la transformación después con evento seguro
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    for _, scored_card in ipairs(cards_to_transform) do
                        if scored_card and scored_card.set_edition then
                            scored_card:set_edition('e_holo', true)
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
                message = 'Allons-y!!',
                colour = G.C.PURPLE,
                card = card
            }
        end
        return nil
    end,
    
    in_pool = function(self) return true end
}