-- chunkname: @/game_cyclopedia/utils.lua

ACHIEVEMENTS = {
	{
		points = 5,
		grade = 2,
		name = "Castlemania",
		description = "You have an eye for suspicious places and love to read other people's diaries, especially those with vampire stories in it. You're also a dedicated token collector and explorer. Respect!",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		description = "Lalalala... you now know the cult's hymn sung in Liberty Bay by heart. Not that hard, considering that it mainly consists of two notes and repetitive lyrics.",
		name = "Chorister"
	},
	{
		points = 2,
		grade = 1,
		description = "Who's the milkman? You are!",
		name = "The Milkman"
	},
	{
		points = 2,
		grade = 1,
		description = "You've always been a rebel - admit it! Supplying prisoners, caring for outcasts, stealing from the rich and giving to the poor - no wait, that was another story.",
		name = "Vive la Resistance"
	},
	{
		points = 4,
		grade = 2,
		description = "Simple hams and bread merely make you laugh. You're the master of the extra-ordinaire, melter of cheese, fryer of bat wings and shaker of shakes. Delicious!",
		name = "Culinary Master"
	},
	{
		points = 3,
		grade = 1,
		name = "Shell Seeker",
		description = "You found a hundred beautiful pearls in large sea shells. By now that necklace should be finished - and hopefully you didn't get your fingers squeezed too often during the process.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Backpack Tourist",
		description = "If someone lost a random thing in a random place, you're probably a good person to ask and go find it, even if you don't know what and where.",
		secret = true
	},
	{
		points = 8,
		grade = 3,
		name = "Dread Lord",
		description = "You don't care for rules that others set up and shape the world to your liking. Having left behind meaningless conventions and morals, you prize only the power you wield. You're a master of your fate and battle to cleanse the world.",
		secret = true
	},
	{
		points = 8,
		grade = 3,
		name = "Lord Protector",
		description = "You proved yourself - not only in your dreams - and possess a strong and spiritual mind. Your valorous fight against demons and the undead plague has granted you the highest and most respected rank among the Nightmare Knights.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		description = "You follow the path of dreams and that of responsibility without self-centered power. Free from greed and selfishness, you help others without expecting a reward.",
		name = "Nightmare Knight"
	},
	{
		points = 1,
		grade = 1,
		description = "You've joined the undead bone brothers - making death your enemy and your weapon as well. Devouring what's weak and leaving space for what's strong is your primary goal.",
		name = "Bone Brother"
	},
	{
		points = 2,
		grade = 1,
		description = "You travelled the world for an almost meaningless prayer - but at least you don't have to do that again and can get a new blessed stake in the blink of an eye.",
		name = "Blessed!"
	},
	{
		points = 3,
		grade = 1,
		description = "You're a talented merchant who's able to handle wares with care, finds good offers and digs up rares every now and then. Never late to complete an order, you're a reliable trader - at least in Rashid's eyes.",
		name = "Recognised Trader"
	},
	{
		points = 1,
		grade = 1,
		name = "Fountain of Life",
		description = "You found and took a sip from the Fountain of Life. Thought it didn't grant you eternal life, you feel changed and somehow at peace.",
		secret = true
	},
	{
		points = 5,
		grade = 2,
		description = "You travelled the surreal realm of the elemental spheres, summoned and slayed the Lord of the Elements, all in order to retrieve neutral matter. And as brave as you were, you couldn't have done it without your team!",
		name = "Lord of the Elements"
	},
	{
		points = 2,
		grade = 1,
		description = "You re-enacted the Taming of the Shrew on a beach setting and proved that you can handle capricious girls quite well. With or without fish tails.",
		name = "Beach Tamer"
	},
	{
		points = 4,
		grade = 2,
		description = "When you do something, you do it right. You have an opinion and you stand by it - and no one will be able to convince you otherwise. On a sidenote, you're a bit on the brutal and war-oriented side, but that's not a bad thing, is it?",
		name = "Follower of Azerus"
	},
	{
		points = 4,
		grade = 2,
		description = "You're a peacekeeper and listen to what the small people have to say. You've made up your mind and know who to help and for which reasons - and you do it consistently. Your war is fought with reason rather than weapons.",
		name = "Follower of Palimuth"
	},
	{
		points = 5,
		grade = 2,
		description = "You jump at every opportunity for a hunting challenge that's offered to you and carry out those tasks with deadly precision. You're a hunter at heart and a valuable member of the Paw & Fur Society.",
		name = "Elite Hunter"
	},
	{
		points = 2,
		grade = 1,
		description = "You're familiar with hunting tasks and have carried out quite a few already. A bright career as hunter for the Paw & Fur society lies ahead!",
		name = "Huntsman"
	},
	{
		points = 3,
		grade = 1,
		description = "For you, a kiss is more than a simple touch of lips. You kiss maidens and deadbeats alike with unmatched affection and faced death and rebirth through the kiss of the banshee queen. Lucky are those who get to share such an intimate moment with you!",
		name = "Passionate Kisser"
	},
	{
		points = 4,
		grade = 2,
		description = "You've proven yourself as a worthy member of the 'family' and successfully carried out numerous spy missions for your 'uncle' to support the Venorean traders and their goals.",
		name = "Top AVIN Agent"
	},
	{
		points = 4,
		grade = 2,
		description = "Girl power! Whether you're female or not, you've proven absolute loyalty and the willingness to put your life at stake for the girls brigade of Carlin.",
		name = "Top CGB Agent"
	},
	{
		points = 4,
		grade = 2,
		description = "Conspiracies and open secrets are your daily bread. You've shown loyalty to the Thaian crown through your courage when facing enemies and completing spy missions. You're an excellent field agent of the TBI.",
		name = "Top TBI Agent"
	},
	{
		points = 1,
		grade = 1,
		description = "Pack your spy gear and get ready for some dangerous missions in service of a secret agency. You've shown you want to - but can you really do it? Time will tell.",
		name = "Secret Agent"
	},
	{
		points = 4,
		grade = 2,
		description = "You're an aspiring mago-mechanic. Science and magic work well together in your eyes - and even though you probably delivered countless wrong charges while working for Telas, you might just have enough knowledge to build your own golem now.",
		name = "Golem in the Gears"
	},
	{
		points = 2,
		grade = 1,
		name = "Poet Laureate",
		description = "Poems, verses, songs and rhymes you've recited many times. You have passed the cryptic door, raconteur of ancient lore. Even elves you've left impressed, so it seems you're truly blessed.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Minstrel",
		description = "You can handle any music instrument you're given - and actually manage to produce a pleasant sound with it. You're a welcome guest and entertainer in most taverns.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		description = "You know Banuta like the back of your hand and are good at destroying caskets and urns. The sight of giant footprints doesn't keep you from exploring unknown areas either.",
		name = "Friend of the Apes"
	},
	{
		points = 1,
		grade = 1,
		name = "Territorial",
		description = "Your map is your friend — always in your back pocket and covered with countless marks of interesting and useful locations. One could say that you might be lost without it — but luckily there's no way to take it from you.",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		description = "You've proven to be a valuable ally to the Marid, and Gabel welcomed you to trade with Haroun and Nah'Bob whenever you want to. Though the Djinn war has still not ended, the Marid can't fail with you on their side.",
		name = "Marid Ally"
	},
	{
		points = 3,
		grade = 1,
		description = "Even though the Efreet welcomed you only reluctantly and viewed you as \"only a human\" for quite some time, you managed to impress Malor and gained his respect and trade options with the green djinns.",
		name = "Efreet Ally"
	},
	{
		points = 2,
		grade = 1,
		description = "Dreams - are your reality? Strange visions, ticking clocks, going to bed and waking up somewhere completely else - that was some trip, but you're almost sure you actually did enjoy it.",
		name = "Lucid Dreamer"
	},
	{
		points = 4,
		grade = 2,
		description = "You've been to places most people don't even know the names of. Collecting botanic, zoologic and ectoplasmic samples is your daily business and you're always prepared to discover new horizons.",
		name = "Explorer"
	},
	{
		points = 2,
		grade = 1,
		description = "Not even the hostile underwater environment stops you from doing your duty for the Explorer Society. Scouting the Quara realm is a piece of cake for you.",
		name = "Sea Scout"
	},
	{
		points = 2,
		grade = 1,
		name = "Unlikely Pathfinder",
		description = "Wow - what was that? You don't know how you ended up here, but somehow you did. How to get from Beregar to Kazordoon in a jiffy - that's something those dwarves would love to know, but you're not quite sure how to reproduce it.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		description = "Warm, furry and cuddly - though that same bear you just hugged would probably rip you into pieces if he had been conscious, he reminded you of that old teddy bear which always slept in your bed when you were still small.",
		name = "Bearhugger"
	},
	{
		points = 3,
		grade = 1,
		description = "You don't hunt them, you talk to them. You know that ghosts might keep secrets that have been long lost among the living, and you're skilled at talking them into revealing them to you.",
		name = "Ghostwhisperer"
	},
	{
		points = 2,
		grade = 1,
		description = "You have a soft spot for little, weak animals, and you do everything in your power to protect them - even if you probably eat dragons for breakfast.",
		name = "Animal Activist"
	},
	{
		points = 1,
		grade = 1,
		description = "You've hugged bears, pushed mammoths and proved your drinking skills. And even though you have a slight hangover, a partially fractured rib and some greasy hair on your tongue, you're quite proud to call yourself a honorary barbarian from now on.",
		name = "Honorary Barbarian"
	},
	{
		points = 5,
		grade = 2,
		description = "You're the one who poses the questions around here, and you know how to get the answers you want to hear. Besides, you're a famous exorcist and slay a few vampires and demons here and there. You and your stake are a perfect team.",
		name = "High Inquisitor"
	},
	{
		points = 1,
		grade = 1,
		name = "Worm Whacker",
		description = "Weehee! Whack those worms! You sure know how to handle a big hammer.",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		description = "You're not sure what it is, but you feel drawn to royalty. Your knees are always a bit grazed from crawling around in front of thrones and you love hanging out in castles. Maybe you should consider applying as a guard?",
		name = "King Tibianus Fan"
	},
	{
		points = 1,
		grade = 1,
		description = "You're a fast runner and are good at delivering wares which are bound to decay just in the nick of time, even if you can't use any means of transportation or if your hands get cold or smelly in the process.",
		name = "Just in Time"
	},
	{
		points = 3,
		grade = 1,
		description = "You love playing jokes on others and tricking them into looking a little silly. Wagging tongues say that the moment of realisation in your victims' eyes is the reward you feed on, but you're probably just kidding and having fun with them... right??",
		name = "Perfect Fool"
	},
	{
		points = 1,
		grade = 1,
		description = "Sometimes the biggest secrets of life can have a simple solution.",
		name = "Mathemagician"
	},
	{
		points = 3,
		grade = 1,
		description = "Delivering letters and parcels has always been a secret passion of yours, and now you can officially put on your blue hat, blow your post horn and do what you like to do most. Beware of dogs!",
		name = "Archpostman"
	},
	{
		points = 1,
		grade = 1,
		description = "You don't believe in romance to be a coincidence or in love at first sight. In fact - love potions, bouquets of flowers and cheesy poems do the trick much better than ever could. Keep those hormones flowing!",
		name = "Matchmaker"
	},
	{
		points = 3,
		grade = 1,
		name = "His True Face",
		description = "You're one of the few Tibians who Armenius chose to actually show his true face to - and he made you fight him. Either that means you're very lucky or very unlucky, but one thing's for sure - it's extremely rare.",
		secret = true
	},
	{
		points = 7,
		grade = 3,
		name = "Razing!",
		description = "People with sharp canine teeth better beware of you, especially at nighttime, or they might find a stake between their ribs. You're a merciless vampire hunter and have gathered numerous tokens as proof.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		description = "Robbing, inviting yourself to VIP parties, faking contracts and pretending to be someone else - you're a jack of all trades when it comes to illegal activities. You take no prisoners, except for the occasional goldfish now and then.",
		name = "Master Thief"
	},
	{
		points = 2,
		grade = 1,
		description = "You helped bringing Princess Buttercup, Doctor Dumbness and Lucky the Wonder Dog to life - and will probably dream of them tonight, since you memorised your lines perfectly. What a .. special piece of.. screenplay.",
		name = "Amateur Actor"
	},
	{
		points = 3,
		grade = 1,
		description = "You put out the Spirit of Fire's flames in the arena of Svargrond. Arena fights are for you - fair, square, with simple rules and one-on-one battles.",
		name = "Scrapper"
	},
	{
		points = 2,
		grade = 1,
		description = "You wiped out Orcus the Cruel in the Arena of Svargrond. You're still a bit green behind the ears, but there's some great potential.",
		name = "Greenhorn"
	},
	{
		points = 5,
		grade = 2,
		description = "You sent the Obliverator into oblivion in the arena of Svargrond and defeated nine other dangerous enemies on the way. All hail the Warlord of Svargrond!",
		name = "Warlord of Svargrond"
	},
	{
		points = 8,
		grade = 3,
		name = "Herbicide",
		description = "You're one of the brave heroes to face and defeat the mysterious demon oak and all the critters it threw in your face. Wielding your blessed axe no tree dares stand in your way - demonic or not.",
		secret = true
	},
	{
		points = 5,
		grade = 2,
		description = "You've daringly jumped into the infamous Annihilator and survived - taking home fame, glory and your reward.",
		name = "Annihilator"
	},
	{
		points = 6,
		grade = 2,
		description = "You were able to fight your way through the countless hordes in the Demon Forge. Once more you proved that nothing is impossible.",
		name = "Master of the Nexus"
	},
	{
		points = 1,
		grade = 1,
		description = "You're a lord or lady of the dance - and not afraid to use your skills to impress tribal gods. One step to the left, one jump to the right, twist and shout!",
		name = "Talented Dancer"
	},
	{
		points = 2,
		grade = 1,
		description = "With a perfectly harmless smile, you tricked all the funny guys into eating your exploding cookies. Next time you pull this prank, consider wearing a Boy Scout outfit to make it even better.",
		name = "Allow Cookies?"
	},
	{
		points = 5,
		grade = 2,
		description = "You've touched all thrones of the Ruthless Seven and absorbed some of their evil spirit. It may have changed you forever.",
		name = "Ruthless"
	},
	{
		points = 4,
		grade = 2,
		description = "You won the merciless 2 vs. 2 team tournament on the Isle of Strife and wiped out wave after wave of fearsome opponents. Death or victory - you certainly chose the latter.",
		name = "Champion of Chazorai"
	},
	{
		points = 3,
		grade = 1,
		name = "Wayfarer",
		description = "Dragon dreams are golden.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Waverider",
		description = "One thing's for sure: You definitely love swimming. Hanging out on the beach with your friends, having ice cream and playing beach ball is splashingly good fun!",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Rockstar",
		description = "Music just comes to you naturally. You feel comfortable on any stage, at any time, and secretly hope that someday you will be able to defeat your foes by playing music only. Rock on!",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Allowance Collector",
		description = "You certainly have your ways when it comes to acquiring money. Many of them are pink and paved with broken fragments of porcelain.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "High-Flyer",
		description = "The breeze in your hair, your fingers clutching the rim of your carpet - that's how you like to travel. Faster! Higher! And a looping every now and then.",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Clay Fighter",
		description = "You love getting your hands wet and dirty - and covered with clay. Your perfect sculpture of Brog, the raging Titan is your true masterpiece.",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Masquerader",
		description = "You probably don't know anymore how you really look like - usually when you look into a mirror, some kind of monster stares back at you. On the other hand - maybe that's an improvement?",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Deep Sea Diver",
		description = "Under the sea - might not be your natural living space, but you're feeling quite comfortable on the ocean floor. Quara don't scare you anymore and sometimes you sleep with your helmet of the deep still equipped.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Firewalker",
		description = "Running barefoot across ember is not for you! You do it the elegant way. Yet, you're kind of drawn to fire and warm surroundings in general - you like it hot!",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Here, Fishy Fishy!",
		description = "Ah, the smell of the sea! Standing at the shore and casting a line is one of your favourite activities. For you, fishing is relaxing - and at the same time, providing easy food. Perfect!",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Green Thumb",
		description = "If someone gives you seeds, you usually grow a beautiful plant from it within a few days. You like your house green and decorated with flowers. Probably you also talk to them.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Potion Addict",
		description = "Your local magic trader considers you one of his best customers - you usually buy large stocks of potions so you won't wake up in the middle of the night craving for more. Yet, you always seem to run out of them too fast. Cheers!",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Ice Sculptor",
		description = "You love to hang out in cold surroundings and consider ice the best material to be shaped. What a waste to use ice cubes for drinks when you can create a beautiful mammoth statue from it!",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Interior Decorator",
		description = "Your home is your castle - and the furniture in it is just as important. Your friends ask for your advice when decorating their houses and your probably own every statue, rack and bed there is.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Jinx",
		description = "Sometimes you feel there's a gremlin in there. So many lottery tickets, so many blanks? That's just not fair! Share your misery with the world.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Lucky Devil",
		description = "That's almost too much luck for one person. If something's really, really rare - it probably falls into your lap sooner or later. Congratulations!",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Marblelous",
		description = "You're an aspiring marble sculptor with promising skills - proven by the perfect little Tibiasula statue you shaped. One day you'll be really famous!",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Party Animal",
		description = "Oh my god, it's a paaaaaaaaaaaarty! You're always in for fun, friends and booze and love being the center of attention. There's endless reasons to celebrate! Woohoo!",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Fireworks in the Sky",
		description = "You love the moment right before your rocket takes off and explodes into beautiful colours - not only on new year's eve!",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Quick as a Turtle",
		description = "There... is... simply... no... better... way - than to travel on the back of a turtle. At least you get to enjoy the beautiful surroundings of Laguna.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Polisher",
		description = "If you see a rusty item, you can't resist polishing it. There's always a little flask of rust remover in your inventory - who knows, there might be a golden armor beneath all that dirt!",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Ship's Kobold",
		description = "You've probably never gotten seasick in your life — you love spending your free time on the ocean and covered quite a lot of miles with ships. Aren't you glad you didn't have to swim all that?",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Steampunked",
		description = "Travelling with the dwarven steamboats through the underground rivers is your preferred way of crossing the lands. No pesky seagulls, and good beer on board!",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Vanity",
		description = "Aren't you just perfectly, wonderfully, beautifully gorgeous? You can't pass a mirror without admiring your looks. Or maybe doing a quick check whether something's stuck in your teeth, perhaps?",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Superstitious",
		description = "Fortune tellers and horoscopes guide you through your life. And you probably wouldn't dare going on a big game hunt without your trusty voodoo skull giving you his approval for the day.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Turncoat",
		description = "You served Yalahar - but you didn't seem so sure whom to believe on the way. Both Azerus and Palimuth had good reasons for their actions, and thus you followed your gut instinct in the end, even if you helped either of them. May Yalahar prosper!",
		secret = true
	},
	{
		points = 6,
		grade = 2,
		name = "Marble Madness",
		description = "Your little statues of Tibiasula have become quite famous around Tibia and there's few people with similar skills when it comes to shaping marble.",
		secret = true
	},
	{
		points = 6,
		grade = 2,
		name = "Clay to Fame",
		description = "Sculpting Brog, the raging Titan, is your secret passion. Numerous perfect little clay statues with your name on them can be found everywhere around Tibia.",
		secret = true
	},
	{
		points = 6,
		grade = 2,
		name = "Cold as Ice",
		description = "Take an ice cube and an obsidian knife and you'll very likely shape something really pretty from it. Mostly cute little mammoths, which are a hit with all the girls.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Exquisite Taste",
		description = "You love fish - but preferably those caught in the cold north. Even though they're hard to come by you never get tired of picking holes in ice sheets and hanging your fishing rod in.",
		secret = true
	},
	{
		points = 5,
		grade = 2,
		name = "Jamjam",
		description = "When it comes to interracial understanding, you're an expert. You've mastered the language of the Chakoya and made someone really happy with your generosity. Achuq!",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "I Did My Part",
		description = "Your world is lucky to have you! You don't hesitate to jump in and help when brave heroes are called to save the world.",
		secret = true
	},
	{
		points = 8,
		grade = 3,
		name = "Notorious Worldsaver",
		description = "You're in the front line when it comes to saving your world or taking part in social events. Whether you do it noticed or unnoticed by the people, your world can rely on you to dutifully do your part to make it a better place for everyone.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Teamplayer",
		description = "You don't consider yourself too good to do the dirty work while someone else might win the laurels for killing Devovorga. They couldn't do it without you!",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Daring Trespasser",
		description = "You've entered the lair of Devovorga and joined the crew trying to take her down - whether crowned with success or not doesn't matter, but they can't blame you for not trying!",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Slayer of Anmothra",
		description = "Souls are like butterflies. The black soul of a living weapon yearning to strike lies shattered beneath your feet.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Slayer of Chikhaton",
		description = "Power lies in the will of her who commands it. You fought it with full force - and were stronger.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Slayer of Irahsae",
		description = "Few things equal the wild fury of a trapped and riven creature. You were a worthy opponent.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Slayer of Phrodomo",
		description = "Blind hatred took physical form, violently rebelling against the injustice it was born into. You were not able to bring justice - but at least temporary peace.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Slayer of Teneshpar",
		description = "The forbidden knowledge of aeons was never meant to invade this world. You silenced its voice before it could be made heard.",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Cocoon of Doom",
		description = "You helped bringing Devovorga's dangerous tentacles and her humongous cocoon down - not stopping her transformation, but ultimately completing a crucial step to her death.",
		secret = true
	},
	{
		points = 5,
		grade = 2,
		name = "Devovorga's Nemesis",
		description = "One special hero among many. This year - it was you. Devovorga withdrew in a darker realm because she could not withstand your power - and that of your comrades. Time will tell if the choice you made was good - but for now, it saved your world.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Mister Sandman",
		description = "Tired... so tired... curling up in a warm and cosy bed seems like the perfect thing to do right now. Sweet dreams!",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Rock Me to Sleep",
		description = "Sleeping - you do it with style. You're chilling in your hammock, listening to the sound of the birds and crickets as you slowly drift away into the realm of dreams.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Modest Guest",
		description = "You don't need much to sleep comfortably. A pile of straw and a roof over your head - with the latter being completely optional - is quite enough to relax. You don't even mind the rats nibbling on your toes.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Joke's on You",
		description = "Well - the contents of that present weren't quite what you expected. With friends like these, who needs enemies?",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Oops",
		description = "So much for your feathered little friend! Maybe standing in front of the birdcage, squeezing its neck and shouting 'Sing! Sing! Sing!' was a little too much for it?!",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Bluebarian",
		description = "You live the life of hunters and gatherers. Well, especially that of a gatherer, and especially of one who gathers lots of blueberries. Have you checked the colour of your tongue lately?",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		description = "Thick, red - shaken, not stirred - and with a straw in it: that's the way you prefer your demon blood. Served with an onion ring, the subtle metallic aftertaste is almost not noticeable. Beneficial effects on health or mana are welcome.",
		name = "Demonic Barkeeper"
	},
	{
		points = 1,
		grade = 1,
		name = "The Snowman",
		description = "You love the winter. Fully equipped with scarf and gloves, you like to have fun outside while building lots of snowmen with your friends. Snowball fight, anyone?",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		description = "Six. Six. Six.",
		name = "Number of the Beast"
	},
	{
		points = 2,
		grade = 1,
		description = "You and your stuffed furry friends are inseparable, and you're not ashamed to take them to bed with you - who knows when you will wake up in the middle of the night in dire need of a cuddle?",
		name = "I Need a Hug"
	},
	{
		points = 1,
		grade = 1,
		description = "Okay, let's face it - as long as you believe it could potentially lead you to the biggest treasure ever, you won't let go of that map, however fishy it might look. There must be a secret behind all of this!",
		name = "Slim Chance"
	},
	{
		points = 1,
		grade = 1,
		name = "Rocket in Pocket",
		description = "Either you are not a fast learner or you find some pleasure in setting yourself on fire. Or you're just looking for a fancy title. In any case, you should know that passing gas during your little donkey experiments is not recommended.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Make a Wish",
		description = "But close your eyes and don't tell anyone what you wished for, or it won't come true!",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Santa's Li'l Helper",
		description = "Christmas is your favourite time of the year, and boy, do you love presents. Buy some nice things for your friends, hide them away until - well, until you decide to actually unwrap them rather yourself.",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Cursed!",
		description = "The wrath of the Noxious Spawn - you accidentally managed to incur it. Your days are counted and your death inevitable. Sometime. Someplace.",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Free Items!",
		description = "Yay! Finders keepers, losers weepers! Who cares where all that stuff came from and if you had to crawl through garbage piles to get it? It's FREE!",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		description = "Up and down and up and down... and then the big looping! Wait - they don't build loopings in Kazordoon. But ore wagon rides are still fun!",
		name = "Rollercoaster"
	},
	{
		points = 5,
		grade = 2,
		name = "Transmutator",
		description = "You, Sir or Lady, are a true alchemist. Conducting transmutating experiments to find every possible combination has been your secret passion since years and the results of your research are incredible. Science has just taken a leap thanks to you!",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		description = "RAWR! Strength running through your body, your heart racing faster and adrenaline fueling your every weapon swing. All in a little bottle. No refund for destroyed furniture. For further questions consult your healer or potion dealer.",
		name = "Berserker"
	},
	{
		points = 3,
		grade = 1,
		description = "You feel you could solve the hardest riddles within a minute or so. Plus, there's a nice boost on your spell damage. All in a little bottle. Aftereffects - feeling slightly stupid. For further questions consult your healer or potion dealer.",
		name = "Mastermind"
	},
	{
		points = 3,
		grade = 1,
		description = "Improved eyesight, arrows and bolts flying at the speed of light and pinning your enemies with extra damage. All in a little bottle. No consumption of carrots required. For further questions consult your healer or potion dealer.",
		name = "Sharpshooter"
	},
	{
		points = 1,
		grade = 1,
		name = "Do Not Disturb",
		description = "Urgh! Close the windows! Shut out the sun rearing its ugly yellow head, shut out the earsplitting laughter of your neighbour's corpulent children. Ahhh. Embrace sweet darkness and silence.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Let the Sunshine In",
		description = "Rise and shine! It's a beautiful new day - open your windows, feel the warm sunlight, watch the birds singing on your windowsill and care for your plants. What reason is there not to be happy?",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Bad Timing",
		description = "Argh! Not now! How is it that those multifunctional tools never fail when you're using them for something completely trivial like squeezing juice, but mess up when you desperately need to climb up a rope spot with a fire-breathing dragon chasing you?",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Nothing Can Stop Me",
		description = "You laugh at unprepared adventurers stuck in high grass or rush wood. Or maybe you actually do help them out. They call you... 'Machete'.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Happy Farmer",
		description = "Scythe swung over your shoulder, sun burning down on your back - you are a farmer at heart and love working in the fields. Or then again maybe you just create fancy crop circles to scare your fellow men.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Natural Sweetener",
		description = "Liberty Bay is the perfect hangout for you and harvesting sugar cane quite a relaxing leisure activity. Would you like some tea with your sugar, hon?",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Homebrewed",
		description = "Yo-ho-ho and a bottle of rum - homebrewed, of course, made from handpicked and personally harvested sugar cane plants. Now, let it age in an oak barrel and enjoy it in about 10 years. Or for the impatient ones: Let's have a paaaarty right now!",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Gold Digger",
		description = "Hidden treasures below the sand dunes of the desert - you have a nose for finding them and you know where to dig. They might not make you filthy rich, but they're shiny and pretty anyhow.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "The Undertaker",
		description = "You and your shovel - a match made in heaven. Or hell, for that matter. Somewhere down below in any case. You're magically attracted by stone piles and love to open them up and see where those holes lead you. Good biceps as well.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Cookie Monster",
		description = "You can easily be found by anyone if they just follow the cookie crumb trail. And for you, true love means to give away your last cookie.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "The Cake's the Truth",
		description = "And anyone claiming otherwise is a liar.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Sweet Tooth",
		description = "The famous 'Ode to a Molten Chocolate Cake' was probably written by you. Spending a rainy afternoon in front of the chimney, wrapped in a blanket while indulging in cocoa delights sounds just like something you'd do. Enjoy!",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "With a Cherry on Top",
		description = "You like your cake soft, with fruity bits and a nice sugar icing. And you prefer to make them by yourself. Have you ever considered opening a bakery? You must be really good by now!",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Mutated Presents",
		description = "Muahahaha it's a... mutated pumpkin! After helping to take it down - you DID help, didn't you? - you claimed your reward and got a more or less weird present. Happy Halloween!",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Keeper of the Flame",
		description = "One of the Lightbearers. One of those who helped to keep the basins burning and worked together against the darkness. The demonic whispers behind the thin veil between the worlds - they were silenced again thanks to your help.",
		secret = true
	},
	{
		points = 5,
		grade = 2,
		name = "True Lightbearer",
		description = "You're one of the most dedicated Lightbearers - without you, the demons would have torn the veil between the worlds for sure. You've lit each and every basin, travelling high and low, pushing back the otherworldly forces. Let there be light!",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		description = "You have defeated the Snake God's incarnations and, with a final powerful swing of the snake sceptre, cut off his life force supply. The story of power, deceit and corruption has come to an end - or... not?",
		name = "Godslayer"
	},
	{
		points = 2,
		grade = 1,
		name = "The Day After",
		description = "Uhm... who's that person who you just woke up beside? Broken cocktail glasses on the floor, flowers all over the room, and why the heck are you wearing a ring? Yesterday must have been a long, weird day...",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Commitment Phobic",
		description = "Longterm relationships are just not for you. And each time you think you're in love, you're proven wrong shortly afterwards. Or maybe you just end up with the wrong lover each time - exploited and betrayed. Staying single might just be better.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Heartbreaker",
		description = "Trust? Love? Faithfulness? Pah! Antiquated sentiments. As long as you have fun, you do not mind stepping on lots of hearts. Preferably while wearing combat boots.",
		secret = true
	},
	{
		points = 6,
		grade = 2,
		description = "Stealth kills and backstabbing are you specialty. Your numerous victims are usually unaware of their imminent death, which you bring to them silently and swiftly. Everything is permitted.",
		name = "Swift Death"
	},
	{
		points = 6,
		grade = 2,
		description = "What is best in life? To crush your enemies. To see them driven before you. And to maybe have a nice cup of tea afterwards.",
		name = "Brutal Politeness"
	},
	{
		points = 4,
		grade = 2,
		description = "You're a beggar, homeless, wearing filthy and ragged clothes. But that doesn't mean you have to beg anyone for stuff - and you still kept your pride. Fine feathers do not necessarily make fine birds - what's under them is more important.",
		name = "Life on the Streets"
	},
	{
		points = 6,
		grade = 2,
		description = "Wearing the insignia and dark robes of the Brotherhood of Bones you roam the lands spreading fear and pain, creating new soldiers for the necromantic army which is about to rise soon. Hail the Brotherhood.",
		name = "Skull and Bones"
	},
	{
		points = 6,
		grade = 2,
		description = "You do not fear nightmares, you travel in them - facing countless horrors and fighting the fate they're about to bring. Few believe the dark prophecies you bring back from those dreams, but those who do fight alongside you as Nightmare Knights.",
		name = "Nightmare Walker"
	},
	{
		points = 4,
		grade = 2,
		description = "Every city should be proud to call someone like you its inhabitant. You're keeping the streets clean and help settling the usual disputes in front of the depot. Also, you probably own a cat and like hiking.",
		name = "Exemplary Citizen"
	},
	{
		points = 6,
		grade = 2,
		description = "You don't carry that stake just for decoration - you're prepared to use it. Usually you're seen hightailing through the deepest dungeons leaving a trail of slain demons. Whoever dares stand in your way should prepare to die.",
		name = "Demonbane"
	},
	{
		points = 6,
		grade = 2,
		description = "One with nature, one with wildlife. Raw and animalistic power, sharpened senses, howling on the highest cliffs and roaring in the thickest forests - that's you.",
		name = "Of Wolves and Bears"
	},
	{
		points = 6,
		grade = 2,
		description = "At daytime you can be found camouflaged in the woods laying traps or chasing big game, at night you're sitting by the campfire and sharing your hunting stories. You eat what you hunted and wear what you skinned. Life could go on like that forever.",
		name = "Hunting with Style"
	},
	{
		points = 3,
		grade = 1,
		description = "And remember: Never try to teach a pig to sing. It wastes your time and annoys the pig.",
		name = "Fool at Heart"
	},
	{
		points = 6,
		grade = 2,
		description = "With edged blade and fully equipped in a sturdy full plate armor, you charge at your enemies with both strength and valour. There's always a maiden to save and a dragon to slay for you.",
		name = "In Shining Armor"
	},
	{
		points = 4,
		grade = 2,
		description = "You begin your day by bathing in your pot of gold and you don't mind showing off your wealth while strolling the streets in your best clothes - after all it's your hard-earned money! You prefer to be addressed with 'Your Highness'.",
		name = "Aristocrat"
	},
	{
		points = 4,
		grade = 2,
		description = "Snow heaps and hailstorms can't keep you from where you want to go. You're perfectly equipped for any expedition into the perpetual ice and know how to keep your feet warm. If you're a woman, that's quite an accomplishment, too.",
		name = "Out in the Snowstorm"
	},
	{
		points = 6,
		grade = 2,
		description = "You feel at home under the hot desert sun with sand between your toes, and your favourite means of travel is a flying carpet. Also, you can probably do that head isolation dance move.",
		name = "One Thousand and One"
	},
	{
		points = 6,
		grade = 2,
		description = "Ye be a gentleman o' fortune, fightin' and carousin' on the high seas, out fer booty and lassies! Ye no be answerin' to no man or blasted monarchy and yer life ain't fer the lily-livered. Aye, matey!",
		name = "Swashbuckler"
	},
	{
		points = 6,
		grade = 2,
		description = "Shaking your rattle and dancing around the fire to jungle drums sounds like something you like doing. Besides, dreadlocks are a convenient way to wear your hair - no combing required!",
		name = "Way of the Shaman"
	},
	{
		points = 6,
		grade = 2,
		description = "You could be the author of the magnum opus 'How to Summon the Ultimate Beast from the Infernal Depths, Volume I'. Or, if your mind and heart are pure, you rather summon beings to help others. Or maybe just a little cat to have someone to cuddle.",
		name = "Ritualist"
	},
	{
		points = 6,
		grade = 2,
		description = "You're not afraid to show your colours in the heat of battle. Enemies fear your lethal lance and impenetrable armor. The list of the wars you've won is impressive. Hail and kill!",
		name = "Master of War"
	},
	{
		points = 6,
		grade = 2,
		description = "Valour is for weaklings - it doesn't matter how you win the battle, as long as you're victorious. Thick armor would just hinder your movements, thus you keep it light and rely on speed and skill instead of hiding in an uncomfortable shell.",
		name = "Wild Warrior"
	},
	{
		points = 6,
		grade = 2,
		description = "You're a humble warrior who doesn't need wealth or specialised equipment for travelling and fighting. You feel at home in the northern lands of Zao and did your part in fighting its corruption.",
		name = "Peazzekeeper"
	},
	{
		points = 3,
		grade = 1,
		description = "Your deeds for Yalahar are usually characterised by deep insight and thoughtful actions. Thanks to you, Yalahar might have a chance to grow peacefully and with happy people living in it.",
		name = "Yalahari of Wisdom"
	},
	{
		points = 3,
		grade = 1,
		description = "You defend Yalahar with brute force and are ready to lead it into a glorious battle, if necessary. Thanks to you, Yalahar will be powerful enough to stand up against any enemy.",
		name = "Yalahari of Power"
	},
	{
		points = 1,
		grade = 1,
		description = "Life can be so easy with the right cake at the right time - and you mastered baking many different ones, so you should be prepared for almost everything life decides to throw at you.",
		name = "Piece of Cake"
	},
	{
		points = 6,
		grade = 2,
		description = "You're considered a first-rate graduate of the Magic Academy in Edron due to your pioneering discoveries and successful studies in the field of experimental magic and spell development. Ever considered teaching the Armageddon spell?",
		name = "Alumni"
	},
	{
		points = 6,
		grade = 2,
		description = "You're proficient in the darker ways of magic and are usually found sitting inside a circle of candles and skulls muttering unspeakable words. Don't carry things too far or the demons might come get you.",
		name = "Warlock"
	},
	{
		points = 2,
		grade = 1,
		name = "Bunny Slipped",
		description = "Indeed, you have a soft spot for rabbits. Maybe the rabbits you saved today will be the rabbits that will save you tomorrow. When you are really hungry.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		description = "True scientists know their equipment. Testing new inventions is essential daily work for any hard working researcher. You showed no fear and took all the new equipment from Spectulus and Sinclair for a spin.",
		name = "Guinea Pig"
	},
	{
		points = 2,
		grade = 1,
		description = "You went into the forest, met Rottin Wood and the Married Men and helped them out in their camp. Oh, and don't worry about those merchants. They won't dare mentioning the strangely large sums of gold they actually possessed which are missing now.",
		name = "Merry Adventures"
	},
	{
		points = 2,
		grade = 1,
		description = "You passed their test and helped the Spirithunters testing equipment, researching the supernatural and catching ghosts - it's you they're gonna call.",
		name = "Afraid of no Ghost!"
	},
	{
		points = 2,
		grade = 1,
		name = "Extreme Degustation",
		description = "Almost all the plants you tested for Chartan in Zao where inedible - you tasted them all, yet you're still standing! You should really get some fresh air now, though.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Cake Conqueror",
		description = "You have bravely stepped onto the cake isle. Is there any more beautiful, tasty place to be in the whole world?",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Baby Sitter",
		description = "You have cheered up a demon baby and returned it to its mother. A quick count of your fingers will reveal if you made it through unharmed.",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Nanny from Hell",
		description = "You have cheered up a bunch of demon babies and returned them to their mother. Don't bother the burn marks, don't bother the strains of grey hair, don't bother the nights you wake up screaming. It was worth it ... probably ... somehow.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Ghost Sailor",
		description = "You have sailed the nether seas with the Ghost Captain. Despite the perils, you and your fellow crewmen have braved the challenge.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Spectral Traveller",
		description = "You have sailed the nether seas with the Ghost Captain several times. The dangers of the nether have become familiar to you and unexperienced travelers turn to you for advice.",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Nether Pirate",
		description = "Not fearing death or ghosts you have traveled with the ghost captain several times and are a seasoned traveler of the netherworld. The dead and the living whisper about your exploits with appreciation.",
		secret = true
	},
	{
		points = 5,
		grade = 2,
		name = "Scourge of Death",
		description = "You are a master of the nether sea and have traveled with the ghost captain so many times that you know his ship and the perils of the nether sea inside out. You laugh in the face of death and may return as a ghost pirate yourself in the afterlife!",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Fire Lighter",
		description = "You have helped to keep the witches fire burning. Just watch your fingers, it's hot!",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Witches Lil' Helper",
		description = "You sacrificed ingredients to create the protective brew of the witches.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Banebringers' Bane",
		description = "You sacrificed a lot of ingredients to create the protective brew of the witches and played a significant part in the efforts to repel the dreaded banebringers. The drawback is that even the banebringers may take notice of you ...",
		secret = true
	},
	{
		points = 3,
		grade = 1,
		name = "Fire Devil",
		description = "To keep the witches' fire burning, you trashed a lot of the wood the bane bringers animated. Some might find your fascination for fire ... disturbing.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Pyromaniac",
		description = "Love ... fire! So ... shiny! Must ... buuuurrrn!",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Honorary Witch",
		description = "Your efforts in fighting back the banebringers has not gone unnoticed. You are a legend amongst the witches and your name is whispered with awe and admiration.",
		secret = true
	},
	{
		points = 1,
		grade = 1,
		name = "Natural Born Cowboy",
		description = "Oh, the joy of riding! You've just got your very first own mount. Conveniently enough you don't even need stables, but can summon it any time you like.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		name = "Petrologist",
		description = "Stones have always fascinated you. So has the chance of finding something really precious inside one of them. Statistically you should've discovered a few nice treasures by now. But then again, most statistics are overriden by Mother Disfortune.",
		secret = true
	},
	{
		points = 2,
		grade = 1,
		description = "You've discovered the Ancients' hidden powers - from now on, they will aid you in your adventures.",
		name = "Hidden Powers"
	},
	{
		points = 1,
		grade = 1,
		name = "I Like it Fancy",
		description = "You definitely know how to bring out the best in your furniture and decoration pieces. Beautiful.",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Skin-Deep",
		description = "You always carry your obsidian knife with you and won't hesitate to use it. You've skinned countless little - and bigger - critters and yeah: they usually don't get any more beautiful on the inside. It's rather blood and gore and all that...",
		secret = true
	},
	{
		points = 4,
		grade = 2,
		name = "Ashes to Dust",
		description = "Staking vampires and demons has almost turned into your profession. You make sure to gather even the tiniest amount of evil dust particles. Beware of silicosis.",
		secret = true
	},
	[196] = {
		points = 2,
		grade = 1,
		name = "Safely Stored Away",
		description = "Don't worry, no one will be able to take it from you. Probably.",
		secret = true
	},
	[197] = {
		points = 1,
		grade = 1,
		name = "Something's in There",
		description = "By the gods! What was that?",
		secret = true
	},
	[198] = {
		points = 1,
		grade = 1,
		name = "Silent Pet",
		description = "Awww. Your very own little goldfish friend - he's cute, he's shiny and he can't complain should you forget to feed him. He'll definitely brighten up your day!",
		secret = true
	},
	[199] = {
		points = 2,
		grade = 1,
		name = "Snowbunny",
		description = "Hopping, hopping through the snow - that's the funnest way to go! Making footprints in a flurry - it's more fun the more you hurry! Licking icicles all day - Winter, never go away!",
		secret = true
	},
	[200] = {
		points = 2,
		grade = 1,
		name = "Dark Voodoo Priest",
		description = "Sinister curses, evil magic - you don't shy away from punishing others by questionable means. Someone just gave you a strange look - now where's that needle again?",
		secret = true
	},
	[201] = {
		points = 2,
		grade = 1,
		name = "Nomad Soul",
		description = "Home is where your current favourite hunting ground is, and though you might hold certain places more dear than others you never feel attached enough to really stay in one city for long. Pack all your stuff - it's time to move on again.",
		secret = true
	},
	[202] = {
		points = 2,
		grade = 1,
		name = "Truth Be Told",
		description = "You told Jack the truth by explaining you and Spectulus made a mistake when trying to convince him of being a completely different person.",
		secret = true
	},
	[203] = {
		points = 2,
		grade = 1,
		name = "You Don't Know Jack",
		description = "You did not tell Jack the truth about the mistake you and Spectulus made when trying to convince him about being a completely different person. He will live in doubt until the end of his existence.",
		secret = true
	},
	[204] = {
		points = 4,
		grade = 2,
		name = "Berry Picker",
		description = "The Combined Magical Winterberry Society hereby honours continued selfless dedication and extraordinary efforts in the Annual Autumn Vintage.",
		secret = true
	},
	[205] = {
		points = 3,
		grade = 1,
		name = "True Colours",
		description = "You and your friends showed the three wizards your loyalty three times - I am sure at least one of them is probably eternally thankful and exceedingly proud of you.",
		secret = true
	},
	[206] = {
		points = 2,
		grade = 1,
		name = "Master Shapeshifter",
		description = "You have mastered Kuriks challenge in all possible shapes.",
		secret = true
	},
	[207] = {
		points = 1,
		grade = 1,
		name = "Slimer",
		description = "With the assistance of your friendly little helper, you gobbled more than 500 chunks of slime. Well done, Slimer.",
		secret = true
	},
	[208] = {
		points = 1,
		grade = 1,
		name = "Mageslayer",
		description = "You killed the raging mage in his tower south of Zao. Again. But this one just keeps coming back. The dimensional portal collapsed once more and you know he will eventually return but hey - a raging mage, it's like asking for it...",
		secret = true
	},
	[209] = {
		points = 1,
		grade = 1,
		name = "Biodegradable",
		description = "You caught fifty rare shimmer swimmers. Getting rid of all those corpses by dumping them into the lake really was worth it, wasn't it? Wait, didn't something move in the water just now...?",
		secret = true
	},
	[210] = {
		points = 1,
		grade = 1,
		name = "Eye of the Deep",
		description = "You didn't look into it - at least not for too long... but Groam did. And you relieved him. Just don't tell his friend Dronk.",
		secret = true
	},
	[211] = {
		points = 2,
		grade = 1,
		name = "Invader of the Deep",
		description = "Many creatures of the deep have lost their lives by your hand. Three hundred have entered the depths of eternity. You should probably fear the revenge of the Eyes of the Deep.",
		secret = true
	},
	[212] = {
		points = 2,
		grade = 1,
		name = "Firefighter",
		description = "You extinguished 500 thornfires! You were there when the Firestarters took over Shadowthorn. You saved the day - and the home of some elves which will try to kill you nonetheless. Isn't it nice to see everything restored just as it was before..?",
		secret = true
	},
	[213] = {
		points = 1,
		grade = 1,
		name = "Deer Hunt",
		description = "You managed to kill more than four hundred white deer - it looks like you are one of the main reasons they will soon be considered extinct, way to go!",
		secret = true
	},
	[214] = {
		points = 1,
		grade = 1,
		name = "Askarak Nemesis",
		description = "You are now the royal archfiend of the Askarak, prince slayer.",
		secret = true
	},
	[215] = {
		points = 1,
		grade = 1,
		name = "Shaburak Nemesis",
		description = "You are now the public archenemy of the Shaburak, prince slayer.",
		secret = true
	},
	[216] = {
		points = 1,
		grade = 1,
		name = "Fearless",
		description = "You broke the jar of Horestis - fifty times. Either you know no fear or simply ignore it. Whatever the case, you are \"fearless\" indeed.",
		secret = true
	},
	[217] = {
		points = 2,
		grade = 1,
		name = "Doctor! Doctor!",
		description = "Did someone call a doctor? You delivered 100 medicine bags to Ottokar of the Venore poor house in times of dire need, well done!",
		secret = true
	},
	[218] = {
		points = 4,
		grade = 2,
		description = "You significantly helped the afflicted citizens of Venore in times of dire need. Somehow you still feel close to the victims of the fever outbreak. Your clothes make you one of them, one poor soul amongst the countless afflicted.",
		name = "Beak Doctor"
	},
	[219] = {
		points = 4,
		grade = 2,
		description = "You vanquished the mad mage, you subdued the raging mage - no spellweaving self-exposer can stand in your way. Yet you are quite absorbed in magical studies yourself. This very fabric reflects this personal approval of the magic arts.",
		name = "Mystic Fabric Magic"
	},
	[221] = {
		points = 1,
		grade = 1,
		description = "You've shattered each of Bloodweb's eight frozen legs. As they say: break a leg, and then some more.",
		name = "Arachnoise"
	},
	[222] = {
		points = 1,
		grade = 1,
		description = "You've descended into the swampy depths of Deathbine's lair and made quick work of it.",
		name = "Rootless Behaviour"
	},
	[223] = {
		points = 1,
		grade = 1,
		description = "You've slain Esmeralda, the most hideous and aggressive of the mutated rats. No one will know that you almost lost a finger in the process.",
		name = "Twisted Mutation"
	},
	[224] = {
		points = 2,
		grade = 1,
		description = "Ethershreck's cry of agony kept ringing in your ear for hours after he had dissolved into thin air. He probably moved to another plane of existence... for a while.",
		name = "Beautiful Agony"
	},
	[225] = {
		points = 1,
		grade = 1,
		description = "A mighty blaze went out today. It's Flameborn's turn to wait for his rebirth in the eternal cycle of life and death.",
		name = "Scorched Flames"
	},
	[226] = {
		points = 1,
		grade = 1,
		description = "You ripped the ancient scarab Fleshcrawler apart and made sure he didn't get under your skin.",
		name = "Crawling Death"
	},
	[227] = {
		points = 2,
		grade = 1,
		description = "You made a knot with Gorgo's living curls and took her scalp. You couldn't save her countless petrified victims, but at least you didn't become one.",
		name = "The Serpent's Bride"
	},
	[228] = {
		points = 1,
		grade = 1,
		description = "You've found a well-hidden spider queen and caught her off guard in the middle of her meal.",
		name = "No More Hiding"
	},
	[229] = {
		points = 2,
		grade = 1,
		description = "It seems the gates to the underworld have to remain unprotected for a while. Kerberos, the mighty hellhound, lost his head. All three of them.",
		name = "The Gates of Hell"
	},
	[230] = {
		points = 2,
		grade = 1,
		description = "As the killer of Leviathan, the giant sea serpent, his underwater kingdom is now under your reign.",
		name = "The Drowned Sea God"
	},
	[231] = {
		points = 1,
		grade = 1,
		description = "Ribstride is striding no more. He had quite a few ribs to spare though.",
		name = "Spareribs for Dinner"
	},
	[232] = {
		points = 1,
		grade = 1,
		description = "You almost made friends with Shardhead... before he died. Poor guy only seems to attract violence with his frosty attitude.",
		name = "Breaking the Ice"
	},
	[233] = {
		points = 2,
		grade = 1,
		description = "Stonecracker's head was much softer than the stones he threw at you.",
		name = "Just Cracked Me Up!"
	},
	[234] = {
		points = 1,
		grade = 1,
		description = "You've exinguished the Sulphur Scuttler's gas clouds and made the air in his cave a little better... at least for a while.",
		name = "Something Smells"
	},
	[235] = {
		points = 1,
		grade = 1,
		description = "You've impaled the big mammoth Bloodtusk with his own tusks.",
		name = "Meat Skewer"
	},
	[236] = {
		points = 2,
		grade = 1,
		description = "The Many is no more, but how many more are there? One can never know.",
		name = "One Less"
	},
	[237] = {
		points = 2,
		grade = 1,
		description = "You've vanquished the Noxious Spawn and his serpentine heart.",
		name = "Hissing Downfall"
	},
	[238] = {
		points = 1,
		grade = 1,
		description = "The Old Widow fell prey to your supreme hunting skills.",
		name = "Choking on Her Venom"
	},
	[239] = {
		points = 1,
		grade = 1,
		description = "You've tainted the jungle floor with the Snapper's crimson blood.",
		name = "Blood-Red Snapper"
	},
	[240] = {
		points = 1,
		grade = 1,
		description = "You've cut off a whole lot of tentacles today. Thul was driven back to where he belongs.",
		name = "Back into the Abyss"
	},
	[241] = {
		points = 8,
		grade = 3,
		name = "Pwned a Lot of Fur",
		description = "You've faced and defeated a lot of the mighty bosses the Paw and Fur society sent you out to kill. All by yourself. What a hunt!",
		secret = true
	},
	[242] = {
		points = 1,
		grade = 1,
		description = "You've stopped the bank robber and returned the bag full of gold. Good to know there are still lawful Tibians like you around.",
		name = "Honest Finder"
	},
	[243] = {
		points = 2,
		grade = 1,
		name = "Goldhunter",
		description = "If it wasn't for you, several banks in Tibia would've gotten bankrupt by now. Keep on chasing bank robbers and no one will have to worry about the Tibian economy!",
		secret = true
	},
	[244] = {
		points = 1,
		grade = 1,
		name = "Trail of the Ape God",
		description = "You've discovered a trail of giant footprints and terrified elephants running everywhere. Could it be that the mysterious ape god is rambling in the jungle?",
		secret = true
	},
	[245] = {
		points = 1,
		grade = 1,
		name = "Someone's Bored",
		description = "That was NOT a giant spider. There's some witchcraft at work here.",
		secret = true
	},
	[246] = {
		points = 1,
		grade = 1,
		name = "Whistle-Blower",
		description = "You can't keep a secret, can you? Then again, you're just fulfilling your duty to the Queen of Carlin as a lawful citizen. That's a good thing, isn't it...?",
		secret = true
	},
	[247] = {
		points = 1,
		grade = 1,
		name = "Torn Treasures",
		description = "Wyda seems to be really, really bored. You also found out that she doesn't really need all those blood herbs that adventurers brought her. Still, she was nice enough to take one from you and gave you something quite cool in exchange.",
		secret = true
	},
	[248] = {
		points = 1,
		grade = 1,
		name = "Loyal Subject",
		description = "You joined the Kingsday festivities and payed King Tibianus your respects. Now, off to party!",
		secret = true
	},
	[249] = {
		points = 1,
		grade = 1,
		description = "You managed to catch a fish in a surrounding that usually doesn't even carry water. Everything is subject to change, probably...",
		name = "Desert Fisher"
	},
	[251] = {
		points = 1,
		grade = 1,
		description = "You showed Noodles the way home. How long will it take this time until he's on the loose again? That dog must be really bored in the throne room by now.",
		name = "Dog Sitter"
	},
	[252] = {
		points = 1,
		grade = 1,
		description = "You witnessed the thawing of Svargrond and harvested rare seeds from some strange icy plants. They must be good for something.",
		name = "Ice Harvester"
	},
	[253] = {
		points = 1,
		grade = 1,
		name = "Preservationist",
		description = "You are a pretty smart thinker and managed to create everlasting flowers. They might become a big hit with all the people who aren't blessed with a green thumb or just forgetful.",
		secret = true
	},
	[254] = {
		points = 1,
		grade = 1,
		description = "You've discovered three nomad camps and stole their supplies. Well, you can probably use them better then they can.",
		name = "Chest Robber"
	},
	[255] = {
		points = 2,
		grade = 1,
		description = "You've found a secret dungeon in the flooded plains and killed several of its inhabitants. And now you have wet feet.",
		name = "Down the Drain"
	},
	[256] = {
		points = 2,
		grade = 1,
		description = "You've survived the Hellgorge eruption and found a way through the flames and lava. You've even managed to kill a few fireborn on the way.",
		name = "Fire from the Earth"
	},
	[257] = {
		points = 2,
		grade = 1,
		description = "Your actions start to make a difference. You have blinded the antennae of the hive often enough to become an annoyance to it.",
		name = "Minor Disturbance"
	},
	[258] = {
		points = 3,
		grade = 1,
		description = "In the war against the hive, your efforts in blinding it begin to pay off. Your actions have blinded the hive severely and the entity seems to become aware that something dangerous is happening.",
		name = "Dazzler"
	},
	[259] = {
		points = 4,
		grade = 2,
		description = "You have put a lot of time and energy into keeping the hive unaware of what is happening on Quirefang. The hive learnt to fear your actions. It would surely crush you with all its might ... if it could only find you!",
		name = "Hive Blinder"
	},
	[260] = {
		points = 2,
		grade = 1,
		description = "You have grown accustomed to frequenting the hive's stomach system. Your actions have caused the hive some first digestion problems.",
		name = "Hickup"
	},
	[261] = {
		points = 3,
		grade = 1,
		description = "Never-tiring, you attack the inner organs of the mighty hive. Your attacks on the hive's digestion system begin to cause some trouble.",
		name = "Heartburn"
	},
	[262] = {
		points = 4,
		grade = 2,
		description = "You severely disrupted the digestion of the hive. The hive should for sure see a doctor. It seems you proved to be more than it can swallow.",
		name = "Stomach Ulcer"
	},
	[263] = {
		points = 2,
		grade = 1,
		description = "The hive has to be fought with might and main, hampering its soldiers is only the first step. You diligently stopped the pores of the hive to spread its warriors.",
		name = "Planter"
	},
	[264] = {
		points = 3,
		grade = 1,
		description = "You are getting more and more experienced in destroying the supply of the enemy's forces. Your actions caused the hive some severe skin problems.",
		name = "Pimple"
	},
	[265] = {
		points = 4,
		grade = 2,
		description = "A war is won by those who have the best supply of troops. The hive's troops have been dealt a significant blow by your actions. You interrupted the hive's replenishment of troops lastingly and severely.",
		name = "Suppressor"
	},
	[266] = {
		points = 2,
		grade = 1,
		description = "By killing creatures of the hive and gaining weapons for further missions, you started a quite effective way of war. You gathered a lot of dissolved chitin to resupply the war effort.",
		name = "Gatherer"
	},
	[267] = {
		points = 3,
		grade = 1,
		description = "The need for supplies often decides over loss or victory. Your tireless efforts to resupply the resources keeps the war against the hive going.",
		name = "Supplier"
	},
	[268] = {
		points = 4,
		grade = 2,
		description = "You have become competent and efficient in gathering the substance that is needed to fight the hive. You almost smell like dissolved chitin and the Hive Born would tell their children scary stories about you if they could speak.",
		name = "Chitin Bane"
	},
	[269] = {
		points = 2,
		grade = 1,
		description = "You have proven that you can beat the best of the hive. You have caused first promising breaches in the defence of the hive",
		name = "Guard Killer"
	},
	[270] = {
		points = 3,
		grade = 1,
		description = "The most powerful warriors of the hive were killed by you by the dozens. The hive is not safe anymore because of your actions.",
		name = "Hive Infiltrator"
	},
	[271] = {
		points = 4,
		grade = 2,
		description = "Efficient and lethal, you have gained significant experience in fighting the elite forces of the hive. Almost single-handed, you have slain the best of the Hive Born and live to tell the tale.",
		name = "Exterminator"
	},
	[272] = {
		points = 2,
		grade = 1,
		description = "Even in the deepest structures of the hive, you began to strike against the mighty foe. Your actions probably already gave the hive a headache.",
		name = "Headache"
	},
	[273] = {
		points = 3,
		grade = 1,
		description = "The destruction you have caused by now can be felt throughout the whole hive. The mayhem that follows your step caused significant confusion in the consciousness of the hive.",
		name = "Confusion"
	},
	[274] = {
		points = 4,
		grade = 2,
		description = "You have destroyed a significant amount of the hive's vital nerve centers and caused massive destruction to the hive's awareness. You are probably causing the hive horrible nightmares.",
		name = "Manic"
	},
	[276] = {
		points = 5,
		grade = 2,
		name = "Navigational Error",
		description = "You confronted the Navigator.",
		secret = true
	},
	[277] = {
		points = 1,
		grade = 1,
		description = "You've found the oriental traveller Yasir and were able to trade with him - even if you didn't really understand his language.",
		name = "Si, Ariki!"
	},
	[278] = {
		points = 4,
		grade = 2,
		description = "You ended the life of over three hundred Deepling Guards. Not quite the guardian of the Deeplings, are you?",
		name = "Guardian Downfall"
	},
	[279] = {
		points = 3,
		grade = 1,
		description = "You hushed the songs of war in the black depths by sliencing more than three hundred Deepling Spellsingers.",
		name = "Death Song"
	},
	[280] = {
		points = 3,
		grade = 1,
		description = "By eliminating at least three hundred Deepling Warriors you delivered quite a blow to the amassing armies of the deep.",
		name = "Depth Dwellers"
	},
	[281] = {
		points = 1,
		grade = 1,
		name = "Gem Cutter",
		description = "You cut your first gem - and it bears your own name! Now that would be a nice gift! This does not make it a \"true\" Heart of the Sea, however...",
		secret = true
	},
	[282] = {
		points = 4,
		grade = 2,
		description = "You travelled the depths of this very world. You entered the blackness of the deep sea to conquer the realm of the Deeplings. May this suit remind you of the strange beauty below.",
		name = "Spolium Profundis"
	},
	[283] = {
		points = 2,
		grade = 1,
		description = "Countless fights and never tiring effort in the war against the hive grant you the experience to finish your outfit with the last remaining part. Your chitin outfit is a testament of your skills and dedication for the cause.",
		name = "Bane of the Hive"
	},
	[285] = {
		points = 1,
		grade = 1,
		description = "Your invaluable experience in fighting the hive allows you to add another piece of armor to your chitin outfit to prove your dedication for the cause.",
		name = "Hive War Veteran"
	},
	[286] = {
		points = 1,
		grade = 1,
		description = "You have participated that much in the hive war, that you are able to create some makeshift armor from the remains of dead hive born that can be found in the major hive, to show of your skill.",
		name = "Hive Fighter"
	},
	[287] = {
		points = 1,
		grade = 1,
		description = "You muted the everlasting howling of Hemming.",
		name = "Howly Silence"
	},
	[288] = {
		points = 1,
		grade = 1,
		description = "No more fear and bad dreams. You stabbed Tormentor to death with its scythe leg.",
		name = "Dream's Over"
	},
	[289] = {
		points = 1,
		grade = 1,
		description = "You wiped Fazzrah away - zzeemzz like now you're the captain.",
		name = "Zzztill Zzztanding!"
	},
	[290] = {
		points = 1,
		grade = 1,
		description = "This time you knocked out the big one.",
		name = "Stepped on a Big Toe"
	},
	[291] = {
		points = 1,
		grade = 1,
		description = "No joke, you murdered the bat.",
		name = "Kapow!"
	},
	[292] = {
		points = 2,
		grade = 1,
		description = "You gave zzze draken a tazte of your finizzzing move.",
		name = "Enter zze Draken!"
	},
	[293] = {
		points = 2,
		grade = 1,
		description = "Bretzecutioner's body just got slammed away. You are a true king of the ring!",
		name = "King of the Ring"
	},
	[294] = {
		points = 2,
		grade = 1,
		description = "You overcame the undead Zanakeph and sent him back into the darkness that spawned him.",
		name = "Back from the Dead"
	},
	[295] = {
		points = 8,
		grade = 3,
		name = "Pwned All Fur",
		description = "You've faced and defeated each of the mighty bosses the Paw and Fur society sent you out to kill. All by yourself. What a hunt!",
		secret = true
	},
	[297] = {
		points = 1,
		grade = 1,
		name = "Bibby's Bloodbath",
		description = "You lend a helping hand in defeating invading Orcs by destroying their warcamp along with their leader. Bibby's personal bloodbath...",
		secret = true
	},
	[298] = {
		points = 1,
		grade = 1,
		description = "You cleansed the land from an eight legged nuisance by defeating Mamma Longlegs three times. She won't be back soon... or will she?",
		name = "Nestling"
	},
	[299] = {
		points = 1,
		grade = 1,
		description = "You did it! You convinced the reclusive gnomes to accept you as one of their Bigfoots. Now you are ready to help them. With big feet big missions seen to come.",
		name = "Becoming a Bigfoot"
	},
	[300] = {
		points = 1,
		grade = 1,
		description = "You think the gnomes start to like you. A little step for a Bigfoot but a big step for humanity.",
		name = "Gnome Little Helper"
	},
	[301] = {
		points = 2,
		grade = 1,
		description = "The gnomes are warming up to you. One or two of them might actually bother to remember your name. You're allowed to access their gnomebase alpha. You are prepared to boldly put your big feet into areas few humans have walked before.",
		name = "Gnome Friend"
	},
	[302] = {
		points = 3,
		grade = 1,
		description = "You have become a household name in gnomish society! Your name is mentioned by gnomes more than once. Of course usually by gnomish mothers whose children refuse to eat their mushroom soup, but you are certainly making some tremendous progress.",
		name = "Gnomelike"
	},
	[303] = {
		points = 4,
		grade = 2,
		description = "You accomplished what few humans ever will: you truly impressed the gnomes. This might not change their outlook on humanity as a whole, but at least you can bathe in gnomish respect! And don't forget you're now allowed to enter the warzones!",
		name = "Honorary Gnome"
	},
	[304] = {
		points = 1,
		grade = 1,
		description = "You brought two loving crystals together. Perhaps they might even name one of their children after you. Too bad you forgot to leave your calling card.",
		name = "Crystals in Love"
	},
	[305] = {
		points = 1,
		grade = 1,
		description = "Ring-a-ding! You have visited the golem workshop and lent a hand in repairing them. To know those golems are safe is worth all the bruises, isn't it?",
		name = "Substitute Tinker"
	},
	[306] = {
		points = 1,
		grade = 1,
		description = "After hunting for the correct mushrooms and their spores you're starting to feel like a mushroom yourself. A few times more and you might start thinking like a mushroom, who knows?",
		name = "Spore Hunter"
	},
	[307] = {
		points = 1,
		grade = 1,
		description = "Burnt fingers and itching lungs are a small price for bringing those gnomes some lousy stone and getting almost killed! Your mother warned you to better become a farmer.",
		name = "Grinding Again"
	},
	[308] = {
		points = 3,
		grade = 1,
		name = "Dungeon Cleaner",
		description = "Seen it all. Done it all. Your unstoppable force swept through the dungeons and you vanquished their masters. Not to forget the precious loot you took! Now stop reading this and continue hunting! Time is money after all!",
		secret = true
	},
	[309] = {
		points = 1,
		grade = 1,
		description = "So you repaired the light of some crystals for those gnomes. What's next? Sitting a week in a mushroom bed as a temporary mushroom?",
		name = "Crystal Keeper"
	},
	[310] = {
		points = 1,
		grade = 1,
		description = "Admittedly you enjoyed the killing as usual. But the part with the sparks still gives you shivers ... or is it that there is some charge left on you?",
		name = "Call Me Sparky"
	},
	[311] = {
		points = 1,
		grade = 1,
		description = "One Bigfoot won over thousands of tiny feet. Perhaps the gnomes are wrong and size matters?",
		name = "One Foot Vs. Many"
	},
	[312] = {
		points = 1,
		grade = 1,
		description = "The gnomes decided their pigs need some exclusive diet and you had to do all the dirty work - but wasn't the piglet adorable?",
		name = "The Picky Pig"
	},
	[313] = {
		points = 4,
		grade = 2,
		name = "Diplomatic Immunity",
		description = "You killed the ambassador of the abyss that often that they might consider sending another one. Perhaps that will one day stop further intrusions.",
		secret = true
	},
	[314] = {
		points = 4,
		grade = 2,
		name = "Fall of the Fallen",
		description = "Have you ever wondered how he reappears again and again? You only care for the loot, do you? Gotcha!",
		secret = true
	},
	[315] = {
		points = 4,
		grade = 2,
		name = "Death on Strike",
		description = "Again and again Deathstrike has fallen to your prowess. Perhaps it's time for people calling YOU Deathstrike from now on.",
		secret = true
	},
	[316] = {
		points = 2,
		grade = 1,
		name = "Death from Below",
		description = "The face of the enemy is unmasked. You have encountered one of 'those below' and survived. More than that, you managed to kill the beast and prove once and for all that the enemy can be beaten.",
		secret = true
	},
	[317] = {
		points = 2,
		grade = 1,
		name = "Gnomebane's Bane",
		description = "The fallen gnome is dead and justice served. But what was it that the gnome whispered with his last breath? He's your father???",
		secret = true
	},
	[318] = {
		points = 2,
		grade = 1,
		name = "Final Strike",
		description = "The mighty Deathstrike is dead! One legend is dead and you're on your way to become one yourself.",
		secret = true
	},
	[319] = {
		points = 1,
		grade = 1,
		name = "Goo Goo Dancer",
		description = "Seeing a mucus plug makes your heart dance and you can't resist to see what it hides. Goo goo away!",
		secret = true
	},
	[320] = {
		points = 3,
		grade = 1,
		description = "Finally your dream to become a walking mushroom has come true ... No, wait a minute!",
		name = "Funghitastic"
	},
	[321] = {
		points = 3,
		grade = 1,
		description = "If the gnomes had told you that crystal armor is see-through you had probably changed your underwear in time.",
		name = "Crystal Clear"
	},
	[322] = {
		points = 3,
		grade = 1,
		description = "You have unleashed your inner gnome and slain some of the most fearsome threats that gnomekind has ever faced. Now you can come and go to the warzones as it pleases you. The enemies of gnomekind will never be safe again.",
		name = "Gnomish Art Of War"
	},
	[324] = {
		points = 5,
		grade = 2,
		name = "True Dedication",
		description = "You conquered the demon challenge and prevailed... now show off your success in style!",
		secret = true
	},
	[325] = {
		points = 2,
		grade = 1,
		name = "Task Manager",
		description = "Helping a poor, stupid goblin to feed his starving children and wifes feels good ... if you'd only get rid of the strange feeling that you're missing something.",
		secret = true
	},
	[326] = {
		points = 3,
		grade = 1,
		description = "Assisting Omrabas' sick plan to resurrect made you dig your way through the blood-soaked halls of Drefia. Maybe better he failed!",
		name = "Gravedigger"
	},
	[327] = {
		points = 1,
		grade = 1,
		name = "Repenter",
		description = "You cleansed your soul in serving the Repenter enclave and purified thine self in completing all tasks in a single day of labour.",
		secret = true
	},
	[328] = {
		points = 6,
		grade = 2,
		description = "You managed to transform, improve and sacrify your blade into a master state and have proven yourself worthy in a nightmarish world.",
		name = "Umbral Swordsman"
	},
	[331] = {
		points = 2,
		grade = 1,
		description = "You have helped the gnomes of the spike in securing the caves and explored enough of the lightles depths to earn you a complete cave explorers outfit. Well done!",
		name = "Cave Completionist"
	},
	[332] = {
		points = 6,
		grade = 2,
		description = "You managed to transform, improve and sacrify your slayer into a master state and have proven yourself worthy in a nightmarish world.",
		name = "Umbral Bladelord"
	},
	[333] = {
		points = 6,
		grade = 2,
		description = "You managed to transform, improve and sacrify your axe into a master state and have proven yourself worthy in a nightmarish world.",
		name = "Umbral Headsman"
	},
	[334] = {
		points = 6,
		grade = 2,
		description = "You managed to transform, improve and sacrify your chopper into a master state and have proven yourself worthy in a nightmarish world.",
		name = "Umbral Executioner"
	},
	[335] = {
		points = 6,
		grade = 2,
		description = "You managed to transform, improve and sacrify your mace into a master state and have proven yourself worthy in a nightmarish world.",
		name = "Umbral Brawler"
	},
	[336] = {
		points = 6,
		grade = 2,
		description = "You managed to transform, improve and sacrify your hammer into a master state and have proven yourself worthy in a nightmarish world.",
		name = "Umbral Berserker"
	},
	[337] = {
		points = 6,
		grade = 2,
		description = "You managed to transform, improve and sacrify your bow into a master state and have proven yourself worthy in a nightmarish world.",
		name = "Umbral Archer"
	},
	[338] = {
		points = 6,
		grade = 2,
		description = "You managed to transform, improve and sacrify your crossbow into a master state and have proven yourself worthy in a nightmarish world.",
		name = "Umbral Marksman"
	},
	[339] = {
		points = 6,
		grade = 2,
		description = "You managed to transform, improve and sacrify your spellbook into a master state and have proven yourself worthy in a nightmarish world.",
		name = "Umbral Harbinger"
	},
	[340] = {
		points = 8,
		grade = 3,
		description = "You managed to transform, improve and sacrify all kinds of weapons into a master state and have proven yourself worthy in a nightmarish world. Respect!",
		name = "Umbral Master"
	},
	[341] = {
		points = 3,
		grade = 1,
		name = "Nevermending Story",
		description = "You collected all of the mysterious bottle messages around the island of Roshamuul and located the remains of the first mate. Time will tell if his tale of mending an evil ring holds true.",
		secret = true
	},
	[342] = {
		points = 2,
		grade = 1,
		description = "What a scientific discovery - they really DO communicate! Using their own communication habits against them, you lured a large pack of silencers away from the walls of Roshamuul.",
		name = "Luring Silence"
	},
	[343] = {
		points = 3,
		grade = 1,
		description = "You did not show any signs of surrender to any sight of... you get the picture. Even a hundred of them did not pose a threat to you.",
		name = "Never Surrender"
	},
	[344] = {
		points = 1,
		grade = 1,
		description = "You have mended many a broken dream and so, the dream of Roshamuul is safely being told over and over again.",
		name = "Dream Wright"
	},
	[345] = {
		points = 2,
		grade = 1,
		description = "You have cleansed the lands of many retching horrors. You sure know how to end a bad dream: forcefully, that's how!",
		name = "Ending the Horror"
	},
	[346] = {
		points = 1,
		grade = 1,
		description = "You know your way, in dream and waking. And how to make tea that transcends the boundaries of conscience.",
		name = "Sleepwalking"
	},
	[347] = {
		points = 5,
		grade = 2,
		description = "It doesn't matter what noise you would hear... dream, nightmare, illusion - there is nothing you can't vanquish. You are a true Dream Warden.",
		name = "Dream Warden"
	},
	[348] = {
		points = 8,
		grade = 3,
		description = "Gaz'haragoth... a day to remember! Your world accomplished something really big - and you have been part of it!",
		name = "Prison Break"
	},
	[349] = {
		points = 6,
		grade = 2,
		description = "After a battle like this you know who your friends are.",
		name = "Noblesse Obliterated"
	},
	[350] = {
		points = 1,
		grade = 1,
		description = "Through the spirit of science and exploration, you have discovered how to enter the secret hideout of the renowned Dr Merlay.",
		name = "Elementary, My Dear"
	},
	[351] = {
		points = 1,
		grade = 1,
		description = "By having rendered numerous services to the city of Rathleton you have been promoted to the rank of Commoner.",
		name = "Rathleton Commoner"
	},
	[352] = {
		points = 1,
		grade = 1,
		description = "By having rendered numerous services to the city of Rathleton you have been promoted to the rank of Inhabitant.",
		name = "Rathleton Inhabitant"
	},
	[353] = {
		points = 1,
		grade = 1,
		description = "By having rendered numerous services to the city of Rathleton you have been promoted to the rank of Citizen.",
		name = "Rathleton Citizen"
	},
	[354] = {
		points = 1,
		grade = 1,
		name = "Combo Master",
		description = "You accomplished 10 or more consecutive chains in a row! That's killing at least 39 creatures in the correct order - now that's combinatorics!",
		secret = true
	},
	[355] = {
		points = 5,
		grade = 2,
		description = "Though you might have averted a dire threat for Rathleton, this relative peace may only hold for a while. At least you've scavenged an outfit from some of the poor fellows that have fallen prey to death priest Shagron.",
		name = "Glooth Engineer"
	},
	[356] = {
		points = 1,
		grade = 1,
		name = "Lion's Den Explorer",
		description = "You discovered the Lion's Rock, passed the tests to enter the inner sanctum and finally revealed the secrets of the buried temple. You literally put your head in the lion's mouth and survived.",
		secret = true
	},
	[357] = {
		points = 1,
		grade = 1,
		description = "Adventure is your middle name. You spent much time in dangerous lands and have seen things others only dream of. You know your way around in Tibia - you are a seasoned adventurer now. And your journey has only just begun!",
		name = "Seasoned Adventurer"
	},
	[358] = {
		points = 1,
		grade = 1,
		description = "You've got a mind ready to draw strange conclusions that defy the laws of logic and sidestep reality. Or maybe it's just a lucky guess - or adventurous recklessness?",
		name = "Mind the Step!"
	},
	[359] = {
		points = 1,
		grade = 1,
		description = "By having rendered numerous services to the city of Rathleton you have been promoted to the rank of Squire.",
		name = "Rathleton Squire"
	},
	[360] = {
		points = 3,
		grade = 1,
		description = "He seriously stored away a wallnut? That was a nutty professor indeed.",
		name = "The Professor's Nut"
	},
	[361] = {
		points = 4,
		grade = 2,
		name = "Plant vs. Minos",
		description = "You have defeated the wallbreaker and saved the glooth plant.",
		secret = true
	},
	[362] = {
		points = 4,
		grade = 2,
		name = "Rumble in the Plant",
		description = "You have defeated the tremor worm - and wonder what kind of fish you'd be able to catch with such a bait.",
		secret = true
	},
	[363] = {
		points = 4,
		grade = 2,
		name = "Robo Chop",
		description = "You have defeated the glooth bomb and chopped down a lot of metal monsters on your way.",
		secret = true
	},
	[364] = {
		points = 1,
		grade = 1,
		name = "Go with da Lava Flow",
		description = "You escaped the glowing hot lava death trap, Professor Maxxen has set for you - Captain Caveworm is indeed proud!",
		secret = true
	},
	[365] = {
		points = 1,
		grade = 1,
		name = "Wail of the Banshee",
		description = "You saw the Crystal Gardens with all their stunning beauty and survived the equally impressive monsters there. In the end you discovered a great evil and destroyed it with the help of a banshee who was not even aware of her support.",
		secret = true
	},
	[366] = {
		points = 1,
		grade = 1,
		description = "You are a man of the public. Or of good publicity at least. Through your efforts in advertising the airtight cloth, Zeronex might yet be redeemed - and Rathleton might yet see its first working Gloud Ship.",
		name = "Publicity"
	},
	[367] = {
		points = 1,
		grade = 1,
		description = "By restoring the Everhungry Altar, you charmed the Fire-Feathered Sea Serpent back into its fitful sleep, twenty miles beneath the sea.",
		name = "Snake Charmer"
	},
	[368] = {
		points = 1,
		grade = 1,
		name = "Hoard of the Dragon",
		description = "Your adventurous way through countless dragon lairs earned you a pretty treasure - and surely the enmity of many a dragon.",
		secret = true
	},
	[370] = {
		points = 1,
		grade = 1,
		description = "You found a lost sheep and thus a steady source of black wool. But careful: don't get entangled.",
		name = "Little Ball of Wool"
	},
	[371] = {
		points = 3,
		grade = 1,
		description = "You made some efforts to bring a little more light into the world. And what a nice present you got in return!",
		name = "Luminous Kitty"
	},
	[372] = {
		points = 1,
		grade = 1,
		description = "By setting the right tone you convinced a crystal wolf to accompany you. Remember it is made of crystal, though, so be careful in a banshee's presence.",
		name = "The Right Tone"
	},
	[373] = {
		points = 1,
		grade = 1,
		description = "Having a loyal friend alongside is comforting to every adventurer. If only this lad was not so stubborn...",
		name = "Loyal Lad"
	},
	[374] = {
		points = 2,
		grade = 1,
		description = "It's not really a dragon, but rather a kind of chimera. Nonetheless a decent mount to impress any passer-by.",
		name = "Dragon Mimicry"
	},
	[375] = {
		points = 2,
		grade = 1,
		description = "The Muggy Plains are a dangerous place, often raided by dragons. But that was your luck: thus you found this scaly little guy.",
		name = "Scales and Tail"
	},
	[376] = {
		points = 2,
		grade = 1,
		description = "There are many delusions and phantasms in the desert. You saw a false oasis with fruit-bearing palm trees. Instead of water and refreshment, however, you found a dromedary in the end. What a useful Fata Morgana!",
		name = "Fata Morgana"
	},
	[377] = {
		points = 3,
		grade = 1,
		description = "Finding all the pieces to this complicated vehicle was one kind of a challenge. However, what you built in the end is rather a fabled than a feeble construction.",
		name = "Fabled Construction"
	},
	[378] = {
		points = 2,
		grade = 1,
		description = "Barking dogs never bite, as the saying goes. But this one clearly tried. In the end, however, you were able to walk the dog - ahem, gnarlhound.",
		name = "Mind the Dog!"
	},
	[379] = {
		points = 2,
		grade = 1,
		description = "This magnetic beast attracted you in a very literal way. Or was it attracted by your metal equipment? Anyway, you seem to be stuck together now.",
		name = "Magnetised"
	},
	[380] = {
		points = 3,
		grade = 1,
		description = "Counting ten thousand grains of sand could not have been harder than gaining this impressive mount.",
		name = "Golden Sands"
	},
	[381] = {
		points = 1,
		grade = 1,
		description = "Kingly deer mostly prefer elves as friends and familiars. This one, however, decided to favour you as a confidant and rider. Well done!",
		name = "Friend of Elves"
	},
	[382] = {
		points = 3,
		grade = 1,
		description = "Finding a four-leaved clover is always a sign of luck. And as luck would have it, you even baited a lovely dotted ladybug. Lucky you!",
		name = "Lovely Dots"
	},
	[383] = {
		points = 2,
		grade = 1,
		description = "This fiery beast really tried to give you hell. But not even a magma crawler can resist a mug of spicy, hot glow wine. Skol!",
		name = "Way to Hell"
	},
	[384] = {
		points = 3,
		grade = 1,
		description = "Not really twenty thousand miles, but you had to dive a fair way beneath the sea to find your personal Manta Ray.",
		name = "Beneath the Sea"
	},
	[385] = {
		points = 3,
		grade = 1,
		description = "By many it is considered a myth like the Yeti. But you came, saw and tamed it. Now you're the proud rider of a midnight panther, black as a starless night.",
		name = "Starless Night"
	},
	[386] = {
		points = 1,
		grade = 1,
		description = "By mastering the secrets of Lion's Rock, you proved yourself worthy to face the mighty lions there. One of them even chose to accompany you.",
		name = "Lion King"
	},
	[387] = {
		points = 1,
		grade = 1,
		description = "Ah, the old carrot-on-a-stick trick. Well done! You've made the racing bird accept you as a rider and provider. Just don't feed it your fingers.",
		name = "Pecking Order"
	},
	[388] = {
		points = 2,
		grade = 1,
		description = "Whoa, sow long! This boar is like a force of nature, breaking through the undergrowth of all the Tibian forests and all records of speed. Hang on!",
		name = "Pig-Headed"
	},
	[389] = {
		points = 3,
		grade = 1,
		description = "It might come as a shock to you, but this is the mount of your dreams. Not exactly the white steed of Prince Charming, but maybe the ladies will still scream and faint at the sight of you.",
		name = "Personal Nightmare"
	},
	[390] = {
		points = 2,
		grade = 1,
		description = "It's unstoppable! Walls? Fortresses? Obstacles? Objections? Pah! Nothing will stand before the stampor. Arrows and spears bounce off its hide, enemies are trampled by the dozen. Just don't go for the subtle approach or a date on this thing.",
		name = "Thick-Skinned"
	},
	[391] = {
		points = 1,
		grade = 1,
		description = "Don't let its fluffy appearance deceive you. The panda is a creature of the wild. It will take you to the most distant regions of Tibia, always in hopes of a little bamboo to nibble on or to check on a possible mate.",
		name = "Chequered Teddy"
	},
	[392] = {
		points = 1,
		grade = 1,
		description = "Well, you can rest your nailcase now. This gravedigger's fingernails are nice and clean. Though after the next hellride, you might not want to let it hand any food to you.",
		name = "Blacknailed"
	},
	[393] = {
		points = 2,
		grade = 1,
		description = "Drugging a snail can have some beneficial side effects. You're now the proud owner of a snarling, speed-crazy slug. Maybe it'll purr if you stroke it. Anyway, life should be one slick ride from now on.",
		name = "Slugging Around"
	},
	[394] = {
		points = 3,
		grade = 1,
		description = "It's a wound-up wooden lizard! Well, stranger things have happened, or so you're told. Just hop on and let this wood-and-tin contraption take you anywhere you want to wind down a bit. And hope you don't get hit by lightning underway.",
		name = "Knock on Wood"
	},
	[395] = {
		points = 2,
		grade = 1,
		description = "This must be underwater love - this enormous crustacean now does thy bidding. Or maybe it's just in it for a little more of that shrimp barbecue, as that's a little hard to come by in the sea.",
		name = "Fried Shrimp"
	},
	[396] = {
		points = 3,
		grade = 1,
		description = "What a blast from the past! This thankful patient thinks you missed your dentist vocation. It's now ready to take a bite of the future and to carry you to your next adventure, or your next patient.",
		name = "Out of the Stone Age"
	},
	[397] = {
		points = 3,
		grade = 1,
		description = "A drop of oil and you're good to go. This unique mount will roll merrily in and out of any strange place you want to visit. If you see no exit, you probably ended up in a circus ring. Ah well, the show must go on!",
		name = "Stuntman"
	},
	[398] = {
		points = 3,
		grade = 1,
		description = "Installing that control unit was a no-brainer. Now you're in control to make it walk this way or that, or to change tack at any moment if required. Your faithful walker mount obeys your every command.",
		name = "Gear Up"
	},
	[399] = {
		points = 1,
		grade = 1,
		description = "Hunter's greeting! Your skillful use of the slingshot actually stunned a large bear. The creature is slightly dazed, but seems susceptible to your commands. Let's declare open season on all our foes!",
		name = "Bearbaiting"
	},
	[400] = {
		points = 1,
		grade = 1,
		description = "'Sweets for my steed' could be your motto. An impressive horse is eating out of your hand. Saddle up and be ready to find adventure, new friends, and maybe someone to shoe your horse now and then.",
		name = "Lucky Horseshoe"
	},
	[401] = {
		points = 1,
		grade = 1,
		description = "By cleverly using a leech to cool that raging bull's blood, you managed not to get swamped or trampled in a water buffalo stampede. The creature is now docile and follows your every command.",
		name = "Swamp Beast"
	},
	[402] = {
		points = 1,
		grade = 1,
		description = "Seems like this spider has got a sweet tooth. As a result, eight hairy legs are now at your disposal to crawl and weave at your whim, and strike fear into the hearts of men.",
		name = "Spin-Off"
	},
	[403] = {
		points = 1,
		grade = 1,
		description = "Here's looking at you, kid. This ancient creature seems to size you up with its brilliant eyes and barely tolerates you riding it. Maybe it thinks you're the defrosted snack, after all?",
		name = "Icy Glare"
	},
	[404] = {
		points = 2,
		grade = 1,
		description = "You succeeded in finding and charting several previously unexplored landmarks and locations for the Adventurer's Guild, you probably never need to ask anyone for the way - do you?",
		name = "Cartography 101"
	},
	[405] = {
		points = 2,
		grade = 1,
		name = "Lost Palace Raider",
		description = "Lifting the secrets of a fabulous palace and defeating a beautiful demon princess was a thrilling experience indeed. This site's marvels nearly matched its terrors. Nearly.",
		secret = true
	},
	[406] = {
		points = 0,
		grade = 1,
		name = "The More the Merrier",
		description = "It's dangerous to go alone... Take ten friends.",
		secret = true
	},
	[408] = {
		points = 3,
		grade = 1,
		description = "You went through hell. Seven times. You defeated the demons. Countless times. You put an end to Ferumbras claims to ascendancy. Once and for all.",
		name = "Rift Warrior"
	},
	[410] = {
		points = 5,
		grade = 2,
		description = "You sucessfully fought against all odds to protect your world from an ascending god! - You weren't there for the hat only after all?",
		name = "Hat Hunter"
	},
	[411] = {
		points = 1,
		grade = 1,
		description = "You didn't manage to become an ogre chief. But at least you are, beyond doubt, a worthy ogre chef.",
		name = "Ogre Chef"
	},
	[412] = {
		points = 2,
		grade = 1,
		description = "You opposed man-eating ogres and clumsy clomps. You grappled with hungry chieftains, desperate goblins and angry spirits. So you truly overcame the wild vastness of Krailos.",
		name = "The Call of the Wild"
	},
	[413] = {
		points = 5,
		grade = 2,
		description = "You have entered the heart of destruction and valiantly defeated the world devourer. By your actions you have postponed the end of the world — at least for a while.",
		name = "Ender of the End"
	},
	[414] = {
		points = 5,
		grade = 2,
		description = "After a long journey and dedication you were favoured by fortune and have tamed all three elusive beasts of the vortex. Unless the Vortexion decides you're a tasty morsel you can enjoy your small stable of ravaging beasts from beyond.",
		name = "Vortex Tamer"
	},
	[415] = {
		points = 1,
		grade = 1,
		description = "Don't forget, even your rhino sometimes needs a hug. A careful one in this case.",
		name = "Rhino Rider"
	},
	[416] = {
		points = 1,
		grade = 1,
		name = "Forbidden Fruit",
		description = "You could not resist the taste of the forbidden fruit. Since you don't feel changed at all, it couldn't have been that bad after all. Or could it?",
		secret = true
	},
	[417] = {
		points = 1,
		grade = 1,
		name = "Forbidden Knowledge",
		description = "Perhaps with so much acquired knowledge, never meant for you, you know even when to stop! Time will tell whether this knowledge will do more harm or good.",
		secret = true
	},
	[418] = {
		points = 3,
		grade = 1,
		name = "Treasure Hunter",
		description = "You wandered the world of Tibia in search of the ancient dragons' hoards. You are sure, you found them all.",
		secret = true
	},
	[419] = {
		points = 1,
		grade = 1,
		description = "You met the legendary First Dragon and survived. That's a reason to celebrate for sure.",
		name = "Reason to Celebrate"
	},
	[420] = {
		points = 1,
		grade = 1,
		description = "You assisted a very prominent fae and you fought tooth and nail to earn this title.",
		name = "Toothfairy Assistant"
	},
	[421] = {
		points = 1,
		grade = 1,
		name = "Fairy Teasing",
		description = "Teasing fairies is fun. They leave behind such pretty clouds of glittering dust when chased. Just hope they don't get you back for it.",
		secret = true
	},
	[422] = {
		points = 5,
		grade = 2,
		description = "You have managed to stall the worst incursion of corruption. Still this is just one battle won in an all out war for your world.",
		name = "Corruption Contained"
	},
	[430] = {
		points = 1,
		grade = 1,
		description = "You have fully unlocked 10 easy monsters in the cyclopedia.",
		name = "Little Adventure"
	},
	[431] = {
		points = 2,
		grade = 1,
		name = "Little Big Adventure",
		description = "You have fully unlocked 100 easy monsters in the cyclopedia.",
		secret = true
	},
	[432] = {
		points = 3,
		grade = 1,
		description = "You have fully unlocked 10 medium monsters in the cyclopedia.",
		name = "Contender"
	},
	[433] = {
		points = 4,
		grade = 2,
		name = "Serious Contender",
		description = "You have fully unlocked 100 medium monsters in the cyclopedia.",
		secret = true
	},
	[434] = {
		points = 5,
		grade = 2,
		description = "You have fully unlocked 10 hard monsters in the cyclopedia.",
		name = "Skilled Hunter"
	},
	[435] = {
		points = 6,
		grade = 2,
		name = "Master Hunter",
		description = "You have fully unlocked 100 hard monsters in the cyclopedia.",
		secret = true
	},
	[436] = {
		points = 1,
		grade = 1,
		description = "You have fully unlocked your very first monster in the cyclopedia.",
		name = "Hunting Permit"
	},
	[437] = {
		points = 5,
		grade = 2,
		description = "The Curse of the Full Moon transforms harmless citizens into feral beasts. But with your help, Edron and Cormaya are safe - fairly.",
		name = "Over the Moon"
	},
	[438] = {
		points = 1,
		grade = 1,
		description = "You defeated the Count of the Core and destroyed his lava pump!",
		name = "His Days are Counted"
	},
	[439] = {
		points = 1,
		grade = 1,
		description = "You defeated the Duke of the Depths and destroyed his lava pump!",
		name = "Duked It Out"
	},
	[440] = {
		points = 1,
		grade = 1,
		description = "You defeated the Baron from Below and destroyed his lava pump!",
		name = "Buried the Baron"
	},
	[441] = {
		points = 2,
		grade = 1,
		description = "The Baron from Below, Duke of the Depths and the Count of the Core are no more!",
		name = "Death in the Depths"
	},
	[442] = {
		points = 3,
		grade = 1,
		description = "You took the heat and defeated the Ancient Spawn of Morgathla!",
		name = "Scourge of Scarabs"
	},
	[443] = {
		points = 6,
		grade = 2,
		description = "Exploring the depths of Tibia can be a dangerous task. Surprisingly, some crude wood planks, rusty nails and a tinged pot can offer a sufficient protection against the creatures lurking in the deep.",
		name = "Cobbled and Patched"
	},
	[444] = {
		points = 3,
		grade = 1,
		description = "Putting this candle stump on your new mount was kind of a waiting game. You're even tempted to call it whack-a-mole. But in the end you found a loyal companion for your journeys into the depths.",
		name = "Up the Molehill"
	},
	[445] = {
		points = 1,
		grade = 1,
		name = "Master Debater",
		description = "You truly are the grand master of verbal debate! Now going forth and putting this wisdom to good use in everyday life... is probably debatable.",
		secret = true
	},
	[446] = {
		points = 2,
		grade = 1,
		name = "High and Dry",
		description = "You asked Captain Charles to take a shortcut quite a few times. Now you are all too familiar with desert islands all over Tibia.",
		secret = true
	},
	[447] = {
		points = 1,
		grade = 1,
		description = "Tall trees, deep forests and and the beauty of Ab'Dendriel - you really know every corner of the elven lands now.",
		name = "Elven Woods"
	},
	[448] = {
		points = 1,
		grade = 1,
		description = "Ancient battlefields, amazons and the glory of Carlin - you really know every corner of Queen Eloise's realm now.",
		name = "Long Live the Queen"
	},
	[449] = {
		points = 1,
		grade = 1,
		description = "Strong fortresses, sprawling woods and ivory towers - you really know every corner of Edron now.",
		name = "Stronghold of Edron"
	},
	[450] = {
		points = 1,
		grade = 1,
		description = "Vast mines, an orc fortress and the magnificence of Kazordoon - you really know every corner of North-Eastern Mainland now.",
		name = "Dwarven Mines"
	},
	[451] = {
		points = 1,
		grade = 1,
		description = "Old temples, a meadowy countryside and the splendour of Thais - you really know every corner of King Tibianus' realm now.",
		name = "All Hail the King"
	},
	[452] = {
		points = 1,
		grade = 1,
		description = "Damp swamps, a dry desert and the opulence of Venore - you really know every corner of Eastern Mainland now.",
		name = "Jewel in the Swamp"
	},
	[453] = {
		points = 1,
		grade = 1,
		description = "A vast steppe, voracious ogres and dried out salt seas - you really know every corner of Krailos now.",
		name = "The Ogre Steppe"
	},
	[454] = {
		points = 1,
		grade = 1,
		description = "Lush meadows, colourful fairies and sentient stones - you really know every corner of Feyrist now.",
		name = "Realms of Dreams"
	},
	[455] = {
		points = 1,
		grade = 1,
		description = "You have combed the desert and searched the pyramid city of Ankrahmun.",
		name = "Mummy's Dearest"
	},
	[456] = {
		points = 1,
		grade = 1,
		description = "You journeyed through Darashia and the sea of sand around it, while fighting the perils of the desert.",
		name = "Daraman's Footsteps"
	},
	[457] = {
		points = 1,
		grade = 1,
		description = "You have searched Port Hope and the jungle that thoroughly, that you are up to adoption by a friendly ape family.",
		name = "King of the Jungle"
	},
	[458] = {
		points = 1,
		grade = 1,
		description = "You've braved the perils of Yalahar and learned of its gloomy shadows of long gone greatness.",
		name = "Ancient Splendor"
	},
	[459] = {
		points = 1,
		grade = 1,
		description = "A pirate's haven and a burglar's hideout. You found your way around Liberty Bay and its surroundings - land, ho!",
		name = "Liberty Bay Watch"
	},
	[460] = {
		points = 1,
		grade = 1,
		description = "You have expelled the fog of the unknown from the islands of Svargrond. Maybe not as first, but that's not what matters in the end.",
		name = "Race to the Pole"
	},
	[461] = {
		points = 1,
		grade = 1,
		description = "From the southern steppe through the Dragonblaze Mountains and the Muggy Plains to the forbidden city of Razachai - you really know every corner of Zao now.",
		name = "Lizard Kingdom"
	},
	[462] = {
		points = 1,
		grade = 1,
		description = "Braving a hive full of unimaginable proportions and its grotesque creatures on the surface is only one side of Gray Beach. Your full trip of the island also included a dive into the black nothingness of the deep sea, facing the wrath of the Njey.",
		name = "Trip to the Beach"
	},
	[463] = {
		points = 1,
		grade = 1,
		description = "Glooth is the substance that powers a whole continent and all its weird inhabitants, workshops and factories. You travelled this strange smorgasbord of curiosities in its entirety - just in time for tea.",
		name = "Glooth Punk"
	},
	[464] = {
		points = 1,
		grade = 1,
		description = "A journey through a dreamscape of evil is no small feat. Yet you traversed the nightmarish lands of Roshamuul and live to tell the tale. Don't fall asleep now...",
		name = "Twisted Dreams"
	},
	[465] = {
		points = 3,
		grade = 1,
		description = "Though you couldn't prevent the theft of the godbreaker knowledge, you still managed to fight off the invasion of the library and to kill the scourge of oblivion, a powerful servant of the enemy.",
		name = "Library Liberator"
	},
	[466] = {
		points = 1,
		grade = 1,
		name = "Spectulation",
		description = "You checked out a strange temple deep in the jungles of Tiquanda. Spectulus was right, it was indeed overrun by strange fish-men you now call Deathlings.",
		secret = true
	},
	[467] = {
		points = 3,
		grade = 1,
		name = "Millennial Falcon",
		description = "You defeated Grand Master Oberon and the remnants of the Order of the Falcon, no matter the odds.",
		secret = true
	},
	[468] = {
		points = 3,
		grade = 1,
		description = "You passion for reading was somewhat diminished by biting books and aggressive quills. But this flying specimen proved to be a loyal companion. Never judge a book by its cover!",
		name = "Bibliomaniac"
	},
	[469] = {
		points = 6,
		grade = 2,
		description = "Wielding dangerous knowledge as well as the sword is your expertise. You have proven yourself versatile in all manner of situations.",
		name = "Battle Mage"
	},
	[470] = {
		points = 7,
		grade = 3,
		description = "As a true globetrotter you can now show your colours proudly with this extraordinary outfit.",
		name = "Widely Travelled"
	},
	[471] = {
		points = 3,
		grade = 1,
		description = "You don't just have a permission to ride a rift runner, you literally went through hell and earned it!",
		name = "Running the Rift"
	},
	[473] = {
		points = 2,
		grade = 1,
		description = "Not only did you master the battlefield as a mage, you were also induced to the most inner secrets of the art of magical warfare and prevailed.",
		name = "Exalted Battle Mage"
	},
	[474] = {
		points = 3,
		grade = 1,
		name = "Areas of Effect",
		description = "Wisely contributing your resources to areas, you pushed creatures to maximum effect, allowing improved respawn for everyone! Well done!",
		secret = true
	},
	[475] = {
		points = 1,
		grade = 1,
		name = "Tied the Knot",
		description = "You figured out the right order of spells in the buried cathedral, how enchanting!",
		secret = true
	},
	[476] = {
		points = 2,
		grade = 1,
		description = "You found the Seven Keys to unlock ... no, not the seven seas. But at least seven doors in the realm of dreams.",
		name = "Keeper of the 7 Keys"
	},
	[477] = {
		points = 6,
		grade = 2,
		description = "You became an acquaintance of the courts of dreams and acquired the right to display your new status and title of 'dream warrior'.",
		name = "Dream Warrior"
	},
	[478] = {
		points = 3,
		grade = 1,
		description = "Your lantern was too bewitching for a hibernal moth. It couldn't withstand and follows you, the bearer of the lantern, now.",
		name = "Moth Whisperer"
	},
	[479] = {
		points = 3,
		grade = 1,
		description = "You caught a lacewing moth with your lantern. It will follow you in companionship as the bearer of the lantern will be its guide through the darkness now.",
		name = "Lacewing Catcher"
	},
	[480] = {
		points = 3,
		grade = 1,
		description = "This sleigh is not driven by magic but pushed by a percht. Hopefully you two get along well together...!",
		name = "No Horse Open Sleigh"
	},
	[481] = {
		points = 6,
		grade = 2,
		description = "But can you truly be one of them?",
		name = "Raider in the Dark"
	},
	[482] = {
		points = 3,
		grade = 1,
		description = "You are the slayer of the ancient nightmare beast and prevented the nightmare to spread its madness.",
		name = "Dream Catcher"
	},
	[483] = {
		points = 2,
		grade = 1,
		name = "Champion of Summer",
		description = "You have vanquished numerous arena champions in the name of the Summer Court.",
		secret = true
	},
	[484] = {
		points = 2,
		grade = 1,
		name = "Champion of Winter",
		description = "You have vanquished numerous arena champions in the name of the Winter Court.",
		secret = true
	},
	[486] = {
		points = 5,
		grade = 2,
		name = "Bewitcher",
		description = "You literally put everything in that cauldron except lilac and gooseberries.",
		secret = true
	},
	[487] = {
		points = 3,
		grade = 1,
		description = "Unmasking spies, killing demons, discovering omens, solving puzzles and fighting ogres, manticores and feral sphinxes. - Nobody said it was easy to become a gryphon rider.",
		name = "Gryphon Rider"
	},
	[488] = {
		points = 2,
		grade = 1,
		name = "Sculptor Apprentice",
		description = "Granted, you didn't carve those lifelike animal figurines yourself. But helping a medusa to find proper objects and even watching her using her petrifying gaze is almost as rewarding.",
		secret = true
	},
	[489] = {
		points = 5,
		grade = 2,
		description = "You made sure that the balance of sun and sea is preserved in Kilmaresh. The Golden City of Issavi won't forget your favour.",
		name = "Sun and Sea"
	},
	[490] = {
		points = 3,
		grade = 1,
		name = "A Study in Scarlett",
		description = "You ended the regn of Scarlett Etzel. All-seeing yet blind, ever powerful yet ultimately helpless, she never got a second chance to truly see. Or has she...",
		secret = true
	},
	[491] = {
		points = 1,
		grade = 1,
		name = "Avid Spectral Reader",
		description = "What draws things to other dimensions, one wonders. You read the almanac at just the right spot to end up... where, of all places? That is the problem with dimensional travel: you will never know. Or you have always known. And everything in between.",
		secret = true
	},
	[492] = {
		points = 1,
		grade = 1,
		name = "Hippofoddermus",
		description = "You did the hippo population of Kilmaresh a great favour. A well-fed hippo is a happy hippo.",
		secret = true
	},
	[493] = {
		points = 3,
		grade = 1,
		description = "You defeated the Lich Knights and became the hand of the Inquisition, allowed to wear their special garb.",
		name = "Inquisition's Hand"
	},
	[494] = {
		points = 1,
		grade = 1,
		description = "Mythical creatures, forgotten catacombs and the Golden City - you really know every corner of Kilmaresh now.",
		name = "The Empire's Glory"
	},
	[495] = {
		points = 2,
		grade = 1,
		description = "Your special garb, solely awarded to a dedicated Hand of the Inquisition, is now complete.",
		name = "Inquisition's Arm"
	},
	[496] = {
		points = 6,
		grade = 2,
		description = "You proudly wear the traditional Orcsoberfest garb, same as it ever was and as it always will be.",
		name = "Traditionalist"
	},
	[497] = {
		points = 3,
		grade = 1,
		description = "Riding a traditional beer barrel from the Orcsoberfest is a once-in-a-lifetime experience. Beer sold separately.",
		name = "Do a Barrel Roll!"
	},
	[499] = {
		points = 3,
		grade = 1,
		name = "Orcsoberfest Welcome",
		description = "The Orcsoberfest is not only known for its traditional food, beer and customs but also fun events and excitement! You took part in all of that and can now truly say: \"I survived!\"",
		secret = true
	},
	[500] = {
		points = 1,
		grade = 1,
		name = "Prospectre",
		description = "You made acquaintance with the Thaian. A strange contemporary with a dark history. No man but a derivate of greed and obsession.",
		secret = true
	},
	[501] = {
		points = 3,
		grade = 1,
		description = "You have tamed the ghostly mists to do your bidding. For now ...",
		name = "Nothing but Hot Air"
	},
	[502] = {
		points = 1,
		grade = 1,
		description = "And so it begins!",
		name = "Verminbane"
	},
	[503] = {
		points = 2,
		grade = 1,
		description = "Fear me, monsters! There is some more slaying to come!",
		name = "Monsterhunter"
	},
	[504] = {
		points = 3,
		grade = 1,
		description = "Having hunted and bested them all, you live for the thrill of the hunt!",
		name = "Taskmaster"
	},
	[505] = {
		points = 2,
		grade = 1,
		description = "Now you are able to wander around Tibia wearing an angst-inducing vestment.",
		name = "Mainstreet Nightmare"
	},
	[506] = {
		points = 2,
		grade = 1,
		description = "A true beastmaster learns the language of his animal companions. Now you as well can bolster your unique bond with nature and help preserve the balance of life as a proud falconer.",
		name = "Falconer"
	},
	[507] = {
		points = 3,
		grade = 1,
		description = "Champion of the wildlands, a swift strider among the creatures of the wild. The elegant nature of the gallop, this envoy of speed has mastered, indicates the precise understanding of its terrain and environment.",
		name = "Steppe Elegance"
	},
	[508] = {
		points = 3,
		grade = 1,
		description = "Adventurous beyond death, you travelled the Netherworld. Although you had just the ghost of a chance you survived and even came back from the realm of the dead.",
		name = "Beyonder"
	},
	[510] = {
		points = 3,
		grade = 1,
		description = "If a pride of lions and a pack of hyaenas feud, it is not called a catfight but a ... whatsoever. For sure, it caused a lot of drama in the Darama Desert.",
		name = "Drama in Darama"
	},
	[511] = {
		points = 1,
		grade = 1,
		name = "Malefitz",
		description = "Made acquaintance with three brothers Fitz.",
		secret = true
	},
	[512] = {
		points = 3,
		grade = 1,
		description = "You bested the maleficent duo Drume and Fugue and restored order to the besieged town of Bounac. You conquered the exotic stronghold of the Order of the Cobra and bested the undead knights of the Order of the Falcon. A true knight in heart and mind.",
		name = "Lionheart"
	},
	[513] = {
		points = 10,
		grade = 4,
		description = "Brought back to the realm of the living this magnificent creature will carry you through death and everything that lays beyond.",
		name = "Soul Mender"
	},
	[514] = {
		points = 8,
		grade = 3,
		description = "Brought back to the realm of the living this magnificent creature will carry you through death and everything that lays beyond.",
		name = "You Got Horse Power"
	},
	[515] = {
		points = 8,
		grade = 3,
		description = "You defeated the manifestation of Goshnar's evil traits by fighting your way through beasts you didn't even want to imagine. It transformed you and now you can also look the part.",
		name = "Unleash the Beast"
	},
	[516] = {
		points = 1,
		grade = 1,
		description = "You helped Domizian and thus proved yourself worthy to enter the werelion sanctum underneath Lion's Rock. You faced the mighty werelions there and one of the rare white lions even chose to accompany you.",
		name = "Well Roared, Lion!"
	},
	[518] = {
		points = 2,
		grade = 1,
		description = "When in Rascacoon, do as the Rascoohans do!",
		name = "Honorary Rascoohan"
	},
	[519] = {
		points = 3,
		grade = 1,
		description = "Riding around on this squishy companion gives you the feeling of flying through the air... uhm... swimming through the seven seas!",
		name = "Release the Kraken"
	},
	[521] = {
		points = 3,
		grade = 1,
		name = "Pied Piper",
		description = "You are not exactly the Pied Piper of Hamelin but at least you managed to fend off a decent amount of pirats and helped to keep them out of the cities.",
		secret = true
	},
	[522] = {
		points = 3,
		grade = 1,
		name = "Woodcarver",
		description = "You defeated Megasylvan Yselda in the wake of the sleeping carnisylvan menace deep under Bounac.",
		secret = true
	},
	[523] = {
		points = 2,
		grade = 1,
		name = "Bounacean Chivalry",
		description = "Yselda forever stands watch against the carnisylvan menace. Ever awake, waiting in the dark, her heart longs to be united with her king once again. Deep empathy let a hero to bring her Kesar's tulip as a token of his love. That hero was you.",
		secret = true
	},
	[524] = {
		points = 3,
		grade = 1,
		description = "Your thirst for knowledge is insatiable. In the task of helping your gnomish friends, flawless execution is just the icing on the cake.",
		name = "Knowledge Raider"
	},
	[525] = {
		points = 2,
		grade = 1,
		description = "It was not the first time that you helped the Sapphire Blade or the Midnight Flame with a difficult task. You may now wear the Kilmareshian robes as well as the tagralt blade and the eye-embroidered veil of the seers as a sign of Issavi's gratitude.",
		name = "Citizen of Issavi"
	},
	[526] = {
		points = 0,
		grade = 1,
		description = "Your continued efforts in keeping Bounac and the people of Kesar the Younger safe, earned you a permanent place at the royal court as an advisor to the king.",
		name = "King's Council"
	},
	[527] = {
		points = 3,
		grade = 1,
		description = "Since it is fireproof, this flaming creature feels right at home in raging infernos. But remember: just because it doesn't burn, you still do!",
		name = "Hot on the Trail"
	},
	[528] = {
		points = 3,
		grade = 1,
		description = "Equipped with the shell of a tortoise and claws of a lobster this insect like companion will help you through every hardship.",
		name = "Shell We Take a Ride"
	},
	[529] = {
		points = 3,
		grade = 1,
		description = "This mighty pachyderm will march into battle as if just taking its Sunday stroll. The cost of friendship was only a few drome points!",
		name = "Phantastic!"
	},
	[530] = {
		points = 2,
		grade = 1,
		description = "You have braved the searing heat in the tunnels deep below Kazordoon and vanquished the Brainstealer. The voices inside your head are finally silenced.",
		name = "Some Like It Hot"
	},
	[531] = {
		points = 1,
		grade = 1,
		name = "First Achievement",
		description = "Congratulations to your very first achievement! ... Well, not really. But imagine, it is. Because at this point during your journey into Tibia's past, achievements have been introduced.",
		secret = true
	},
	[532] = {
		points = 2,
		grade = 1,
		description = "Just everyone will be crazy about you if you are wearing this formal dress. They will come running, promise!",
		name = "Sharp Dressed"
	},
	[533] = {
		points = 3,
		grade = 1,
		description = "This glooth-driven locomotive will bring you to any party in the blink of an eye.",
		name = "Engine Driver"
	},
	[534] = {
		points = 2,
		grade = 1,
		description = "You mastered the fire and tamed a supervulcano!",
		name = "Friendly Fire"
	},
	[535] = {
		points = 3,
		grade = 1,
		description = "Alas! What could be more beautiful and satisfying than bringing two loving hearts together? So romantic!",
		name = "Wedding Planner"
	},
	[536] = {
		points = 1,
		grade = 1,
		description = "You really were as busy as a beaver in order to help the nagas. Enjoy some eager company!",
		name = "Beaver Away"
	},
	[537] = {
		points = 1,
		grade = 1,
		description = "Mysterious nagas, a vibrant jungle and a sinking island - you really know every corner of Marapur now.",
		name = "Snake Pit"
	},
	[538] = {
		points = 1,
		grade = 1,
		description = "For some it can't be hazardous enough.",
		name = "Royalty of Hazard"
	},
	[539] = {
		points = 2,
		grade = 1,
		description = "Step by step you discovered many of the secrets hidden in the world, thus gaining the right to wear the Discoverer outfit and hat. Made-to-measure for a brave traveller of the Tibian wilds.",
		name = "Measuring the World"
	},
	[540] = {
		points = 3,
		grade = 1,
		description = "Don't get carried away by your success. Get carried away by your Ripptor.",
		name = "Ripp-Ripp Hooray!"
	},
	[541] = {
		points = 2,
		grade = 1,
		description = "Combining unabating courage in combat and respect for the traditions and culture of the ancient Iks earned you the honours of true Aucar.",
		name = "Warrior of the Iks"
	},
	[542] = {
		points = 2,
		grade = 1,
		description = "You accomplished the impossible and created 16 mutagens of corresponding colours.",
		name = "Mutagenius"
	},
	[543] = {
		points = 3,
		grade = 1,
		description = "Only its rider can love this abomination of a mount.",
		name = "Strangest Thing"
	},
	[544] = {
		points = 2,
		grade = 1,
		description = "You defeated the embodiments of decay and live to tell the tale, wear the rotting attire of the unfaltering defender proudly.",
		name = "Fully Decayed"
	},
	[545] = {
		points = 3,
		grade = 1,
		description = "Sly as a fox, quiet as a mouse - the perfect mount for a stealthy foray.",
		name = "Like Fox and Mouse"
	},
	[546] = {
		points = 3,
		grade = 1,
		description = "Withstanding both filth and desolation of the rotten darkness that corrupted the very core of this world, you embodied the weapon of purity and light to defy all that was tainted. This spirit will continue guide you on all future paths.",
		name = "The Spirit of Purity"
	},
	[547] = {
		points = 2,
		grade = 1,
		description = "You unveiled the secret plot of the Mitmah who stole away an entire civilisation for their own entertainment. Let the death of their outpost vanguard be an eternal lesson to them.",
		name = "Museum Goer"
	},
	[548] = {
		points = 3,
		grade = 1,
		description = "Proving your true worth to a mystic creature like the jaguar, king of the hunt, granted you not only respect but also its heart.",
		name = "Mystic Predator"
	},
	[549] = {
		points = 2,
		grade = 1,
		description = "You almost feel as cool as a raccoon. Now, where's the trash?",
		name = "The Rule of Raccool"
	}
}

function Cyclopedia.formatGold(value)
	local number = tostring(value)

	number = string.reverse(number)
	number = string.gsub(number, "(%d%d%d)", "%1,")
	number = string.reverse(number)

	if string.sub(number, 1, 1) == "," then
		number = string.sub(number, 2)
	end

	return number
end

function Cyclopedia.calculateCombatValues(percent)
	percent = tonumber(percent) or 100

	local values = {}

	if percent == 0 then
		values.color = "#AE0F0F"
		values.tooltip = "0% (immune)"
	elseif percent < 100 then
		values.color = "#E4C00A"
		values.tooltip = percent .. "% (strong)"
	elseif percent == 100 then
		values.color = "#FFFFFF"
		values.tooltip = "100% (neutral)"
	else
		values.color = "#18CE18"
		values.tooltip = percent .. "% (weak)"
	end

	if percent > 100 then
		values.margin = 15 + (125 - percent) * 0.28
	else
		values.margin = 22 + (100 - percent) * 0.21
	end

	if values.margin < 0 then
		values.margin = 0
	elseif values.margin > 65 then
		values.margin = 65
	end

	return values
end

local function sortSaleRowsByLocationThenName(rows)
	table.sort(rows, function(a, b)
		local locA = string.lower(a.value.various and "Various Locations" or a.value.location or "")
		local locB = string.lower(b.value.various and "Various Locations" or b.value.location or "")

		if locA ~= locB then
			return locA < locB
		end

		return string.lower(a.name) < string.lower(b.name)
	end)
end

function Cyclopedia.formatSaleData(data)
	local s, b = {}, {}
	local sell, buy = {}, {}

	for i = 1, #data do
		local value = data[i]

		if value then
			if value.salePrice > 0 then
				if s[value.name] and value.name == "Rashid" then
					s[value.name].various = true
				end

				if not s[value.name] then
					local formated = {
						various = false,
						price = value.salePrice,
						location = value.location
					}

					s[value.name] = formated
				end
			end

			if value.buyPrice > 0 then
				if b[value.name] and value.name == "Rashid" then
					b[value.name].various = true
				end

				if not b[value.name] then
					local formated = {
						various = false,
						price = value.buyPrice,
						location = value.location
					}

					b[value.name] = formated
				end
			end
		end
	end

	local sellRows = {}

	for name, value in pairs(s) do
		table.insert(sellRows, {
			name = name,
			value = value
		})
	end

	sortSaleRowsByLocationThenName(sellRows)

	for _, row in ipairs(sellRows) do
		local name, value = row.name, row.value

		if value.various then
			table.insert(sell, string.format("%s gp, %s\nResidence: %s", Cyclopedia.formatGold(value.price), name, "Various Locations"))
		else
			table.insert(sell, string.format("%s gp, %s\nResidence: %s", Cyclopedia.formatGold(value.price), name, value.location))
		end
	end

	local buyRows = {}

	for name, value in pairs(b) do
		table.insert(buyRows, {
			name = name,
			value = value
		})
	end

	sortSaleRowsByLocationThenName(buyRows)

	for _, row in ipairs(buyRows) do
		local name, value = row.name, row.value

		if value.various then
			table.insert(buy, string.format("%s gp, %s\nResidence: %s", Cyclopedia.formatGold(value.price), name, "Various Locations"))
		else
			table.insert(buy, string.format("%s gp, %s\nResidence: %s", Cyclopedia.formatGold(value.price), name, value.location))
		end
	end

	return sell, buy
end

function Cyclopedia.compareItems(item1, item2)
	local name1 = item1.nameLower

	if not name1 then
		if item1.name then
			name1 = item1.name:lower()
		else
			name1 = string.lower(Cyclopedia.getItemDisplayName and Cyclopedia.getItemDisplayName(item1) or item1.getName and item1:getName() or "")
		end
	end

	local name2 = item2.nameLower

	if not name2 then
		if item2.name then
			name2 = item2.name:lower()
		else
			name2 = string.lower(Cyclopedia.getItemDisplayName and Cyclopedia.getItemDisplayName(item2) or item2.getName and item2:getName() or "")
		end
	end

	return name1 < name2
end

function Cyclopedia.hasHandedFilter(categoryId)
	local ids = {
		17,
		18,
		19,
		20,
		21,
		1000
	}

	if table.contains(ids, categoryId) then
		return true
	end

	return false
end

function Cyclopedia.hasClassificationFilter(categoryId)
	local ids = {
		1,
		24,
		7,
		15,
		17,
		18,
		19,
		20,
		21,
		1000
	}

	if table.contains(ids, categoryId) then
		return true
	end

	return false
end

Cyclopedia.House.Data = {}

local combatStates = {
	CLIENT_COMBAT_FIRE = 1,
	CLIENT_COMBAT_PHYSICAL = 0,
	CLIENT_COMBAT_MANADRAIN = 10,
	CLIENT_COMBAT_LIFEDRAIN = 9,
	CLIENT_COMBAT_DROWN = 8,
	CLIENT_COMBAT_HEALING = 7,
	CLIENT_COMBAT_DEATH = 6,
	CLIENT_COMBAT_HOLY = 5,
	CLIENT_COMBAT_ICE = 4,
	CLIENT_COMBAT_ENERGY = 3,
	CLIENT_COMBAT_EARTH = 2
}

Cyclopedia.clientCombat = {}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_PHYSICAL] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-physical-resist",
	id = "Physical"
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_FIRE] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-fire-resist",
	id = "Fire"
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_EARTH] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-earth-resist",
	id = "Earth"
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_ENERGY] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-energy-resist",
	id = "Energy"
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_ICE] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-ice-resist",
	id = "Ice"
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_HOLY] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-holy-resist",
	id = "Holy"
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_DEATH] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-death-resist",
	id = "Death"
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_HEALING] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-healing-resist",
	id = "Healing"
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_DROWN] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-drowning-resist",
	id = "Drown"
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_LIFEDRAIN] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-lifedrain-resist",
	id = "Lifedrain "
}
Cyclopedia.clientCombat[combatStates.CLIENT_COMBAT_MANADRAIN] = {
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-manadrain-resist",
	id = "Manadrain"
}
