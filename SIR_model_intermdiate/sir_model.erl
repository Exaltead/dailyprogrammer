-module(sir_model).
-export ([simulate/0]).

simulate() ->
    {ok, [Systems, Infected, SI, IR, SR]} = read_io_command(),
    sir(Systems, Infected, SI, IR, SR).

sir(Systems, Infected, SI, IR, SR) ->
    print_stats(Systems - Infected, Infected, 0, 0),
    sir_simulation(Systems - Infected, Infected, 0, SI, IR, SR, 1).


sir_simulation(0, 0, _, _, _, _, Iteration) ->
    print_finish(Iteration);
sir_simulation(S, I, R, SI, IR, SR, Iteration) ->
    Infected = simulate_change(S, SI, 0),
    Cured = simulate_change(I, IR, 0),
    Patched = simulate_change(S - Infected, SR, 0),
    % For clarity the new caleus are calculated in advance
    New_s = S - Infected - Patched,
    New_i = I - Cured + Infected,
    New_r = R + Patched + Cured,
    print_stats(New_s, New_i, New_r, Iteration),
    sir_simulation(New_s, New_i, New_r, SI, IR, SR, Iteration + 1).


simulate_change(0, _, Remaining) ->
    Remaining;
simulate_change(Systems, Proba, Remaining) ->
    case system_state_changed(Proba) of
        false ->
            simulate_change(Systems - 1, Proba, Remaining + 1);
        true ->
            simulate_change(Systems - 1, Proba, Remaining)
    end.

system_state_changed(Proba)->
    Proba > rand:uniform().

% IO part of the system
print_finish(Iteration) ->
    io:format("On gention ~w simualton ened with all systems resistant", [Iteration]).

print_stats(S, I, R, Gen) ->
    SIR_size = length(integer_to_list(S + I + R)),
    % Format the text so that only the numbers increment
    % and placement remains the same.
    FS = string:pad(integer_to_list(S), SIR_size),
    FI = string:pad(integer_to_list(I), SIR_size),
    FR = string:pad(integer_to_list(R), SIR_size),
    io:format("S -> ~s I -> ~s R -> ~s on iteration ~w ~n", [FS, FI, FR, Gen]).

read_io_command() ->
    Prompt = "Input the simulation parameters: Systems Infected SI-rate IR-rate RI-rate:\n ",
    io:fread(Prompt, "~d ~d ~f ~f ~f").
