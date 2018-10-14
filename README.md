# ConnectFour
AI bot to play connect four against.

# Informatics 2D Coursework 1:

# Search and Games

## Xue Li, Thomas Wright, Stefano Albrecht, Cristina Alexandru

## February 2, 2018

## 1 Introduction

The objective of this assignment is to help you understand the various search algorithms and their applications in
path finding problems. You will implement the search algorithms usingHaskell.

You should download the following file from the Inf2D web page:

```
http://www.inf.ed.ac.uk/teaching/courses/inf2d/coursework/Inf2dAssignment1.tar
```
Use the commandtar -xf Inf2dAssignment1.tarto extract the files contained within. This will create a directory
namedInf2dAssignment1containingInf2d1.hsand four other supporting files for the assignment.

You will submit a version of theInf2d1.hsfile containing your implemented functions. Remember to add your
matriculation numberto the top of the file. Submission details can be found in Section 7.

```
The deadline for the assignment is:
3pm, Tuesday 13th March 2018
```
Some basic commands of Haskell are listed below^1. An example of using these commands are given in Figure 1, in
which commands are highlighted.

- ghciGHCi is the interactive environment, in which Haskell expressions can be interactively evaluated and
    programs can be interpreted. You can start GHCi with the commandghciin a terminal. All following
    commands work in GHCi environment.
- :helpGet help information.
- :cd <dir>You can save *.hs files anywhere you like, but if you save it somewhere other than the current
    directory, then you will need to change to the right directory, the directory (or folder) in which you saved *.hs.
- :show pathsShow the current directory.
- :load MainTo load a Haskell source file into GHCi. For short, you can also use:l Main, where Main is the
    topmost module in our assignment.
- mainRun function main.

If your Haskell is quite rusty, you should revise the following topics:

- Recursion
- Currying
- Higher-order functions
- List processing functions such as map, filter, foldl, sortBy, etc
- The Maybe monad

The following webpage has lots of useful information if you need to revise Haskell. There are also links to descriptions
of the Haskell libraries that you might find useful:

```
Haskell resources: http://www.haskell.org/haskellwiki/Haskell
```
(^1) Fromhttp://downloads.haskell.org/~ghc/latest/docs/html/users_guide/ghci.html


```
Figure 1: Getting start with Haskell
```
In particular, to read this assignment sheet, you should recall the Haskell type-definition syntax. For example, a
functionfoowhich takes an argument of typeIntand an argument of typeString, and returns an argument of
typeInt, has the type declarationfoo :: Int→String →Int. Most of the functions you will write have their
corresponding type-definitions already given.

## 2 Help

There are the following sources of help:

- Attend lab sessions.
- Check Piazza for peer support and clarifications.
- Read any emails sent to the Inf2D mailing list regarding the assignment.
- Read ”Artificial Intelligence: A Modern Approach” Third Edition, Russell & Norvig, Prentice Hall, 2010
    (R&N) Chapters 3 and 5.
- Email TA Xue Li (xue.lee@ed.ac.uk) or lab demonstrators Patrick Chen (patrick.chen@ed.ac.uk) and Zheng
    Zhao (s1533564@sms.ed.ac.uk).

## 3 Uninformed Search (35%)

In this section, you will implement some uninformed search procedures (see Chapter 3 of R&N).

The problem for which you are searching a solution is to find a path for a robot on a 6 by 6 grid. The position on
grid is represented as a pair of integers inInttype, which has been defined as typeNode. We use a list of nodes,
defined as typeBranch, to represent the searchagenda: the set of nodes which are on the fringe of the search tree.
In order to write search algorithms in Haskell, we need to represent the status of the search as we expand new nodes
to search branches.

As a search problem we have:


- Initial state:[start], wherestartis(startRow, startColumn).
- Successor function: the functionnextwhich extends branches.
- Goal test: the functioncheckArrival checks whether the robot has reached its destination position or not.
- Path cost: the functioncostreturn the cost of a path, which is its length.

Each time a node is taken from the search agenda, it is checked to see whether it is a solution to the problem. If
it is a solution, the branch is returned as the desired path. Otherwise, the node is expanded using the successor
function and the new nodes are added to the search agenda in the appropriate order.

### 3.1 6 by 6 Grid (4%)

You must first implement the following functions which represent traces in the grid world:

- next :: Branch →[Branch]. The first argument is an input search branch. Thenextfunction should
    expand the input branch with its possible continuations, and then return the list of expanded search branches.
       - The robot can only move up, down, left or right and cannot move off the grid, which are from position
          (1,1) to (6, 6). However, theNextfunction does not need to handle the case that the head of input
          branch is invalid.
       - The search branch generated by theNextfunction should not contain repeated node, which means that
          every node in a branch could only occur once.
- checkArrival :: Node→ Node→Bool. The first argument of this function is the destination position.
    The second argument is the current position of the robot. ThecheckArrivalfunction is for determining
    whether the robot has arrived at the destination or not.

### 3.2 Breadth-first Search (7%)

Breadth-first search expands old nodes on the search agenda before new nodes.

- breadthFirstSearch :: Node →(Branch→[Branch])→[Branch] →[Node]→Maybe Branch
- The first argument is the destination position in typeNode, based on whichcheckArrivalfunction determines
    whether a node is the destination position or not. The branch achieving the destination node is a solution to
    the search problem.
- (Branch→[Branch])is the type of thenextfunction which expands a search branch with new nodes.
- [Branch]argument is the search agenda.
- [Node]is the list of explored nodes. Before expanding a search branch, you should check whether the current
    node of the search branch is an old node or not. You should not search for continuations of a repeated node.
- The function returns a value of typeMaybe Branchwhich is eitherNothing, if a solution is not found, orJust
    Branchsolution, if one is found.

### 3.3 Depth-first Search (7%)

Depth-first search expands new nodes on the search agenda over old nodes.

- depthFirstSearch :: Node→(Branch→ [Branch])→[Branch]→[Node] →Maybe Branch
- The type ofdepthFirstSearchis the same asbreadthFirstSearch, but their behaviour is different.

### 3.4 Depth-limited Search (7%)

Depth-limited search solves a possible failure of depth-first search in infinite search spaces by supplying depth-first
search with a pre-determined depth limit. Branches at this depth are treated as if they have no successors.

- depthLimitedSearch :: Node →(Branch→[Branch])→[Branch]→ Int→ [Node]→Maybe Branch
- TheIntargument is the maximum depth at which a solution is searched for.


### 3.5 Iterative-deepening Search (10%)

Iterative deepening search tries depth-first down to a given depth, and if it cannot find a solution it increases the
depth. This process is repeated until a solution is found.

- iterDeepSearch :: Node →(Branch→[Branch])→ Node→Int→Maybe Branch
- The third argument is the start position of the search problem, whoes type isNode.
- TheIntargument is the initial depth that a solution is searched for, and subsequent depths should be generated
    by increasing by one every time.

## 4 Informed Search (30%)

In this section you will implement some heuristic search functions. See Chapter 3 of R&N.

### 4.1 Manhattan Distance Heuristic (5%)

The Manhattan distance, also known ascity block distance(see Chapter 3 of R&N) gives the distance between two
positions on the grid, when we can only travel up, down, left or right. It can be used as a heuristic to rank branches
based upon how far they are from the goal node.

- manhattan :: Node →Node→Int

### 4.2 Best-First Search (10%)

Best-first search ranks nodes on the search agenda according to a heuristic function and selects the one with the
smallest heuristic value.

- bestFirstSearch :: Node→(Branch→[Branch]) →(Node→Int) →[Branch]→[Node] →Maybe
    Branch
- The first argument is the destination position in typeNode, based on whichcheckArrivalfunction determines
    whether a node is the destination position or not (same as uninformed search).
- (Branch→[Branch])is the type of thenextfunction (same as uninformed search).
- (Node →Int)is the type of the heuristic function, which defines at least an ordering on the nodes in the
    search agenda.
- [Branch]is the search agenda (same as uninformed search).
- [Node]is the list of explored nodes (same as uninformed search).
- Maybe Branchis the value the function returns (same as uninformed search).

### 4.3 A* Search (15%)

A* search includes the cost it takes to reach the node in the ranking of nodes on the search agenda. All the other
arguments are the same asbestFirstSearch, except the fourth argument, which is a cost function.

- aStarSearch :: Node→ (Branch→ [Branch])→(Node→ Int)→(Branch→Int)→[Branch]
    →[Node] →Maybe Branch
- (Node →Int)is the heuristic function as inbestFirstSearch.
- (Branch→Int)is the cost function which needs to be implemented by you. Here the cost of a path is
    its length. Both heuristic function and cost function return anInttype to which makes it possible to get a
    combined ranking of nodes.

An example of employing a search algorithm is given in Figure 2, with commands highlighted.


```
Figure 2: Employ Breadth First Search in GHCi.
```
## 5 Games (35%)

In this section you will implement minimax search and minimax search with alpha-beta pruning (see Chapter 5 of
R&N) for the two-player gameConnect Four. The board size is 4 columns and 4 rows..

Rules introduction:

1. Two players take turns adding one piece at a time.
2. For each column, only the lowest unoccupied cell is the available space for a player to add a piece. An example
    is given by Figure 3.
3. The winner is the player who is the first to form a horizontal, vertical, or diagonal line of four of one’s own
    pieces. If the game board fills before either player achieves four in a row, then the game is a draw.

Figure 3: An example for available cells to add a piece. Given existing moves by MAX(X) and MIN(O), the available
cells have been highlighted in green.

### 5.1 Game Functions

We will represent the 4 by 4 grid for the game board as a list type with 16 elements. Your game player will interact
with the game by providing the (row, column) pair for his/her moves. Several useful functions for the Connect Four
game are defined in ConnectFour.hs.


- Game, CellandRoletypes: TheGametype is a list ofInttypes. It represents the 16 cells on the game
    board. TheCelltype represents positions on the board as the(row,column), anIntpair. TheRoletype
    describes which player it is, the human player or computer player.
- getLinesprovides all possible lines on the board (rows, columns and diagonals) for winning the game.
- terminalfunction takes aGamestate and returnsTrueif it is a terminal state orFalseif otherwise.
- movestakes aGameand aRoleas arguments and returns a list of possible game states that the player can
    move into.
- checkWintakes aGameand aRoleand determines if the game is a winning position for the player.
- switchallows you to alternate roles of players, e.g. MAX and MIN.

### 5.2 Evaluation Function (5%)

For this section, you will implement an evaluation function for terminal states. The function determines the score
of a terminal state, assigning it a value of +1, -1 or 0 as defined below:

- eval :: Game →Int
- evaltakes aGameas an argument, and should return anInttype so that game states can be ranked.
    - A winning position for MAX should be +1.
    - A winning position for MIN should be -1.
    - A draw has a 0 value.
    - TheterminalandcheckWinfunctions defined in ConnectFour.hs will be useful.

### 5.3 Minimax Algorithm (15%)

Theminimaxvalue of a state represents the value of the best possible outcome from that state. This assumes that
the MAX player plays moves which maximise the value and MIN plays moves which minimise the value (see Figure
4). The minimax algorithm from R&N is shown in Figure 5, however note that your function should return the best
evaluation valuereached from the input game state, not the action that achieves this value.

- minimax :: Role→Game →Int
- minimaxtakes a typeRoleand aGameas arguments.
- minimaxreturns anIntsince the terminal evaluation of a game is either +1, a win for player MAX; 0, a draw;
    or -1, a win for player MIN.
- Yourminimaxfunction should use theeval::Game→Intfunction to evaluate terminal states.

Figure 4: The MAX player can play moves to get to either B, C, or D. MIN can then play moves which result in
different possible valuations. For each of B, C, or D MAX must find what the least value MIN could select is. For
example from state B MIN could play eitherb 1 ,b 2 orb 3 to reach states with valuation 3,12 or 8 respectively. So, if
the state was B MIN would playb 1 to reach the state with valuation 3. Since the best response for MIN in C and
D is 2, the best state for MAX is B, hence MAX should play movea 1. (From R&N)


```
Figure 5: An algorithm for calculating minimax decisions (From R&N)
```
### 5.4 Alpha-Beta Pruning (15%)

Alpha-beta finds the minimax value of a state, but searches fewer states than the regularminimaxfunction. It
does this by ignoring branches of the search space which cannot affect the minimax value of the state. A range of
possible values for the minimax value of the state is calculated. If a node in a branch has a value outside this range
then the rest of the nodes in that branch can be ignored, as the player can avoid this branch of the search space
(see Figure 6). You will have to choose an initial range for alpha-beta pruning. We can’t represent infinite numbers
in Haskell, so you should use the range (-2, +2) for youralphabetafunction. Since the maximum evaluation of a
game position is +1 and the minimum is−1, this range covers all possible minimax values for the state.

- alphabeta :: Role→ Game→Int
- Youralphabetafunction should use theeval :: Game→Intfunction to evaluate terminal states.

```
Figure 6: The alpha-beta search algorithm (From R&N)
```
An example of playing one step in Connect Four is given in Figure 7, with commands highlighted.


```
Figure 7: Play Connect Four in a terminal.
```

