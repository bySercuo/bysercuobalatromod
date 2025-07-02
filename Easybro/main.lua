--- STEAMODDED HEADER
--- MOD_NAME: bySerculón
--- MOD_ID: BYSERCUO
--- MOD_AUTHOR: [bySercuo]
--- MOD_DESCRIPTION: Test de mi mod y mis jokers
--- PREFIX: xmpl
----------------------------------------------
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
            'un comodín {C:blue}Blueprint{}'
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
SMODS.Joker{
    key = 'El Prestamista',
    loc_txt = {
        name = 'El Prestamista',
        text = {
            'Suma +4 multi por cada $ que tengas.',
            'Actual: +{X:mult,C:mult}#1#{}'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 8,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    pos = { x = 3, y = 0 },

    -- Calcula el total a sumar al multiplicador
    loc_vars = function(self)
        local dinero = (G.player and G.player.coins) or G.coins or 0
        local total = math.floor(dinero) * 4
        return { vars = { tostring(total) } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local dinero = (G.player and G.player.coins) or G.coins or 0
            local extra = math.floor(dinero) * 4
            return {
                card       = card,
                Xmult_mod  = extra,
                message    = '+' .. extra,
                colour     = G.C.MULT
            }
        end
    end,

    in_pool = function(self)
        return true
    end
}

