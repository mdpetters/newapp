using Genie.Router
using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests
using Stipple
using StippleUI
# using Plots
# using Plots.PlotMeasures
using Gadfly
using Random
using Chain

include("ThisApp.jl")
include("ThatApp.jl")

function foo()
  x = open("public/mdp.html") do f
    readlines(f)
  end

  return x
end


function makeplot(n)
  xs = 0:0.01:500
  #plot(xs, sin.(2.0 .* pi ./ n .* xs), size=(870, 300), xlim=[0, 500], ylim=[-1, 1], xlabel="Hello", ylabel="World", bottom_margin=20px, label="$n", left_margin=10px)
 
  set_default_plot_size(870px, 300px)
  p = plot(x = xs, y =sin.(2.0 .* pi ./ n .* xs), Geom.line)
  # pp = plot(p, p, p, layout=grid(1, 1))

end

ppp = makeplot(1)
draw(SVG("public/img/1.svg"), ppp)
#savefig(ppp, )

@vars thisName begin
  toggle::Bool = false
  name::String = "World!"
  fn::String = "img/1.svg"
  output::String = "", READONLY
  r::Int = 1
  r1::Int = 1
  value::Bool = false
end


function thisHandlers(model)
  on(model.r) do x
    n = x[]
    model.fn[] = "img/$n.svg"
    ppp = makeplot(n)
    draw(SVG("public/" * model.fn[]), ppp)
    #savefig(pp, "public/" * model.fn[])
  end

  model
end

function thisUI()
  a = foo()

  c1 = slider(1:1:100,
    :r;
    label=true,
    lazy=true,
    vertical=false,
    color="blur",
    reverse=false,
    dragonlyrange=true
  )

  c = """ <div class="ex1"> <b> Frequency: 0-100 (-)</b> $c1 </div>"""
  f = imageview(src=:fn, spinnercolor="white", style="height: 300px; max-width: 870px")

  vcat(a, c, f)

end



route("/") do
  global thisModel = thisName |> init |> thisHandlers
  page(thisModel, thisUI()) |> html
end

route("/test") do
  global thatModel = thatName |> init |> thatHandlers
  page(thatModel, thatUI()) |> html
end
