%% Solution for: http://projecteuler.net/problem=42
%% Author: Angelo Poerio <angelo.poerio@gmail.com>

-module(solution).
-export([get_solution/0, solve/2, solve_i/3, recv_solutions/3]).

readlines() ->
    {ok, Data} = file:read_file("words.txt"),
    binary:split(Data, [<<",">>], [global]).

get_word_number_i([], N) -> N;
get_word_number_i([H_W|T_W], N) -> get_word_number_i(T_W, N + (H_W - 64)).
get_word_number(Word) -> get_word_number_i(re:replace(Word, "\"", "", [global,{return,list}]), 0).  

get_triangle_number(N) -> (N * (N + 1)) / 2.

recv_solutions(Words, T_recv, R_recv) ->
		  if 
			  T_recv < length(Words) ->
				  receive 
					yes -> recv_solutions(Words, T_recv + 1, R_recv + 1);
				    no -> recv_solutions(Words, T_recv + 1, R_recv)
				  end;
			  true ->  io:format("Answer is ~p~n", [R_recv]) %% 162 :)
		  end.

solve_i(Word_number, PID, N) -> New_triangle_number = get_triangle_number(N),
		if 
			New_triangle_number > Word_number ->
					PID ! no;
			true -> if
						New_triangle_number == Word_number ->
								PID ! yes;
						true -> solve_i(Word_number, PID, N + 1)
					end
		end.		
solve(Word_number, PID) -> solve_i(Word_number, PID, 0).

launch_solvers([]) -> ok;
launch_solvers([H|T]) -> spawn(solution, solve, [get_word_number(H), self()]), 
							launch_solvers(T).

get_solution() -> Words = readlines(), launch_solvers(Words), recv_solutions(Words, 0, 0).  %% entry point