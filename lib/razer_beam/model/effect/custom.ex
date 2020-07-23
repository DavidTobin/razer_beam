defmodule RazerBeam.Model.Effect.Custom do
  @derive Jason.Encoder
  defstruct effects: [
              %{
                effect: "CHROMA_STATIC",
                param: %{
                  color: 1_234_567
                }
              },
              %{
                effect: "CHROMA_CUSTOM",
                param: [255, 65280, 16_711_680, 65535, 16_711_935]
              }
            ]
end
