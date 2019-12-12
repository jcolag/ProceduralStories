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


Ideally, this part of the generation would use the country's census information, but finding and packaging census information for every country in the world would require a prohibitive level of effort.

Perhaps noteworthy, the specific project I had in mind for this script involved a world where much of the Northern Hemisphere is irrelevant.  So, the program has a variable and a command-line parameter to set the northernmost latitude.

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


