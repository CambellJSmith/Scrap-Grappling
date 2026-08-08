class_name PixelPalette
extends RefCounted

const BACKGROUND: Color = Color8(12, 14, 13) # Defines the darkest world backdrop tone.
const GROUND: Color = Color8(39, 43, 36) # Defines the primary terrain tone.
const GROUND_LIGHT: Color = Color8(57, 60, 48) # Defines sparse terrain detail pixels.
const INK: Color = Color8(18, 20, 18) # Defines outlines and deep machinery recesses.
const LIGHT: Color = Color8(202, 198, 168) # Defines scrapling bodies and high-value highlights.
const IRON: Color = Color8(112, 115, 108) # Defines iron materials and common machinery.
const IRON_LIGHT: Color = Color8(151, 151, 137) # Defines lit iron edges and finished components.
const WOOD: Color = Color8(113, 78, 49) # Defines timber, huts, and wooden infrastructure.
const WOOD_LIGHT: Color = Color8(151, 105, 62) # Defines exposed timber edges.
const GREEN: Color = Color8(72, 93, 61) # Defines vegetation with a muted natural accent.
const NICKEL: Color = Color8(127, 139, 128) # Defines nickel with a restrained cool metal tone.
const COBALT: Color = Color8(59, 76, 111) # Defines cobalt as the first strong technological color.
const ELECTRIC: Color = Color8(166, 154, 84) # Defines electronics and active machine indicator pixels.
const RESEARCH: Color = Color8(103, 126, 116) # Defines academic and technical workers.
const DANGER: Color = Color8(126, 67, 54) # Defines heat, forge openings, and warnings.

static func resource_color(resource_id: StringName) -> Color: # Maps resource types to consistent world colors.
    if resource_id == ResourceIds.WOOD:
        return WOOD_LIGHT
    if resource_id == ResourceIds.NICKEL or resource_id == ResourceIds.NICKEL_ORE:
        return NICKEL
    if resource_id == ResourceIds.COBALT or resource_id == ResourceIds.COBALT_ORE:
        return COBALT
    if resource_id == ResourceIds.ELECTRONICS:
        return ELECTRIC
    if resource_id == ResourceIds.KNOWLEDGE:
        return RESEARCH
    return IRON_LIGHT
