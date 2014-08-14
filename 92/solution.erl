%% Solution for: http://projecteuler.net/problem=92
%% Run faster if you distribute it on multiple Erlang nodes (is_89_seq process)
%% Author: Angelo Poerio <angelo.poerio@gmail.com>

-module(solution).
-export([is_89_seq/2, get_next/1, recv_nums/2, compute_seq/1, get_solution/0]).
-define(LIM, 10000000).

get_next(N) -> U = trunc((N/1)) rem 10, D = trunc((N/10)) rem 10,
		  	   C = trunc((N/100)) rem 10, M = trunc((N/1000)) rem 10,
		  	   M_2 = trunc((N/10000)) rem 10, M_3 = trunc((N/100000)) rem 10,
		  	   M_4 = trunc((N/1000000)) rem 10, M_5 = trunc((N/10000000)) rem 10,
		  	   Sum = math:pow(U, 2) + math:pow(D, 2) + math:pow(C, 2) + math:pow(M, 2) + math:pow(M_2, 2) + math:pow(M_3, 2) + math:pow(M_4, 2) + math:pow(M_5, 2),
		  	   Sum.

is_89_seq(N, PID) -> 
					 if 
						N == 1 -> PID ! no;
						N == 89 -> PID ! yes;
						true -> is_89_seq(get_next(N), PID)
					 end.

compute_seq(N) when N > ?LIM -> ok;
compute_seq(N) -> spawn(solution, is_89_seq, [N, self()]), compute_seq(N + 1). %% 10^7 processes! (you should distribute them)

recv_nums(Y_cnt, Cnt) when Cnt == ?LIM -> io:format("Answer is ~p~n",[Y_cnt]); %% 8581146 :)
recv_nums(Y_cnt, Cnt) ->
				receive
					yes -> recv_nums(Y_cnt + 1, Cnt + 1);
					no -> recv_nums(Y_cnt, Cnt + 1)
				end.

get_solution() -> io:format("It can take a while ...~n"), compute_seq(1), recv_nums(0, 0). %% entry point