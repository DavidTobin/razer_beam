defmodule RazerBeam.Model.Effect.Static do
  @derive Jason.Encoder
  defstruct effect: "CHROMA_STATIC",
            param: %{
              color: 0
            }
end
