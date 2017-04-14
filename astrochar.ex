import :math

defmodule Trait do
  defstruct id: 0, name: "Trait", negname: "Antitrait"
end

defmodule Planet do
  # Mass is stored in 10^24g
  # Distances are stored in 10^6m
  defstruct id: 0, name: "Planet", mass: 1000000, centerid: -1, focusangle: 0, focusdist: 0, aradius: 1000000, eccentricity: 0, traitid: 0, positive: true, currangle: 0

  def period(%Planet{aradius: aradius}, Planet: parent) do
    2 * pi() * sqrt(aradius * aradius * aradius / parent.mass / 6.67408)
  end
end

defmodule Element do
  defstruct id: 0, name: "Element"
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

defmodule Orrery do
  defp init() do
    p1 = %Planet{id: 0, name: "Sun", mass: 1988550000, centerid: -1, focusangle: 0, focusdist: 0, aradius: 1, eccentricity: 0, traitid: 0, positive: true, currangle: 0}
    p2 = %Planet{id: 1, name: "Mercury", mass: 330, centerid: 0, focusangle: 0, focusdist: 0, aradius: 57909, eccentricity: 0.20563069, traitid: 0, positive: true, currangle: 0}
    p3 = %Planet{id: 2, name: "Venus", mass: 4868, centerid: 0, focusangle: 0, focusdist: 0, aradius: 108208, eccentricity: 0.00677323, traitid: 0, positive: true, currangle: 0}
    p4 = %Planet{id: 3, name: "Earth", mass: 5972, centerid: 0, focusangle: 0, focusdist: 0, aradius: 149598, eccentricity: 0.01671022, traitid: 0, positive: true, currangle: 0}
    p5 = %Planet{id: 4, name: "Moon", mass: 73, centerid: 3, focusangle: 0, focusdist: 0, aradius: 385, eccentricity: 0.0549, traitid: 0, positive: true, currangle: 0}
    p6 = %Planet{id: 5, name: "Mars", mass: 641, centerid: 0, focusangle: 0, focusdist: 0, aradius: 227939, eccentricity: 0.09341233, traitid: 0, positive: true, currangle: 0}
    p7 = %Planet{id: 6, name: "Jupiter", mass: 1898700, centerid: 0, focusangle: 0, focusdist: 0, aradius: 778299, eccentricity: 0.04839266, traitid: 0, positive: true, currangle: 0}
    p8 = %Planet{id: 7, name: "Saturn", mass: 568510, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1429000, eccentricity: 0.05415060, traitid: 0, positive: true, currangle: 0}
    p9 = %Planet{id: 8, name: "Uranus", mass: 868490, centerid: 0, focusangle: 0, focusdist: 0, aradius: 2875040, eccentricity: 0.04716771, traitid: 0, positive: true, currangle: 0}
    p10 = %Planet{id: 9, name: "Neptune", mass: 1024400, centerid: 0, focusangle: 0, focusdist: 0, aradius: 4504450, eccentricity: 0.04716771, traitid: 0, positive: true, currangle: 0}
    p11 = %Planet{id: 10, name: "Ceres", mass: 1, centerid: 0, focusangle: 0, focusdist: 0, aradius: 414010, eccentricity: 0.080, traitid: 0, positive: true, currangle: 0}
    p12 = %Planet{id: 11, name: "Pluto", mass: 13, centerid: 0, focusangle: 0, focusdist: 0, aradius: 5906380, eccentricity: 0.24880766, traitid: 0, positive: true, currangle: 0}
    p13 = %Planet{id: 12, name: "Haumea", mass: 4, centerid: 0, focusangle: 0, focusdist: 0, aradius: 6465000000, eccentricity: 0.18874, traitid: 0, positive: true, currangle: 0}
    p14 = %Planet{id: 13, name: "Makemake", mass: 4, centerid: 0, focusangle: 0, focusdist: 0, aradius: 6838872, eccentricity: 0.159, traitid: 0, positive: true, currangle: 0}
    p15 = %Planet{id: 14, name: "Eris", mass: 17, centerid: 0, focusangle: 0, focusdist: 0, aradius: 10166000, eccentricity: 0.44177, traitid: 0, positive: true, currangle: 0}

    e1 = %Element{id: 0, name: "Earth"}
    e2 = %Element{id: 1, name: "Fire"}
    e3 = %Element{id: 2, name: "Water"}
    e4 = %Element{id: 3, name: "Air"}
    
    q1 = %Quality{id: 0, name: "Cardinal"}
    q1 = %Quality{id: 1, name: "Fixed"}
    q1 = %Quality{id: 2, name: "Mutable"}

    c1 = %Constellation{id: 0, name: "Aries", angle: 0, traitid: 0, positive: true, elementid: 1, qualityid: 0}
    c2 = %Constellation{id: 1, name: "Taurus", angle: 30, traitid: 0, positive: true, elementid: 0, qualityid: 0}
    c3 = %Constellation{id: 2, name: "Gemini", angle: 60, traitid: 0, positive: true, elementid: 3, qualityid: 0}
    c4 = %Constellation{id: 3, name: "Cancer", angle: 90, traitid: 0, positive: true, elementid: 2, qualityid: 0}
    c5 = %Constellation{id: 4, name: "Leo", angle: 120, traitid: 0, positive: true, elementid: 1, qualityid: 0}
    c6 = %Constellation{id: 5, name: "Virgo", angle: 150, traitid: 0, positive: true, elementid: 0, qualityid: 0}
    c7 = %Constellation{id: 6, name: "Libra", angle: 180, traitid: 0, positive: true, elementid: 3, qualityid: 0}
    c8 = %Constellation{id: 7, name: "Scorpio", angle: 210, traitid: 0, positive: true, elementid: 2, qualityid: 0}
    c9 = %Constellation{id: 8, name: "Sagittarius", angle: 240, traitid: 0, positive: true, elementid: 1, qualityid: 0}
    c10 = %Constellation{id: 9, name: "Capricorn", angle: 270, traitid: 0, positive: true, elementid: 0, qualityid: 0}
    c11 = %Constellation{id: 10, name: "Aquarius", angle: 300, traitid: 0, positive: true, elementid: 3, qualityid: 0}
    c12 = %Constellation{id: 11, name: "Pisces", angle: 330, traitid: 0, positive: true, elementid: 2, qualityid: 0}
  end
end

