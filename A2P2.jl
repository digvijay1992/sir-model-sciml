# The SIR Model
using DifferentialEquations, ModelingToolkit

# Define the equations and variables
function SIR!(du, u, p, t)
    S, I, R = u # S: susceptible, I: infected, R: recovered
    β, γ, N = p   # β: infection rate, γ: recovery rate, N: total population
    du[1] = -p[1] * u[1] * u[2] / p[3]
    du[2] = p[1] * u[1] * u[2] / p[3] - p[2] * u[2]
    du[3] = p[2] * u[2]
end

# Initial conditions
u0 = [999.0, 1.0, 0.0] # initial susceptible, infected, recovered
# Parameters: β, γ, N
p = [0.3, 0.1, sum(u0)] # infection rate, recovery rate, total population

# Time span for the simulation
tspan = (0.0, 160.0)  # in days

# Define the ODE problem
prob = ODEProblem(SIR!, u0, tspan, p)

# Solve the ODE problem
sol = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)

# Plot the results
using Plots 
p1 = plot(sol, idxs=(0,1), xlabel="Time (days)", ylabel="Number of Individuals",
          title="SIR Model: Susceptible and Infected", label="Susceptible")
p2 = plot!(sol, idxs=(0,2), xlabel="Time (days)", ylabel="Number of Individuals",
          label="Infected")
p3 = plot!(sol, idxs=(0,3), xlabel="Time (days)", ylabel="Number of Individuals",
          label="Recovered")
pic = plot(p3)
# Save the combined figure as PNG, first locate the same directory as this script
outfp = joinpath(@__DIR__, "SIR_model.png")
savefig(pic, outfp)


