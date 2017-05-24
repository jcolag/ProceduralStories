import :math

defmodule Trait do
  defstruct id: 0, name: "Trait", negname: "Antitrait"
end

defmodule Effect do
  defstruct id: 0, name: "Effect"
end

defmodule Event do
  defstruct id: 0, name: "Event"
end

defmodule Planet do
  # Mass is stored in 10^24g
  # Distances are stored in 10^6m
  defstruct id: 0, name: "Planet", mass: 1000000, centerid: -1, focusangle: 0, focusdist: 0, aradius: 1000000, eccentricity: 0, traitid: -1, effectid: -1, eventid: -1, metalid: -1, positive: true, currangle: 0

  def period(%Planet{aradius: aradius}, Planet: parent) do
    sqrt(aradius * aradius * aradius / parent.mass / 6.67408) * 0.73048
  end

  def position(Planet: planet, Integer: day) do
    p = Planet.period(planet)
    left = rem(day, p)
    left * 360 / p
  end
end

defmodule Element do
  defstruct id: 0, name: "Element"
end

defmodule Metal do
  defstruct id: 0, name: "Metal"
end

defmodule Quality do
  defstruct id: 0, name: "Quality"
end

defmodule Constellation do
  defstruct id: 0, name: "Constellation", angle: 0, traitid: 0, positive: true, elementid: 0, qualityid: 0
end

defmodule Angle do
  defstruct id: 0, name: "Angle", angle: 0, influence: 0
end

defmodule Aspect do
  defstruct id: 0, name: "Aspect", angle: 0, influence: 0
end

defmodule Position do
  defstruct planetid: -1, absangle: 0, relangle: 0
end

defmodule Orrery do
  defstruct planets: [], elements: [], qualities: [], qualities: [], traits: [], effects: [], events: [], metals: [], constellations: []

  defp init() do
    p1 = %Planet{id: 0, name: "Sun", mass: 1988550000, centerid: -1, focusangle: 0, focusdist: 0, aradius: 1, eccentricity: 0, traitid: 0, effectid: 0, eventid: -1, metalid: 0, positive: true, currangle: 0}
    p2 = %Planet{id: 1, name: "Mercury", mass: 330, centerid: 0, focusangle: 0, focusdist: 0, aradius: 57909, eccentricity: 0.20563069, traitid: 2, effectid: 2, eventid: 2, metalid: -1, positive: true, currangle: 0}
    p3 = %Planet{id: 2, name: "Venus", mass: 4868, centerid: 0, focusangle: 0, focusdist: 0, aradius: 108208, eccentricity: 0.00677323, traitid: 3, effectid: 3, eventid: -1, metalid: 3, positive: true, currangle: 0}
    p4 = %Planet{id: 3, name: "Earth", mass: 5972, centerid: 0, focusangle: 0, focusdist: 0, aradius: 149598, eccentricity: 0.01671022, traitid: 0, effectid: -1, eventid: -1, metalid: -1, positive: true, currangle: 0}
    p5 = %Planet{id: 4, name: "Moon", mass: 73, centerid: 3, focusangle: 0, focusdist: 0, aradius: 385, eccentricity: 0.0549, traitid: 1, effectid: 3, eventid: -1, metalid: 1, positive: true, currangle: 0}
    p6 = %Planet{id: 5, name: "Mars", mass: 641, centerid: 0, focusangle: 0, focusdist: 0, aradius: 227939, eccentricity: 0.09341233, traitid: 4, effectid: 4, eventid: -1, metalid: 4, positive: true, currangle: 0}
    p7 = %Planet{id: 6, name: "Jupiter", mass: 1898700, centerid: 0, focusangle: 0, focusdist: 0, aradius: 778299, eccentricity: 0.04839266, traitid: 5, effectid: 5, eventid: 5, metalid: -1, positive: true, currangle: 0}
    p8 = %Planet{id: 7, name: "Saturn", mass: 568510, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1429000, eccentricity: 0.05415060, traitid: 6, effectid: 6, eventid: 6, metalid: -1, positive: true, currangle: 0}
    p9 = %Planet{id: 8, name: "Uranus", mass: 868490, centerid: 0, focusangle: 0, focusdist: 0, aradius: 2875040, eccentricity: 0.04716771, traitid: -1, effectid: 7, eventid: -1, metalid: -1, positive: true, currangle: 0}
    p10 = %Planet{id: 9, name: "Neptune", mass: 1024400, centerid: 0, focusangle: 0, focusdist: 0, aradius: 4504450, eccentricity: 0.04716771, traitid: -1, effectid: 8, eventid: -1, metalid: -1, positive: true, currangle: 0}
    p11 = %Planet{id: 10, name: "Ceres", mass: 1, centerid: 0, focusangle: 0, focusdist: 0, aradius: 414010, eccentricity: 0.080, traitid: -1, effectid: 10, eventid: -1, metalid: -1, positive: true, currangle: 0}
    p12 = %Planet{id: 11, name: "Pluto", mass: 13, centerid: 0, focusangle: 0, focusdist: 0, aradius: 5906380, eccentricity: 0.24880766, traitid: -1, effectid: 9, eventid: -1, metalid: -1, positive: true, currangle: 0}
    p13 = %Planet{id: 12, name: "Haumea", mass: 4, centerid: 0, focusangle: 0, focusdist: 0, aradius: 6465000000, eccentricity: 0.18874, traitid: -1, effectid: -1, eventid: -1, metalid: -1, positive: true, currangle: 0}
    p14 = %Planet{id: 13, name: "Makemake", mass: 4, centerid: 0, focusangle: 0, focusdist: 0, aradius: 6838872, eccentricity: 0.159, traitid: -1, effectid: -1, eventid: -1, metalid: -1, positive: true, currangle: 0}
    p15 = %Planet{id: 14, name: "Eris", mass: 17, centerid: 0, focusangle: 0, focusdist: 0, aradius: 10166000, eccentricity: 0.44177, traitid: -1, effectid: -1, eventid: -1, metalid: -1, positive: true, currangle: 0}
    planets = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15]

    e1 = %Element{id: 0, name: "Earth"}
    e2 = %Element{id: 1, name: "Fire"}
    e3 = %Element{id: 2, name: "Water"}
    e4 = %Element{id: 3, name: "Air"}
    elements = [e1, e2, e3, e4]
    
    q1 = %Quality{id: 0, name: "Cardinal"}
    q2 = %Quality{id: 1, name: "Fixed"}
    q3 = %Quality{id: 2, name: "Mutable"}
    qualities = [q1, q2, q3]
    
    t1 = %Trait{id: 0, name: "Gregarious"}
    t2 = %Trait{id: 1, name: "Wandering"}
    t3 = %Trait{id: 2, name: "Quick"}
    t4 = %Trait{id: 3, name: "Charismatic"}
    t5 = %Trait{id: 4, name: "Assertive"}
    t6 = %Trait{id: 5, name: "Jovial"}
    t7 = %Trait{id: 6, name: "Wise"}
    traits = [t1, t2, t3, t4, t5, t6, t7]
    
    f1 = %Effect{id: 0, name: "Fortune"}
    f2 = %Effect{id: 1, name: "Travel"}
    f3 = %Effect{id: 2, name: "Rapid Change"}
    f4 = %Effect{id: 3, name: "Luck"}
    f5 = %Effect{id: 4, name: "Conflict"}
    f6 = %Effect{id: 5, name: "Fortune"}
    f7 = %Effect{id: 6, name: "Bad Luck"}
    f8 = %Effect{id: 7, name: "Disruption"}
    f9 = %Effect{id: 8, name: "Confusion"}
    f10 = %Effect{id: 9, name: "Transformation"}
    f11 = %Effect{id: 10, name: "Compassion"}
    effects = [f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11]
    
    v1 = %Event{id: 0, name: "Action"}
    v2 = %Event{id: 1, name: "Fortunate Events"}
    v3 = %Event{id: 2, name: "War"}
    v4 = %Event{id: 3, name: "Prosperity"}
    v5 = %Event{id: 4, name: "Disaster"}
    v6 = %Event{id: 5, name: "Innovation"}
    events = [v1, v2, v3, v4, v5, v6]
    
    l1 = %Metal{id: 0, name: "Gold"}
    l2 = %Metal{id: 1, name: "Silver"}
    l3 = %Metal{id: 2, name: "Mercury"}
    l4 = %Metal{id: 3, name: "Copper"}
    l5 = %Metal{id: 4, name: "Iron"}
    l6 = %Metal{id: 5, name: "Tin"}
    l7 = %Metal{id: 6, name: "Lead"}
    metals = [l1, l2, l3, l4, l5, l6, l7]

    c1 = %Constellation{id: 0, name: "Aries", angle: 0, traitid: 4, positive: true, elementid: 1, qualityid: 0}
    c2 = %Constellation{id: 1, name: "Taurus", angle: 30, traitid: 3, positive: true, elementid: 0, qualityid: 1}
    c3 = %Constellation{id: 2, name: "Gemini", angle: 60, traitid: 2, positive: true, elementid: 3, qualityid: 2}
    c4 = %Constellation{id: 3, name: "Cancer", angle: 90, traitid: 1, positive: true, elementid: 2, qualityid: 0}
    c5 = %Constellation{id: 4, name: "Leo", angle: 120, traitid: 0, positive: true, elementid: 1, qualityid: 1}
    c6 = %Constellation{id: 5, name: "Virgo", angle: 150, traitid: 2, positive: true, elementid: 0, qualityid: 2}
    c7 = %Constellation{id: 6, name: "Libra", angle: 180, traitid: 3, positive: true, elementid: 3, qualityid: 0}
    c8 = %Constellation{id: 7, name: "Scorpio", angle: 210, traitid: 4, positive: true, elementid: 2, qualityid: 1}
    c9 = %Constellation{id: 8, name: "Sagittarius", angle: 240, traitid: 5, positive: true, elementid: 1, qualityid: 2}
    c10 = %Constellation{id: 9, name: "Capricorn", angle: 270, traitid: 6, positive: true, elementid: 0, qualityid: 0}
    c11 = %Constellation{id: 10, name: "Aquarius", angle: 300, traitid: 6, positive: true, elementid: 3, qualityid: 1}
    c12 = %Constellation{id: 11, name: "Pisces", angle: 330, traitid: 5, positive: true, elementid: 2, qualityid: 2}
    constellations = [c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12]
    
    %Orrery {planets: planets, elements: elements, qualities: qualities, qualities: qualities, traits: traits, effects: effects, events: events, metals: metals, constellations: constellations}
  end
  
  defp byIndex([], _) do
    nil
  end
  
  defp byIndex([head|tail], id) do
    if head.id == id do
      head
    else
      byIndex(tail, id)
    end
  end
  
  defp byName([], _) do
    nil
  end
  
  defp byName([head|tail], name) do
    if head.name == name do
      head
    else
      byName(tail, name)
    end
  end
  
  def allCenters(_, nil) do
    []
  end
  
  def allCenters([], _) do
    []
  end
  
  def allCenters(planets, planet) do
    parent = byIndex(planets, planet.centerid)
    [planet | allCenters(planets, parent)]
  end
  
  def trimCommonPrefix([], [head|tail]) do
    [head|tail]
  end
  
  def trimCommonPrefix([head|tail], []) do
    [head|tail]
  end
  
  def trimCommonPrefix([head1|tail1], [head2|tail2]) do
    IO.puts head1.name <> " =?= " <> head2.name
    if head1 == head2 do
      trimCommonPrefix(tail1, tail2)
    else
      [ [head1|tail1], [head2|tail2] ]
    end
  end
end

