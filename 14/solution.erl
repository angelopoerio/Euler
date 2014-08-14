%% Solution for http://projecteuler.net/problem=14
%% This can run faster if you distribute the program on many Erlang nodes (process_seq processes)
%% Author: Angelo Poerio <angelo.poerio@gmail.com>

-module(solution).
-export([get_collatz_seq/1, process_seq/2, get_solution/0]).
-define(LIM, 1000000).

get_collatz_seq_i(N, List) when N == 1 -> lists:reverse(List);
get_collatz_seq_i(N, List) -> 
	if 
		N rem 2 == 0 -> Next = N/2, get_collatz_seq_i(trunc(Next), [trunc(Next)|List]);
		true -> Next = (3 * N) + 1.0, get_collatz_seq_i(trunc(Next), [trunc(Next)|List])
	end.
get_collatz_seq(N) -> get_collatz_seq_i(N, [N]).

process_seq(PID, N) -> Seq = get_collatz_seq(N), PID ! Seq.

generate_seq(Cnt) when Cnt > ?LIM -> ok;
generate_seq(Cnt) -> spawn(solution, process_seq, [self(), Cnt]), generate_seq(Cnt + 1). %% this spawns 10^6 processes!

recv_seq(Cnt, Max_N, Max_seq_len) when Cnt == ?LIM -> io:format("Answer is ~p (Seq len: ~p) ~n", [Max_N, Max_seq_len]); 
recv_seq(Cnt, Max_N, Max_seq_len) ->
	receive 
		[H|T] ->  if 
					length([H|T]) > Max_seq_len -> recv_seq(Cnt + 1, H, length([H|T]));
					true -> recv_seq(Cnt + 1, Max_N, Max_seq_len)
				  end
	end.

get_solution() -> io:format("It can take a while ...~n"), generate_seq(1), recv_seq(1, 0, 0). %% Answer is 837799 :)
