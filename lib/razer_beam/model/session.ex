defmodule RazerBeam.Model.Session do
  @derive Jason.Encoder
  defstruct sessionid: nil,
            uri: nil
end
