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
    moves(F, O, T),
    Forward     = [F, O, T],
    Opposite = [T, O, F].

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
    [F, O, T] = Move, RemainingAfterMove is Remaining-1,
    (step(Move, _); step(_, Move)),
    assign(F, CellConfig,     0, 1, NewCellConfig0),
    assign(O, NewCellConfig0, 0, 1, NewCellConfig1),
    assign(T, NewCellConfig1, 1, 0, NewCellConfigFinal),
    AfterMove = [RemainingAfterMove, NewCellConfigFinal].

% generator that finds all possible solutions
% given a cell configuration
solve([1, _], []).
solve(PegBoard, Moves):-
    [Move | T] = Moves,
    move(PegBoard, Move, Result),
    solve(Result, T).

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
    [B | E] = Indices,
    ((nth0(B, ListOfPegs, 0),write('. '));(nth0(B, ListOfPegs, 1),write('x '))),
    write_to(ListOfPegs, E).

% shows the result by printing out successive states
show(PegBoard):-once(show(PegBoard, [[4,0,0],[3,1,2],[2,3,5],[1,6,9],[0,10,14]])).
show(PegBoard, Lines):-
    [_ | [CellList]] = PegBoard,
    [Lines | Remaining ] = Lines,
    [T, A, B] = Lines,
    tab(T),
    numlist(A, B, Indices),
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
    [Remaining | BoardListTail] = BoardList,
    dont_show_replay(Remaining, EndingMoves, PegBoardEndMove).
    

printPegs([]).
printPegs(List):-
    [B | E] = List,
    print(B),nl,
    printPegs(E).

% prints out a terse view of solutions for each missing peg 
terse():-
    numlist(0, 14, Indices),
    terse(Indices).
        
terse([]).
terse(Indices):-
    [B | E] = Indices,
    puzzle(B, Moves, PegBoard),
    print(PegBoard),
    nl,
    printPegs(Moves),
    dont_show_replay(PegBoard, Moves, ListOfPegs),
    last(ListOfPegs, Remaining),
    print(Remaining),
    nl,
    nl,
    terse(E).

% visualizes a solution for each first 5 positions
% others look the same after 120 degrees rotations
go():-
   numlist(0, 4, Indices),
   go(Indices),

go([]).
go(Indices):-
    [B | E] = Indices,
    write('=== '),write(B),write(' ==='),nl,
    puzzle(B, Moves, Board),
    show(Board),
    nl,
    replay(Board, Moves),
    go(E).