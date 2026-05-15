import Foundation

// MARK: - Time blocks & phases
enum FrostlakeTimeBlock: Int, CaseIterable {
    case dawn = 0, morning, noon, afternoon, dusk, evening

    var label: String {
        switch self {
        case .dawn: return "Dawn"
        case .morning: return "Morning"
        case .noon: return "Noon"
        case .afternoon: return "Afternoon"
        case .dusk: return "Dusk"
        case .evening: return "Evening"
        }
    }

    var hourLabel: String {
        switch self {
        case .dawn: return "6 AM"
        case .morning: return "9 AM"
        case .noon: return "12 PM"
        case .afternoon: return "3 PM"
        case .dusk: return "5 PM"
        case .evening: return "7 PM"
        }
    }
}

enum FrostlakePhase: Int, CaseIterable {
    case early = 0, mid, late

    var label: String {
        switch self {
        case .early: return "Early Frost"
        case .mid: return "Mid Frost"
        case .late: return "Late Frost"
        }
    }

    var dayRange: ClosedRange<Int> {
        switch self {
        case .early: return 1...10
        case .mid: return 11...20
        case .late: return 21...30
        }
    }
}

enum FrostlakeWeather: Int, CaseIterable {
    case clear = 0, lightSnow, heavySnow, wind, mist

    var label: String {
        switch self {
        case .clear: return "Clear"
        case .lightSnow: return "Light Snow"
        case .heavySnow: return "Heavy Snow"
        case .wind: return "Wind"
        case .mist: return "Mist"
        }
    }
}

// MARK: - NPCs
struct FrostlakeNPC: Identifiable, Hashable {
    let id: Int
    let name: String
    let role: String
    let bio: String
    // location per time block (.dawn ... .evening) — string name of location
    let schedule: [String]
    let dialogueTiers: [[String]] // tier 0..3, 5 lines each
    let loreCards: [String] // 4 unlock cards
}

enum FrostlakeNPCData {
    static let all: [FrostlakeNPC] = [
        FrostlakeNPC(
            id: 0,
            name: "Helga",
            role: "Innkeeper",
            bio: "Warm and watchful, Helga trades rumors over hot mead by the hearth.",
            schedule: ["Inn", "Inn", "Market", "Inn", "Inn", "Inn"],
            dialogueTiers: [
                [
                    "Helga: You must be the new soul up at the cabin. Get yourself warm.",
                    "Helga: Snowfall came early this year. Bring your hood next time.",
                    "Helga: The bench by the door is yours if you want it.",
                    "Helga: I served two travellers like you last spring — neither stayed past Mid Frost.",
                    "Helga: Eat first, talk later. That's the inn's only rule."
                ],
                [
                    "Helga: Folks say the lake hums at dawn. I think it's just the timbers.",
                    "Helga: Olaf hasn't moved from that bench in twenty winters. Bless him.",
                    "Helga: The market's busier on noons after a clear night. Mark that.",
                    "Helga: Watch Eero — gruff, but he keeps the pier honest.",
                    "Helga: If you spot Ren, mind your purse and your patience."
                ],
                [
                    "Helga: Saara left a tin of birch tea for you. Don't lose it.",
                    "Helga: Mira asked about you. She thinks you live inside the almanac.",
                    "Helga: The crack on Mid-Lake opens its own door come Day 18.",
                    "Helga: Bring me a salmon roe bowl and I'll tell you the old festival lyric.",
                    "Helga: You smell of woodsmoke. That means you're staying."
                ],
                [
                    "Helga: There's a name for your kind of guest. We call them 'kept.'",
                    "Helga: My great-aunt fished the Forbidden Cape once. Never told what she saw.",
                    "Helga: When the Almanac is full, the inn rings the iron bell. Just so you know.",
                    "Helga: I've kept your seat by the window. Always will.",
                    "Helga: You're cove, now. Don't let it forget you."
                ]
            ],
            loreCards: [
                "Helga keeps the Inn fire going year-round; locals say a draft from her hearth means a clear morning.",
                "Helga learned mead-brewing from a peddler who travelled through three frosts in one year.",
                "Helga writes the cove's birth roll in the back of the Inn's day-book.",
                "Helga has refused four offers to leave Frostlake. Each suitor sent her a candle every winter since."
            ]
        ),
        FrostlakeNPC(
            id: 1,
            name: "Eero",
            role: "Bait Master",
            bio: "Gruff fisherman who measures everyone by line and patience.",
            schedule: ["Pier", "Pier", "Pier", "Stone Pier", "Inn", "Inn"],
            dialogueTiers: [
                [
                    "Eero: You hold the rod like a child holding a broom.",
                    "Eero: Pier's mine before noon. Don't crowd me.",
                    "Eero: Bait dries quick in this wind. Tuck it inside your coat.",
                    "Eero: Lake doesn't owe you a thing. Earn it.",
                    "Eero: Quiet. The smelt heard you."
                ],
                [
                    "Eero: Pike at Old Hole bite slow. Wait. Then strike.",
                    "Eero: Use lake roach for whitefish — anything else is for show.",
                    "Eero: Mid Frost makes them lazy. Move your line.",
                    "Eero: Toivo's auger is overpriced. Tell him I said so.",
                    "Eero: Olaf knows a song that calls the perch. He won't sing it for you."
                ],
                [
                    "Eero: I've got a spare auger if you ever break yours.",
                    "Eero: Forbidden Cape, eh? You're not ready. But you will be.",
                    "Eero: The Vigil on Day 24 — I'll save you a hole.",
                    "Eero: You cast cleaner now. Took you long enough.",
                    "Eero: My father caught the Moonwhite once. Didn't keep it. I never knew why."
                ],
                [
                    "Eero: When I die, give my rod to the lake. Not Toivo. The lake.",
                    "Eero: You and me — pier dawn tomorrow. No words. Just lines.",
                    "Eero: That book of yours — the Almanac — I read mine once. The lake reads us back.",
                    "Eero: You're cove now. Took less time than I expected.",
                    "Eero: I trust you with the Cape. Watch the wind on the Dusk turn."
                ]
            ],
            loreCards: [
                "Eero built his own pier in the third spring of his apprenticeship and never replaced a single plank.",
                "Eero refuses to fish on Day 13 each season. He won't say why; even Olaf won't ask.",
                "Eero once lent his line to a stranger who returned it weighted with a single perch scale.",
                "Eero's bait recipe uses pine resin, salted bread, and one word whispered before it sets."
            ]
        ),
        FrostlakeNPC(
            id: 2,
            name: "Saara",
            role: "Herbalist",
            bio: "She trades pine tincture, lichen tea, and patient recipes.",
            schedule: ["Cabin Garden", "Trail", "Market", "Market", "Market", "Cabin Garden"],
            dialogueTiers: [
                [
                    "Saara: Hands cold? Wrap them in wool, not bark.",
                    "Saara: Birch tea soothes the throat. Try it before the festival.",
                    "Saara: I tend the herb-box behind your cabin. Don't trample it.",
                    "Saara: Lichen looks like rock. It is not rock. Don't bite it.",
                    "Saara: I learn one new recipe each frost. The cove insists."
                ],
                [
                    "Saara: Frostbite cocoa needs cranberry and pine nut. I'll show you.",
                    "Saara: The trail by the forest edge bears mushrooms after a light snow.",
                    "Saara: I traded a tincture for one of Olaf's old verses last frost. Worth it.",
                    "Saara: Mira gives me daisies. In winter. Where does she find them?",
                    "Saara: Helga keeps my recipes safe. They live in her cellar."
                ],
                [
                    "Saara: Try whitefish pâté for guests. They never refuse it.",
                    "Saara: I'll teach you the Mid-Frost bonfire brew — it warms the bones for two days.",
                    "Saara: My grandmother's almanac sleeps in your bookshelf. Treat its pages gently.",
                    "Saara: When the lake mists, the lichen blooms blue. Save a sprig for me.",
                    "Saara: Anneli paints my jars. Better art than any gallery in the south."
                ],
                [
                    "Saara: I'll write you the Almanac Cake recipe. It's only baked on Day 30.",
                    "Saara: There's a kind of mead that remembers the year. Helga and I made one for you.",
                    "Saara: Don't fear the Cape. Fear the silence afterward.",
                    "Saara: When you complete the Almanac, plant cranberry. Promise.",
                    "Saara: The cove keeps its herbalists honest. You're keeping me honest."
                ]
            ],
            loreCards: [
                "Saara's herb-box behind the cabin survived three frosts buried under snow with no losses.",
                "Saara records every guest's first illness in a leatherbook called the 'Cough Log.'",
                "Saara distills birch sap each year on the morning of the First Snow Feast.",
                "Saara's lichen brew has been called both medicine and warning by Olaf in the same week."
            ]
        ),
        FrostlakeNPC(
            id: 3,
            name: "Olaf",
            role: "Lore Keeper",
            bio: "An old voice on a colder bench — he carries every fish's name in his head.",
            schedule: ["Inn", "Bench by Lake", "Bench by Lake", "Inn", "Inn", "Inn"],
            dialogueTiers: [
                [
                    "Olaf: Sit. Don't speak for a moment. Listen to the ice settle.",
                    "Olaf: I knew your cabin's last keeper. Same hat. Different boots.",
                    "Olaf: There are twenty-two names below this lake. I'll teach you one a week.",
                    "Olaf: My bench is older than the inn. It's all the same wood.",
                    "Olaf: A still lake means a busy one underneath."
                ],
                [
                    "Olaf: Roach feeds the perch. Perch feeds the pike. Pike feeds the song.",
                    "Olaf: I knew a man who counted only burbots. He drowned content.",
                    "Olaf: Whitefish remember their mothers. Salmon do not. Or so the song claims.",
                    "Olaf: Trout swim where the cold meets the warm. Late Frost is their hour.",
                    "Olaf: There is a Moonwhite. There is also a question about whether it can be caught."
                ],
                [
                    "Olaf: Ask me of the Cape. I'll tell, when you can carry the telling.",
                    "Olaf: Day 24 — the Vigil. Bring a steel knife and an empty notebook.",
                    "Olaf: I lost an apprentice to the Cape in my middle frosts. He came back. He didn't speak the same after.",
                    "Olaf: Anneli paints me. I sit so still she thinks I'm dead. I am not.",
                    "Olaf: The Almanac doesn't end. It loops. You'll see, by Day 30."
                ],
                [
                    "Olaf: I'll teach you the Moonwhite song. Sing it at Dusk. The lake answers.",
                    "Olaf: When I'm gone, my bench is yours. Not to sit on — to tend.",
                    "Olaf: The Almanac you fill is a copy. The original sleeps in Helga's cellar.",
                    "Olaf: You're cove. The lake said so, the bench said so, my old knee said so.",
                    "Olaf: Thank you for listening. So few do, before they leave."
                ]
            ],
            loreCards: [
                "Olaf was the cove's pier-builder for forty years before his knee gave out at the start of a Mid Frost.",
                "Olaf has named every fish in the lake — including ones nobody else has seen.",
                "Olaf's bench was built from the keel of a boat that froze in place in the year of the long winter.",
                "Olaf hums the Moonwhite song so quietly that only the lake can hear the second verse."
            ]
        ),
        FrostlakeNPC(
            id: 4,
            name: "Mira",
            role: "Errand Runner",
            bio: "A child who knows the cove better than most adults; trades errands for treats.",
            schedule: ["Cabin Yard", "Market", "Market", "Market", "Inn", "Inn"],
            dialogueTiers: [
                [
                    "Mira: Are you the writer? Helga said you might be.",
                    "Mira: I can carry letters. I am very fast. Watch.",
                    "Mira: The forge smells like burnt bread. Don't tell Toivo.",
                    "Mira: I draw maps. Mine is better than the real one.",
                    "Mira: Bring me a cookie and I'll tell you a secret place."
                ],
                [
                    "Mira: I saw a fox by the trail. He looked at me like he knew my name.",
                    "Mira: I trade Saara daisies for honey. I think she likes the trade.",
                    "Mira: The Lantern Lighting is my favorite night. I get to hold one.",
                    "Mira: Anneli paints me, but only my back. She says my face is too quick.",
                    "Mira: I know which day Ren comes. Want to know?"
                ],
                [
                    "Mira: I left a pebble on your windowsill. Don't move it. It's holding a wish.",
                    "Mira: Olaf tells me about the Moonwhite. I think he's a little scared of it.",
                    "Mira: I want to be like you. With a cabin. And a book.",
                    "Mira: Helga said I could ring the iron bell when you finish the Almanac.",
                    "Mira: I drew the cove for you. I left it under your diary."
                ],
                [
                    "Mira: Promise me you'll stay for next frost. Even one day after.",
                    "Mira: I will be the next keeper of the cove's letters. Helga said.",
                    "Mira: When you sleep, the cove dreams it's alive. I dream it too.",
                    "Mira: You're my favorite. I'm not supposed to say that out loud.",
                    "Mira: I want to learn the Moonwhite song. Will you teach me?"
                ]
            ],
            loreCards: [
                "Mira's mother runs the cove's post hut, two ridges over; Mira is the only courier in winter.",
                "Mira has memorised every door in Frostlake and which ones never close.",
                "Mira keeps a 'good days' jar full of pebbles from the lake's edge.",
                "Mira has predicted the first snowfall of three seasons running — though she insists she just listens."
            ]
        ),
        FrostlakeNPC(
            id: 5,
            name: "Toivo",
            role: "Blacksmith",
            bio: "Gruff hands, dry humor; he forges augers, locks, and patience.",
            schedule: ["Forge", "Forge", "Forge", "Forge", "Forge", "Inn"],
            dialogueTiers: [
                [
                    "Toivo: Your auger is junk. I won't ask where you got it.",
                    "Toivo: New gear means new respect from the lake. Old gear means old habits.",
                    "Toivo: The forge runs cold today. I'll set a longer kindling.",
                    "Toivo: If you want a tool, bring me iron and bread. Both.",
                    "Toivo: My door is open until Dusk. Try not to need me at Evening."
                ],
                [
                    "Toivo: I built Olaf's bench, you know. He hasn't paid me yet.",
                    "Toivo: A line is just iron pretending to be patient.",
                    "Toivo: Saara trades me herb oil for kindling. Best deal in the cove.",
                    "Toivo: I'll size you a new auger when you can afford it.",
                    "Toivo: When Mira visits, the fire behaves. Don't ask me why."
                ],
                [
                    "Toivo: I can upgrade your cabin's stove. Cuts firewood by a third.",
                    "Toivo: My grandfather's hammer is on your wall. Or it will be, soon.",
                    "Toivo: A skilled blade pays back in three winters. Yours will, too.",
                    "Toivo: I forged Eero's first auger. He still owes me three pints.",
                    "Toivo: Bring me a Lake Trout's scale. I'll make you a clasp."
                ],
                [
                    "Toivo: I'll build you the Cape auger. Costs me three days. Worth it for you.",
                    "Toivo: The cove keeps a smith, always. When I'm done, it'll be Mira's mother.",
                    "Toivo: I keep your storeroom up. You keep my fire honest. Deal.",
                    "Toivo: There's a forge song. Helga knows it. Ask her.",
                    "Toivo: You stay through Day 30. Don't leave on Day 31. I'm asking."
                ]
            ],
            loreCards: [
                "Toivo's forge has never gone fully cold since his father lit it forty-two years ago.",
                "Toivo carves a tally on his hammer for every auger he's repaired — currently at ninety-three.",
                "Toivo barters work for stories; he prefers Olaf's tale of the long winter over coin.",
                "Toivo built the iron bell that hangs in Helga's inn — it rings once for every completed almanac."
            ]
        ),
        FrostlakeNPC(
            id: 6,
            name: "Anneli",
            role: "Quiet Artist",
            bio: "She paints almanac pages with mineral inks and an empty afternoon.",
            schedule: ["Forest Edge", "Forest Edge", "Forest Edge", "Cabin", "Cabin", "Cabin"],
            dialogueTiers: [
                [
                    "Anneli: ...",
                    "Anneli: Move slightly to the left. The light is kinder there.",
                    "Anneli: I do not need the colors. I need the cold.",
                    "Anneli: Hold still. Two minutes.",
                    "Anneli: I will leave a fish sketch on your table. Don't fold it."
                ],
                [
                    "Anneli: Salmon roe is the hardest red. I mix it with cranberry.",
                    "Anneli: My ink dries in three breaths. Three exactly.",
                    "Anneli: Olaf sat for me twice. The second time he was already gone, in spirit.",
                    "Anneli: I'll paint your cabin if you bring me white. Real white, not snow.",
                    "Anneli: Saara grinds my pigments. We talk in silences."
                ],
                [
                    "Anneli: There is a color in the Mid-Lake Crack. I have not yet captured it.",
                    "Anneli: I will sketch every fish you bring me. You will fill the Almanac.",
                    "Anneli: The bonfire on Day 18 — I make a study of the embers each year.",
                    "Anneli: I dream in two colors. Teal and ember. Same as the cove.",
                    "Anneli: I lost a brush in the lake. It came back wet. Then dry. Then ink."
                ],
                [
                    "Anneli: I'll paint your Almanac's frontispiece. The fox watches us as I do.",
                    "Anneli: Stay. The Cape needs a witness. I am not enough alone.",
                    "Anneli: There is a self-portrait I made of you. I burned it last frost. Then re-painted it.",
                    "Anneli: When you finish the Almanac, I will sign each page.",
                    "Anneli: You are cove. I painted you that color this morning."
                ]
            ],
            loreCards: [
                "Anneli's paintings line the inn's walls, each labelled with a date and a single weather word.",
                "Anneli once spent an entire Late Frost painting the same patch of ice every Dusk.",
                "Anneli sketches every newcomer to the cove twice — once on arrival, once on departure.",
                "Anneli's mineral pigments are gathered from the riverbed below the Forbidden Cape."
            ]
        ),
        FrostlakeNPC(
            id: 7,
            name: "Ren",
            role: "Wandering Trader",
            bio: "Three visits a season, three boxes of curiosities, never the same twice.",
            schedule: ["Market", "Market", "Market", "Market", "Market", "Market"],
            dialogueTiers: [
                [
                    "Ren: One look, no touch. Touch is two coins.",
                    "Ren: I come on the fives. Day five, fifteen, twenty-five.",
                    "Ren: I bring what the cove does not. That is my entire trade.",
                    "Ren: My prices are not negotiable. My stories are.",
                    "Ren: I will be gone before Dusk. Hurry."
                ],
                [
                    "Ren: A scroll for Mead. A scroll for Lichen Soup. A scroll for keeping warm.",
                    "Ren: The Mid-Frost gathering brings my best stock. Come early.",
                    "Ren: I traded with Helga last year for nothing but stories. She got the better deal.",
                    "Ren: This auger? Made by a cousin of Toivo. Better. Quieter. More expensive.",
                    "Ren: My carriage's wheels need ice. The cove provides."
                ],
                [
                    "Ren: A rare lure, for you alone. Show no one but Eero.",
                    "Ren: Tell Olaf the river still flows under the Cape. He will know.",
                    "Ren: I'll save you a scroll on Day 25. Promise.",
                    "Ren: The Moonwhite — only one man I know has caught one. He stopped speaking after.",
                    "Ren: I do not stay. I do not leave. I visit. Remember the difference."
                ],
                [
                    "Ren: This is the last visit before you finish the Almanac. Pick wisely.",
                    "Ren: I traded a story for a story with you. We are even now.",
                    "Ren: The cove keeps me on its map. I do not always keep it on mine.",
                    "Ren: When the Almanac rings the iron bell, I hear it from three valleys.",
                    "Ren: You are cove. Even when I leave."
                ]
            ],
            loreCards: [
                "Ren's true name is unknown; the cove uses 'Ren' because it is one syllable, like a knock.",
                "Ren's first visit each season is always paid for in salt; the second in cinnamon; the third in bread.",
                "Ren's cart carries scrolls written in seven hands, none of which match Ren's own.",
                "Ren has visited Frostlake for at least thirty-three frosts; no one is certain when the count began."
            ]
        )
    ]
}

// MARK: - Lake spots
struct FrostlakeLakeSpot: Identifiable, Hashable {
    let id: Int
    let name: String
    let unlockDay: Int
    let description: String
}

enum FrostlakeLakeSpotData {
    static let all: [FrostlakeLakeSpot] = [
        FrostlakeLakeSpot(id: 0, name: "Old Hole", unlockDay: 1,
                         description: "Reliable, low yields — good for daily roach and perch."),
        FrostlakeLakeSpot(id: 1, name: "Stone Pier", unlockDay: 4,
                         description: "Parallel-line bonus; mid-species pull stronger near Noon."),
        FrostlakeLakeSpot(id: 2, name: "Mid-Lake Crack", unlockDay: 11,
                         description: "Rare species favor this seam; needs Toivo's auger upgrade."),
        FrostlakeLakeSpot(id: 3, name: "Forbidden Cape", unlockDay: 18,
                         description: "Night-only; legendary species haunt the Late-Frost dusk.")
    ]
}

// MARK: - Fish
struct FrostlakeFish: Identifiable, Hashable {
    let id: Int
    let name: String
    let rarity: Int // 0 common, 1 mid, 2 rare, 3 legendary
    let availablePhases: Set<Int>   // 0,1,2
    let availableSpots: Set<Int>    // 0-3
    let availableBlocks: Set<Int>   // 0-5
    let allowedWeather: Set<Int>?   // nil = any
    let lore: String
}

enum FrostlakeFishData {
    static let all: [FrostlakeFish] = [
        // commons (rarity 0): Day 1+, Old Hole + others
        FrostlakeFish(id: 0, name: "Roach", rarity: 0,
                     availablePhases: [0,1,2], availableSpots: [0,1], availableBlocks: [0,1,2,3,4,5],
                     allowedWeather: nil,
                     lore: "Common silver roach; the cove's first lesson in patience."),
        FrostlakeFish(id: 1, name: "Perch", rarity: 0,
                     availablePhases: [0,1,2], availableSpots: [0,1,2], availableBlocks: [1,2,3,4],
                     allowedWeather: nil,
                     lore: "Striped perch — quick to bite, slow to learn."),
        FrostlakeFish(id: 2, name: "Ruffe", rarity: 0,
                     availablePhases: [0,1,2], availableSpots: [0,1], availableBlocks: [0,1,2,3],
                     allowedWeather: nil,
                     lore: "Bristly small ruffe; bait stealer if you are inattentive."),
        FrostlakeFish(id: 3, name: "Smelt", rarity: 0,
                     availablePhases: [0,1,2], availableSpots: [0,1], availableBlocks: [0,5],
                     allowedWeather: nil,
                     lore: "Smelt run in cold dusks; smell of cucumber on the line."),
        FrostlakeFish(id: 4, name: "Bleak", rarity: 0,
                     availablePhases: [0,1], availableSpots: [0,1], availableBlocks: [1,2,3],
                     allowedWeather: nil,
                     lore: "Surface-bright bleak; useful for bait swaps."),
        // mid (rarity 1): Day 4+, Stone Pier and others
        FrostlakeFish(id: 5, name: "Pike", rarity: 1,
                     availablePhases: [0,1,2], availableSpots: [0,1,2], availableBlocks: [2,3,4],
                     allowedWeather: nil,
                     lore: "Long pike — every cove's daily villain and hero."),
        FrostlakeFish(id: 6, name: "Zander", rarity: 1,
                     availablePhases: [0,1,2], availableSpots: [1,2], availableBlocks: [3,4,5],
                     allowedWeather: nil,
                     lore: "Pale-eyed zander; favors the dusk and the deeper line."),
        FrostlakeFish(id: 7, name: "Bream", rarity: 1,
                     availablePhases: [0,1], availableSpots: [0,1], availableBlocks: [1,2,3],
                     allowedWeather: nil,
                     lore: "Wide-flank bream; the cove's measuring stick for skill."),
        FrostlakeFish(id: 8, name: "Whitefish", rarity: 1,
                     availablePhases: [0,1,2], availableSpots: [1,2], availableBlocks: [2,3],
                     allowedWeather: nil,
                     lore: "Sleek whitefish; remembers what bait worked last winter."),
        FrostlakeFish(id: 9, name: "Burbot", rarity: 1,
                     availablePhases: [1,2], availableSpots: [1,2], availableBlocks: [4,5],
                     allowedWeather: nil,
                     lore: "Bottom-feeding burbot; surfaces only when the ice creaks."),
        FrostlakeFish(id: 10, name: "Grayling", rarity: 1,
                     availablePhases: [0,1], availableSpots: [1,2], availableBlocks: [1,2,3],
                     allowedWeather: nil,
                     lore: "Sail-finned grayling; favors clear water and clear minds."),
        FrostlakeFish(id: 11, name: "Crucian", rarity: 1,
                     availablePhases: [0,1], availableSpots: [0,1], availableBlocks: [1,2,3,4],
                     allowedWeather: nil,
                     lore: "Crucian carp; if it bites, the cove is in a forgiving mood."),
        FrostlakeFish(id: 12, name: "Tench", rarity: 1,
                     availablePhases: [0,1], availableSpots: [0,1], availableBlocks: [2,3,4],
                     allowedWeather: nil,
                     lore: "Olive-flank tench; called 'doctor fish' by Saara, half-joking."),
        FrostlakeFish(id: 13, name: "Pikeperch", rarity: 1,
                     availablePhases: [1,2], availableSpots: [1,2], availableBlocks: [3,4],
                     allowedWeather: nil,
                     lore: "Pikeperch — Eero says it bites like a question."),
        // rare (rarity 2): Day 11+, Mid-Lake Crack and beyond
        FrostlakeFish(id: 14, name: "Trout", rarity: 2,
                     availablePhases: [1,2], availableSpots: [2], availableBlocks: [2,3,4],
                     allowedWeather: [0,1],
                     lore: "Dappled trout from the lake's middle vein."),
        FrostlakeFish(id: 15, name: "Salmon", rarity: 2,
                     availablePhases: [1,2], availableSpots: [2], availableBlocks: [3,4],
                     allowedWeather: [0,1,3],
                     lore: "A migrating salmon, off-route in winter — a gift."),
        FrostlakeFish(id: 16, name: "Char", rarity: 2,
                     availablePhases: [1,2], availableSpots: [2,3], availableBlocks: [3,4,5],
                     allowedWeather: nil,
                     lore: "Bright-bellied char — visible only when the cove holds its breath."),
        FrostlakeFish(id: 17, name: "Eelpout", rarity: 2,
                     availablePhases: [1,2], availableSpots: [2,3], availableBlocks: [4,5],
                     allowedWeather: nil,
                     lore: "Long, dark eelpout; surfaces near cracks under the deep ice."),
        FrostlakeFish(id: 18, name: "Northern Pike", rarity: 2,
                     availablePhases: [1,2], availableSpots: [2,3], availableBlocks: [3,4],
                     allowedWeather: nil,
                     lore: "Old, scarred pike; the lake's measuring rod against the years."),
        // legendary (rarity 3): Late Frost + Forbidden Cape + Dusk/Evening + specific weather
        FrostlakeFish(id: 19, name: "Lake Trout", rarity: 3,
                     availablePhases: [2], availableSpots: [3], availableBlocks: [4,5],
                     allowedWeather: [0,4],
                     lore: "Spirit-grey lake trout; only patrols the Cape after Day 21."),
        FrostlakeFish(id: 20, name: "Frost Char", rarity: 3,
                     availablePhases: [2], availableSpots: [3], availableBlocks: [4,5],
                     allowedWeather: [1,4],
                     lore: "Frost char; ice-shimmered scales, only on misty cape nights."),
        FrostlakeFish(id: 21, name: "Moonwhite", rarity: 3,
                     availablePhases: [2], availableSpots: [3], availableBlocks: [4,5],
                     allowedWeather: [0,4],
                     lore: "The Moonwhite. Olaf will not say its second name aloud."),
    ]
}

// MARK: - Foraged finds
struct FrostlakeForagedFind: Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
}

enum FrostlakeForagedData {
    static let all: [FrostlakeForagedFind] = [
        FrostlakeForagedFind(id: 0, name: "Bracket Mushroom",
                            description: "Hardy bracket; useful in jerky."),
        FrostlakeForagedFind(id: 1, name: "Pine Resin",
                            description: "Glossy pine resin; Eero's bait component."),
        FrostlakeForagedFind(id: 2, name: "Cranberries",
                            description: "Sour cranberries from the wind-shielded thicket."),
        FrostlakeForagedFind(id: 3, name: "Birch Bark",
                            description: "Slender birch bark; fire-starter and tea."),
        FrostlakeForagedFind(id: 4, name: "Mineral Pigment",
                            description: "Anneli's red ochre, riverbed-gathered."),
        FrostlakeForagedFind(id: 5, name: "Lichen Sprig",
                            description: "Blue-tinged lichen; only after a misted lake."),
        FrostlakeForagedFind(id: 6, name: "Iron Nail",
                            description: "An iron nail from the old pier's third row."),
        FrostlakeForagedFind(id: 7, name: "Glass Bead",
                            description: "Tiny green glass bead from the festival path."),
        FrostlakeForagedFind(id: 8, name: "Goose Feather",
                            description: "Bright white goose feather, quill-quality."),
        FrostlakeForagedFind(id: 9, name: "Smooth Stone",
                            description: "A perfectly smooth lake stone, oddly warm."),
        FrostlakeForagedFind(id: 10, name: "Lost Charm",
                            description: "A child's metal charm; Mira knows its story."),
        FrostlakeForagedFind(id: 11, name: "Old Coin",
                            description: "A worn coin stamped with an unfamiliar mark.")
    ]
}

// MARK: - Recipes
struct FrostlakeRecipe: Identifiable, Hashable {
    let id: Int
    let name: String
    // ingredient requirements: keys are "fish:<id>", "find:<id>", "shop:<key>"
    let ingredients: [String: Int]
    let buffLabel: String
    let buffKey: String
    let buffDays: Int
}

enum FrostlakeRecipeData {
    static let all: [FrostlakeRecipe] = [
        FrostlakeRecipe(id: 0, name: "Pike Stew",
                       ingredients: ["fish:5":1, "shop:butter":1, "find:3":1],
                       buffLabel: "Warmth — fatigue -1 next day", buffKey: "fatigue", buffDays: 1),
        FrostlakeRecipe(id: 1, name: "Smoked Roach Skewer",
                       ingredients: ["fish:0":2, "find:1":1],
                       buffLabel: "Steady hands — bite window +5% today", buffKey: "bite", buffDays: 1),
        FrostlakeRecipe(id: 2, name: "Bream Pie",
                       ingredients: ["fish:7":1, "shop:flour":1, "shop:butter":1],
                       buffLabel: "Guest favor — NPC gift slot +1", buffKey: "gift", buffDays: 1),
        FrostlakeRecipe(id: 3, name: "Trout Broth",
                       ingredients: ["fish:14":1, "find:0":1],
                       buffLabel: "Clear sight — rare bite +10% today", buffKey: "rare", buffDays: 1),
        FrostlakeRecipe(id: 4, name: "Salmon Roe Bowl",
                       ingredients: ["fish:15":1, "shop:rice":1],
                       buffLabel: "Festival energy — coin reward +20% today", buffKey: "coin", buffDays: 1),
        FrostlakeRecipe(id: 5, name: "Burbot Soup",
                       ingredients: ["fish:9":1, "shop:butter":1, "find:5":1],
                       buffLabel: "Deep nerve — Cape access fatigue -1", buffKey: "fatigue", buffDays: 1),
        FrostlakeRecipe(id: 6, name: "Pickled Perch",
                       ingredients: ["fish:1":3, "shop:vinegar":1],
                       buffLabel: "Storage gift — sell prices +10% today", buffKey: "sell", buffDays: 1),
        FrostlakeRecipe(id: 7, name: "Charcoal Char",
                       ingredients: ["fish:16":1, "find:3":1],
                       buffLabel: "Ash craft — bite window +8% today", buffKey: "bite", buffDays: 1),
        FrostlakeRecipe(id: 8, name: "Ruffe Cracker",
                       ingredients: ["fish:2":2, "shop:flour":1],
                       buffLabel: "Quick snack — fatigue -0.5 next day", buffKey: "fatigue", buffDays: 1),
        FrostlakeRecipe(id: 9, name: "Whitefish Pâté",
                       ingredients: ["fish:8":1, "shop:butter":1, "find:8":1],
                       buffLabel: "Civic gift — relationship +1 chance bonus today", buffKey: "rel", buffDays: 1),
        FrostlakeRecipe(id: 10, name: "Frostbite Cocoa",
                       ingredients: ["find:2":2, "shop:cocoa":1],
                       buffLabel: "Hearth — fatigue -1 today", buffKey: "fatigue", buffDays: 1),
        FrostlakeRecipe(id: 11, name: "Birch Tea",
                       ingredients: ["find:3":2],
                       buffLabel: "Calm — bite window +3% for two days", buffKey: "bite", buffDays: 2),
        FrostlakeRecipe(id: 12, name: "Pine Nut Bread",
                       ingredients: ["shop:flour":2, "find:1":1],
                       buffLabel: "Travel ration — Cape stamina +1", buffKey: "fatigue", buffDays: 1),
        FrostlakeRecipe(id: 13, name: "Mushroom Jerky",
                       ingredients: ["find:0":3, "shop:salt":1],
                       buffLabel: "Wayfarer snack — fatigue -0.5 for two days", buffKey: "fatigue", buffDays: 2),
        FrostlakeRecipe(id: 14, name: "Cranberry Jam",
                       ingredients: ["find:2":3, "shop:sugar":1],
                       buffLabel: "Sweet gift — NPC tier-up bonus +5% today", buffKey: "rel", buffDays: 1),
        FrostlakeRecipe(id: 15, name: "Mead",
                       ingredients: ["shop:honey":2, "find:3":1],
                       buffLabel: "Inn cheer — coin reward +15% today", buffKey: "coin", buffDays: 1),
        FrostlakeRecipe(id: 16, name: "Lichen Soup",
                       ingredients: ["find:5":2, "shop:butter":1],
                       buffLabel: "Mistwarden — rare bite +8% today", buffKey: "rare", buffDays: 1),
        FrostlakeRecipe(id: 17, name: "Almanac Cake",
                       ingredients: ["shop:flour":2, "shop:sugar":2, "find:2":2],
                       buffLabel: "Day 30 only — Season grade +1", buffKey: "grade", buffDays: 1)
    ]
}

// MARK: - Shop
struct FrostlakeShopItem: Identifiable, Hashable {
    let id: String
    let label: String
    let basePrice: Int
    let kind: String  // "bait" / "ingredient" / "scroll" / "gear" / "decor"
}

enum FrostlakeShopData {
    static let all: [FrostlakeShopItem] = [
        FrostlakeShopItem(id: "bait_basic", label: "Basic Bait", basePrice: 5, kind: "bait"),
        FrostlakeShopItem(id: "bait_rich", label: "Rich Bait", basePrice: 12, kind: "bait"),
        FrostlakeShopItem(id: "line_thin", label: "Thin Line", basePrice: 18, kind: "gear"),
        FrostlakeShopItem(id: "line_braid", label: "Braided Line", basePrice: 30, kind: "gear"),
        FrostlakeShopItem(id: "lure_silver", label: "Silver Lure", basePrice: 22, kind: "gear"),
        FrostlakeShopItem(id: "lure_ember", label: "Ember Lure", basePrice: 36, kind: "gear"),
        FrostlakeShopItem(id: "shop:butter", label: "Butter", basePrice: 6, kind: "ingredient"),
        FrostlakeShopItem(id: "shop:flour", label: "Flour", basePrice: 4, kind: "ingredient"),
        FrostlakeShopItem(id: "shop:rice", label: "Rice", basePrice: 7, kind: "ingredient"),
        FrostlakeShopItem(id: "shop:cocoa", label: "Cocoa", basePrice: 8, kind: "ingredient"),
        FrostlakeShopItem(id: "shop:salt", label: "Salt", basePrice: 3, kind: "ingredient"),
        FrostlakeShopItem(id: "shop:sugar", label: "Sugar", basePrice: 5, kind: "ingredient"),
        FrostlakeShopItem(id: "shop:honey", label: "Honey", basePrice: 9, kind: "ingredient"),
        FrostlakeShopItem(id: "shop:vinegar", label: "Vinegar", basePrice: 5, kind: "ingredient"),
        FrostlakeShopItem(id: "scroll_recipe", label: "Recipe Scroll", basePrice: 28, kind: "scroll"),
        FrostlakeShopItem(id: "decor_lantern", label: "Cabin Lantern", basePrice: 40, kind: "decor"),
        FrostlakeShopItem(id: "decor_rug", label: "Wool Rug", basePrice: 35, kind: "decor"),
        FrostlakeShopItem(id: "decor_clock", label: "Pine Clock", basePrice: 55, kind: "decor"),
    ]

    static let dailyRotationSize = 7
}

// MARK: - Home rooms
struct FrostlakeRoom: Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
}

enum FrostlakeRoomData {
    static let all: [FrostlakeRoom] = [
        FrostlakeRoom(id: 0, name: "Kitchen", description: "Tier-up boosts cooked-buff duration."),
        FrostlakeRoom(id: 1, name: "Stove", description: "Tier-up reduces nightly firewood by 20%."),
        FrostlakeRoom(id: 2, name: "Bookshelf", description: "Tier-up unlocks one extra lore card per NPC tier."),
        FrostlakeRoom(id: 3, name: "Storeroom", description: "Tier-up raises inventory cap.")
    ]

    static func upgradeCost(roomId: Int, tier: Int) -> Int {
        // tier is current tier being upgraded from (0..3)
        let base = (tier + 1) * 25
        let roomMod = [1, 1, 2, 1][roomId]
        return base * roomMod
    }
}

// MARK: - Festivals
struct FrostlakeFestival: Identifiable, Hashable {
    let id: Int
    let day: Int
    let timeBlock: Int
    let location: String
    let name: String
    let description: String
}

enum FrostlakeFestivalData {
    static let all: [FrostlakeFestival] = [
        FrostlakeFestival(id: 0, day: 3, timeBlock: 5, location: "Inn",
                         name: "Lantern Lighting",
                         description: "Lanterns hang from every porch; +small reputation with all villagers."),
        FrostlakeFestival(id: 1, day: 7, timeBlock: 2, location: "Market",
                         name: "First Snow Feast",
                         description: "A cooking contest. Bring a recipe to win extra coin."),
        FrostlakeFestival(id: 2, day: 12, timeBlock: 1, location: "Pier",
                         name: "Auger Fair",
                         description: "Toivo discounts gear; better lines and lures all day."),
        FrostlakeFestival(id: 3, day: 18, timeBlock: 4, location: "Forest Edge",
                         name: "Mid-Frost Bonfire",
                         description: "Foraging bonus all night; Saara hands out warm cups."),
        FrostlakeFestival(id: 4, day: 24, timeBlock: 4, location: "Mid-Lake Crack",
                         name: "Ice Crack Vigil",
                         description: "A silent watch; legendary fish may surface."),
        FrostlakeFestival(id: 5, day: 30, timeBlock: 5, location: "Inn",
                         name: "Almanac Ceremony",
                         description: "Frostlake rings the iron bell for every completed almanac."),
    ]
}

// MARK: - Diary entry
struct FrostlakeDiaryEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let day: Int
    let timeBlock: Int
    let title: String
    let body: String
    let kind: String   // "milestone" / "manual" / "festival" / "tier"
}

// MARK: - Game state (persisted)
struct FrostlakeGameState: Codable {
    var day: Int
    var timeBlock: Int
    var phase: Int
    var weatherToday: Int
    var fatigue: Double
    var coins: Int
    var inventoryFish: [Int: Int]
    var inventoryFinds: [Int: Int]
    var inventoryGear: [String: Int]
    var inventoryIngredients: [String: Int]
    var npcRelationship: [Int]      // length 8, 0..40
    var homeTiers: [Int]            // length 4, 0..4
    var unlockedSpots: Set<Int>
    var unlockedRecipes: Set<Int>
    var almanacSpecies: Set<Int>
    var almanacFinds: Set<Int>
    var almanacFestivals: Set<Int>
    var almanacNPCTiers: [Int: Int] // npcId -> highest tier reached
    var festivalsAttended: Set<Int>
    var firstCaughtDate: [Int: Int] // fishId -> day
    var diaryEntries: [FrostlakeDiaryEntry]
    var seasonsCompleted: Int
    var bestSeasonGrade: Int        // 0..3 (C/B/A/S)
    var onboardingSeen: Bool
    var soundOn: Bool
    var hapticsOn: Bool
    var dailyShopSeed: Int
    var dailyShopItems: [String]
    var buffsActiveKey: String?
    var buffsDaysRemaining: Int
    var weatherForecast: [Int]      // per-day forecast for 30 days
    var seasonStartedTimestamp: Date
    // Per-day counter for gift actions (reset at sleep).
    // Default 0 for back-compat with older saves; decoded leniently.
    var giftsGivenToday: Int

    private enum CodingKeys: String, CodingKey {
        case day, timeBlock, phase, weatherToday, fatigue, coins
        case inventoryFish, inventoryFinds, inventoryGear, inventoryIngredients
        case npcRelationship, homeTiers, unlockedSpots, unlockedRecipes
        case almanacSpecies, almanacFinds, almanacFestivals, almanacNPCTiers
        case festivalsAttended, firstCaughtDate, diaryEntries
        case seasonsCompleted, bestSeasonGrade
        case onboardingSeen, soundOn, hapticsOn
        case dailyShopSeed, dailyShopItems
        case buffsActiveKey, buffsDaysRemaining
        case weatherForecast, seasonStartedTimestamp
        case giftsGivenToday
    }

    // Backwards-compatible decode: missing keys (e.g., giftsGivenToday from older saves)
    // fall back to a sensible default rather than failing the decode.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        day = try c.decode(Int.self, forKey: .day)
        timeBlock = try c.decode(Int.self, forKey: .timeBlock)
        phase = try c.decode(Int.self, forKey: .phase)
        weatherToday = try c.decode(Int.self, forKey: .weatherToday)
        fatigue = try c.decode(Double.self, forKey: .fatigue)
        coins = try c.decode(Int.self, forKey: .coins)
        inventoryFish = try c.decode([Int: Int].self, forKey: .inventoryFish)
        inventoryFinds = try c.decode([Int: Int].self, forKey: .inventoryFinds)
        inventoryGear = try c.decode([String: Int].self, forKey: .inventoryGear)
        inventoryIngredients = try c.decode([String: Int].self, forKey: .inventoryIngredients)
        npcRelationship = try c.decode([Int].self, forKey: .npcRelationship)
        homeTiers = try c.decode([Int].self, forKey: .homeTiers)
        unlockedSpots = try c.decode(Set<Int>.self, forKey: .unlockedSpots)
        unlockedRecipes = try c.decode(Set<Int>.self, forKey: .unlockedRecipes)
        almanacSpecies = try c.decode(Set<Int>.self, forKey: .almanacSpecies)
        almanacFinds = try c.decode(Set<Int>.self, forKey: .almanacFinds)
        almanacFestivals = try c.decode(Set<Int>.self, forKey: .almanacFestivals)
        almanacNPCTiers = try c.decode([Int: Int].self, forKey: .almanacNPCTiers)
        festivalsAttended = try c.decode(Set<Int>.self, forKey: .festivalsAttended)
        firstCaughtDate = try c.decode([Int: Int].self, forKey: .firstCaughtDate)
        diaryEntries = try c.decode([FrostlakeDiaryEntry].self, forKey: .diaryEntries)
        seasonsCompleted = try c.decode(Int.self, forKey: .seasonsCompleted)
        bestSeasonGrade = try c.decode(Int.self, forKey: .bestSeasonGrade)
        onboardingSeen = try c.decode(Bool.self, forKey: .onboardingSeen)
        soundOn = try c.decode(Bool.self, forKey: .soundOn)
        hapticsOn = try c.decode(Bool.self, forKey: .hapticsOn)
        dailyShopSeed = try c.decode(Int.self, forKey: .dailyShopSeed)
        dailyShopItems = try c.decode([String].self, forKey: .dailyShopItems)
        buffsActiveKey = try c.decodeIfPresent(String.self, forKey: .buffsActiveKey)
        buffsDaysRemaining = try c.decode(Int.self, forKey: .buffsDaysRemaining)
        weatherForecast = try c.decode([Int].self, forKey: .weatherForecast)
        seasonStartedTimestamp = try c.decode(Date.self, forKey: .seasonStartedTimestamp)
        giftsGivenToday = (try c.decodeIfPresent(Int.self, forKey: .giftsGivenToday)) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(day, forKey: .day)
        try c.encode(timeBlock, forKey: .timeBlock)
        try c.encode(phase, forKey: .phase)
        try c.encode(weatherToday, forKey: .weatherToday)
        try c.encode(fatigue, forKey: .fatigue)
        try c.encode(coins, forKey: .coins)
        try c.encode(inventoryFish, forKey: .inventoryFish)
        try c.encode(inventoryFinds, forKey: .inventoryFinds)
        try c.encode(inventoryGear, forKey: .inventoryGear)
        try c.encode(inventoryIngredients, forKey: .inventoryIngredients)
        try c.encode(npcRelationship, forKey: .npcRelationship)
        try c.encode(homeTiers, forKey: .homeTiers)
        try c.encode(unlockedSpots, forKey: .unlockedSpots)
        try c.encode(unlockedRecipes, forKey: .unlockedRecipes)
        try c.encode(almanacSpecies, forKey: .almanacSpecies)
        try c.encode(almanacFinds, forKey: .almanacFinds)
        try c.encode(almanacFestivals, forKey: .almanacFestivals)
        try c.encode(almanacNPCTiers, forKey: .almanacNPCTiers)
        try c.encode(festivalsAttended, forKey: .festivalsAttended)
        try c.encode(firstCaughtDate, forKey: .firstCaughtDate)
        try c.encode(diaryEntries, forKey: .diaryEntries)
        try c.encode(seasonsCompleted, forKey: .seasonsCompleted)
        try c.encode(bestSeasonGrade, forKey: .bestSeasonGrade)
        try c.encode(onboardingSeen, forKey: .onboardingSeen)
        try c.encode(soundOn, forKey: .soundOn)
        try c.encode(hapticsOn, forKey: .hapticsOn)
        try c.encode(dailyShopSeed, forKey: .dailyShopSeed)
        try c.encode(dailyShopItems, forKey: .dailyShopItems)
        try c.encodeIfPresent(buffsActiveKey, forKey: .buffsActiveKey)
        try c.encode(buffsDaysRemaining, forKey: .buffsDaysRemaining)
        try c.encode(weatherForecast, forKey: .weatherForecast)
        try c.encode(seasonStartedTimestamp, forKey: .seasonStartedTimestamp)
        try c.encode(giftsGivenToday, forKey: .giftsGivenToday)
    }

    // Memberwise-style init retained for freshState() and any future programmatic construction.
    init(
        day: Int, timeBlock: Int, phase: Int, weatherToday: Int, fatigue: Double, coins: Int,
        inventoryFish: [Int: Int], inventoryFinds: [Int: Int],
        inventoryGear: [String: Int], inventoryIngredients: [String: Int],
        npcRelationship: [Int], homeTiers: [Int],
        unlockedSpots: Set<Int>, unlockedRecipes: Set<Int>,
        almanacSpecies: Set<Int>, almanacFinds: Set<Int>, almanacFestivals: Set<Int>,
        almanacNPCTiers: [Int: Int], festivalsAttended: Set<Int>,
        firstCaughtDate: [Int: Int], diaryEntries: [FrostlakeDiaryEntry],
        seasonsCompleted: Int, bestSeasonGrade: Int,
        onboardingSeen: Bool, soundOn: Bool, hapticsOn: Bool,
        dailyShopSeed: Int, dailyShopItems: [String],
        buffsActiveKey: String?, buffsDaysRemaining: Int,
        weatherForecast: [Int], seasonStartedTimestamp: Date,
        giftsGivenToday: Int = 0
    ) {
        self.day = day; self.timeBlock = timeBlock; self.phase = phase
        self.weatherToday = weatherToday; self.fatigue = fatigue; self.coins = coins
        self.inventoryFish = inventoryFish; self.inventoryFinds = inventoryFinds
        self.inventoryGear = inventoryGear; self.inventoryIngredients = inventoryIngredients
        self.npcRelationship = npcRelationship; self.homeTiers = homeTiers
        self.unlockedSpots = unlockedSpots; self.unlockedRecipes = unlockedRecipes
        self.almanacSpecies = almanacSpecies; self.almanacFinds = almanacFinds
        self.almanacFestivals = almanacFestivals; self.almanacNPCTiers = almanacNPCTiers
        self.festivalsAttended = festivalsAttended; self.firstCaughtDate = firstCaughtDate
        self.diaryEntries = diaryEntries; self.seasonsCompleted = seasonsCompleted
        self.bestSeasonGrade = bestSeasonGrade
        self.onboardingSeen = onboardingSeen; self.soundOn = soundOn; self.hapticsOn = hapticsOn
        self.dailyShopSeed = dailyShopSeed; self.dailyShopItems = dailyShopItems
        self.buffsActiveKey = buffsActiveKey; self.buffsDaysRemaining = buffsDaysRemaining
        self.weatherForecast = weatherForecast
        self.seasonStartedTimestamp = seasonStartedTimestamp
        self.giftsGivenToday = giftsGivenToday
    }

    static func freshState() -> FrostlakeGameState {
        var rng = SystemRandomNumberGenerator()
        var forecast: [Int] = []
        for d in 1...30 {
            let phaseIdx: Int = (d - 1) / 10
            // weight per phase: Early favors clear; Mid favors snow; Late mixes
            let weights: [Int] = {
                switch phaseIdx {
                case 0: return [4, 3, 1, 2, 1]    // clear / light / heavy / wind / mist
                case 1: return [2, 3, 3, 2, 2]
                default: return [3, 2, 1, 2, 3]
                }
            }()
            forecast.append(FrostlakeGameState.weightedPick(weights, using: &rng))
        }
        let shopItems = FrostlakeGameState.computeShopRotation(seed: 1)
        return FrostlakeGameState(
            day: 1,
            timeBlock: 0,
            phase: 0,
            weatherToday: forecast.first ?? 0,
            fatigue: 0,
            coins: 80,
            inventoryFish: [:],
            inventoryFinds: [:],
            inventoryGear: ["bait_basic": 6, "line_thin": 1, "lure_silver": 1],
            inventoryIngredients: ["shop:butter": 2, "shop:flour": 2, "shop:salt": 2, "shop:sugar": 1],
            npcRelationship: Array(repeating: 0, count: 8),
            homeTiers: Array(repeating: 0, count: 4),
            unlockedSpots: [0],
            unlockedRecipes: [0, 1, 2, 8, 11, 10, 12, 17],
            almanacSpecies: [],
            almanacFinds: [],
            almanacFestivals: [],
            almanacNPCTiers: [:],
            festivalsAttended: [],
            firstCaughtDate: [:],
            diaryEntries: [],
            seasonsCompleted: 0,
            bestSeasonGrade: 0,
            onboardingSeen: false,
            soundOn: true,
            hapticsOn: true,
            dailyShopSeed: 1,
            dailyShopItems: shopItems,
            buffsActiveKey: nil,
            buffsDaysRemaining: 0,
            weatherForecast: forecast,
            seasonStartedTimestamp: Date(),
            giftsGivenToday: 0
        )
    }

    static func weightedPick(_ weights: [Int], using rng: inout SystemRandomNumberGenerator) -> Int {
        let total = max(1, weights.reduce(0, +))
        var n = Int.random(in: 0..<total, using: &rng)
        for (i, w) in weights.enumerated() {
            if n < w { return i }
            n -= w
        }
        return 0
    }

    static func computeShopRotation(seed: Int) -> [String] {
        var picked: [String] = []
        let items = FrostlakeShopData.all
        let total = items.count
        var s = seed
        for _ in 0..<FrostlakeShopData.dailyRotationSize {
            s = (s &* 1103515245 &+ 12345) & 0x7FFFFFFF
            let idx = s % total
            if !picked.contains(items[idx].id) {
                picked.append(items[idx].id)
            } else {
                // Linear probe: skip already-picked IDs. If all are taken, accept duplicate.
                var chosen: String = items[idx].id
                for offset in 1..<total {
                    let probeIdx = (idx + offset) % total
                    if !picked.contains(items[probeIdx].id) {
                        chosen = items[probeIdx].id
                        break
                    }
                }
                picked.append(chosen)
            }
        }
        return picked
    }
}
