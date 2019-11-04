%Sarah Richards
use_module(library(lists)).

%from,over,to: describes moves 
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

%generator for moves and their opposites 
step(Forward, Opposite):-
    moves(Front, O, Back),
    Forward     = [Front, O, Back],
    Opposite = [Front, O, Back].

%builds cells, 1 if full 0 if empty
%returns as a pair a count k of the full ones and the cells 
init(I, PegBoard):-
    length(L0, 14),
    maplist(=(1), L0),
    nth0(I, Cells, 0, L0),
    PegBoard = [14, Cells].

%assigns peg board value 
assign(Index, List, NewValue, Value, Result):-
    nth0(Index, List, Value, BeforeSet),
    nth0(Index, Result, NewValue, BeforeSet).

% performs, if possible, a move
% given the current occupancy of the cells 
move(PegBoard, Move, AfterMove):-
    [Remaining | [CellConfig]] = PegBoard,
    [Front, O, Back] = Move, RemainingAfterMove is Remaining-1,
    (step(Move, _); step(_, Move)),
    assign(Front, CellConfig,     0, 1, NewCellConfig0),
    assign(O, NewCellConfig0, 0, 1, NewCellConfig1),
    assign(Back, NewCellConfig1, 1, 0, NewCellConfigFinal),
    AfterMove = [RemainingAfterMove, NewCellConfigFinal].

% generator that finds all possible solutions
% given a cell configuration
solve([1, _], []).
solve(PegBoard, Moves):-
    [Front | Back] = Moves,
    move(PegBoard, Front, Result),
    solve(Result, Back).

% sets initial position with empty at i 
% picks first solution
%collects path made of moves to a list 
puzzle(I, Moves):-
    init(I, PegBoard),
    once(solve(PegBoard, Moves)).

% sets initial position with empty at i 
% picks first solution
%collects path made of moves to a list 
%returns inital board
puzzle(I, Moves, InitalBoard):-
    init(I, InitalBoard),
    once(solve(InitalBoard, Moves)).


write_to(_, []).
write_to(ListOfPegs, Indices):-
    [Front | Back] = Indices,
    ((nth0(Front, ListOfPegs, 0),write('. '));(nth0(B, ListOfPegs, 1),write('x '))),
    write_to(ListOfPegs, Back).

% shows the result by printing out successive states
show(PegBoard):-once(show(PegBoard, [[4,0,0],[3,1,2],[2,3,5],[1,6,9],[0,10,14]])).
show(PegBoard, Lines):-
    [_ | [CellList]] = PegBoard,
    [Lines | Remaining ] = Lines,
    [Front, Mid, Back] = Lines,
    tab(Front),
    numlist(Mid, Back, Indices),
    write_to(CellList, Indices),
    nl,
    show(PegBoard, Remaining).
    
show(_, []).

% Replay a sequence of moves, showing the state of the cells.
replay(_, []).
replay(PegBoard, Moves):-
    [Move | EndingMoves] = Moves,
    move(PegBoard, Move, Result),
    show(Result),
    nl,
    replay(Remaining, EndingMoves).

% replay a sequence of moves, without showing the state of the cells.
dont_show_replay(_, [], []).
dont_show_replay(PegBoard, Moves, BoardList):-
    [Move | EndingMoves] = Moves,
    move(PegBoard, Move, Remaining),
    [Front | Back] = BoardList,
    dont_show_replay(Front, EndingMoves, Back).
    

printPegs([]).
printPegs(List):-
    [Front | Back] = List,
    print(Back),nl,
    printPegs(Front).

% prints out a terse view of solutions for each missing peg 
terse():-
    numlist(0, 14, Indices),
    terse(Indices).
        
terse([]).
terse(Indices):-
    [Front | Back] = Indices,
    puzzle(Front, Moves, PegBoard),
    print(PegBoard),
    nl,
    printPegs(Moves),
    dont_show_replay(PegBoard, Moves, ListOfPegs),
    last(ListOfPegs, Remaining),
    print(Remaining),
    nl,
    nl,
    terse(Back).

% visualizes a solution for each first 5 positions
% others look the same after 120 degrees rotations
go():-
   numlist(0, 4, Indices),
   go(Indices),

go([]).
go(Indices):-
    [Front | Back] = Indices,
    write('=== '),write(B),write(' ==='),nl,
    puzzle(Front, Moves, Board),
    show(Board),
    nl,
    replay(Board, Moves),
    go(Back).
