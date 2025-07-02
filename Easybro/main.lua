--- STEAMODDED HEADER
--- MOD_NAME: bySercuo
--- MOD_ID: BYSERCUO
--- MOD_AUTHOR: [bySercuo]
--- MOD_DESCRIPTION: Test de mi mod y mis jokers
--- PREFIX: xmpl
--- MOD_VERSION: 0.1.1-beta
---------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{ --Atlas
    key = 'Jokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

SMODS.Joker{ --Obsesionado
    key = 'Obsesionado',
    loc_txt = {
        name = 'El Obsesionado',
        text = {
            'Al seleccionar una ciega,',
            '{C:green}1 de cada 20{} veces, se crea',
            'un comodín {C:blue}Plano{}'
        },
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 4,
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    pos = {x = 1, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind then
            if pseudorandom('romantico_blueprint') < 0.05 then
                local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_blueprint')
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
            end
        end
    end,
    in_pool = function(self)
        return true
    end
}

SMODS.Joker{ --Romántico
    key = 'El Romántico',
    loc_txt = {
        name = 'El Romántico 2.0',
        text = {
            '+{X:mult,C:white}X0.1{} de multi por cada mano jugada.',
            'Actual: {X:mult,C:white}X#1#{}'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 12,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    pos = {x = 0, y = 0},
    config = {
        extra = {
            Xmult = 1.0
        }
    },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {string.format('%.1f', center.ability.extra.Xmult or 1.0)}
        }
    end,
    check_for_unlock = function(self, args)
        unlock_card(self)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult or 1.0,
                message = 'X' .. string.format('%.1f', card.ability.extra.Xmult or 1.0),
                colour = G.C.MULT
            }
        end

        if context.after then
            card.ability.extra.Xmult = (card.ability.extra.Xmult or 1.0) + 0.1
        end
    end,
    in_pool = function(self)
        return true
    end
}

SMODS.Joker{ --El Poderoso
    key = 'El Poderoso',
    loc_txt = {
        name = 'El Poderoso',
        text = {
            '{C:red}+ 8{} multi fijo.'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 8,
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    pos = {x = 2, y = 0},
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                card = card,
                mult_mod = 8,
                message = '+8',
                colour = G.C.MULT
            }
        end
    end,
    in_pool = function(self)
        return true
    end
}

SMODS.Joker{ --El Banquero
    key = 'El Banquero',
    loc_txt = {
        name = 'El Banquero',
        text = {
            '{C:red}+3 {}multi y {C:blue}+25 {}fichas por cada {C:yellow}$5{} que tengas.'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 10,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    pos = {x = 3, y = 0},
    config = {
        extra = {
            bonus_mult = 0,
            bonus_chips = 0
        }
    },
    loc_vars = function(self, info_queue, center)
        local money = G.GAME and G.GAME.dollars or 0
        local count = math.floor(money / 5)
        local bonus_mult = count * 3
        local bonus_chips = count * 25
        return {
            vars = {tostring(bonus_mult), tostring(bonus_chips)}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local money = G.GAME and G.GAME.dollars or 0
            local count = math.floor(money / 5)
            local bonus_mult = count * 3
            local bonus_chips = count * 25
            card.ability.extra.bonus_mult = bonus_mult
            card.ability.extra.bonus_chips = bonus_chips
            if count > 0 then
                return {
                    card = card,
                    mult_mod = bonus_mult,
                    chips = bonus_chips,
                    message = '+' .. tostring(bonus_mult) .. ' multi',
                    colour = G.C.MULT
                }
            else
                return nil
            end
        end
        if context.after then
            card.ability.extra.bonus_mult = 0
            card.ability.extra.bonus_chips = 0
        end
    end,
    in_pool = function(self)
        return true
    end
}
-- todos los derechos bysercuo