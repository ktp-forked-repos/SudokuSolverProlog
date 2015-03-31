% sudoku
% solved using constraint programming
% 
% run as: sudoku(+Input, -Solution).
:- use_module(library(clpfd)).

solve(Input) :-
	sudoku(Input, Solution),
	pretty_print(Solution).

sudoku(Input, Solution) :-
	write('begin'), nl,
	length(Solution, 9),
	length_all_elems(Solution, 9),
	write('constrain all rows'), nl,
	constrain_all_rows(Solution),
	write('get squares'), nl,
	get_squares(Solution, Squares),
	write('constrain all squares'), nl,
	constrain_all_squares(Solution),
	write('constrain given input'), nl,
	constrain_given_input(Input, Solution).
	
constrain_given_input([], []) :- !.
constrain_given_input([InH|InT], [SolH|SolT]) :-
	constrain_row_given_input(InH, SolH),
	constrain_given_input(IntT, SolT).

constrain_row_given_input([], []) :- !.
constrain_row_given_input([InH|InT], [SolH|SolT]) :-
	(InH #= 0; 
	SolH #= InH),
	constrain_row_given_input(InT, SolT).
		

constrain_all_rows([]).
constrain_all_rows([X|Xs]) :-
	constrain_nine(X),
	constrain_between_rows(X, Xs).

constrain_between_rows(_, []).
constrain_between_rows(X, [Y|Ys]) :-
	constrain_between_individual_rows(X, Y),
	constrain_between_rows(X, Ys).
	
constrain_between_individual_rows([], []).
constrain_between_individual_rows([X|Xs], [Y|Ys]) :-
	X #\= Y.

constrain_all_squares([]).
constrain_all_squares([H|Rest]) :-
		constrain_nine(H),
		constrain_all_squares(Rest).

get_squares([], []) :- !.	
get_squares(Rows, Squares) :-
	get_first_three(Rows, First3, Rest),
	get_squares_horizontally(First3, Squares1),
	%write('Rest: '), write(Rest), nl,
	%write('Rows: '), write(Rows), nl,
	%write('First3: '), write(First3), nl,
	%write('Squares1:'), write(Squares1), nl,
	%get_squares(Rest, Squares2),
	%write('Squares2:'), write(Squares2), nl,
	append(Squares1, Squares2, Squares).
	
get_squares_horizontally([[]|_], []) :- !.
get_squares_horizontally([Row1,Row2,Row3|_], Squares) :-
	get_first_three(Row1, First1, Rest1),
	get_first_three(Row2, First2, Rest2),
	get_first_three(Row3, First3, Rest3),
	%write('Row1: '), write(Row1), nl,
	append(First1, First2, First12),
	append(First12, First3, First123),
	%write('First123: '), write(First123), nl,
	append([Rest1], [Rest2], Rest12),
	append(Rest12, [Rest3], Rest123),
	%write('Rest123: '), write(Rest123), nl,
	%write('RestSquares: '), write(RestSquares), nl,
	get_squares_horizontally(Rest123, RestSquares),
	append([First123], RestSquares, Squares).

	
		
get_first_three([], [], []).
get_first_three([H1,H2,H3|T], [H1,H2,H3], T).

constrain_all_rows([]).
constrain_all_rows([X|Xs]) :-
	constrain_nine(X),
	constrain_all_rows(Xs).
	
constrain_nine(SetOfNine) :-
	length(SetOfNine, 9),
	SetOfNine ins 1..9,
	all_different(SetOfNine),
	label(SetOfNine).
	
length_all_elems([], _).
length_all_elems([H|T], N) :-
        length(H, N),
        length_all_elems(T, N).
		
pretty_print([]).
pretty_print([H|T]) :-
	write(H), nl,
	pretty_print(T).