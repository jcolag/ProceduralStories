defmodule Trait do
  defstruct id: 0, name: "Trait", negname: "Antitrait"
end

defmodule Planet do
  defstruct id: 0, name: "Planet", aradius: 1000000, bradius: 1000000, traitid: 0, positive: true
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


