%% Solution for: http://projecteuler.net/problem=30
%% Run faster if you distribute it on multiple Erlang nodes (is_verified process)
%% Author: Angelo Poerio <angelo.poerio@gmail.com>

-module(solution).
-export([is_verified/2, recv_nums/2, get_numbers/0, get_solution/0]).
-define(LIM, 700000). %% a reasonable limit :)

is_verified(N, PID) -> U = trunc((N/1)) rem 10, D = trunc((N/10)) rem 10,
				  	   C = trunc((N/100)) rem 10, M = trunc((N/1000)) rem 10,
				  	   M_2 = trunc((N/10000)) rem 10, M_3 = trunc((N/100000)) rem 10,
				  	   Sum = math:pow(U, 5) + math:pow(D, 5) + math:pow(C, 5) + math:pow(M, 5) + math:pow(M_2, 5) + math:pow(M_3, 5),
				  	   if
				  	   		Sum == N -> PID ! {yes, N};
				  	   		true -> PID ! {no, N}
				  	   end.

get_numbers_i(N) when N > ?LIM -> ok;
get_numbers_i(N) -> spawn(solution, is_verified, [N, self()]), get_numbers_i(N + 1).
get_numbers() -> get_numbers_i(2).

recv_nums(Sum, Cnt) when Cnt == ?LIM -> io:format("Answer is ~p~n",[Sum]); %% 443839 :)
recv_nums(Sum, Cnt) ->
				receive
					{yes, N} -> recv_nums(Sum + N, Cnt + 1);
					{no, _} -> recv_nums(Sum, Cnt + 1)
				end.

get_solution() -> get_numbers(), recv_nums(0, 1). %% entry point