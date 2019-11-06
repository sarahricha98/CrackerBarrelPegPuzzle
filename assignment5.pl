%Sarah Richards
% A, B, C : describes moves
moves(0,1,3).
moves(0,2,5).
moves(1,3,6).
moves(1,4,8).
moves(2,4,7).
moves(2,5,9).
moves(3,6,10).
moves(3,7,12).
moves(4,7,11).
moves(4,8,13).
moves(5,8,12).
moves(5,9,14).
moves(3,4,5).
moves(6,7,8).
moves(7,8,9).
moves(10,11,12).
moves(11,12,13).
moves(12,13,14).

% generator for steps and their oposites
step(A,B,C):-
    moves(A,B,C);moves(C,B,A).

% build cells
init(I,PegBoard):-
    findall(Next,(between(0,14,Next),Next=\=I),PegBoard).

% performs, if possible, a move
% given the current occupancy of the cells  
move(moves(A,B,C),PegBoard1,[C|PegBoard3]):-
    select(A,PegBoard1,PegBoard2),
    select(B,PegBoard2,PegBoard3),
    step(A,B,C),
    not(member(C,PegBoard1)).
   
% generator that yields all possible solutions
% given a cell configuration
solve([_],[]).
solve(PegBoard1,[M|Moves]):-
    move(M,PegBoard1,PegBoard2),
    solve(PegBoard2,Moves).
  
% replay a sequence of moves, showing the state of cells
replay([_],[]).
replay(PegBoard1,[M|Moves]):-  
    move(M,PegBoard1,PegBoard2),
    !,
    show(PegBoard2),
    replay(PegBoard2,Moves).

assign(I,PegBoard,X):-
    member(I,PegBoard)->X=x ; X='.'.

% shows the result by printing out successive states  
show(PegBoard):-
    Lines = [[4,0,0], [3,1,2], [2,3,5], [1,6,9], [0,10,14]],
    member(Line, Lines),
    [B, M, E] = Line,
    nl,
    tab(B),
    between(M,E,I),
    assign(I,PegBoard,X),
    write(X),
    write(' '),
    fail.

show(_):- nl.

% visualize a solution for each first 5 positions
% others look the same after 120 degrees rotation
go:-
    between(0, 4, I),
    init(I,PegBoard),
    once(solve(PegBoard,Moves)),
    J is (I + 1),
    write('=== '),
    write(J),
    write(' ==='),
    nl,
    show(PegBoard),
    nl,
    replay(PegBoard,Moves),
    nl,
    maplist(writeln, Moves).