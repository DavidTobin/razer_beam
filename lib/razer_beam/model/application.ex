defmodule RazerBeam.Model.Application do
  @derive Jason.Encoder
  defstruct title: "Razer Beam",
            description: "Razer Chroma effects running on Beam",
            author: %{
              name: "David Tobin",
              contact: "github.com/davidtobin"
            },
            device_supported: [
              "keyboard",
              "mouse",
              "mousepad"
            ],
            category: "application"
end
