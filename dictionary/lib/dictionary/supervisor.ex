defmodule Dictionary.Supervisor do 

  def start_link(opts) do 
    Supervisor.start_link(__MODULE__, :ok, opts) 
  end 

  def init(:ok) do 
    children = [
      { Dictionary.WordList, name: Dictionary.WordList } 
    ]

    Supervisor.init(children, strategy: :one_for_one) 
  end 

end 