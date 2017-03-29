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
  end
end

