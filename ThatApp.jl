@vars thatName begin
    process = false
    input = ""
    output::String = "", READONLY
  end
  
  function thatHandlers(model)
    on(model.input) do input
        model.output[] = input |> reverse
    end
  
    onbutton(model.process) do
        model.output[] = model.output[] |> reverse
    end
  
    model
  end
  
  function thatUI()
    
    row(cell(class = "st-module", [
      textfield(class = "q-my-md", "Input", :input, hint = "Please enter some words", @on("keyup.enter", "process = true"))
  
      btn(class = "q-my-md", "Action!", @click(:process), color = "primary")
      
      card(class = "q-my-md", [
        card_section(h2("Output"))
        card_section("Variant 1: {{ output }}")
        card_section(["Variant 2: ", span(class = "text-red", @text(:output))])
      ])
    ]))
  end
  