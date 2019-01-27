defmodule Hangman.Supervisor do 

  def start_link(opts) do 
    Supervisor.start_link(__MODULE__, :ok, opts) 
  end 

  def init(:ok) do 
    children = [
      { Hangman.Server, name: Hangman.Server },
      { DynamicSupervisor, name: Hangman.GameSupervisor, strategy: :one_for_one } 
    ]

    Supervisor.init(children, strategy: :one_for_all) 
  end 

end 