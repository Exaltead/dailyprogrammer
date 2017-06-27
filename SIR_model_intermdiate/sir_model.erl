-module(sir_model).
-export ([sir/5]).


sir(Systems, Infected, SI, IR, SR) ->
    print_stats(Systems - Infected, Infected, 0, 0),
    sir_simulation(Systems - Infected, Infected, 0, SI, IR, SR, 1).

sir_simulation(0, 0, _, _, _, _, Iteration) ->
    print_finish(Iteration);
sir_simulation(S, I, R, SI, IR, SR, Iteration) ->
    Infected = simulate_change(S, SI, 0),
    Cured = simulate_change(I, IR, 0),
    Patched = simulate_change(S - Infected, SR, 0),
    print_stats(S - Infected - Patched, I - Cured + Infected,
    R + Patched + Cured, Iteration),
    sir_simulation(S - Infected - Patched, I - Cured + Infected,
    R + Patched + Cured, SI, IR, SR, Iteration + 1).



simulate_change(0, _, Remaining) ->
    Remaining;
simulate_change(Systems, Ratio, Remaining) ->
    Changed = state_changed(Ratio),
    case Changed of
        true ->
            simulate_change(Systems - 1, Ratio, Remaining + 1);
        false ->
            simulate_change(Systems - 1, Ratio, Remaining)
    end.

state_changed(Ratio)->
    Ratio > rand:uniform().


print_finish(Iteration) ->
    io:format("On gention ~w simualton ened with all systems resistant", [Iteration]).


print_stats(S, I, R, Gen) ->
    SIR_size = length(integer_to_list(S + I + R)),
    % Format the text so that only the numbers increment
    FS = string:pad(integer_to_list(S), SIR_size),
    FI = string:pad(integer_to_list(I), SIR_size),
    FR = string:pad(integer_to_list(R), SIR_size),
    Message = io_lib:format("S -> ~s I -> ~s R -> ~s on iteration ~w ~n", [FS, FI, FR, Gen]),
    io:format(Message).
