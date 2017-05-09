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

