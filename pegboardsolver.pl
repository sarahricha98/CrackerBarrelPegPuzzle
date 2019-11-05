% Initiale, Middle, Final : describe steps
steps(0,1,3).
steps(0,2,5).
steps(1,3,6).
steps(1,4,8).
steps(2,4,7).
steps(2,5,9).
steps(3,6,10).
steps(3,7,12).
steps(4,7,11).
steps(4,8,13).
steps(5,8,12).
steps(5,9,14).
steps(3,4,5).
steps(6,7,8).
steps(7,8,9).
steps(10,11,12).
steps(11,12,13).
steps(12,13,14).

% generator for steps and their oposites
step(Initial,Middle,Final):-
    steps(Initial,Middle,Final);steps(Final,Middle,Initial).

% build cells
init(I,PegBoard):-
    findall(J,(between(0,14,J),J=\=I),PegBoard).

% performs, if possible, a move
% given the current occupancy of the cells  
move(steps(Initial,Middle,Final),PegBoard1,[Final|PegBoard3]):-
    select(Initial,PegBoard1,PegBoard2),
    select(Middle,PegBoard2,PegBoard3),
    step(Initial,Middle,Final),
    not(member(Final,PegBoard1)).
   
% generator that yields all possible solutions
% given a cell configuration
solve([_],[]).
solve(PegBoard1,[M|steps]):-
    move(M,PegBoard1,PegBoard2),
    solve(PegBoard2,steps).
  
% replay a sequence of moves, showing the state of cells 
replay([_],[]).
replay(PegBoard1,[M|steps]):-  
    move(M,PegBoard1,PegBoard2),
    !,
    show(PegBoard2),
    replay(PegBoard2,steps).

assign(I,PegBoard,X):-
    member(I,PegBoard)->X=x ; X='.'.

% shows the result by printing out successive states 
show(PegBoard):-
    Lines = [[4,0,0], [3,1,2], [2,3,5], [1,6,9], [0,10,14]],
    member(Line, Lines),
    [T, A, B] = Line,
    nl,
    tab(T),
    between(A,B,I),
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
    once(solve(PegBoard,steps)),
    J is (I + 1),
    write('=== '),
    write(J),
    write(' ==='),
    nl,
    show(PegBoard),
    nl,
    replay(PegBoard,steps),
    nl,
    maplist(writeln, steps).