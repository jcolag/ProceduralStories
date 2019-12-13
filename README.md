# ProceduralStories
Various experiments in procedural storytelling

For a long time, I've been interested in generating stories, either for the purposes of conducting a game or having an unlimited variety of stories available for various purposes.  Recently, I have finally started thinking about the implementation of a lot of these ideas, and this repository will contain these implementations as I attempt to make them work.

There are four broad parts of story generation that I have been looking at.

 - Character generation and motivation
 - Plot generation
 - Action resolution
 - Dialogue generation

Action resolution will probably (mostly) receive the least attention, since that's a well-studied problem through games.  And dialogue generation is, of course, an extremely difficult, well-studied, and maybe beyond the ability of algorithms to do in any reasonable way.

## Character Generation

There are quite a few ways to procedurally generate interesting information about a character.  A few come immediately to mind.

### Astrological Generation (`astrochar.ex`)

The first pass on character creation is a very, very old (and never researched) concept of mine to use the character's random birthday to generate an astrological profile in the European style.  Despite astrology being pseudoscience, the techniques are mostly straightforward and can be used as if the original classical planets are meaningful as people have thought, extended with modern planets, or use a completely original model of the solar system.  Likewise, the generated content could be vague personality traits or very specific abilities.  Since Kepler's laws of planetary motion are likely to be universal and the results (bluntly) meaningless except in a fictional setting, the same principles apply in all cases.

At heart, `astrochar.ex` is a sort of orrery, attempting to mimic [Kepler's laws](https://en.wikipedia.org/wiki/Kepler's_laws_of_planetary_motion) to track the planets against a background of astrological (or other) signs.

It will start with the features of [Western astrology](https://en.wikipedia.org/wiki/Western_astrology) and presumably incorporate other traditions.  The result _should_ be, based on a birthday, a rough character personality concept and a daily situation.


### Background Generation (`people/generate.js`)

An obvious problem in creating characters is in diversifying backgrounds, especially when it's far easier to assume that everybody looks like one's neighbors.  American sitcoms come to mind as a strong example, where a viewer can still somehow watch a show set in an urban center where ten out of ten people just happen to be white people in their twenties.

`generate`, then, guesses at a random person on Earth, to take advantage of the full scope of diversity on the planet.

In short, the program uses a population density map from Columbia University's [SEDAC](http://sedac.ciesin.columbia.edu/data/set/gpw-v4-population-density-rev10/data-download) to find a random latitude and longitude, then uses that information to find the country best represented by that location and the five nearest cities.

Note that:

 * Because of the rectangular projection used by the SEDAC maps, it's surprisingly common for selected coordinates to be out in the ocean or for the nearest cities to all be in a different country.
 * One degree of longitude by one degree of latitude is a _big_ space, but that map is used because the file has a reasonable size.  In the downloads at the SEDAC site, you can also find maps whose cells are one kilometer by one kilometer.  The existing code should at least _mostly_ work for those.
 * A handful of countries recognized by SEDAC are not recognized by the rest of the world.

Given a country, then, `generate` uses the JSON conversion of the [CIA World Factbook](https://github.com/iancoleman/cia_world_factbook_api) and other data to create a random skeletal background for the target person based on the country, including:

 * Age range
 * Gender Identity and Sexuality
 * Religion
 * Ethnicity
 * Literacy
 * Average Skin Tone for the Region
 * Languages Spoken
 * Physical impairments and psychological disorders
 * A random name

Because the data is on the national level, the religion, ethnicity, and language information do _not_ necessarily correlate appropriately with each other or with location.  To explain, here's one example.

```
28S 46W 🌎 : Brazil 🇧🇷 (76)
 Lagoa, 26, BR (-27.60491, -48.46713) 240.974km
 Rio Tavares, 26, BR (-27.64529, -48.47486) 241.262km
 Pantano do Sul, 26, BR (-27.77972, -48.50861) 243.4km
 Armação, 26, BR (-27.74963, -48.50713) 243.55km
 Itacorubi, 26, BR (-27.58315, -48.49503) 244.33km
 > Republica Federativa do Brasil
 > Male ♂ (bisexual 🏳️‍🌈), age 25 to 54, Spiritist 👻 (2.2%), mulatto (43.1%)
 > Possible name:  "Diego Montes"
 > Average regional skin tone: #3B3A29 👋🏿
 > Living with: ♿ Hearing (3.6%) impairments
 > Coping with: 🧠 Social Phobia (6.8%)
 > Literate 📚 (92.2%)
```

In this case, we've generated someone in a tiny religious minority and a large ethnic minority, so he's a perfect example.  The position is in (or near) Rio de Janeiro, Brazil.  Are the "mulattos" (local term with a specific connotation, not the offensive English term) sufficiently represented around Rio to be likely?  Is there any overlap with Spiritists?  Do Spiritists tend to be in the 25 to 54 age bracket?  Unless you know the area well, it would take research to know definitively, and it's probably beyond the scope of this project.

Ideally, this part of the generation would use each individual country's census information, but finding and packaging census information for every country in the world would require a prohibitive level of effort.

Along similar lines, in a sense, is the city database listing only cities above a certain population.  This will frequently show cities in nearby countries, if the city is across the border.  And in some extreme cases (for example, a low-population island), the "nearest city" might be thousands of miles away.

One additional problem (illustrated above) is the skin tone.  This is based on a [Luschan Skin Color Map](https://commons.wikimedia.org/wiki/Category:Human_skin_color#/media/File:Unlabeled_Renatto_Luschan_Skin_color_map.png) by [Dark Tichondrias](https://en.wikipedia.org/wiki/User:Dark_Tichondrias) on Wikimedia Commons (licensed [CC-BY-SA](http://creativecommons.org/licenses/by-sa/3.0/)).  As a conceptual artifact, such maps are necessarily outdated (this uses 1940 data) and reductive (it hides minority populations), but here we see the additional wrinkle that coastal regions have a tendency to show as water (#A4B2E2) or a latitude line (#000000), at which point the algorithm starts searching in concentric squares for a non-water point or bombing out to report its maximum radius in pixels.  There still may be cases where the _legend_ is detected instead of a land mass, though.  Regardless, it's a starting point to help visualize the person.

Likewise, there isn't official, compiled reporting on non-binary gender populations, so the gender is limited to "male" and "female," with an attempt to apply very broad average representation on top of the binary.  The same (extremely weak) technique is used to include representation for people living with psychiatric disorders and physical impairments, who collectively make up a large part of the population.

Names are only the barest recommendation, relying on the data (but not the API, to prevent overloading their servers) for [UINames](https://uinames.com/), which can be found [here](https://raw.githubusercontent.com/thm/uinames/master/names.json) and proposed contributions (available under the [MIT License](https://opensource.org/licenses/MIT)) and should probably be refreshed periodically as the maintainers add countries and names.  Note that UINames only currently supports given name/surname pairs (reversed, for many East Asian countries) and knows nothing about different forms of name, and of course carries the same culture-blindness as the ethnicity/religion estimates.  In this case, "Diego Montes" sounds plausible, but in some cases, a name might be ignoring long-standing traditions and come off as insensitive or tone deaf.  As an obvious example for English speakers, it's possible to generate a name like "Thomas Thomas" in several countries, even though it's a highly unlikely combination.

At some point, it might be worth investigating how to navigate and parse Wiktionary's [names by language](https://en.wiktionary.org/wiki/Category:Names_subcategories_by_language) category.  It would probably require another layer of mapping data and a fair amount of work, but would improve the chances of names sounding credible to native ears.

In cases where the writing system isn't strictly the Latin alphabet, the name will also be transliterated, shown along the lines of `"康 肖" (Kang  Xiao)`.  Like many aspects, here, it's not advisable to take those results as anything more than a starting point, specifically since transliterations of Semitic languages won't include most vowels and the transliteration library doesn't seem to care about any difference between Chinese logograms and Japanese kanji, producing unpleasant results there--`"مهسا حسنی" (mhs Hsny)` (should be *Mahsa Hassani*) or `"直子 高橋" (Zhi Zi  Gao Qiao)` (should be *Naoko Takahashi*)--and probably in other writing systems.

Perhaps noteworthy, the specific project I had in mind for this script involved a world where much of the Northern Hemisphere is irrelevant, so it's designed to be tuned for the Global South.  To that end, the program has a variable and a command-line parameter to set the northernmost latitude.

You can modify the number of people generated and the northernmost latitude with command-line arguments.  This being a lazily-written script, these arguments are determined by position, the count followed by the latitude.  The command:

 > `node generate.js 5 50`

then, will create five characters originating from no further north than 50N.

By default, the parameters are assumed to be ten characters as far north as 80N, which is as far north as the maps go.

### Language Nonsense (`people/geller.js`)

This is a self-consciously goofier idea than the other scripts.

In the original _Mission: Impossible_ TV series, production designer Bruce Geller created signage with fictional languages.  Generally, these were intended to represent generic Eastern European and South American countries without naming a specific country.  And the pseudo-languages were strongly based on English to a degree that a mono-lingual American living in the 1960s could easily read it.

The classic examples are a tank of "Gaz" and the base's "Priziion Mikitik," not to mention the occasional "Zöna Restrik."

While the original "Gellerese," as the cast and crew called it, was an ad hoc process without much consistency, it is still a semi-interesting idea, so this script...

 * Creates such an ad hoc languages, by choosing spelling rules,
 * "Translates" input into that language, and
 * Add gratuitous diacritical marks to the result.

The script maintains libraries (which should be expanded) of stereotypical spelling choices in specifically Eastern European and (with fewer options) Romance languages.

The result, as with Gellerese, is text that doesn't feel like English, but bears sufficient resemblance that it can be easily read.  For example:

 > Da r͋ȅsult, a̾en v͗id Zellérͅesa͒, ien̙ te͓xͮt da̮t͊ do̶esn't fe͘elͫ li͔ka En͒zl͘ish, bu̞t̀ bea̿re̔n s̼uf̸ficie͆nt r̒e͋se̐m͈b̵la͘n͒ca d͢a͗t̿ it can ba easily r͡ëa͎a. F̕er exa̙m̏pla...

...Obviously, a work in progress.


