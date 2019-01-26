defmodule Dictionary.Application do
  
  use Application 

  def start(_type, _args) do 
    Dictionary.Supervisor.start_link(name: Dictionary.Supervisor) 
  end 
  
end