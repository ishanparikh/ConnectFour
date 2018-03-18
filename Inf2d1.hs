-- Inf2d Assignment 1 2017-2018
-- Matriculation number: s1674417
-- {-# OPTIONS -Wall #-}


module Inf2d1 where

import Data.List (sortBy)
import Debug.Trace
import ConnectFour

gridLength_search::Int
gridLength_search = 6
gridWidth_search :: Int
gridWidth_search = 6

{- NOTES:


-- DO NOT CHANGE THE NAMES OR TYPE DEFINITIONS OF THE FUNCTIONS!
You can write new auxillary functions, but don't change the names or type definitions
of the functions which you are asked to implement.

-- Comment your code.

-- You should submit this file, and only this file, when you have finished the assignment.

-- The deadline is the 3pm Tuesday 13th March 2018.

-- See the assignment sheet and document files for more information on the predefined game functions.

-- See the README for description of a user interface to test your code.

-- See www.haskell.org for haskell revision.

-- Useful haskell topics, which you should revise:
-- Recursion
-- The Maybe monad
-- Higher-order functions
-- List processing functions: map, fold, filter, sortBy ...

-- See Russell and Norvig Chapters 3 for search algorithms,
-- and Chapter 5 for game search algorithms.

-}

-- Section 1: Uniform Search

-- 6 x 6 grid search states

-- The Node type defines the position of the robot on the grid.
-- The Branch type synonym defines the branch of search through the grid.
type Node = (Int,Int)
type Branch = [(Int,Int)]


-- The next function should return all the possible continuations of input search branch through the grid.
-- Remember that the robot can only move up, down, left and right, and can't move outside the grid.
-- The current location of the robot is the head of the input branch.
-- Your function should return an empty list if the input search branch is empty.
-- This implementation of next function does not backtrace branches.
next::Branch-> [Branch]
next branch=[(x,y): branch | (x,y) <- moveNode(head branch), (x,y) `notElem` branch, 1 <= x && x<=6,1 <= y && y<=6 ]

-- |The checkArrival function should return true if the current location of the robot is the destination, and false otherwise.
checkArrival::Node-> Node-> Bool
checkArrival destination curNode = destination == curNode

-- Section 3 Uniformed Search
-- | Breadth-First Search
-- The breadthFirstSearch function should use the next function to expand a node,
-- and the checkArrival function to check whether a node is a destination position.
-- The function should search nodes using a breadth first search order.
breadthFirstSearch::Node-> (Branch-> [Branch])-> [Branch]->[Node]-> Maybe Branch
breadthFirstSearch destination next [] exploredList = Nothing
breadthFirstSearch destination next branches exploredList
  | checkArrival destination (head currBranch) = Just currBranch
  | (head currBranch) `notElem` exploredList = breadthFirstSearch destination next (tail branches ++ next currBranch) (head currBranch : exploredList)
  | otherwise = breadthFirstSearch destination next (tail branches) exploredList
  where currBranch = head branches





-- | Depth-First Search
-- The depthFirstSearch function is similiar to the breadthFirstSearch function,
-- except it searches nodes in a depth first search order.

depthFirstSearch::Node-> (Branch-> [Branch])-> [Branch]-> [Node]-> Maybe Branch
depthFirstSearch destination next [] exploredList = Nothing
depthFirstSearch destination next  branches exploredList
  | checkArrival destination (head currBranch) = Just currBranch
  | head currBranch `notElem` exploredList = depthFirstSearch destination next (next currBranch ++ tail branches) (head currBranch : exploredList)
  | otherwise = depthFirstSearch destination next (tail branches) exploredList
  where currBranch = head branches


-- | Depth-Limited Search
-- The depthLimitedSearch function is similiar to the depthFirstSearch function,
-- except its search is limited to a pre-determined depth, d, in the search tree..

depthLimitedSearch :: Node-> (Branch-> [Branch])-> [Branch]-> Int-> [Node]-> Maybe Branch
depthLimitedSearch destination next [] d exploredList = Nothing
depthLimitedSearch destination next  branches d exploredList
  | checkArrival destination (head currBranch) = Just currBranch
  | d == 0 = Nothing
  | length currBranch > d= depthLimitedSearch destination next (tail branches) d exploredList
  | head currBranch `notElem` exploredList = depthLimitedSearch destination next ( next currBranch ++ tail branches ) d (head currBranch : exploredList)
  | otherwise = depthLimitedSearch destination next (tail branches) d exploredList
  where currBranch = head branches

-- | Iterative-deepening search
-- The iterDeepSearch function should initially search nodes using depth-first to depth d,
-- and should increase the depth by d if search is unsuccessful.
-- This process should be continued until a solution is found.
-- Each time a solution is not found, the depth should be increased.
iterDeepSearch:: Node-> (Branch-> [Branch])-> Node-> Int-> Maybe Branch
iterDeepSearch destination next initialNode d -- SOMETHING MISSING
  | checkArrival destination initialNode = Just [initialNode]
  | depthLimitedSearch destination next [[initialNode]] d [] == Nothing = iterDeepSearch destination next initialNode (d+1)
  | otherwise = depthLimitedSearch destination next [[initialNode]] d []

-- | Section 4: Informed search

-- Manhattan distance heuristic
-- This function should return the manhattan distance between the current position and the destination position.
manhattan::Node-> Node-> Int
manhattan (x,y) (u,v) = abs(x-u) + abs(y-v)

-- | Best-First Search
-- The bestFirstSearch function uses the checkArrival function to check whether a node is a destination position,
-- and the heuristic function (of type Node->Int) to determine the order in which nodes are searched.
-- Nodes with a lower heuristic value should be searched before nodes with a higher heuristic value.
bestFirstSearch :: Node -> (Branch-> [Branch])-> (Node->Int)-> [Branch]-> [Node]-> Maybe Branch
bestFirstSearch destination next heuristic [] exploredList = Nothing

bestFirstSearch destination next heuristic branches exploredList
  | checkArrival destination (head currBranch) = Just currBranch
  | head currBranch `notElem` exploredList = bestFirstSearch destination next heuristic (next currBranch ++ tail (sort_Heuristics branches heuristic )) (head currBranch : exploredList)-- sort_Heuristics WRITE FUNCTION!!!
  | otherwise = bestFirstSearch destination next heuristic (tail (sort_Heuristics branches heuristic )) exploredList
  where currBranch = head(sort_Heuristics branches heuristic)
-- | A* Search
-- The aStarSearch function is similar to the bestFirstSearch function
-- except it includes the cost of getting to the state when determining the value of the node.

aStarSearch:: Node-> (Branch-> [Branch])-> (Node->Int)-> (Branch-> Int)-> [Branch]-> [Node]-> Maybe Branch
aStarSearch destination next heuristic cost [] exploredList = Nothing
aStarSearch destination next heuristic cost branches exploredList
  | checkArrival destination (head currBranch) = Just currBranch
  | head currBranch `notElem` exploredList = aStarSearch destination next heuristic cost (next currBranch ++ tail ( sortAllBranches branches heuristic cost)) (head currBranch : exploredList) -- sortAllBranches WRITE FUNCTION!!!
  | otherwise = bestFirstSearch destination next heuristic (tail (sortAllBranches branches heuristic cost)) exploredList
  where currBranch = head (sortAllBranches branches heuristic cost)



-- | The cost function calculates the current cost of a trace, where each movement from one state to another has a cost of 1.
cost :: Branch-> Int
cost branch = length branch





-- In this section, the function determines the score of a terminal state, assigning it a value of +1, -1 or 0:
eval :: Game-> Int
eval game | terminal game && checkWin game maxPlayer = 1
          | terminal game && checkWin game minPlayer = -1
          | terminal game                            = 0



-- | The minimax function should return the minimax value of the state (without alphabeta pruning).
-- The eval function should be used to get the value of a terminal state.

minimax :: Role -> Game -> Int
minimax player game
    | terminal game = eval game
    | player == maxPlayer = maximum [minimax (switch player) g | g <- moves game player]
    | otherwise = minimum [minimax (switch player) g | g <- moves game player]



-- | The alphabeta function should return the minimax value using alphabeta pruning.
-- The eval function should be used to get the value of a terminal state.

alphabeta:: Role-> Game-> Int
alphabeta  player game = undefined

{- Auxiliary Functions
-- Include any auxiliary functions you need for your algorithms below.
-- For each function, state its purpose and comment adequately.
-- Functions which increase the complexity of the algorithm will not get additional scores
-}


moveNode :: Node -> Branch
moveNode (x,y) = [(x+1,y), (x-1,y),(x,y+1),(x,y-1)]

branchesHeurCost :: [Branch] -> (Node -> Int) ->[Int]
branchesHeurCost branches heuristic = map heuristic (map head branches)


pathCostOfBranch :: [Branch] -> (Branch -> Int) -> [Int]
pathCostOfBranch branches cost = map cost branches

totalCost :: [Branch] -> (Node -> Int) ->(Branch-> Int) -> [Int]
totalCost branches heuristic cost = zipWith (+) (branchesHeurCost branches heuristic ) ( pathCostOfBranch branches cost)


greaterOrLesser (a,b) (c,d) = compare b d

sort_Heuristics :: [Branch] -> (Node -> Int) -> [Branch]
sort_Heuristics branches heuristic = [b | (b,c) <- sortBy greaterOrLesser (zip branches (branchesHeurCost branches heuristic ))]


sortAllBranches :: [Branch] -> (Node -> Int ) -> (Branch -> Int) -> [Branch]
sortAllBranches branches heuristic cost = [b | (b,c) <- sortBy greaterOrLesser (zip branches ( totalCost branches heuristic cost))]
