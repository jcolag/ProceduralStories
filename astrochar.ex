import :math

defmodule Trait do
  defstruct id: 0, name: "Trait", negname: "Antitrait"
end

defmodule Planet do
  defstruct id: 0, name: "Planet", mass: 1000000, centerid: -1, focusangle: 0, focusdist: 0, aradius: 1000000, bradius: 1000000, traitid: 0, positive: true, currangle: 0

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
    p1 = %Planet{id: 0, name: "Sun", mass: 1988550000, centerid: -1, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p2 = %Planet{id: 1, name: "Mercury", mass: 1988550000, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p3 = %Planet{id: 2, name: "Venus", mass: 1988550000, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p4 = %Planet{id: 3, name: "Earth", mass: 1988550000, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p5 = %Planet{id: 4, name: "Moon", mass: 1988550000, centerid: 3, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p6 = %Planet{id: 5, name: "Mars", mass: 1988550000, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p7 = %Planet{id: 6, name: "Jupiter", mass: 1988550000, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p8 = %Planet{id: 7, name: "Saturn", mass: 1988550000, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p9 = %Planet{id: 8, name: "Uranus", mass: 1988550000, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p10 = %Planet{id: 9, name: "Neptune", mass: 1988550000, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
    p11 = %Planet{id: 10, name: "Pluto", mass: 1988550000, centerid: 0, focusangle: 0, focusdist: 0, aradius: 1, bradius: 1, traitid: 0, positive: true, currangle: 0}
  end
end

